import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'admin_screen.dart';
import 'member_management.dart';
import 'due_date_fine.dart';
import 'issue_return_books.dart';
import 'reports_logs.dart';
import 'signin_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SmsNotificationsPage extends StatefulWidget {
  const SmsNotificationsPage({super.key});

  @override
  _SmsNotificationsPageState createState() => _SmsNotificationsPageState();
}

class _SmsNotificationsPageState extends State<SmsNotificationsPage> {
  final _searchController = TextEditingController();

  int _calculatePenalty(DateTime returnDate) {
    final currentDate = DateTime.now();
    if (returnDate.isBefore(currentDate)) {
      return currentDate.difference(returnDate).inDays;
    }
    return 0;
  }

  Future<void> _sendSmsNotification(String phoneNumber, String message) async {
    const String twilioSID = 'AC64bea50a1823cc80444d6cfa91566b3f';
    const String twilioAuthToken = '57606219f8ec047103aff111a0c6a57d';
    const String twilioPhoneNumber = '+14452921344';

    if (phoneNumber.isEmpty) return;

    String formattedPhone = phoneNumber;
    if (!phoneNumber.startsWith('+')) {
      formattedPhone = '+91$phoneNumber';
    }

    final Uri url = Uri.parse(
      'https://api.twilio.com/2010-04-01/Accounts/$twilioSID/Messages.json',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Basic ' +
              base64Encode(utf8.encode('$twilioSID:$twilioAuthToken')),
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'From': twilioPhoneNumber,
          'To': formattedPhone,
          'Body': message,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('SMS sent successfully');
      } else {
        final errorData = json.decode(response.body);
        print('Failed to send SMS: ${errorData['message']}');
        // Log more details about the error
        print('Error details: $errorData');
      }
    } catch (e) {
      print('Error sending SMS: $e');
    }
  }

  Future<void> _sendNotificationForUser(
    String studentName,
    String phoneNumber,
    DateTime returnDate,
  ) async {
    int penalty = _calculatePenalty(returnDate);

    if (penalty > 0) {
      String message =
          "Hello $studentName, you have a penalty of ₹$penalty for returning the book late. Please return it as soon as possible.";

      await _sendSmsNotification(phoneNumber, message);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('SMS sent to $studentName')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminSidebar(
        onFeatureTap: (feature) => _handleFeatureTap(context, feature),
      ),
      appBar: AppBar(
        title: Text(
          "SMS Notifications",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFA3D5FF),
                Color(0xFF83C9F4),
                Color(0xFF6F73D2),
                Color(0xFF242A42),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search by name, email, class, or book",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('due_date_fine')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var records = snapshot.data!.docs;

                  var filteredRecords =
                      records.where((record) {
                        String query = _searchController.text.toLowerCase();
                        return record['name'].toLowerCase().contains(query) ||
                            record['email'].toLowerCase().contains(query) ||
                            record['class'].toLowerCase().contains(query) ||
                            record['issueDate'].toLowerCase().contains(query) ||
                            record['returnDate'].toLowerCase().contains(
                              query,
                            ) ||
                            record['penalty'].toString().contains(query);
                      }).toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Class')),
                        DataColumn(label: Text('Issue Date')),
                        DataColumn(label: Text('Return Date')),
                        DataColumn(label: Text('Penalty')),
                        DataColumn(label: Text('Send')),
                      ],
                      rows:
                          filteredRecords.map((record) {
                            DateTime returnDate = DateTime.parse(
                              record['returnDate'],
                            );
                            DateTime issueDate = DateTime.parse(
                              record['issueDate'],
                            );
                            String studentName = record['name'];
                            String phoneNumber = record['phno'] ?? '';
                            int penalty = _calculatePenalty(returnDate);

                            return DataRow(
                              cells: [
                                DataCell(Text(studentName)),
                                DataCell(Text(record['email'])),
                                DataCell(Text(phoneNumber)),
                                DataCell(Text(record['class'])),
                                DataCell(
                                  Text(DateFormat.yMMMd().format(issueDate)),
                                ),
                                DataCell(
                                  Text(DateFormat.yMMMd().format(returnDate)),
                                ),
                                DataCell(Text(penalty.toString())),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () async {
                                      await _sendNotificationForUser(
                                        studentName,
                                        phoneNumber,
                                        returnDate,
                                      );
                                    },
                                    child: const Text("Send Notification"),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFeatureTap(BuildContext context, String feature) {
    Widget page;
    switch (feature) {
      case "Home":
        page = const AdminHomePage();
        break;
      case "Member Management":
        page = const MemberManagementPage();
        break;
      case "Issue & Return Books":
        page = const IssueReturnBooksPage();
        break;
      case "Due Date & Fine":
        page = const DueDateFinePage();
        break;
      case "SMS Notifications":
        page = const SmsNotificationsPage();
        break;
      case "Reports & Logs":
        page = const ReportsLogsPage();
        break;
      case "Logout":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SigninPage()),
        );
        return;
      default:
        return;
    }

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}

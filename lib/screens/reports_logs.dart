import 'package:flutter/material.dart';
import 'admin_screen.dart';
import 'issue_return_books.dart';
import 'sms_notifications.dart';
import 'due_date_fine.dart';
import 'signin_screen.dart';
import 'member_management.dart';

class ReportsLogsPage extends StatelessWidget {
  const ReportsLogsPage({super.key});

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

    // Close the drawer before navigation
    Navigator.pop(context);

    // Navigate to the selected page
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminSidebar(
        onFeatureTap: (feature) => _handleFeatureTap(context, feature),
      ),
      appBar: AppBar(
        title: const Text("Reports & Logs"),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Library Reports & Logs",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildReportItem(
                    "Daily Transactions Report",
                    Icons.insert_chart,
                  ),
                  _buildReportItem("Overdue Books Report", Icons.warning),
                  _buildReportItem("Member Activity Logs", Icons.history),
                  _buildReportItem(
                    "Fine Collection Summary",
                    Icons.attach_money,
                  ),
                  _buildReportItem("System Access Logs", Icons.lock),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade900, size: 30),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade600),
        onTap: () {
          // TODO: Navigate to detailed reports page
        },
      ),
    );
  }
}

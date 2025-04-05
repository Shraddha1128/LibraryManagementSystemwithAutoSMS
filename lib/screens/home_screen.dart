import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  final String userName;

  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text(
            "Welcome, $userName",
            style: GoogleFonts.lato(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Solid white text color
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Light blue
                  Color(0xFFA3D5FF), // Sky blue
                  Color(0xFF83C9F4), // Medium blue
                  Color(0xFF6F73D2), // Lavender blue
                  Color(0xFF242A42), // Dark navy
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SigninPage()),
                );
              },
            ),
          ],
        ),
      ),
      drawer: StudentSidebar(
        onLogout: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SigninPage()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Features",
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF242A42), // Solid text color
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildFeatureCard(Icons.book, "Borrowed Books"),
                  _buildFeatureCard(Icons.notifications, "Notifications"),
                  _buildFeatureCard(Icons.person, "Profile"),
                  _buildFeatureCard(Icons.help, "Help & Support"),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title, {
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (isLogout) {
          FirebaseAuth.instance.signOut();
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Color(0xFF6F73D2)),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF242A42), // Solid text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Student Sidebar with Gradient Header
class StudentSidebar extends StatelessWidget {
  final VoidCallback onLogout;

  const StudentSidebar({Key? key, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFD9F0FF),
                  Color(0xFFA3D5FF),
                  Color(0xFF83C9F4),
                  Color(0xFF6F73D2),
                  Color(0xFF242A42),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.person, size: 60, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  "Student Menu",
                  style: TextStyle(
                    color: Colors.white, // Solid white text
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSidebarItem(Icons.home, "Home", () {}),
                _buildSidebarItem(Icons.book, "My Borrowed Books", () {}),
                _buildSidebarItem(Icons.notifications, "Notifications", () {}),
                _buildSidebarItem(Icons.person, "Profile", () {}),
                _buildSidebarItem(Icons.help, "Help & Support", () {}),
                _buildSidebarItem(Icons.logout, "Logout", onLogout),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF242A42)),
      title: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 18,
          color: Colors.black87, // Solid text color
        ),
      ),
      onTap: onTap,
    );
  }
}

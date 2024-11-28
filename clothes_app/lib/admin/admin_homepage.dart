import 'package:clothes/admin/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clothes/admin/admin_items.dart';
import 'package:clothes/admin/admin_upload_items.dart';
import 'package:clothes/admin/admin_vieworder.dart';
import 'package:clothes/admin/admin_viewuser.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;

  // Function to handle logout
  void _handleLogout() {
    Fluttertoast.showToast(
      msg: "Logging out...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  // Function to show FlutterToast for button clicks
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
    );
  }

  // Widgets for different pages
  final List<Widget> _pages = [
    AdminDashboard(),
    AdminViewUser(),
    AdminUploadItemScreen(),
    AdminItemsPage(),
    OrderPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('View Reports'),
              onTap: () {
                _showToast("View Reports");
                _navigateTo(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('View User'),
              onTap: () {
                _showToast("View User");
                _navigateTo(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud_upload),
              title: Text('Upload Item'),
              onTap: () {
                _showToast("Upload Item");
                _navigateTo(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('View Items'),
              onTap: () {
                _showToast("View Items");
                _navigateTo(3);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('View Orders'),
              onTap: () {
                _showToast("View Orders");
                _navigateTo(4);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                _handleLogout();
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
    );
  }

  void _navigateTo(int index) {
    Navigator.pop(context); // Close the drawer
    setState(() {
      _currentIndex = index;
    });
  }
}

import 'package:clothes/admin/admin_items.dart';
import 'package:clothes/admin/admin_vieworder.dart';
import 'package:clothes/admin/admin_viewuser.dart';
import 'package:clothes/users/widgets/custom_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int totalUsers = 0;
  int totalItems = 0;
  int totalOrders = 0;
  int totalPaymentSum = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/getCountsAndSum'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['countsAndSum'];
      setState(() {
        totalUsers = data['totalUsers'];
        totalItems = data['totalItems'];
        totalOrders = data['totalOrders'];
        totalPaymentSum = data['totalPaymentSum'];
      });
    } else {
      // Handle error
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextButton(
          onPressed: () {},
          child: Text(
            'Admin Dashboard',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildClickableInfoCard('Total Users', totalUsers, () {
                CustomOverlayMessage.showOverlayMessage(context,
                    "To view user list, you can close this then after that you can see an icon beside the admin homepage click it! and click! View Users");
              }),
              buildClickableInfoCard('Total Items', totalItems, () {
                CustomOverlayMessage.showOverlayMessage(context,
                    "To view item list, you can close this then after that you can see an icon beside the admin homepage click it! and click! View Items");
              }),
              buildClickableInfoCard('Total Orders', totalOrders, () {
                CustomOverlayMessage.showOverlayMessage(context,
                    "To view order list, you can close this then after that you can see an icon beside the admin homepage click it! and click! View Orders");
              }),
              buildInfoCard('Total Sales', totalPaymentSum, fontSize: 35),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, int value, {double fontSize = 70}) {
    return Container(
      width: 250, // Adjust the width as needed
      height: 600, // Adjust the height as needed
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                title == 'Total Sales'
                    ? '₱${value.toStringAsFixed(2)}' // Add the Philippine Peso sign
                    : value.toString(),
                style:
                    TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildClickableInfoCard(String title, int value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 600,
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  title == 'Total Sales'
                      ? '₱${value.toStringAsFixed(2)}'
                      : value.toString(),
                  style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

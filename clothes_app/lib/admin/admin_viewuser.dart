import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminViewUser extends StatefulWidget {
  const AdminViewUser({Key? key}) : super(key: key);

  @override
  State<AdminViewUser> createState() => _AdminViewUserState();
}

class _AdminViewUserState extends State<AdminViewUser> {
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/getAllUsers'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['usersData'];
        return data.cast<Map<String, dynamic>>();
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        automaticallyImplyLeading:
            false, // Add this line to remove the back button
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text('Username: ${user['user_name']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user['user_email']}'),
                      Text(
                        'Password: ********',
                        style: TextStyle(fontFamily: 'Courier New'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

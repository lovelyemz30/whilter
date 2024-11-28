import 'package:clothes/admin/admin_homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminEditItem extends StatefulWidget {
  final Map<String, dynamic> item;

  const AdminEditItem({required this.item, Key? key}) : super(key: key);

  @override
  _AdminEditItemState createState() => _AdminEditItemState();
}

class _AdminEditItemState extends State<AdminEditItem> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController sizeController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current item details
    nameController = TextEditingController(text: widget.item['name']);
    priceController =
        TextEditingController(text: widget.item['price'].toString());
    sizeController = TextEditingController(text: widget.item['size']);
    descriptionController =
        TextEditingController(text: widget.item['description']);
  }

  Future<void> updateItem() async {
    final String url =
        'http://localhost:3000/api/updateItem/${widget.item['item_id']}';

    final Map<String, dynamic> requestBody = {
      'name': nameController.text,
      'price': priceController.text,
      'size': sizeController.text,
      'description': descriptionController.text,
    };

    final response = await http.patch(
      Uri.parse(url),
      body: json.encode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Handle success, navigate back or show a success message
      print('Item updated successfully');
    } else {
      // Handle error, show an error message
      print('Error updating item: ${response.body}');
    }
  }

  Future<void> deleteItem() async {
    final String url =
        'http://localhost:3000/api/deleteItem/${widget.item['item_id']}';

    final response = await http.delete(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      // Handle success, navigate back or show a success message
      print('Item deleted successfully');
    } else {
      // Handle error, show an error message
      print('Error deleting item: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: sizeController,
              decoration: InputDecoration(labelText: 'Size'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                updateItem().then((value) {
                  // Navigate to a different screen after successful update
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminHomePage(),
                    ),
                  );
                }).catchError((e) {
                  // Handle error if necessary
                });
              },
              child: Text('Update Item'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                deleteItem().then((value) {
                  // Navigate to a different screen after successful update
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminHomePage(),
                    ),
                  );
                }).catchError((e) {
                  // Handle error if necessary
                });
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text('Delete Item'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_editItem.dart';

class AdminItemsPage extends StatefulWidget {
  @override
  State<AdminItemsPage> createState() => _AdminItemsPageState();
}

class _AdminItemsPageState extends State<AdminItemsPage> {
  List<Map<String, dynamic>> itemsData = [];

  @override
  void initState() {
    super.initState();
    fetchAllItems();
  }

  Future<void> fetchAllItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/getAllItems'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            itemsData = List<Map<String, dynamic>>.from(
              responseData['clothItemsData'],
            );
          });
        } else {
          // Handle error
        }
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle other errors
    }
  }

  Future<void> addQuantity(int itemId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/addQuantity'),
        body: {'itemId': itemId.toString()},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          // Refresh the list after updating quantity
          fetchAllItems();
        } else {
          // Handle error
        }
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle other errors
    }
  }

  Future<void> subtractQuantity(int itemId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/subtractQuantity'),
        body: {'itemId': itemId.toString()},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success']) {
          // Refresh the list after updating quantity
          fetchAllItems();
        } else {
          // Handle error
        }
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle other errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items/Product List Page'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.topCenter, // Align to the top center

        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name'),
            ),
            DataColumn(
              label: Text('Price'),
              numeric: true,
            ),
            DataColumn(
              label: Text('Size'),
              numeric: false,
            ),
            DataColumn(
              label: Text('Description'),
              numeric: false,
            ),
            DataColumn(
              label: Text('Image'),
              numeric: false,
            ),
            DataColumn(
              label: Text('Edit'),
              numeric: false,
            ),
            DataColumn(
              label: Text('Quantity'),
              numeric: false,
            ),
            DataColumn(
              label: Text('Actions'),
              numeric: false,
            ),
          ],
          rows: itemsData.map<DataRow>((item) {
            return DataRow(
              cells: [
                DataCell(Text(item['name'])),
                DataCell(Text('\₱${item['price']}')),
                DataCell(Text(item['size'])),
                DataCell(Text(item['description'])),
                DataCell(
                  Image.asset(
                    'images/${item['image']}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Handle edit action here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminEditItem(item: item),
                        ),
                      ).then((value) {
                        // Refresh the list after returning from AdminEditItem
                        if (value == true) {
                          fetchAllItems();
                        }
                      });
                    },
                  ),
                ),
                DataCell(Text(item['quantity'].toString())),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          addQuantity(item['item_id']);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          subtractQuantity(item['item_id']);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

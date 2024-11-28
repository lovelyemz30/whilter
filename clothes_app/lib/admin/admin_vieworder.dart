import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/orders'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          orders = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print(
            'Failed to fetch orders. Error ${response.statusCode}: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      final response = await http.patch(
        Uri.parse('http://localhost:3000/api/orders/$orderId/status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': newStatus}),
      );

      if (response.statusCode == 200) {
        _showStatusToast(newStatus);
        _fetchOrders(); // Refresh the orders after updating status
      } else {
        print(
            'Failed to update order status. Error ${response.statusCode}: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showStatusToast(String status) {
    String message;
    switch (status) {
      case 'confirmed':
        message = 'Order has been confirmed!';
        break;
      case 'deleted':
        message = 'Order has been deleted!';
        break;
      case 'delivered':
        message = 'Order has been delivered!';
        break;
      default:
        message = 'Order status pending!';
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
    );
  }

  // Method to determine background color based on order status
  Color getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.blue; // Replace with your confirmed color
      case 'deleted':
        return Colors.red; // Replace with your deleted color
      case 'delivered':
        return Colors.green; // Replace with your delivered color
      case 'pending':
        return Colors.grey; // Replace with your pending color
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders List Page'),
        automaticallyImplyLeading: false,
      ),
      body: orders.isEmpty
          ? Center(
              child: Text('No orders available'),
            )
          : Container(
              alignment: Alignment.topCenter, // Align to the top center
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 16.0, // Adjust the space between columns
                  columns: [
                    DataColumn(
                      label: Text(
                        'Cart Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0, // Custom font size
                        ),
                      ),
                      numeric: false,
                      tooltip: 'This is the cart details column',
                    ),
                    DataColumn(
                      label: Text(
                        'Parcel Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0, // Custom font size
                        ),
                      ),
                      numeric: true,
                      tooltip: 'This is the parcel name column',
                    ),
                    DataColumn(
                      label: Text(
                        'Total Payment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0, // Custom font size
                        ),
                      ),
                      numeric: true,
                      tooltip: 'This is the total payment column',
                    ),
                    DataColumn(
                      label: Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0, // Custom font size
                        ),
                      ),
                      numeric: false,
                      tooltip: 'This is the delivery address column',
                    ),
                    DataColumn(
                      label: Text(
                        'Phone Number',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0, // Custom font size
                        ),
                      ),
                      numeric: false,
                      tooltip: 'This is the phone number column',
                    ),
                    DataColumn(
                      label: Text(
                        'Shipping Option',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0, // Custom font size
                        ),
                      ),
                      numeric: false,
                      tooltip: 'This is the shipping option column',
                    ),
                    DataColumn(
                      label: Text(
                        'Payment Option',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0, // Custom font size
                        ),
                      ),
                      numeric: false,
                      tooltip: 'This is the payment option column',
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0, // Custom font size
                        ),
                      ),
                      numeric: false,
                      tooltip: 'This is the status column',
                    ),
                  ],
                  rows: orders.map<DataRow>((order) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            order['cart_details'],
                            style:
                                TextStyle(fontSize: 14.0), // Custom font size
                          ),
                        ),
                        DataCell(
                          Text(
                            order['parcel_name'],
                            style:
                                TextStyle(fontSize: 14.0), // Custom font size
                          ),
                        ),
                        DataCell(
                          Text(
                            '\₱${order['total_payment']}',
                            style:
                                TextStyle(fontSize: 14.0), // Custom font size
                          ),
                        ),
                        DataCell(
                          Text(
                            order['delivery_address'],
                            style:
                                TextStyle(fontSize: 14.0), // Custom font size
                          ),
                        ),
                        DataCell(
                          Text(
                            order['phone_number'],
                            style:
                                TextStyle(fontSize: 14.0), // Custom font size
                          ),
                        ),
                        DataCell(
                          Text(
                            order['shipping_option'],
                            style:
                                TextStyle(fontSize: 14.0), // Custom font size
                          ),
                        ),
                        DataCell(
                          Text(
                            order['payment_option'],
                            style:
                                TextStyle(fontSize: 14.0), // Custom font size
                          ),
                        ),
                        DataCell(
                          DropdownButton<String>(
                            value: order['status'],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                _updateOrderStatus(order['order_id'], newValue);
                              }
                            },
                            items: <String>[
                              'pending',
                              'confirmed',
                              'delivered',
                              'deleted'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                      color: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          // Use the getStatusColor method to determine the color
                          return getStatusColor(order['status']);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}

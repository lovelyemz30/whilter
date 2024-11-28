import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderFragmentScreen extends StatefulWidget {
  final int userId;

  OrderFragmentScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _OrderFragmentScreenState createState() => _OrderFragmentScreenState();
}

class _OrderFragmentScreenState extends State<OrderFragmentScreen> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/userOrders/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedOrders =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        setState(() {
          orders = fetchedOrders;
        });
      } else {
        print('Failed to fetch orders. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Orders',
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (orders.isEmpty)
            Text("No orders found for this user.")
          else
            allOrdersWidget(),
        ],
      ),
    );
  }

  Widget allOrdersWidget() {
    return ListView.builder(
      itemCount: orders.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final order = orders[index];

        return GestureDetector(
          onTap: () {
            // Handle order click as needed
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 0, 0, 0),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 6,
                  color: Colors.grey,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Order Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                orderDetailWidget(
                  "Delivery Address: ",
                  order['delivery_address'],
                ),
                orderDetailWidget("Phone Number: ", order['phone_number']),
                orderDetailWidget(
                  "Shipping Option: ",
                  order['shipping_option'],
                ),
                orderDetailWidget(
                  "Payment Option: ",
                  order['payment_option'],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        "Total Payment: \₱${order['total_payment']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${order['status']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget orderDetailWidget(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 8), // Adjust the width as needed
          Expanded(
            child: Tooltip(
              message: value, // Show full address on tooltip
              child: Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.white),
                overflow: TextOverflow.ellipsis, // Handle overflow
                maxLines: 1, // Limit to a single line
              ),
            ),
          ),
        ],
      ),
    );
  }
}

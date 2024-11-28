import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clothes/users/fragments/dashboard_of_fragments.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Map<String, int> itemQuantities;
  final int userId; // Add this line
  final String userEmail;
  final String userName;

  const CheckoutPage({
    Key? key,
    required this.cartItems,
    required this.itemQuantities,
    required this.userId,
    required this.userEmail,
    required this.userName, // Add this line
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController parcelNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool jAndTExpressSelected = false;
  bool ninjaVanSelected = false;
  bool lbcSelected = false;
  bool codSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Enter your delivery address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your delivery address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Enter your phone number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // You can add more specific validation rules for the phone number if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: parcelNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter parcel name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the parcel name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Cart Item Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = widget.cartItems[index];
                    final itemId = cartItem['item_id'].toString();
                    final quantity = widget.itemQuantities[itemId] ?? 1;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(cartItem['name'] ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantity: $quantity'),
                            ],
                          ),
                          leading: Image.asset(
                            'images/${cartItem['image']}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Shipping Option',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                CheckboxListTile(
                  title: Text('JT Express'),
                  value: jAndTExpressSelected,
                  onChanged: (value) {
                    setState(() {
                      jAndTExpressSelected = value!;
                      ninjaVanSelected = false;
                      lbcSelected = false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('NinjaVan'),
                  value: ninjaVanSelected,
                  onChanged: (value) {
                    setState(() {
                      ninjaVanSelected = value!;
                      jAndTExpressSelected = false;
                      lbcSelected = false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('LBC'),
                  value: lbcSelected,
                  onChanged: (value) {
                    setState(() {
                      lbcSelected = value!;
                      jAndTExpressSelected = false;
                      ninjaVanSelected = false;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Total:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '\₱${calculateTotalAmount().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Payment Option:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                CheckboxListTile(
                  title: Text('Cash on Delivery (COD)'),
                  value: codSelected,
                  onChanged: (value) {
                    setState(() {
                      codSelected = value!;
                    });
                  },
                ),

                // Add fields for Paymaya payment details here
                SizedBox(height: 16),
                Text(
                  'Payment Details:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Merchandise: \₱${calculateTotalAmount().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Shipping fee: \₱${getShippingFee().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Total: \₱${(calculateTotalAmount() + getShippingFee()).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, you can proceed with the form submission
                      placeOrder();
                    }
                  },
                  child: Text('Place Order'),
                ),
              ],
            ),
          )),
    );
  }

  double calculateTotalAmount() {
    return widget.cartItems.fold(0, (total, item) {
      final price = item['price'] as num? ?? 0;
      final quantity = widget.itemQuantities[item['item_id'].toString()] ?? 1;
      return total + price * quantity;
    });
  }

  double getShippingFee() {
    if (jAndTExpressSelected) {
      return 100.0;
    } else if (ninjaVanSelected) {
      return 80.0;
    } else if (lbcSelected) {
      return 330.0;
    } else {
      return 0.0;
    }
  }

  Future<void> placeOrder() async {
    final deliveryAddress = addressController.text;
    final phoneNumber = phoneNumberController.text;
    final parcelName = parcelNameController.text;
    final cartDetails = widget.cartItems.map((item) {
      return {
        'item_id': item['item_id'],
        'name': item['name'],
        'quantity': widget.itemQuantities[item['item_id'].toString()] ?? 1,
      };
    }).toList();
    final shippingOption = jAndTExpressSelected
        ? 'JT Express'
        : (ninjaVanSelected ? 'NinjaVan' : 'LBC');
    final orderTotal = calculateTotalAmount();
    final paymentOption = codSelected ? 'Cash on Delivery (COD)' : '';
    final totalPayment = orderTotal + getShippingFee();

    final Map<String, dynamic> orderData = {
      'user_id': widget.userId,
      'deliveryAddress': deliveryAddress,
      'phoneNumber': phoneNumber,
      'parcelName': parcelName,
      'cartDetails': cartDetails,
      'shippingOption': shippingOption,
      'orderTotal': orderTotal,
      'paymentOption': paymentOption,
      'totalPayment': totalPayment,
    };

    final response = await http.post(
      Uri.parse('http://localhost:3000/placeOrder'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final orderId = responseData['orderId'];
      print('Order placed successfully. Order ID: $orderId');

      Fluttertoast.showToast(
        msg: 'Order placed successfully. Order ID: $orderId',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Update local quantities after placing the order
      widget.cartItems.forEach((item) {
        final itemId = item['item_id'].toString();
        final quantity = widget.itemQuantities[itemId] ?? 1;

        // Convert quantity to integer using toInt()
        widget.itemQuantities[itemId] = (quantity - item['quantity']).toInt();
      });

      // Navigate to the home screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardOfFragments(
            userId: widget.userId,
            userEmail: widget.userEmail,
            userName: widget.userName,
          ),
        ),
      );
    } else {
      print('Failed to place order. Error: ${response.body}');
      Fluttertoast.showToast(
        msg: 'Failed to place order. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}

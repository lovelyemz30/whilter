import 'package:clothes/users/checkout/checkout.dart';
import 'package:clothes/users/widgets/custom_message.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final int userId; // Add this line
  final String userEmail;
  final String userName;

  const CartPage(
      {Key? key,
      required this.cartItems,
      required this.userId,
      required this.userEmail,
      required this.userName})
      : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<String, int> itemQuantities = {};
  Map<String, TextEditingController> quantityControllers = {};
  bool validateQuantities() {
    for (var cartItem in widget.cartItems) {
      final itemId = cartItem['item_id'].toString();
      final quantity = itemQuantities[itemId] ?? 1;
      final availableQuantity = cartItem['quantity'] as int? ?? 1;

      if (quantity <= 0 || quantity > availableQuantity) {
        return false;
      }
    }
    return true;
  }

  double calculateTotalAmount() {
    return widget.cartItems.fold(0, (total, item) {
      final price = item['price'] as num? ?? 0;
      final quantity = itemQuantities[item['item_id'].toString()] ?? 1;
      return total + price * quantity;
    });
  }

  void removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
  }

  void updateQuantity(String itemId, int newQuantity) {
    setState(() {
      final availableQuantity = widget.cartItems.firstWhere(
            (item) => item['item_id'].toString() == itemId,
            orElse: () => {'quantity': 1},
          )['quantity'] as int? ??
          1;

      if (newQuantity == 0) {
        CustomOverlayMessage.showOverlayMessage(
          context,
          "Please click remove icon to remove item, where you can see the remove icon beside the image",
        );
      } else if (newQuantity > 0 && newQuantity <= availableQuantity) {
        itemQuantities[itemId] = newQuantity;
        quantityControllers[itemId]?.text = newQuantity.toString();
      } else {
        CustomOverlayMessage.showOverlayMessage(
          context,
          "Only $availableQuantity Available, Please Change the quantity",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      backgroundColor: Colors.black,
      body: widget.cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your Cart is Empty',
                style: TextStyle(color: Colors.white),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Cart Items',
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  cartItemsWidget(context),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: \₱${calculateTotalAmount().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (validateQuantities()) {
                              // Pass both cart items and quantities to CheckoutPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPage(
                                    cartItems: widget.cartItems,
                                    itemQuantities: itemQuantities,
                                    userId: widget.userId,
                                    userEmail: widget.userEmail,
                                    userName: widget.userName,
                                  ),
                                ),
                              );
                            } else {
                              CustomOverlayMessage.showOverlayMessage(
                                context,
                                "Invalid quantity. Please adjust quantities before checkout.",
                              );
                            }
                          },
                          child: Text('Checkout'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget cartItemsWidget(BuildContext context) {
    return ListView.builder(
      itemCount: widget.cartItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final cartItem = widget.cartItems[index];
        final price = cartItem['price'] as num? ?? 0;
        final itemId = cartItem['item_id'].toString();
        final quantity = itemQuantities[itemId] ?? 1;
        final availableQuantity = cartItem['quantity'] as int? ?? 1;

        final quantityController = quantityControllers.putIfAbsent(
          itemId,
          () => TextEditingController(text: quantity.toString()),
        );

        return Dismissible(
          key: Key(itemId),
          onDismissed: (direction) {
            removeItem(index);
          },
          background: Container(
            color: Colors.red,
            child: Icon(Icons.delete, color: Colors.white),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16.0),
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Name: ${cartItem['name']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                              ),
                              child: Text(
                                'Price: \₱${price.toStringAsFixed(2)}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.purpleAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Size: ${cartItem['size']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Description: ${cartItem['description']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Quantity: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              child: TextField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                onChanged: (value) {
                                  // Handle onChanged if needed
                                },
                                onSubmitted: (value) {
                                  updateQuantity(itemId, int.parse(value));
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                updateQuantity(itemId, quantity + 1);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                updateQuantity(itemId, quantity - 1);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'images/${cartItem['image']}',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    removeItem(index);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 16,
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
}

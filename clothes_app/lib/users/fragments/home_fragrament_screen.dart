import 'package:clothes/users/widgets/custom_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../cart_page.dart/cartpage.dart';

class HomeFragmentScreen extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) addtofavoriteCallback;
  final int userId;
  final String userEmail;
  final String userName;

  HomeFragmentScreen({
    Key? key,
    required this.userId,
    required this.addtofavoriteCallback,
    required this.userEmail,
    required this.userName,
  }) : super(key: key);

  @override
  State<HomeFragmentScreen> createState() => _HomeFragmentScreenState();
}

class _HomeFragmentScreenState extends State<HomeFragmentScreen> {
  List<Map<String, dynamic>> itemsData = [];
  List<Map<String, dynamic>> cartItems = [];
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

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
            itemsData.forEach((item) {
              item['isFavorite'] = false;
            });
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

  void filterItems(String query) {
    _searchResults.clear();

    if (query.isNotEmpty) {
      _searchResults = itemsData
          .where((item) =>
              item['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: (query) => filterItems(query),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(
                          cartItems: cartItems,
                          userId: widget.userId,
                          userEmail: widget.userEmail,
                          userName: widget.userName,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Text(
                  "New Collections",
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/");
                },
                child: Text('Sign-out'),
              ),
            ],
          ),
          allItemsWidget(context),
        ],
      ),
    );
  }

  Widget allItemsWidget(context) {
    List<Map<String, dynamic>> displayItems =
        _searchController.text.isNotEmpty ? _searchResults : itemsData;

    return ListView.builder(
      itemCount: displayItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final item = displayItems[index];
        bool isFavorite = item['isFavorite'];

        return GestureDetector(
          onTap: () {
            // Handle item click as needed
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(
              16,
              index == 0 ? 16 : 8,
              16,
              index == displayItems.length - 1 ? 16 : 8,
            ),
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
                                'Name: ${item['name']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                              ),
                              child: Text(
                                'Price: \₱${item['price']}',
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
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Size: ${item['size']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Description: ${item['description']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                addtofavorite(context, item);
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                addToCart(context, item);
                              },
                              child: Text('Add to Cart'),
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
                    'images/${item['image']}',
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addToCart(BuildContext context, Map<String, dynamic> item) {
    int quantity = item['quantity'] ?? 1;
    int availableQuantity = item['quantity'] ?? 1;

    if (quantity > 0) {
      if (quantity <= availableQuantity) {
        bool itemExists = cartItems.contains(item);

        if (!itemExists) {
          setState(() {
            cartItems.add(item);
          });

          CustomOverlayMessage.showOverlayMessage(
              context, "Item added to cart");
        } else {
          CustomOverlayMessage.showOverlayMessage(context,
              "This item is already in your cart. To view your cart, check the cart icon next to the search bar ");
        }
      } else {
        CustomOverlayMessage.showOverlayMessage(
            context, "Only $availableQuantity available");
      }
    } else {
      CustomOverlayMessage.showOverlayMessage(
          context, "The item is not available");
    }
  }

  void addtofavorite(BuildContext context, Map<String, dynamic> item) {
    int index = itemsData.indexOf(item);
    bool isFavorite = itemsData[index]['isFavorite'];

    if (!isFavorite) {
      setState(() {
        itemsData[index]['isFavorite'] = true;
        widget.addtofavoriteCallback(
            itemsData.where((item) => item['isFavorite']).toList());
      });

      CustomOverlayMessage.showOverlayMessage(
          context, "Item added to favorites");
    } else {
      CustomOverlayMessage.showOverlayMessage(context,
          "This item is already in your favorites. To view your favorites, check the icons below and click the heart icon next to the home icon.");
    }
  }
}

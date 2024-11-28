import 'package:flutter/material.dart';

class FavoritesFragmentScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteItems;

  const FavoritesFragmentScreen({Key? key, required this.favoriteItems})
      : super(key: key);

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
              'Favorite Items',
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 20),
          favoriteItemsWidget(context),
        ],
      ),
    );
  }

  Widget favoriteItemsWidget(BuildContext context) {
    return ListView.builder(
      itemCount: favoriteItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final favoriteItem = favoriteItems[index];

        return GestureDetector(
          onTap: () {
            // Handle item click as needed
          },
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
                                'Name: ${favoriteItem['name']}',
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
                                'Price: \₱${favoriteItem['price'].toStringAsFixed(2)}',
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
                          'Size: ${favoriteItem['size']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Description: ${favoriteItem['description']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
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
                    'images/${favoriteItem['image']}',
                    width: 80,
                    height: 80,
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
}






// import 'package:flutter/material.dart';

// class FavoritesFragmentScreen extends StatefulWidget {
//   final List<Map<String, dynamic>> favoriteItems;

//   FavoritesFragmentScreen({Key? key, required this.favoriteItems})
//       : super(key: key);

//   @override
//   State<FavoritesFragmentScreen> createState() =>
//       _FavoritesFragmentScreenState();
// }

// class _FavoritesFragmentScreenState extends State<FavoritesFragmentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 24, 8, 8),
//             child: Text(
//               "My Favorite List:",
//               style: TextStyle(
//                 color: Colors.purpleAccent,
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 24, 8, 8),
//             child: Text(
//               "Order these best clothes for yourself now",
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           favoriteItemsWidget(context),
//           SizedBox(
//             height: 24,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget favoriteItemsWidget(context) {
//     return ListView.builder(
//       itemCount: widget.favoriteItems.length,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         final item = widget.favoriteItems[index];

//         return Container(
//           margin: EdgeInsets.fromLTRB(
//             16,
//             index == 0 ? 16 : 8,
//             16,
//             index == widget.favoriteItems.length - 1 ? 16 : 8,
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Color.fromARGB(255, 0, 0, 0),
//             boxShadow: const [
//               BoxShadow(
//                 offset: Offset(0, 0),
//                 blurRadius: 6,
//                 color: Colors.grey,
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               'Name: ${item['name']}',
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               left: 12,
//                               right: 12,
//                             ),
//                             child: Text(
//                               'Price: \$${item['price']}',
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: Colors.purpleAccent,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 16,
//                       ),
//                       Text(
//                         'Size: ${item['size']}',
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 8,
//                       ),
//                       Text(
//                         'Description: ${item['description']}',
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   bottomRight: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//                 child: Image.asset(
//                   'images/${item['image']}',
//                   width: 130,
//                   height: 130,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

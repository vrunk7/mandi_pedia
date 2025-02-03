// jovin dsouza
// import 'package:flutter/material.dart';
// import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'search_result.dart'; // result screen

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: const Color(0xFF1995AD),
//         scaffoldBackgroundColor: const Color(0xFFF1F1F2),
//         textTheme: GoogleFonts.exo2TextTheme(),
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//   final bool _isSearching = false;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               'assets/orange_background.jpg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned(
//             top: 30,
//             left: 20,
//             child: Text(
//               "MandiPedia",
//               style: TextStyle(
//                 fontSize: 34,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 letterSpacing: 1.5,
//                 shadows: [
//                   Shadow(
//                     blurRadius: 3.0,
//                     color: Colors.black.withOpacity(0.5),
//                     offset: const Offset(1, 1),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0,
//             right: 0,
//             child: Image.asset(
//               'assets/logo2.png',
//               height: 95,
//               width: 90,
//             ),
//           ),
//           Positioned(
//             top: MediaQuery.of(context).size.height * 0.35,
//             left: 0,
//             right: 0,
//             child: Column(
//               children: [
//                 const Text(
//                   "Discover Price",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: "Search...",
//                       suffixIcon: IconButton(
//                         icon: Icon(Icons.search,
//                             color: Theme.of(context).primaryColor),
//                         onPressed: () async {
//                           print(
//                               "); // Debug line to check if the button press is triggered
//                           String searchQuery = _searchController.text.trim();
//                           if (searchQuery.isNotEmpty) {
//                             print(
//                                 "Sending request for: $searchQuery"); // Debug to see what is being sent
//                             final response = await http.get(
//                               Uri.parse(
//                                   'http://127.0.0.1:5000/get-data?product=$searchQuery'),
//                             );

//                             if (response.statusCode == 200) {
//                               List<dynamic> results = jsonDecode(response.body);
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => SearchResultsScreen(
//                                       searchResults: results),
//                                 ),
//                               );
//                             } else {
//                               print(
//                                   "Error fetching data: ${response.statusCode}");
//                             }
//                           }
//                         },
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.8),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: MediaQuery.of(context).size.height * 0.07,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildLogo('assets/th.jpg'),
//                 _buildLogo('assets/bk.png'),
//                 _buildLogo('assets/swiggy-logo.png'),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: FlashyTabBar(
//         selectedIndex: _selectedIndex,
//         animationDuration: const Duration(milliseconds: 500),
//         onItemSelected: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         items: [
//           FlashyTabBarItem(
//             icon: const Icon(Icons.home),
//             title: const Text('Home'),
//           ),
//           FlashyTabBarItem(
//             icon: const Icon(Icons.tag),
//             title: const Text('Tags'),
//           ),
//           FlashyTabBarItem(
//             icon: const Icon(Icons.close),
//             title: const Text('Close'),
//           ),
//           FlashyTabBarItem(
//             icon: const Icon(Icons.person),
//             title: const Text('Profile'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget _buildCard(String imagePath, String title, String price) {
//   //   return Card(
//   //     shape: RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.circular(15),
//   //     ),
//   //     elevation: 5,
//   //     child: ListTile(
//   //       leading: Image.asset(imagePath, width: 50, height: 50),
//   //       title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//   //       subtitle: Text(price, style: const TextStyle(color: Colors.green)),
//   //     ),
//   //   );
//   // }

//   Widget _buildLogo(String imagePath) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(15),
//       child: Image.asset(
//         imagePath,
//         width: 70,
//         height: 70,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search_result.dart'; // result screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1995AD),
        scaffoldBackgroundColor: const Color(0xFFF1F1F2),
        textTheme: GoogleFonts.exo2TextTheme(),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/orange_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Text(
              "MandiPedia",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    blurRadius: 3.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/logo2.png',
              height: 95,
              width: 90,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  "Discover Price",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller:
                        _searchController, // Make sure controller is linked
                    decoration: InputDecoration(
                      hintText: "Search...",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search,
                            color: Theme.of(context).primaryColor),
                        onPressed: () async {
                          print("Button pressed");

                          String searchQuery = _searchController.text.trim();
                          print("Search query: $searchQuery");

                          if (searchQuery.isNotEmpty) {
                            print("Sending request for: $searchQuery");

                            // Change localhost to the actual IP address for mobile devices
                            final response = await http.get(
                              Uri.parse(
                                  'http://127.0.0.1:5000/get-data?product=$searchQuery'),
                            );

                            if (response.statusCode == 200) {
                              var results = jsonDecode(response.body);
                              print(results);
                              if (results is Map<String, dynamic>) {
                                // var price = results['site1']['price'] ?? 'N//A';
                                // var quantity = results['site1']['quantity'] ?? 'N//A';
                                // var price1 = results['site2']['price'] ?? 'N//A';
                                // var quantity1 = results['site2']['quantity'] ?? 'N//A';

                                // Navigate to SearchResultsScreen with the price and quantity data
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchResultsScreen(
                                      // price: price,
                                      // quantity: quantity,
                                      results: results,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              print(
                                  "Error fetching data: ${response.statusCode}");
                              print("Response body: ${response.body}");
                            }
                          } else {
                            print("Search query is empty.");
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.07,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLogo('assets/th.jpg'),
                _buildLogo('assets/bk.png'),
                _buildLogo('assets/swiggy-logo.png'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        animationDuration: const Duration(milliseconds: 500),
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.tag),
            title: const Text('Tags'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.close),
            title: const Text('Close'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
          ),
        ],
      ),
    );
  }

  // Widget _buildCard(String imagePath, String title, String price) {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     elevation: 5,
  //     child: ListTile(
  //       leading: Image.asset(imagePath, width: 50, height: 50),
  //       title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
  //       subtitle: Text(price, style: const TextStyle(color: Colors.green)),
  //     ),
  //   );
  // }

  Widget _buildLogo(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        imagePath,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      ),
    );
  }
}
//hello
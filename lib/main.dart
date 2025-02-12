import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search_result.dart';
import 'inspect_prices_tab.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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

  final List<Widget> _tabs = [
    const HomeTab(),
    const InspectPricesTab(),
    Center(child: Text("Close Tab")),
    Center(child: Text("Profile Tab")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
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
}

// First tab widget (Home Screen UI)
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

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
                    controller: _searchController,
                    enabled: !_isLoading, // Disable TextField when loading
                    decoration: InputDecoration(
                      hintText: "Search...",
                      suffixIcon: _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            )
                          : IconButton(
                              icon: Icon(Icons.search,
                                  color: Theme.of(context).primaryColor),
                              onPressed: _search,
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
    );
  }

  void _search() async {
    setState(() {
      _isLoading = true; // Show loading icon
    });

    String searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      print("Sending request for: $searchQuery");
      final response = await http.get(
        Uri.parse('http://127.0.0.1:5000/get-data?product=$searchQuery'),
      );

      setState(() {
        _isLoading = false; // Hide loading icon
      });

      if (response.statusCode == 200) {
        var results = jsonDecode(response.body);
        if (results is Map<String, dynamic>) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultsScreen(
                query: searchQuery,
                results: results,
              ),
            ),
          );
          setState(() {
            _searchController.clear();
            _isLoading = false;
          });
        }
      } else {
        print("Error fetching data: ${response.statusCode}");
      }
    } else {
      setState(() {
        _isLoading = false; // Hide loading icon if query is empty
      });
      print("Search query is empty.");
    }
  }

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

 // import 'package:flutter/material.dart';
// import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'search_result.dart'; // result screen
// import 'inspect_prices_tab.dart'; // Graph Screen

// void main() {
//   runApp(
//     const ProviderScope(
//       child: MyApp(),
//     ),
//   );
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
//   final TextEditingController _searchController = TextEditingController();
//   final List<Widget> _tabs = [
//     HomePage(), // First tab
//     const InspectPricesTab(), // Second tab
//     Center(child: Text("Close Tab")), // Third tab (Placeholder)
//     Center(child: Text("Profile Tab")), // Fourth tab (Placeholder)
//   ];
//   bool _isLoading = false; // Loading state

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
//                     controller: _searchController,
//                     enabled: !_isLoading, // Disable TextField when loading
//                     decoration: InputDecoration(
//                       hintText: "Search...",
//                       suffixIcon: _isLoading
//                           ? const Padding(
//                               padding: EdgeInsets.all(10.0),
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor:
//                                     AlwaysStoppedAnimation<Color>(Colors.blue),
//                               ),
//                             )
//                           : IconButton(
//                               icon: Icon(Icons.search,
//                                   color: Theme.of(context).primaryColor),
//                               onPressed: _search,
//                             ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.8),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 if (_isLoading || _searchController.text.isNotEmpty)
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _isLoading =
//                             false; // Stop loading when cancel is pressed
//                         _searchController.clear(); // Clear search text
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         width: 120,
//                         decoration: BoxDecoration(
//                           color: Colors.red.withOpacity(0.8),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: const Text(
//                           "CANCEL",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
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

//   void _search() async {
//     setState(() {
//       _isLoading = true; // Show loading icon
//     });

//     String searchQuery = _searchController.text.trim();
//     if (searchQuery.isNotEmpty) {
//       print("Sending request for: $searchQuery");
//       final response = await http.get(
//         Uri.parse('http://127.0.0.1:5000/get-data?product=$searchQuery'),
//       );

//       setState(() {
//         _isLoading = false; // Hide loading icon
//       });

//       if (response.statusCode == 200) {
//         var results = jsonDecode(response.body);
//         if (results is Map<String, dynamic>) {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => SearchResultsScreen(
//                 query: searchQuery,
//                 results: results,
//               ),
//             ),
//           );
//           setState(() {
//             _searchController.clear();
//             _isLoading = false;
//           });
//         }
//       } else {
//         print("Error fetching data: ${response.statusCode}");
//       }
//     } else {
//       setState(() {
//         _isLoading = false; // Hide loading icon if query is empty
//       });
//       print("Search query is empty.");
//     }
//   }

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

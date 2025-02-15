import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'main.dart';
import 'for_you.dart';
import 'inspect_prices_tab.dart';

class Guess_Price extends StatelessWidget {
  const Guess_Price({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF1995AD),
        scaffoldBackgroundColor: const Color(0xFFF1F1F2),
        textTheme: GoogleFonts.exo2TextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _commodityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<Map<String, dynamic>> commodities = [];
  String? selectedCommodity;
  int points = 0;
  Set<String> guessedCommodities = {};
  bool showSparkles = false;

  @override
  void initState() {
    super.initState();
    loadCommodities();
  }

  Future<void> loadCommodities() async {
    final String response = await rootBundle.loadString('assets/prices.json');
    final data = json.decode(response);
    setState(() {
      commodities = List<Map<String, dynamic>>.from(data['FV']);
    });
  }

  void predictPrice() {
    if (selectedCommodity == null || _priceController.text.isEmpty) return;

    final commodity = commodities.firstWhere(
      (item) => item['Commodity'] == selectedCommodity,
    );

    final prices = [
      commodity['Jan'] ?? 0,
      commodity['Feb'] ?? 0,
      commodity['Mar'] ?? 0,
      commodity['Apr'] ?? 0,
      commodity['May'] ?? 0,
      commodity['June'] ?? 0,
      commodity['July'] ?? 0,
      commodity['Aug'] ?? 0,
      commodity['Sep'] ?? 0,
      commodity['Oct'] ?? 0,
      commodity['Nov'] ?? 0,
      commodity['Dec'] ?? 0,
    ].map((price) => price.toDouble()).toList();

    final predictedPrice =
        (prices.reduce((a, b) => a + b) / prices.length).round();

    final userPrice = int.tryParse(_priceController.text) ?? 0;

    print("Predicted Price: $predictedPrice");
    print("User's Entered Price: $userPrice");

    if (userPrice == predictedPrice) {
      setState(() {
        points += 10;
        guessedCommodities.add(selectedCommodity!);
        showSparkles = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          showSparkles = false;
        });
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("🎉 Correct! 🎉"),
            content: const Text("You guessed the price correctly!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Continue"),
              ),
            ],
          );
        },
      );
    } else {
      String hint;
      if (userPrice < predictedPrice) {
        hint = "Too low! Try a higher price.";
      } else if (userPrice > predictedPrice) {
        hint = "Too high! Try a lower price.";
      } else {
        hint = "Close, but not quite!";
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Incorrect!"),
            content: Text(hint),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Try Again"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("Bg4.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: const Text(
              "Mandipedia",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    blurRadius: 3.0,
                    color: Colors.black,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 300,
            child: Image.asset(
              'assets/logo2.png', // Path to your logo image
              width: 150, // Adjust the width as needed
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("GUESS THE PRICE !!", style: TextStyle(fontSize: 24)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return commodities
                        .map((item) => item['Commodity'] as String)
                        .where((item) =>
                            item.toLowerCase().contains(
                                textEditingValue.text.toLowerCase()) &&
                            !guessedCommodities.contains(item));
                  },
                  onSelected: (String value) {
                    setState(() {
                      selectedCommodity = value;
                    });
                  },
                  fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController controller,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Search Commodity",
                        prefixIcon: Icon(Icons.search), // Search icon
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter Price",
                    enabled: selectedCommodity != null,
                    prefixIcon: Icon(Icons.currency_rupee), // Rupee icon
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty &&
                        !RegExp(r'^[1-9][0-9]*$').hasMatch(value)) {
                      _priceController.text = "";
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: predictPrice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text("Submit", style: TextStyle(fontSize: 18)),
              ),
              Text("Points: $points", style: const TextStyle(fontSize: 24)),
            ],
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const InspectPricesTab(),
    const MandiPediaApp(),
    const Guess_Price(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        backgroundColor:
            const Color.fromARGB(255, 69, 71, 214), // Changed background color
        animationDuration: const Duration(milliseconds: 500),
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home, color: Color(0xFF8B5E3C)),
            title: const Text('Home'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.trending_up, color: Color(0xFF8B5E3C)),
            title: const Text('Trends'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.recommend, color: Color(0xFF8B5E3C)),
            title: const Text('For You'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.sports_esports, color: Color(0xFF8B5E3C)),
            title: const Text('Game'),
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'dart:math';
// import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
// import 'main.dart';
// import 'for_you.dart';
// import 'inspect_prices_tab.dart';

// class Guess_Price extends StatelessWidget {
//   const Guess_Price({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primaryColor: const Color(0xFF1995AD),
//         scaffoldBackgroundColor: const Color(0xFFF1F1F2),
//         textTheme: GoogleFonts.exo2TextTheme(),
//       ),
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _commodityController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   List<Map<String, dynamic>> commodities = [];
//   String? selectedCommodity;
//   int points = 0;
//   Set<String> guessedCommodities = {};
//   bool showSparkles = false;

//   @override
//   void initState() {
//     super.initState();
//     loadCommodities();
//   }

//   Future<void> loadCommodities() async {
//     final String response = await rootBundle.loadString('assets/prices.json');
//     final data = json.decode(response);
//     setState(() {
//       commodities = List<Map<String, dynamic>>.from(data['FV']);
//     });
//   }

//   void predictPrice() {
//     if (selectedCommodity == null || _priceController.text.isEmpty) return;

//     final commodity = commodities.firstWhere(
//       (item) => item['Commodity'] == selectedCommodity,
//     );

//     final prices = [
//       commodity['Jan'] ?? 0,
//       commodity['Feb'] ?? 0,
//       commodity['Mar'] ?? 0,
//       commodity['Apr'] ?? 0,
//       commodity['May'] ?? 0,
//       commodity['June'] ?? 0,
//       commodity['July'] ?? 0,
//       commodity['Aug'] ?? 0,
//       commodity['Sep'] ?? 0,
//       commodity['Oct'] ?? 0,
//       commodity['Nov'] ?? 0,
//       commodity['Dec'] ?? 0,
//     ].map((price) => price.toDouble()).toList();

//     final predictedPrice =
//         (prices.reduce((a, b) => a + b) / prices.length).round();

//     final userPrice = int.tryParse(_priceController.text) ?? 0;

//     print("Predicted Price: $predictedPrice");
//     print("User's Entered Price: $userPrice");

//     if (userPrice == predictedPrice) {
//       setState(() {
//         points += 10;
//         guessedCommodities.add(selectedCommodity!);
//         showSparkles = true;
//       });

//       Future.delayed(const Duration(seconds: 2), () {
//         setState(() {
//           showSparkles = false;
//         });
//       });

//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text("🎉 Correct! 🎉"),
//             content: const Text("You guessed the price correctly!"),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text("Continue"),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       String hint;
//       if (userPrice < predictedPrice) {
//         hint = "Too low! Try a higher price.";
//       } else if (userPrice > predictedPrice) {
//         hint = "Too high! Try a lower price.";
//       } else {
//         hint = "Close, but not quite!";
//       }

//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text("Incorrect!"),
//             content: Text(hint),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text("Try Again"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("Bg4.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 30,
//             left: 130,
//             child: Text(
//               "MandiPedia",
//               style: TextStyle(
//                 fontSize: 45,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 letterSpacing: 1.5,
//                 shadows: [
//                   Shadow(
//                     blurRadius: 3.0,
//                     color: Colors.black.withOpacity(0.5),
//                     offset: const Offset(1, 1),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text("GUESS THE PRICE !!", style: TextStyle(fontSize: 24)),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Autocomplete<String>(
//                   optionsBuilder: (TextEditingValue textEditingValue) {
//                     if (textEditingValue.text.isEmpty) {
//                       return const Iterable<String>.empty();
//                     }
//                     return commodities
//                         .map((item) => item['Commodity'] as String)
//                         .where((item) =>
//                             item.toLowerCase().contains(
//                                 textEditingValue.text.toLowerCase()) &&
//                             !guessedCommodities.contains(item));
//                   },
//                   onSelected: (String value) {
//                     setState(() {
//                       selectedCommodity = value;
//                     });
//                   },
//                   fieldViewBuilder: (
//                     BuildContext context,
//                     TextEditingController controller,
//                     FocusNode focusNode,
//                     VoidCallback onFieldSubmitted,
//                   ) {
//                     return TextField(
//                       controller: controller,
//                       focusNode: focusNode,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: "Search Commodity",
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   controller: _priceController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     hintText: "Enter Price",
//                     enabled: selectedCommodity != null,
//                   ),
//                   onChanged: (value) {
//                     if (value.isNotEmpty &&
//                         !RegExp(r'^[1-9][0-9]*$').hasMatch(value)) {
//                       _priceController.text = "";
//                     }
//                   },
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: predictPrice,
//                 child: const Text("Submit"),
//               ),
//               Text("Points: $points", style: const TextStyle(fontSize: 24)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   final List<Widget> _tabs = [
//     const HomeTab(),
//     const InspectPricesTab(),
//     const MandiPediaApp(),
//     const Guess_Price(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _tabs[_selectedIndex],
//       bottomNavigationBar: FlashyTabBar(
//         selectedIndex: _selectedIndex,
//         backgroundColor:
//             const Color.fromARGB(255, 69, 71, 214), // Changed background color
//         animationDuration: const Duration(milliseconds: 500),
//         onItemSelected: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         items: [
//           FlashyTabBarItem(
//             icon: const Icon(Icons.home, color: Color(0xFF8B5E3C)),
//             title: const Text('Home'),
//           ),
//           FlashyTabBarItem(
//             icon: const Icon(Icons.trending_up, color: Color(0xFF8B5E3C)),
//             title: const Text('Trends'),
//           ),
//           FlashyTabBarItem(
//             icon: const Icon(Icons.recommend, color: Color(0xFF8B5E3C)),
//             title: const Text('For You'),
//           ),
//           FlashyTabBarItem(
//             icon: const Icon(Icons.sports_esports, color: Color(0xFF8B5E3C)),
//             title: const Text('Game'),
//           ),
//         ],
//       ),
//     );
//   }
// }

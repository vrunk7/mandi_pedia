import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:google_fonts/google_fonts.dart';

class MandiPediaApp extends StatelessWidget {
  const MandiPediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.exo2TextTheme(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> topSearchedFruits = [];
  List<Map<String, dynamic>> topSellingFruits = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      final String response = await rootBundle.loadString('assets/data.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> fruits = data['user_searches'];

      setState(() {
        topSearchedFruits = List<Map<String, dynamic>>.from(fruits)
          ..sort((a, b) => b['times_searched'].compareTo(a['times_searched']))
          ..length = 4;

        topSellingFruits = List<Map<String, dynamic>>.from(fruits)
          ..sort((a, b) => b['sales'].compareTo(a['sales']))
          ..length = 4;
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg10.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // App Title & Logo
          Positioned(
            top: 20, // Adjust spacing from the top
            left: 16, // Left padding for text
            right: 16, // Right padding for logo
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Align elements in a straight line
              children: [
                Text(
                  'MandiPedia',
                  style: TextStyle(
                    fontSize: 40, // Keep text size bold and clear
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B5E3C),
                    shadows: [
                      Shadow(
                          blurRadius: 4,
                          color: Colors.black45,
                          offset: Offset(1, 2)),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/logo2.png',
                  height: 80, // Adjusted to be in sync with text height
                  width: 80, // Increased width to maintain proportion
                  fit: BoxFit.contain, // Ensure it scales properly
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: 60, // Pushed content down after title & logo
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  sectionTitle('For You', 60, center: true),
                  const SizedBox(height: 10),
                  sectionTitle('Recommended', 100),
                  cardScrollSection(topSearchedFruits),
                  sectionTitle('Best Seller', 100),
                  cardScrollSection(topSellingFruits),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title, double vanishOffset,
      {bool center = false}) {
    double scrollOffset =
        _scrollController.hasClients ? _scrollController.offset : 0;
    return Opacity(
      opacity: scrollOffset >= vanishOffset ? 0 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
        child: Align(
          alignment: center ? Alignment.center : Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: title == 'For You' ? 24 : 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8B5E3C),
            ),
          ),
        ),
      ),
    );
  }

  Widget cardScrollSection(List<Map<String, dynamic>> fruits) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: fruits
            .map((fruit) =>
                buildCard(fruit['fruit'], fruitImageUrl(fruit['fruit'])))
            .toList(),
      ),
    );
  }

  Widget buildCard(String fruitName, String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      width: 160,
      height: 190,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 4))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15), // Rounded corners
            child: Image.asset(imagePath,
                width: 95, height: 95, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Text(
            fruitName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String fruitImageUrl(String fruitName) {
    Map<String, String> fruitImages = {
      "Apple": "assets/apple.jpg",
      "Banana": "assets/banana.jpg",
      "Cherry": "assets/cherry.jpg",
      "Lychee": "assets/lychee.jpg",
      "Plum": "assets/plum.jpg",
      "Strawberry": "assets/strawberry.jpg",
      "Potato": "assets/potato.jpg",
      "Mango": "assets/mango.jpg",
      "Onion": "assets/onion.jpg"
    };
    return fruitImages[fruitName] ?? "assets/apple.jpg";
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const AkinatorApp());
}

class AkinatorApp extends StatelessWidget {
  const AkinatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AkinatorHome(),
    );
  }
}

class AkinatorHome extends StatefulWidget {
  const AkinatorHome({super.key});

  @override
  _AkinatorHomeState createState() => _AkinatorHomeState();
}

class _AkinatorHomeState extends State<AkinatorHome> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (Optional)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage("assets/Bg4.jpg"), // Add your background image
                fit: BoxFit.cover,
              ),
            ),
          ),

          // MandiPedia Title (Top-Left)
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

          // Logo (Top-Right)
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/logo2.png', // Path to your logo
              height: 95,
              width: 90,
            ),
          ),

          // Akinator-like Tab Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Select the next game",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _buildCategoryButton("Thematic"),
                _buildCategoryButton("Characters"),
                _buildCategoryButton("Objects"),
                _buildCategoryButton("Animals"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build category buttons
  Widget _buildCategoryButton(String categoryName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          // Handle button press
          print("$categoryName selected");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        child: Text(
          categoryName,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

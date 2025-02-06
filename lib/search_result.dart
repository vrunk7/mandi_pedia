import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final Map<String, dynamic> results;
  final String query;

  const SearchResultsScreen({super.key, required this.results, required this.query});

  @override
  Widget build(BuildContext context) {
    // Extract price and quantity directly from the results
    var price1 = results['site1']['price'] ?? 'N/A';
    var quantity1 = results['site1']['quantity'] ?? 'N/A';
    var price2 = results['site2']['price'] ?? 'N/A';
    var quantity2 = results['site2']['quantity'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1995AD),
        title: Text("Search Results for '$query'",
          style: TextStyle(
            fontWeight: FontWeight.bold,
        ),
        ),
        //textTheme: GoogleFonts.exo2TextTheme(),
      ),
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
              height: 85,
              width: 80,
            ),
          ),
          Positioned(
            top: 150,
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard('assets/th.jpg', "Zepto", price1, quantity1),
                const SizedBox(height: 20),
                _buildCard(
                    'assets/swiggy-logo.png', "InstaMart", price2, quantity2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      String imagePath, String title, String price, String quantity) {
        String formattedPrice = price.contains('₹') ? price : '₹$price';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        leading: Image.asset(imagePath, width: 70, height: 100),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "$formattedPrice | $quantity",
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            ),
        ),
      ),
    );
  }
}


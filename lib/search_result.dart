// // import 'package:flutter/material.dart';

// // class SearchResultsScreen extends StatelessWidget {
// //   final List<dynamic> searchResults;

// //   const SearchResultsScreen({super.key, required this.searchResults});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: const Color(0xFF1995AD),
// //         title: const Text("Search Results"),
// //       ),
// //       body: Stack(
// //         children: [
// //           Positioned.fill(
// //             child: Image.asset(
// //               'assets/orange_background.jpg',
// //               fit: BoxFit.cover,
// //             ),
// //           ),
// //           Positioned(
// //             top: 30,
// //             left: 20,
// //             child: Text(
// //               "MandiPedia",
// //               style: TextStyle(
// //                 fontSize: 34,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //                 letterSpacing: 1.5,
// //                 shadows: [
// //                   Shadow(
// //                     blurRadius: 3.0,
// //                     color: Colors.black.withOpacity(0.5),
// //                     offset: const Offset(1, 1),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           Positioned(
// //             top: 150,
// //             left: 20,
// //             right: 20,
// //             bottom: 20,
// //             child: searchResults.isEmpty
// //                 ? const Center(
// //                     child: Text(
// //                       "No results found",
// //                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
// //                     ),
// //                   )
// //                 : ListView.builder(
// //                     itemCount: searchResults.length,
// //                     itemBuilder: (context, index) {
// //                       var item = searchResults[index];
// //                       return _buildCard(
// //                         item['image'] ?? 'assets/default.png',  // Provide default image
// //                         item['name'] ?? 'Unknown',
// //                         item['price'] ?? 'N/A',
// //                         item['quantity'] ?? 'N/A',
// //                       );
// //                     },
// //                   ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildCard(String imagePath, String title, String price, String quantity) {
// //     return Card(
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(15),
// //       ),
// //       elevation: 5,
// //       child: ListTile(
// //         leading: Image.asset(imagePath, width: 50, height: 50),
// //         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
// //         subtitle: Text("$price | $quantity", style: const TextStyle(color: Colors.green)),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class SearchResultsScreen extends StatefulWidget {
//   final String product;

//   const SearchResultsScreen({super.key, required this.product});

//   @override
//   _SearchResultsScreenState createState() => _SearchResultsScreenState();
// }

// class _SearchResultsScreenState extends State<SearchResultsScreen> {
//   late Future<Map<String, dynamic>> searchResults;

//   // Fetch data from Flask API
//   Future<Map<String, dynamic>> fetchSearchResults() async {
//     final response = await http.get(Uri.parse(
//         'http://127.0.0.1:5000/get-data?product=${widget.product}')); // Use your API URL
//     if (response.statusCode == 200) {
//       return json.decode(response.body); // Decode the JSON response
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     searchResults = fetchSearchResults();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1995AD),
//         title: const Text("Search Results"),
//       ),
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
//             top: 150,
//             left: 20,
//             right: 20,
//             bottom: 20,
//             child: FutureBuilder<Map<String, dynamic>>(
//               future: searchResults,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "No results found",
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                   );
//                 } else {
//                   final data = snapshot.data!;
//                   List<Map<String, dynamic>> results = [];
                  
//                   // Populate results from both sites (site1 and site2)
//                   if (data['site1'] != null) {
//                     results.add({
//                       'name': 'Zepto',
//                       'price': data['site1']['price'],
//                       'quantity': data['site1']['quantity'],
//                       'image': 'assets/zepto.png', // Add image or use a default
//                     });
//                   }
//                   if (data['site2'] != null) {
//                     results.add({
//                       'name': 'Instamart',
//                       'price': data['site2']['price'],
//                       'quantity': data['site2']['quantity'],
//                       'image': 'assets/instamart.png', // Add image or use a default
//                     });
//                   }

//                   return ListView.builder(
//                     itemCount: results.length,
//                     itemBuilder: (context, index) {
//                       var item = results[index];
//                       return _buildCard(
//                         item['image'] ?? 'assets/default.png',
//                         item['name'] ?? 'Unknown',
//                         item['price'] ?? 'N/A',
//                         item['quantity'] ?? 'N/A',
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCard(String imagePath, String title, String price, String quantity) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       elevation: 5,
//       child: ListTile(
//         leading: Image.asset(imagePath, width: 50, height: 50),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text("$price | $quantity", style: const TextStyle(color: Colors.green)),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class SearchResultsScreen extends StatelessWidget {
//   final String price;
//   final String quantity;

//   const SearchResultsScreen({super.key, required this.price, required this.quantity});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1995AD),
//         title: const Text("Search Results"),
//       ),
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
//             top: 150,
//             left: 20,
//             right: 20,
//             bottom: 20,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Price: $price",
//                   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   "Quantity: $quantity",
//                   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final Map<String, dynamic> results;

  const SearchResultsScreen({super.key, required this.results});

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
        title: const Text("Search Results"),
      ),
      body: Column(
        children: [
          _buildCard('assets/th.jpg', "Zepto", price1, quantity1),
          _buildCard('assets/swiggy-logo.png', "InstaMart", price2, quantity2),
        ],
      ),
    );
  }

  Widget _buildCard(String imagePath, String title, String price, String quantity) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        leading: Image.asset(imagePath, width: 50, height: 50),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "$price | $quantity",
          style: const TextStyle(color: Colors.green),
        ),
      ),
    );
  }
}

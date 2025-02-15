import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Define Riverpod provider to fetch data from JSON
final productDataProvider = FutureProvider<List<TrendData>>((ref) async {
  String data = await rootBundle.loadString('prices.json');
  final jsonData = jsonDecode(data);

  List<TrendData> trendData = [];

  for (var item in jsonData['FV']) {
    for (var month in item.keys) {
      if (month != "Commodity") {
        trendData.add(TrendData(
          commodity: item["Commodity"],
          month: month.trim(), // Trim spaces from keys
          price: (item[month] as num).toDouble(),
        ));
      }
    }
  }

  return trendData;
});

// Create TrendData class for chart data
class TrendData {
  final String commodity;
  final String month;
  final double price;

  TrendData(
      {required this.commodity, required this.month, required this.price});
}

// Main widget
class InspectPricesTab extends ConsumerStatefulWidget {
  const InspectPricesTab({super.key});

  @override
  _InspectPricesTabState createState() => _InspectPricesTabState();
}

class _InspectPricesTabState extends ConsumerState<InspectPricesTab> {
  final TextEditingController _searchController = TextEditingController();
  List<TrendData> _filteredData = [];
  bool _showGraph = false;

  final List<String> _quotes = [
    '"The price of success is hard work."',
    '"An investment in knowledge pays the best interest."',
    '"Do not save what is left after spending, but spend what is left after saving."',
    '"Wealth consists not in having great possessions, but in having few wants."',
    '"The stock market is filled with individuals who know the price of everything, but the value of nothing."',
    '"Money grows on the tree of persistence."',
    '"The real measure of your wealth is how much you’d be worth if you lost all your money."',
    '"Formal education will make you a living; self-education will make you a fortune."',
    '"It’s not about having lots of money. It’s about knowing how to manage it."',
    '"The goal isn’t more money. The goal is living life on your terms."'
  ];

  String _randomQuote = '';

  @override
  void initState() {
    super.initState();
    _randomQuote = (_quotes..shuffle()).first;
  }

  void _onSearchButtonPressed() {
    final inputText = _searchController.text.trim();

    if (inputText.isEmpty || RegExp(r'[^a-zA-Z ]').hasMatch(inputText)) {
      return;
    }

    final allData = ref.read(productDataProvider).maybeWhen(
          data: (data) => data.cast<TrendData>(), // Cast to List<TrendData>
          orElse: () => <TrendData>[],
        );

    setState(() {
      _filteredData = allData
          .where((item) =>
              item.commodity.toLowerCase().contains(inputText.toLowerCase()))
          .toList();
      _showGraph = _filteredData.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
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
                  Image.asset('assets/logo2.png', height: 95, width: 90),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search commodity...",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.blueAccent),
                    onPressed: _onSearchButtonPressed,
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

            const SizedBox(height: 20),

            // Display quote when no graph is shown
            if (!_showGraph)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _randomQuote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            // Display graph if search is valid
            if (_showGraph)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TrendLineChart(trendData: _filteredData),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TrendLineChart extends StatelessWidget {
  final List<TrendData> trendData;

  const TrendLineChart({super.key, required this.trendData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SfCartesianChart(
        title: ChartTitle(text: "Price Trends Over the Year"),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        tooltipBehavior: TooltipBehavior(enable: true),
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          enableDoubleTapZooming: true,
        ),
        series: trendData.map((data) {
          return LineSeries<TrendData, String>(
            dataSource:
                trendData.where((t) => t.commodity == data.commodity).toList(),
            xValueMapper: (TrendData trend, _) => trend.month,
            yValueMapper: (TrendData trend, _) => trend.price,
            name: data.commodity,
            color: Colors
                .primaries[trendData.indexOf(data) % Colors.primaries.length],
            dataLabelSettings: DataLabelSettings(isVisible: true),
            enableTooltip: true,
            markerSettings: MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
              borderWidth: 2,
            ),
          );
        }).toList(),
      ),
    );
  }
}

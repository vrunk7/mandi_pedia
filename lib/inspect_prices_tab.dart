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

  void _onSearchButtonPressed() {
    final allData = ref.read(productDataProvider).maybeWhen(
          data: (data) => data.cast<TrendData>(), // Cast to List<TrendData>
          orElse: () => <TrendData>[],
        );

    setState(() {
      _filteredData = allData
          .where((item) => item.commodity
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      _showGraph = _filteredData.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('background3.jpg'),
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
                          offset: Offset(1, 1),
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
                    icon: Icon(Icons.search, color: Colors.blueAccent),
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

// Interactive Trend Line Chart
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
        tooltipBehavior:
            TooltipBehavior(enable: true), // Enables hover tooltips
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          enableDoubleTapZooming: true,
        ), // Enables zooming & panning
        series: <CartesianSeries<TrendData, String>>[
          LineSeries<TrendData, String>(
            dataSource: trendData,
            xValueMapper: (TrendData trend, _) => trend.month,
            yValueMapper: (TrendData trend, _) => trend.price,
            dataLabelSettings:
                DataLabelSettings(isVisible: true), // Shows data labels
            enableTooltip: true, // Enables tooltip on hover
            markerSettings: MarkerSettings(
              isVisible: true, // Shows points on the line
              shape: DataMarkerType.circle,
              borderWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}

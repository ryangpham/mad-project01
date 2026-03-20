import 'package:flutter/material.dart';

import '../services/preferences_service.dart';
import 'search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PreferencesService _prefs = PreferencesService.instance;

  String _selectedPrice = '';
  double _selectedDistance = 5;

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final price = await _prefs.getPriceFilter();
    final distance = await _prefs.getDistanceFilter();

    setState(() {
      _selectedPrice = price ?? '';
      _selectedDistance = distance ?? 5;
    });
  }

  void _search() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsScreen(
          query: _searchController.text,
          priceFilter: _selectedPrice,
          distanceFilter: _selectedDistance,
        ),
      ),
    );
  }

  void _setPriceFilter(String price) async {
    await _prefs.savePriceFilter(price);
    setState(() => _selectedPrice = price);
  }

  void _setDistance(double distance) async {
    await _prefs.saveDistanceFilter(distance);
    setState(() => _selectedDistance = distance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PantherBites")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            //Search bar
            TextField(
              controller: _searchController,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: "Search restaurants...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            //Filter by price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["\$", "\$\$", "\$\$\$"].map((price) {
                return ChoiceChip(
                  label: Text(price),
                  selected: _selectedPrice == price,
                  onSelected: (_) => _setPriceFilter(price),
                );
              }).toList(),
            ),

            const SizedBox(height: 10),

            //filter by distance
            Row(
              children: [
                const Text("Distance: "),
                Expanded(
                  child: Slider(
                    value: _selectedDistance,
                    min: 0.5,
                    max: 10,
                    divisions: 10,
                    label: "${_selectedDistance.toStringAsFixed(1)} mi",
                    onChanged: (value) => _setDistance(value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

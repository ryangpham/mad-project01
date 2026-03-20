import 'package:flutter/material.dart';

import '../data/restaurant_seed_data.dart';
import '../models/restaurant.dart';
import '../services/preferences_service.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details_screen.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFilters() async {
    final price = await _prefs.getPriceFilter();
    final distance = await _prefs.getDistanceFilter();

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedPrice = price ?? '';
      _selectedDistance = distance ?? 5;
    });
  }

  List<Restaurant> _applyFilters(List<Restaurant> restaurants) {
    return restaurants.where((restaurant) {
      final matchesPrice =
          _selectedPrice.isEmpty || restaurant.price == _selectedPrice;
      final matchesDistance = restaurant.distance <= _selectedDistance;
      return matchesPrice && matchesDistance;
    }).toList();
  }

  void _search() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsScreen(
          query: _searchController.text.trim(),
          priceFilter: _selectedPrice,
          distanceFilter: _selectedDistance,
        ),
      ),
    );
  }

  Future<void> _showFiltersDialog() async {
    String draftPrice = _selectedPrice;
    double draftDistance = _selectedDistance;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Any'),
                        selected: draftPrice.isEmpty,
                        onSelected: (_) {
                          setModalState(() {
                            draftPrice = '';
                          });
                        },
                      ),
                      for (final price in [r'$', r'$$', r'$$$'])
                        ChoiceChip(
                          label: Text(price),
                          selected: draftPrice == price,
                          onSelected: (_) {
                            setModalState(() {
                              draftPrice = price;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Distance: ${draftDistance.toStringAsFixed(1)} mi'),
                  Slider(
                    value: draftDistance,
                    min: 0.5,
                    max: 10,
                    divisions: 19,
                    onChanged: (value) {
                      setModalState(() {
                        draftDistance = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            draftPrice = '';
                            draftDistance = 5;
                          });
                        },
                        child: const Text('Reset'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () async {
                          await _prefs.savePriceFilter(draftPrice);
                          await _prefs.saveDistanceFilter(draftDistance);
                          if (!mounted) {
                            return;
                          }
                          setState(() {
                            _selectedPrice = draftPrice;
                            _selectedDistance = draftDistance;
                          });
                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          }
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = _applyFilters(seededRestaurants);

    return Scaffold(
      appBar: AppBar(title: const Text('PantherBites')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      hintText: 'Search restaurants near GSU...',
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
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: _showFiltersDialog,
                  icon: const Icon(Icons.tune),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedPrice.isEmpty
                    ? 'Nearby restaurants within ${_selectedDistance.toStringAsFixed(1)} mi'
                    : 'Nearby $_selectedPrice restaurants within ${_selectedDistance.toStringAsFixed(1)} mi',
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredRestaurants.isEmpty
                  ? const Center(
                      child: Text('No restaurants match these filters.'),
                    )
                  : ListView.builder(
                      itemCount: filteredRestaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = filteredRestaurants[index];

                        return RestaurantCard(
                          restaurant: restaurant,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RestaurantDetailsScreen(
                                  restaurant: restaurant,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

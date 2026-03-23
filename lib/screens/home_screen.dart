import 'package:flutter/material.dart';

import '../data/restaurant_seed_data.dart';
import '../models/matcher_input.dart';
import '../models/restaurant.dart';
import '../services/preferences_service.dart';
import '../widgets/restaurant_card.dart';
import 'ai_matcher_screen.dart';
import 'restaurant_details_screen.dart';
import 'search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  // Preferences service for filters (price,distance)
  final PreferencesService _prefs = PreferencesService.instance;

  //Currently selected filters
  String _selectedPrice = '';
  double _selectedDistance = 5;

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  @override
  void dispose() {
    _searchController.dispose(); //Prevents memory leaks
    super.dispose();
  }

  // Load saved filters from local preferences
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

  // Apply filters to restaurant list
  List<Restaurant> _applyFilters(List<Restaurant> restaurants) {
    return restaurants.where((restaurant) {
      final matchesPrice =
          _selectedPrice.isEmpty || restaurant.price == _selectedPrice;
      final matchesDistance = restaurant.distance <= _selectedDistance;
      return matchesPrice && matchesDistance;
    }).toList();
  }

  // Navigate to search result screen
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

  // Converts mood enum to readable string
  String _moodLabel(UserMood mood) {
    switch (mood) {
      case UserMood.stressed:
        return 'Stressed';
      case UserMood.focused:
        return 'Focused';
      case UserMood.social:
        return 'Social';
      case UserMood.adventurous:
        return 'Adventurous';
      case UserMood.comfort:
        return 'Need Comfort';
    }
  }

  //Colllects AI matcher input from user
  Future<void> _showMatcherInputSheet() async {
    UserMood selectedMood = UserMood.stressed;
    // Default selections
    bool strictBudget = true;
    bool inRush = false;
    bool hasNextClass = true;
    double minutesUntilClass = 60;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        // Allows updating UI inside inside model
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
                    'AI Meal Matcher',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text('How are you feeling?'),
                  const SizedBox(height: 8),
                  
                  // Mood selection chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: UserMood.values.map((mood) {
                      return ChoiceChip(
                        label: Text(_moodLabel(mood)),
                        selected: selectedMood == mood,
                        onSelected: (_) {
                          setModalState(() {
                            selectedMood = mood;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),

                  // Toggle options
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Strict budget mode'),
                    value: strictBudget,
                    onChanged: (value) {
                      setModalState(() {
                        strictBudget = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('I am in a rush'),
                    value: inRush,
                    onChanged: (value) {
                      setModalState(() {
                        inRush = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Use next class timing'),
                    value: hasNextClass,
                    onChanged: (value) {
                      setModalState(() {
                        hasNextClass = value;
                      });
                    },
                  ),

                  // Slider for next class timing
                  if (hasNextClass)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Next class in ${minutesUntilClass.round()} min'),
                        Slider(
                          value: minutesUntilClass,
                          min: 15,
                          max: 180,
                          divisions: 33,
                          onChanged: (value) {
                            setModalState(() {
                              minutesUntilClass = value;
                            });
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    // Submit button
                    child: FilledButton.icon(
                      onPressed: () {
                        final nextClassStart = hasNextClass
                            ? DateTime.now().add(
                                Duration(minutes: minutesUntilClass.round()),
                              )
                            : null;

                        final input = MatcherInput(
                          mood: selectedMood,
                          strictBudget: strictBudget,
                          inRush: inRush,
                          nextClassStart: nextClassStart,
                        );

                        Navigator.pop(sheetContext);

                        // Navigate to AI matcher results screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AiMatcherScreen(initialInput: input),
                          ),
                        );
                      },
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Get Recommendations'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  // opens filter dialog for prices and distances
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

                      //Price filter options
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

                  // distance slider
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

                      // Applying filters
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showMatcherInputSheet,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('AI Match'),
      ),
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

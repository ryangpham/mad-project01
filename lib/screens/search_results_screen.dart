import 'package:flutter/material.dart';

import '../data/restaurant_seed_data.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;
  final String priceFilter;
  final double distanceFilter;

  const SearchResultsScreen({
    super.key,
    required this.query,
    required this.priceFilter,
    required this.distanceFilter,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim().toLowerCase();

    final results = seededRestaurants.where((restaurant) {
      final matchesQuery =
          normalizedQuery.isEmpty ||
          restaurant.name.toLowerCase().contains(normalizedQuery);

      final matchesPrice =
          priceFilter.isEmpty || restaurant.price == priceFilter;

      final matchesDistance = restaurant.distance <= distanceFilter;

      return matchesQuery && matchesPrice && matchesDistance;
    }).toList();

    final title = query.trim().isEmpty
        ? 'Filtered Restaurants'
        : 'Results for "${query.trim()}"';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: results.isEmpty
          ? const Center(child: Text('No restaurants found'))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final restaurant = results[index];

                return RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RestaurantDetailsScreen(restaurant: restaurant),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

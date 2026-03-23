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
    //Lets query use case sensitive comparison
    final normalizedQuery = query.trim().toLowerCase();

    // Filters restaurants based on query and filters
    final results = seededRestaurants.where((restaurant) {
      // Match if query is empty or restaurant name contains query
      final matchesQuery =
          normalizedQuery.isEmpty ||
          restaurant.name.toLowerCase().contains(normalizedQuery);

      final matchesPrice =
          priceFilter.isEmpty || restaurant.price == priceFilter;

      //Distance constraint
      final matchesDistance = restaurant.distance <= distanceFilter;

      return matchesQuery && matchesPrice && matchesDistance;
    }).toList();

    //Dynamic title based on search input
    final title = query.trim().isEmpty
        ? 'Filtered Restaurants'
        : 'Results for "${query.trim()}"';

    return Scaffold(
      appBar: AppBar(title: Text(title)),

      //Displays if no matches are found
      body: results.isEmpty
          ? const Center(child: Text('No restaurants found'))

          //otherwise shows the list of results
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final restaurant = results[index];

                return RestaurantCard(
                  restaurant: restaurant,
                  
                  //nagivates to details screen when pressed
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

import 'package:flutter/material.dart';
import '../models/restaurant.dart';
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
    final allRestaurants = [
      Restaurant(
        name: "Krispy Krunchy Chicken",
        price: "\$",
        distance: 0.1,
        hours: "Open until 5PM",
      ),
      Restaurant(
        name: "Gotta Eat ATL",
        price: "\$",
        distance: 0.2,
        hours: "Open until 8PM",
      ),
      Restaurant(
        name: "Chick-fil-A",
        price: "\$\$",
        distance: 0.2,
        hours: "Open until 9PM",
      ),
    ];

    //logic for filter
    final results = allRestaurants.where((r) {
      final matchesQuery = r.name.toLowerCase().contains(query.toLowerCase());

      final matchesPrice = priceFilter.isEmpty || r.price == priceFilter;

      final matchesDistance = r.distance <= distanceFilter;

      return matchesQuery && matchesPrice && matchesDistance;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Results for \"$query\"")), //note this doesnt display $$$
      body: results.isEmpty
          ? const Center(child: Text("No restaurants found"))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final restaurant = results[index];

                return ListTile(
                  leading: const Icon(Icons.restaurant),
                  title: Text(restaurant.name),
                  subtitle: Text(
                    "${restaurant.price} • ${restaurant.distance} mi",
                  ),
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

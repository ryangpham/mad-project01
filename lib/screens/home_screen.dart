import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurants = [
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

    return Scaffold(
      appBar: AppBar(title: const Text("PantherBites"), centerTitle: true),

      body: Column(
        children: [
          //Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search restaurants near GSU...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          ///adding the list
          Expanded(
            child: ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];

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
          ),
        ],
      ),
    );
  }
}

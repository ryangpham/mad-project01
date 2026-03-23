import 'package:flutter/material.dart';
import '../models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  //Action when tapped
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      child: ListTile(
        //Icon for visual identification 
        leading: const Icon(Icons.restaurant, size: 40),

        //Restaurant name
        title: Text(
          restaurant.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        //Key details of price, distance and hours
        subtitle: Text(
          "${restaurant.price} • ${restaurant.distance} miles • ${restaurant.hours}",
        ),
        //arrows to indicate natvigation
        trailing: const Icon(Icons.arrow_forward_ios),

        //Opens details screen
        onTap: onTap,
      ),
    );
  }
}

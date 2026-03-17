import 'package:flutter/material.dart';

import '../models/restaurant.dart';
import '../services/database_helper.dart';
import 'restaurant_details_screen.dart';
import '../widgets/favorite_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  Future<List<Restaurant>>? _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
  }

  void _refreshFavorites() {
    setState(() {
      _favoritesFuture = _db.getFavorites();
    });
  }

  Future<void> _removeFavorite(int id) async {
    await _db.removeFavorite(id);
    if (!mounted) {
      return;
    }
    _refreshFavorites();
  }

  Future<void> _showAddFavoriteDialog() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController(text: r'$$');
    final distanceController = TextEditingController();
    final hoursController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Favorite'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price Tier'),
                ),
                TextField(
                  controller: distanceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Distance (miles)',
                  ),
                ),
                TextField(
                  controller: hoursController,
                  decoration: const InputDecoration(labelText: 'Hours'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final price = priceController.text.trim();
                final distance = double.tryParse(
                  distanceController.text.trim(),
                );
                final hours = hoursController.text.trim();

                if (name.isEmpty ||
                    price.isEmpty ||
                    distance == null ||
                    hours.isEmpty) {
                  return;
                }

                await _db.addFavorite(
                  Restaurant(
                    name: name,
                    price: price,
                    distance: distance,
                    hours: hours,
                  ),
                );

                if (!mounted) {
                  return;
                }

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
                _refreshFavorites();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        actions: [
          TextButton(onPressed: _refreshFavorites, child: const Text("Reload")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFavoriteDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<List<Restaurant>>(
          future: _favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final favorites = snapshot.data ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${favorites.length} saved restaurants",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: favorites.isEmpty
                      ? const Center(child: Text('No favorites yet.'))
                      : ListView.builder(
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final item = favorites[index];
                            return FavoriteCard(
                              name: item.name,
                              price: item.price,
                              distance:
                                  '${item.distance.toStringAsFixed(1)} mi',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RestaurantDetailsScreen(
                                      restaurant: item,
                                    ),
                                  ),
                                );
                              },
                              onRemove: () {
                                if (item.id != null) {
                                  _removeFavorite(item.id!);
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

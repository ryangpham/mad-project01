import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/database_helper.dart';
import '../services/preferences_service.dart';
import '../widgets/budget_card.dart';
import '../widgets/meal_card.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final PreferencesService _prefs = PreferencesService.instance;

  Future<List<Meal>>? _mealsFuture;
  double _weeklyBudget = 100;

  @override
  void initState() {
    super.initState();
    _loadBudget();
    _refreshMeals();
  }

  Future<void> _loadBudget() async {
    final savedBudget = await _prefs.getBudget();
    if (!mounted) {
      return;
    }

    setState(() {
      _weeklyBudget = savedBudget ?? 100;
    });
  }

  void _refreshMeals() {
    setState(() {
      _mealsFuture = _db.getMeals();
    });
  }

  String _formatDate(String rawDate) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) {
      return rawDate;
    }

    return '${parsed.month}/${parsed.day}';
  }

  Future<void> _showSetBudgetDialog() async {
    final controller = TextEditingController(
      text: _weeklyBudget.toStringAsFixed(2),
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Set Weekly Budget'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(prefixText: '\$'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final parsed = double.tryParse(controller.text.trim());
                if (parsed == null || parsed < 0) {
                  return;
                }
                await _prefs.saveBudget(parsed);
                if (!mounted) {
                  return;
                }
                setState(() {
                  _weeklyBudget = parsed;
                });
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddMealDialog() async {
    final mealNameController = TextEditingController();
    final restaurantController = TextEditingController();
    final priceController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Meal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: mealNameController,
                  decoration: const InputDecoration(labelText: 'Meal Name'),
                ),
                TextField(
                  controller: restaurantController,
                  decoration: const InputDecoration(
                    labelText: 'Restaurant Name',
                  ),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixText: '\$',
                  ),
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
                final mealName = mealNameController.text.trim();
                final restaurantName = restaurantController.text.trim();
                final price = double.tryParse(priceController.text.trim());

                if (mealName.isEmpty ||
                    restaurantName.isEmpty ||
                    price == null) {
                  return;
                }

                await _db.insertMeal(
                  Meal(
                    mealName: mealName,
                    restaurantName: restaurantName,
                    price: price,
                    date: DateTime.now().toIso8601String(),
                  ),
                );

                if (!mounted) {
                  return;
                }

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
                _refreshMeals();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeMeal(int id) async {
    await _db.deleteMeal(id);
    if (!mounted) {
      return;
    }
    _refreshMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Tracker"),
        actions: [
          TextButton(
            onPressed: _showSetBudgetDialog,
            child: const Text("Set Budget"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMealDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<List<Meal>>(
          future: _mealsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final meals = snapshot.data ?? [];
            final spent = meals.fold<double>(
              0,
              (sum, meal) => sum + meal.price,
            );
            final remaining = _weeklyBudget - spent;

            return Column(
              children: [
                BudgetCard(
                  budget: _weeklyBudget,
                  spent: spent,
                  remaining: remaining,
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "LOGGED MEALS",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: meals.isEmpty
                      ? const Center(child: Text('No meals logged yet.'))
                      : ListView.builder(
                          itemCount: meals.length,
                          itemBuilder: (context, index) {
                            final meal = meals[index];
                            return MealCard(
                              name: '${meal.mealName} (${meal.restaurantName})',
                              price: meal.price,
                              date: _formatDate(meal.date),
                              onRemove: () {
                                if (meal.id != null) {
                                  _removeMeal(meal.id!);
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

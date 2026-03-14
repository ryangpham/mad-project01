import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService._internal();

  static final PreferencesService instance = PreferencesService._internal();

  static const String _budgetKey = 'budget';

  Future<void> saveBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetKey, budget);
  }

  Future<double?> getBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_budgetKey);
  }
}

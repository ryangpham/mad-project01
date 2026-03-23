import '../models/match_result.dart';
import '../models/matcher_input.dart';
import '../models/meal.dart';
import '../models/restaurant.dart';
import 'database_helper.dart';
import 'preferences_service.dart';

class MealMatcherService {
  MealMatcherService._internal();

  //Single global instance used across the app
  static final MealMatcherService instance = MealMatcherService._internal();

  //Maps each user mood to descriptive tags
  //These are used to match with restaurant tags
  static const Map<UserMood, List<String>> _moodTags = {
    UserMood.stressed: ['comfort', 'quick', 'familiar'],
    UserMood.focused: ['light', 'healthy', 'quiet'],
    UserMood.social: ['shareable', 'popular', 'lively'],
    UserMood.adventurous: ['spicy', 'new', 'bold'],
    UserMood.comfort: ['comfort', 'warm', 'classic'],
  };

  //tags assigned to restaurants for the AI matching
  static const Map<String, List<String>> _restaurantTags = {
    'Krispy Krunchy Chicken': ['comfort', 'quick', 'familiar', 'shareable'],
    'Gotta Eat ATL': ['bold', 'new', 'spicy', 'lively'],
    'Chick-fil-A': ['quick', 'familiar', 'popular', 'classic'],
  };

  // Estimated prep time for each restraurant, used for schedule scoring
  static const Map<String, int> _prepMinutes = {
    'Krispy Krunchy Chicken': 12,
    'Gotta Eat ATL': 18,
    'Chick-fil-A': 10,
  };

  //estimated average meal price for budget scoring
  static const Map<String, double> _averageMealPrice = {
    'Krispy Krunchy Chicken': 8.5,
    'Gotta Eat ATL': 13.0,
    'Chick-fil-A': 11.0,
  };

  //Database + preferences access
  final DatabaseHelper _db = DatabaseHelper.instance;
  final PreferencesService _prefs = PreferencesService.instance;

  // Main AI ranking function
  Future<List<MatchResult>> rankRestaurants({
    required List<Restaurant> candidates,
    required MatcherInput input,
  }) async {
    if (candidates.isEmpty) {
      return const [];
    }

    //Gets user data for budget, past meals and favorites
    final budget = await _prefs.getBudget() ?? 100;
    final meals = await _db.getMeals();
    final favorites = await _db.getFavorites();

    //Favorite names for matching
    final favoriteNames = favorites
        .map((favorite) => favorite.name.trim().toLowerCase())
        .toSet();

    //Calculates how much left to spend
    final spent = meals.fold<double>(0, (sum, meal) => sum + meal.price);
    final remaining = (budget - spent).clamp(0, double.infinity).toDouble();
    final targetPerMeal = _estimateTargetPerMeal(remaining);

    //tracks recently eaten restaurants to avoid repeats
    final recentRestaurantNames = _recentRestaurants(meals);

    final results = <MatchResult>[];

    for (final restaurant in candidates) {
      //Individual scoring components
      final moodScore = _computeMoodScore(restaurant, input.mood);
      final budgetScore = _computeBudgetScore(
        restaurant: restaurant,
        targetPerMeal: targetPerMeal,
        strictBudget: input.strictBudget,
      );
      final scheduleScore = _computeScheduleScore(
        restaurant: restaurant,
        nextClassStart: input.nextClassStart,
        inRush: input.inRush,
      );
      final personalScore = _computePersonalScore(
        restaurant: restaurant,
        favoriteNames: favoriteNames,
        recentRestaurantNames: recentRestaurantNames,
      );

      //Weighted final score
      final score =
          (0.35 * moodScore) +
          (0.30 * budgetScore) +
          (0.25 * scheduleScore) +
          (0.10 * personalScore);

      //Score result with breakdown and explanation
      results.add(
        MatchResult(
          restaurant: restaurant,
          score: score,
          breakdown: {
            'Mood': moodScore,
            'Budget': budgetScore,
            'Schedule': scheduleScore,
            'Personal': personalScore,
          },
          reasons: _buildReasons(
            restaurant: restaurant,
            moodScore: moodScore,
            budgetScore: budgetScore,
            scheduleScore: scheduleScore,
            personalScore: personalScore,
            targetPerMeal: targetPerMeal,
          ),
        ),
      );
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    return results;
  }

  double _estimateTargetPerMeal(double remainingBudget) {
    final now = DateTime.now();
    final daysLeft = (7 - now.weekday + 1).clamp(1, 7);
    final estimatedMealsLeft = (daysLeft * 2).clamp(2, 14);
    return (remainingBudget / estimatedMealsLeft).clamp(6, 30);
  }

  Set<String> _recentRestaurants(List<Meal> meals) {
    final recent = meals
        .take(5)
        .map((meal) => meal.restaurantName.trim().toLowerCase());
    return recent.toSet();
  }

  double _computeMoodScore(Restaurant restaurant, UserMood mood) {
    final desiredTags = _moodTags[mood] ?? const [];
    if (desiredTags.isEmpty) {
      return 0.5;
    }

    final tags = _restaurantTags[restaurant.name] ?? const [];
    if (tags.isEmpty) {
      return 0.5;
    }

    final matches = desiredTags.where(tags.contains).length;
    return (matches / desiredTags.length).clamp(0, 1).toDouble();
  }

  double _computeBudgetScore({
    required Restaurant restaurant,
    required double targetPerMeal,
    required bool strictBudget,
  }) {
    final estimated = _estimatedPrice(restaurant);
    final delta = estimated - targetPerMeal;

    if (delta <= 0) {
      return 1.0;
    }

    final ratio = (delta / targetPerMeal).clamp(0, 2);
    final penaltyMultiplier = strictBudget ? 1.0 : 0.6;

    return (1 - (ratio * penaltyMultiplier)).clamp(0, 1).toDouble();
  }

  double _estimatedPrice(Restaurant restaurant) {
    final fromMap = _averageMealPrice[restaurant.name];
    if (fromMap != null) {
      return fromMap;
    }

    switch (restaurant.price) {
      case r'$':
        return 8;
      case r'$$':
        return 13;
      case r'$$$':
        return 20;
      default:
        return 12;
    }
  }

  double _computeScheduleScore({
    required Restaurant restaurant,
    required DateTime? nextClassStart,
    required bool inRush,
  }) {
    if (nextClassStart == null) {
      return inRush ? 0.75 : 0.65;
    }

    final minutesUntilClass = nextClassStart
        .difference(DateTime.now())
        .inMinutes;

    if (minutesUntilClass <= 0) {
      return 0.05;
    }

    final travelMinutes = (restaurant.distance * 12).round();
    final prepMinutes = _prepMinutes[restaurant.name] ?? 15;
    final eatBufferMinutes = 12;
    final totalMinutesNeeded = travelMinutes + prepMinutes + eatBufferMinutes;
    final slack = minutesUntilClass - totalMinutesNeeded;

    double score;
    if (slack >= 20) {
      score = 1.0;
    } else if (slack >= 5) {
      score = 0.75;
    } else if (slack >= 0) {
      score = 0.45;
    } else {
      score = 0.05;
    }

    if (inRush && totalMinutesNeeded > 25) {
      score *= 0.8;
    }

    return score.clamp(0, 1).toDouble();
  }

  double _computePersonalScore({
    required Restaurant restaurant,
    required Set<String> favoriteNames,
    required Set<String> recentRestaurantNames,
  }) {
    double score = 0.5;
    final normalizedName = restaurant.name.trim().toLowerCase();

    if (favoriteNames.contains(normalizedName)) {
      score += 0.35;
    }

    if (recentRestaurantNames.contains(normalizedName)) {
      score -= 0.2;
    } else {
      score += 0.1;
    }

    return score.clamp(0, 1).toDouble();
  }

  List<String> _buildReasons({
    required Restaurant restaurant,
    required double moodScore,
    required double budgetScore,
    required double scheduleScore,
    required double personalScore,
    required double targetPerMeal,
  }) {
    final reasons = <String>[];

    if (moodScore >= 0.7) {
      reasons.add('Strong mood match based on your current vibe.');
    }

    if (budgetScore >= 0.75) {
      final estimated = _estimatedPrice(restaurant);
      reasons.add(
        'Estimated at about \$${estimated.toStringAsFixed(0)}, near your target of \$${targetPerMeal.toStringAsFixed(0)}.',
      );
    }

    if (scheduleScore >= 0.7) {
      reasons.add('Fits your class timing with a quick turnaround.');
    }

    if (personalScore >= 0.75) {
      reasons.add('Boosted from your favorites and recent habits.');
    }

    if (reasons.isEmpty) {
      reasons.add('Balanced pick across mood, budget, and schedule.');
    }

    return reasons;
  }
}

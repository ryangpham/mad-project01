import 'restaurant.dart';

class MatchResult {
  final Restaurant restaurant;
  final double score;
  final Map<String, double> breakdown;
  final List<String> reasons;

  const MatchResult({
    required this.restaurant,
    required this.score,
    required this.breakdown,
    required this.reasons,
  });
}

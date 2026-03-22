enum UserMood { stressed, focused, social, adventurous, comfort }

class MatcherInput {
  final UserMood mood;
  final bool strictBudget;
  final bool inRush;
  final DateTime? nextClassStart;

  const MatcherInput({
    required this.mood,
    required this.strictBudget,
    required this.inRush,
    this.nextClassStart,
  });
}

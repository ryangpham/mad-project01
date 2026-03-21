import 'package:flutter/material.dart';

import '../data/restaurant_seed_data.dart';
import '../models/match_result.dart';
import '../models/matcher_input.dart';
import '../models/restaurant.dart';
import '../services/meal_matcher_service.dart';
import '../services/preferences_service.dart';

class AiMatcherScreen extends StatefulWidget {
  const AiMatcherScreen({super.key});

  @override
  State<AiMatcherScreen> createState() => _AiMatcherScreenState();
}

class _AiMatcherScreenState extends State<AiMatcherScreen> {
  final MealMatcherService _matcher = MealMatcherService.instance;
  final PreferencesService _prefs = PreferencesService.instance;

  UserMood _mood = UserMood.stressed;
  bool _strictBudget = true;
  bool _inRush = false;
  bool _hasNextClass = true;
  double _minutesUntilClass = 60;

  bool _loading = true;
  List<MatchResult> _results = const [];

  @override
  void initState() {
    super.initState();
    _runMatcher();
  }

  DateTime? get _nextClassStart {
    if (!_hasNextClass) {
      return null;
    }
    return DateTime.now().add(Duration(minutes: _minutesUntilClass.round()));
  }

  Future<List<Restaurant>> _candidateRestaurants() async {
    final priceFilter = await _prefs.getPriceFilter() ?? '';
    final distanceFilter = await _prefs.getDistanceFilter() ?? 10;

    final filtered = seededRestaurants.where((restaurant) {
      final matchesPrice =
          priceFilter.isEmpty || restaurant.price == priceFilter;
      final matchesDistance = restaurant.distance <= distanceFilter;
      return matchesPrice && matchesDistance;
    }).toList();

    if (filtered.isNotEmpty) {
      return filtered;
    }

    return seededRestaurants;
  }

  Future<void> _runMatcher() async {
    setState(() {
      _loading = true;
    });

    final candidates = await _candidateRestaurants();
    final input = MatcherInput(
      mood: _mood,
      strictBudget: _strictBudget,
      inRush: _inRush,
      nextClassStart: _nextClassStart,
    );

    final ranked = await _matcher.rankRestaurants(
      candidates: candidates,
      input: input,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _results = ranked.take(3).toList();
      _loading = false;
    });
  }

  String _moodLabel(UserMood mood) {
    switch (mood) {
      case UserMood.stressed:
        return 'Stressed';
      case UserMood.focused:
        return 'Focused';
      case UserMood.social:
        return 'Social';
      case UserMood.adventurous:
        return 'Adventurous';
      case UserMood.comfort:
        return 'Need Comfort';
    }
  }

  String _confidenceLabel() {
    if (_results.length < 2) {
      return 'Medium confidence';
    }

    final spread = _results.first.score - _results[1].score;
    if (spread >= 0.2) {
      return 'High confidence';
    }
    if (spread >= 0.08) {
      return 'Medium confidence';
    }
    return 'Low confidence';
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How are you feeling?',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: UserMood.values.map((mood) {
              return ChoiceChip(
                label: Text(_moodLabel(mood)),
                selected: _mood == mood,
                onSelected: (_) {
                  setState(() {
                    _mood = mood;
                  });
                  _runMatcher();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Strict budget mode'),
            value: _strictBudget,
            onChanged: (value) {
              setState(() {
                _strictBudget = value;
              });
              _runMatcher();
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('I am in a rush'),
            value: _inRush,
            onChanged: (value) {
              setState(() {
                _inRush = value;
              });
              _runMatcher();
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Use next class timing'),
            value: _hasNextClass,
            onChanged: (value) {
              setState(() {
                _hasNextClass = value;
              });
              _runMatcher();
            },
          ),
          if (_hasNextClass)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Next class in ${_minutesUntilClass.round()} min'),
                Slider(
                  value: _minutesUntilClass,
                  min: 15,
                  max: 180,
                  divisions: 33,
                  onChanged: (value) {
                    setState(() {
                      _minutesUntilClass = value;
                    });
                  },
                  onChangeEnd: (_) => _runMatcher(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(MatchResult result, int rank) {
    final percentage = (result.score * 100).clamp(0, 100).round();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 14, child: Text('$rank')),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    result.restaurant.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text('$percentage% match'),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${result.restaurant.price} • ${result.restaurant.distance.toStringAsFixed(1)} mi • ${result.restaurant.hours}',
            ),
            const SizedBox(height: 8),
            for (final reason in result.reasons)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $reason'),
              ),
            const SizedBox(height: 6),
            Text(
              'Mood ${_percent(result.breakdown['Mood'])}  |  Budget ${_percent(result.breakdown['Budget'])}  |  Schedule ${_percent(result.breakdown['Schedule'])}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _percent(double? value) {
    if (value == null) {
      return '--';
    }
    return '${(value * 100).round()}%';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Meal Matcher')),
      body: RefreshIndicator(
        onRefresh: _runMatcher,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _buildControls(),
            const SizedBox(height: 10),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_results.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: Text('No recommendations available yet.')),
              )
            else ...[
              Text(
                _confidenceLabel(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              for (var i = 0; i < _results.length; i++)
                _buildMatchCard(_results[i], i + 1),
            ],
          ],
        ),
      ),
    );
  }
}

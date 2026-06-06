// providers/discovery_provider.dart

import 'dart:math' as math;
import 'package:course_it/models/collage_model.dart';
import 'package:course_it/models/user_preferance.dart';
import 'package:flutter/foundation.dart';

import '../database/local_box_seeder.dart';

class DiscoveryProvider extends ChangeNotifier {
  // ── Raw data store ────────────────────────────────────────────────────────
  List<College> _allColleges = [];
  bool _isLoading = true;
  String? _error;

  // ── MAUT constants ────────────────────────────────────────────────────────
  static const double _minStateLPA = 3.0;
  static const double _maxStateLPA = 12.0;
  static const double _minStateFee = 10000.0;
  static const double _maxAllowedFee = 800000.0;

  // ── Getters ───────────────────────────────────────────────────────────────
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<College> get allColleges => List.unmodifiable(_allColleges);

  // ── Initialisation ────────────────────────────────────────────────────────
  Future<void> initialise() async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(
        const Duration(milliseconds: 600),
      ); // simulate DB read
      _allColleges = LocalBoxSeeder.seedColleges();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── MAUT engine ───────────────────────────────────────────────────────────
  double computeMautScore({
    required double avgLPA,
    required double annualFee,
    required double w1Placement,
    required double w2Fee,
  }) {
    final uPlacement = ((avgLPA - _minStateLPA) / (_maxStateLPA - _minStateLPA))
        .clamp(0.0, 1.0);
    final rawFeeUtil =
        (_maxAllowedFee - annualFee) / (_maxAllowedFee - _minStateFee);
    final uFee = rawFeeUtil.clamp(0.0, 1.0);
    return (w1Placement * uPlacement) + (w2Fee * uFee);
  }

  /// Computes a college-level MAUT score using its best-performing course.
  double collegeMautScore(College college, UserPreference pref) {
    if (college.courses.isEmpty) return 0.0;
    // Use the course that maximises its own individual MAUT score
    double best = 0.0;
    for (final course in college.courses) {
      final s = computeMautScore(
        avgLPA: course.avgLPA,
        annualFee: course.annualFee,
        w1Placement: pref.w1Placement,
        w2Fee: pref.w2Fee,
      );
      if (s > best) best = s;
    }
    return best;
  }

  // ── Query pipeline ────────────────────────────────────────────────────────

  /// Returns filtered + MAUT-sorted colleges based on current preferences.
  List<College> queryColleges(UserPreference pref) {
    List<College> results = List.from(_allColleges);

    // 1. Search query
    final q = pref.searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      results = results.where((c) {
        return c.name.toLowerCase().contains(q) ||
            c.shortName.toLowerCase().contains(q) ||
            c.city.toLowerCase().contains(q) ||
            c.courses.any((co) => co.name.toLowerCase().contains(q));
      }).toList();
    }

    // 2. Stream filter
    if (pref.selectedStreams.isNotEmpty) {
      results = results.where((c) {
        return c.streams.any((s) => pref.selectedStreams.contains(s));
      }).toList();
    }

    // 3. District filter
    if (pref.selectedDistricts.isNotEmpty) {
      results = results
          .where((c) => pref.selectedDistricts.contains(c.district))
          .toList();
    }

    // 4. Max fee filter – college must have at least one course within budget
    results = results.where((c) {
      return c.courses.any((co) => co.annualFee <= pref.maxFee);
    }).toList();

    // 5. Amenity filter
    for (final amenity in pref.requiredAmenities) {
      results = results.where((c) => c.hasAmenity(amenity)).toList();
    }

    // 6. Compute MAUT scores and sort descending
    for (final c in results) {
      c.mautScore = collegeMautScore(c, pref);
    }
    results.sort((a, b) => b.mautScore.compareTo(a.mautScore));

    return results;
  }

  /// Returns the colleges matching given IDs for comparison.
  List<College> getCompareColleges(List<String> ids) {
    return _allColleges.where((c) => ids.contains(c.id)).toList();
  }

  College? getCollegeById(String id) {
    try {
      return _allColleges.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Statistics helpers ────────────────────────────────────────────────────

  Map<String, int> streamDistribution() {
    final map = <String, int>{};
    for (final c in _allColleges) {
      for (final s in c.streams) {
        map[s] = (map[s] ?? 0) + 1;
      }
    }
    return map;
  }

  List<String> allDistricts() =>
      _allColleges.map((c) => c.district).toSet().toList()..sort();

  double avgMautPercent(UserPreference pref) {
    final filtered = queryColleges(pref);
    if (filtered.isEmpty) return 0;
    return filtered.map((c) => c.mautScore).reduce((a, b) => a + b) /
        filtered.length *
        100;
  }
}

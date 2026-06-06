// models/user_preference.dart

import 'package:flutter/foundation.dart';

class UserPreference extends ChangeNotifier {
  // MAUT weights – must sum to 1.0
  double _w1Placement = 0.6; // placement importance
  double _w2Fee = 0.4; // fee importance

  // Filter state
  double _maxFee = 800000; // ₹8L
  List<String> _selectedDistricts = [];
  List<String> _selectedStreams = [];
  List<String> _requiredAmenities = [];
  String _searchQuery = '';

  // Comparison basket
  List<String> _compareIds = []; // up to 3 college IDs

  // ── Getters ──────────────────────────────────────────────────────────────
  double get w1Placement => _w1Placement;
  double get w2Fee => _w2Fee;
  double get maxFee => _maxFee;
  List<String> get selectedDistricts => List.unmodifiable(_selectedDistricts);
  List<String> get selectedStreams => List.unmodifiable(_selectedStreams);
  List<String> get requiredAmenities => List.unmodifiable(_requiredAmenities);
  String get searchQuery => _searchQuery;
  List<String> get compareIds => List.unmodifiable(_compareIds);

  // ── MAUT weight setters ───────────────────────────────────────────────────
  void setWeights(double placementWeight) {
    _w1Placement = placementWeight.clamp(0.0, 1.0);
    _w2Fee = (1.0 - _w1Placement);
    notifyListeners();
  }

  // ── Filter setters ────────────────────────────────────────────────────────
  void setMaxFee(double fee) {
    _maxFee = fee.clamp(50000, 800000);
    notifyListeners();
  }

  void toggleDistrict(String district) {
    if (_selectedDistricts.contains(district)) {
      _selectedDistricts.remove(district);
    } else {
      _selectedDistricts.add(district);
    }
    notifyListeners();
  }

  void toggleStream(String stream) {
    if (_selectedStreams.contains(stream)) {
      _selectedStreams.remove(stream);
    } else {
      _selectedStreams.add(stream);
    }
    notifyListeners();
  }

  void toggleAmenity(String amenity) {
    if (_requiredAmenities.contains(amenity)) {
      _requiredAmenities.remove(amenity);
    } else {
      _requiredAmenities.add(amenity);
    }
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void clearFilters() {
    _maxFee = 800000;
    _selectedDistricts = [];
    _selectedStreams = [];
    _requiredAmenities = [];
    _searchQuery = '';
    notifyListeners();
  }

  // ── Comparison basket ─────────────────────────────────────────────────────
  bool isInCompare(String id) => _compareIds.contains(id);

  bool toggleCompare(String id) {
    if (_compareIds.contains(id)) {
      _compareIds.remove(id);
      notifyListeners();
      return false;
    } else if (_compareIds.length < 3) {
      _compareIds.add(id);
      notifyListeners();
      return true;
    }
    return false; // basket full
  }

  void clearCompare() {
    _compareIds = [];
    notifyListeners();
  }

  // ── Serialization (for persistence) ──────────────────────────────────────
  Map<String, dynamic> toMap() => {
    'w1Placement': _w1Placement,
    'maxFee': _maxFee,
    'selectedDistricts': _selectedDistricts,
    'selectedStreams': _selectedStreams,
    'requiredAmenities': _requiredAmenities,
  };

  void loadFromMap(Map<String, dynamic> m) {
    _w1Placement = (m['w1Placement'] as num?)?.toDouble() ?? 0.6;
    _w2Fee = 1.0 - _w1Placement;
    _maxFee = (m['maxFee'] as num?)?.toDouble() ?? 800000;
    _selectedDistricts = List<String>.from(m['selectedDistricts'] ?? []);
    _selectedStreams = List<String>.from(m['selectedStreams'] ?? []);
    _requiredAmenities = List<String>.from(m['requiredAmenities'] ?? []);
    notifyListeners();
  }
}

// models/college_model.dart

class Course {
  final String name;
  final String stream; // Engineering, Management, Science, Arts, Medicine
  final double annualFee;
  final double avgLPA;
  final double maxLPA;
  final int durationYears;

  const Course({
    required this.name,
    required this.stream,
    required this.annualFee,
    required this.avgLPA,
    required this.maxLPA,
    required this.durationYears,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'stream': stream,
    'annualFee': annualFee,
    'avgLPA': avgLPA,
    'maxLPA': maxLPA,
    'durationYears': durationYears,
  };

  factory Course.fromMap(Map<String, dynamic> m) => Course(
    name: m['name'],
    stream: m['stream'],
    annualFee: (m['annualFee'] as num).toDouble(),
    avgLPA: (m['avgLPA'] as num).toDouble(),
    maxLPA: (m['maxLPA'] as num).toDouble(),
    durationYears: m['durationYears'],
  );
}

class PlacementStat {
  final String year;
  final double avgLPA;
  final double maxLPA;
  final double medianLPA;
  final int totalPlaced;
  final int totalStudents;

  const PlacementStat({
    required this.year,
    required this.avgLPA,
    required this.maxLPA,
    required this.medianLPA,
    required this.totalPlaced,
    required this.totalStudents,
  });

  double get placementPercent =>
      totalStudents > 0 ? (totalPlaced / totalStudents) * 100.0 : 0.0;

  Map<String, dynamic> toMap() => {
    'year': year,
    'avgLPA': avgLPA,
    'maxLPA': maxLPA,
    'medianLPA': medianLPA,
    'totalPlaced': totalPlaced,
    'totalStudents': totalStudents,
  };

  factory PlacementStat.fromMap(Map<String, dynamic> m) => PlacementStat(
    year: m['year'],
    avgLPA: (m['avgLPA'] as num).toDouble(),
    maxLPA: (m['maxLPA'] as num).toDouble(),
    medianLPA: (m['medianLPA'] as num).toDouble(),
    totalPlaced: m['totalPlaced'],
    totalStudents: m['totalStudents'],
  );
}

class Review {
  final String reviewerName;
  final String batch;
  final double rating;
  final String comment;
  final bool isVerified;

  const Review({
    required this.reviewerName,
    required this.batch,
    required this.rating,
    required this.comment,
    required this.isVerified,
  });

  Map<String, dynamic> toMap() => {
    'reviewerName': reviewerName,
    'batch': batch,
    'rating': rating,
    'comment': comment,
    'isVerified': isVerified,
  };

  factory Review.fromMap(Map<String, dynamic> m) => Review(
    reviewerName: m['reviewerName'],
    batch: m['batch'],
    rating: (m['rating'] as num).toDouble(),
    comment: m['comment'],
    isVerified: m['isVerified'],
  );
}

class College {
  final String id;
  final String name;
  final String shortName;
  final String city;
  final String district; // Kerala district
  final String type; // Public/Government, Deemed Private, Private
  final String affiliation;
  final double overallRating;
  final String naacGrade;
  final int established;
  final List<String> amenities;
  final List<Course> courses;
  final List<PlacementStat> placementHistory;
  final List<Review> reviews;
  final String description;
  final String imageAsset; // placeholder identifier
  double mautScore; // computed at runtime

  College({
    required this.id,
    required this.name,
    required this.shortName,
    required this.city,
    required this.district,
    required this.type,
    required this.affiliation,
    required this.overallRating,
    required this.naacGrade,
    required this.established,
    required this.amenities,
    required this.courses,
    required this.placementHistory,
    required this.reviews,
    required this.description,
    required this.imageAsset,
    this.mautScore = 0.0,
  });

  double get lowestAnnualFee => courses.isEmpty
      ? 0
      : courses.map((c) => c.annualFee).reduce((a, b) => a < b ? a : b);

  double get highestAvgLPA => courses.isEmpty
      ? 0
      : courses.map((c) => c.avgLPA).reduce((a, b) => a > b ? a : b);

  double get overallMaxLPA => courses.isEmpty
      ? 0
      : courses.map((c) => c.maxLPA).reduce((a, b) => a > b ? a : b);

  List<String> get streams => courses.map((c) => c.stream).toSet().toList();

  bool hasAmenity(String amenity) =>
      amenities.any((a) => a.toLowerCase().contains(amenity.toLowerCase()));

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'shortName': shortName,
    'city': city,
    'district': district,
    'type': type,
    'affiliation': affiliation,
    'overallRating': overallRating,
    'naacGrade': naacGrade,
    'established': established,
    'amenities': amenities,
    'courses': courses.map((c) => c.toMap()).toList(),
    'placementHistory': placementHistory.map((p) => p.toMap()).toList(),
    'reviews': reviews.map((r) => r.toMap()).toList(),
    'description': description,
    'imageAsset': imageAsset,
  };

  factory College.fromMap(Map<String, dynamic> m) => College(
    id: m['id'],
    name: m['name'],
    shortName: m['shortName'],
    city: m['city'],
    district: m['district'],
    type: m['type'],
    affiliation: m['affiliation'],
    overallRating: (m['overallRating'] as num).toDouble(),
    naacGrade: m['naacGrade'],
    established: m['established'],
    amenities: List<String>.from(m['amenities']),
    courses: (m['courses'] as List).map((c) => Course.fromMap(c)).toList(),
    placementHistory: (m['placementHistory'] as List)
        .map((p) => PlacementStat.fromMap(p))
        .toList(),
    reviews: (m['reviews'] as List).map((r) => Review.fromMap(r)).toList(),
    description: m['description'],
    imageAsset: m['imageAsset'],
  );
}

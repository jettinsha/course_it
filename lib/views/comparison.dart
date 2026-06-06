// views/matrix_comparison_view.dart

import 'package:course_it/models/collage_model.dart';
import 'package:course_it/models/user_preferance.dart';
import 'package:course_it/views/instituition_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/discovery_provider.dart';


class MatrixComparisonView extends StatefulWidget {
  const MatrixComparisonView({super.key});

  @override
  State<MatrixComparisonView> createState() => _MatrixComparisonViewState();
}

class _MatrixComparisonViewState extends State<MatrixComparisonView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _horizScroll = ScrollController();

  @override
  void dispose() {
    _horizScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final pref = context.watch<UserPreference>();
    final discovery = context.watch<DiscoveryProvider>();
    final colleges = discovery.getCompareColleges(pref.compareIds);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        title: const Text(
          'Side-by-Side Comparison',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          if (colleges.isNotEmpty)
            TextButton(
              onPressed: pref.clearCompare,
              child: const Text(
                'Clear All',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: colleges.isEmpty
          ? _buildEmptyState(context)
          : _buildComparisonMatrix(context, colleges, pref),
    );
  }

  // ── Empty state ─────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E).withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.compare_arrows_rounded,
              size: 64,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Colleges Selected',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Use the Compare button on college cards\nto add up to 3 institutions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF1A237E).withOpacity(0.2),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Color(0xFF1A237E),
                ),
                SizedBox(width: 8),
                Text(
                  'Max 3 colleges can be compared',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1A237E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Main comparison matrix ──────────────────────────────────────────────
  Widget _buildComparisonMatrix(
    BuildContext context,
    List<College> colleges,
    UserPreference pref,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // ── College header cards ──────────────────────────────────────
          _buildCollegeHeaders(context, colleges, pref),

          // ── Scrollable matrix body ────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizScroll,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildMatrixSection(
                  title: 'Basic Information',
                  icon: Icons.info_outline_rounded,
                  rows: _buildBasicInfoRows(colleges),
                ),
                _buildMatrixSection(
                  title: 'Fee Structure',
                  icon: Icons.currency_rupee_rounded,
                  rows: _buildFeeRows(colleges),
                ),
                _buildMatrixSection(
                  title: 'Placement Statistics',
                  icon: Icons.trending_up_rounded,
                  rows: _buildPlacementRows(colleges),
                ),
                _buildMatrixSection(
                  title: 'Academic Streams',
                  icon: Icons.school_rounded,
                  rows: _buildStreamRows(colleges),
                ),
                _buildMatrixSection(
                  title: 'Campus Amenities',
                  icon: Icons.apartment_rounded,
                  rows: _buildAmenityRows(colleges),
                ),
                _buildMatrixSection(
                  title: 'MAUT Match Score',
                  icon: Icons.auto_awesome_rounded,
                  rows: _buildMautRows(colleges, pref),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ── College header cards ──────────────────────────────────────────────────
  Widget _buildCollegeHeaders(
    BuildContext context,
    List<College> colleges,
    UserPreference pref,
  ) {
    return Container(
      color: const Color(0xFF1A237E),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Row label spacer
            Container(
              width: 140,
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Metric',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...colleges.map(
              (c) => _CollegeHeaderCard(
                college: c,
                onRemove: () => pref.toggleCompare(c.id),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => InstitutionDetailView(college: c),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Matrix section builder ────────────────────────────────────────────────
  Widget _buildMatrixSection({
    required String title,
    required IconData icon,
    required List<_MatrixRow> rows,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF1A237E)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
        ),
        ...rows.asMap().entries.map(
          (entry) =>
              _MatrixRowWidget(row: entry.value, isEven: entry.key.isEven),
        ),
      ],
    );
  }

  // ── Row data builders ─────────────────────────────────────────────────────
  List<_MatrixRow> _buildBasicInfoRows(List<College> colleges) => [
    _MatrixRow(
      label: 'Short Name',
      values: colleges.map((c) => c.shortName).toList(),
      valueType: _ValueType.text,
    ),
    _MatrixRow(
      label: 'Type',
      values: colleges.map((c) => c.type).toList(),
      valueType: _ValueType.badge,
    ),
    _MatrixRow(
      label: 'City',
      values: colleges.map((c) => c.city).toList(),
      valueType: _ValueType.text,
    ),
    _MatrixRow(
      label: 'NAAC Grade',
      values: colleges.map((c) => c.naacGrade).toList(),
      valueType: _ValueType.grade,
    ),
    _MatrixRow(
      label: 'Est. Year',
      values: colleges.map((c) => c.established.toString()).toList(),
      valueType: _ValueType.text,
    ),
    _MatrixRow(
      label: 'Rating',
      values: colleges.map((c) => c.overallRating.toStringAsFixed(1)).toList(),
      valueType: _ValueType.rating,
      higherIsBetter: true,
      numericValues: colleges.map((c) => c.overallRating).toList(),
    ),
  ];

  List<_MatrixRow> _buildFeeRows(List<College> colleges) => [
    _MatrixRow(
      label: 'Min Annual Fee',
      values: colleges
          .map((c) => '₹${(c.lowestAnnualFee / 1000).toStringAsFixed(0)}K')
          .toList(),
      valueType: _ValueType.highlight,
      higherIsBetter: false,
      numericValues: colleges.map((c) => c.lowestAnnualFee).toList(),
    ),
    _MatrixRow(
      label: 'Courses Offered',
      values: colleges.map((c) => '${c.courses.length} courses').toList(),
      valueType: _ValueType.text,
      higherIsBetter: true,
      numericValues: colleges.map((c) => c.courses.length.toDouble()).toList(),
    ),
  ];

  List<_MatrixRow> _buildPlacementRows(List<College> colleges) {
    latestStat(College c) =>
        c.placementHistory.isNotEmpty ? c.placementHistory.first : null;
    return [
      _MatrixRow(
        label: 'Avg LPA (Best)',
        values: colleges
            .map((c) => '${c.highestAvgLPA.toStringAsFixed(1)} LPA')
            .toList(),
        valueType: _ValueType.highlight,
        higherIsBetter: true,
        numericValues: colleges.map((c) => c.highestAvgLPA).toList(),
      ),
      _MatrixRow(
        label: 'Highest Package',
        values: colleges
            .map((c) => '${c.overallMaxLPA.toStringAsFixed(0)} LPA')
            .toList(),
        valueType: _ValueType.highlight,
        higherIsBetter: true,
        numericValues: colleges.map((c) => c.overallMaxLPA).toList(),
      ),
      _MatrixRow(
        label: 'Placement %',
        values: colleges.map((c) {
          final s = latestStat(c);
          if (s == null) return 'N/A';
          return '${s.placementPercent.toStringAsFixed(0)}%';
        }).toList(),
        valueType: _ValueType.highlight,
        higherIsBetter: true,
        numericValues: colleges.map((c) {
          final s = latestStat(c);
          return s?.placementPercent ?? 0;
        }).toList(),
      ),
      _MatrixRow(
        label: 'Median LPA',
        values: colleges.map((c) {
          final s = latestStat(c);
          if (s == null) return 'N/A';
          return '${s.medianLPA.toStringAsFixed(1)} LPA';
        }).toList(),
        valueType: _ValueType.text,
        higherIsBetter: true,
        numericValues: colleges.map((c) {
          final s = latestStat(c);
          return s?.medianLPA ?? 0;
        }).toList(),
      ),
    ];
  }

  List<_MatrixRow> _buildStreamRows(List<College> colleges) => [
    _MatrixRow(
      label: 'Streams',
      values: colleges.map((c) => c.streams.join(', ')).toList(),
      valueType: _ValueType.text,
    ),
    _MatrixRow(
      label: 'Has Engineering',
      values: colleges
          .map((c) => c.streams.contains('Engineering') ? '✓ Yes' : '✗ No')
          .toList(),
      valueType: _ValueType.bool,
      boolValues: colleges
          .map((c) => c.streams.contains('Engineering'))
          .toList(),
    ),
    _MatrixRow(
      label: 'Has Management',
      values: colleges
          .map((c) => c.streams.contains('Management') ? '✓ Yes' : '✗ No')
          .toList(),
      valueType: _ValueType.bool,
      boolValues: colleges
          .map((c) => c.streams.contains('Management'))
          .toList(),
    ),
    _MatrixRow(
      label: 'Has Science',
      values: colleges
          .map((c) => c.streams.contains('Science') ? '✓ Yes' : '✗ No')
          .toList(),
      valueType: _ValueType.bool,
      boolValues: colleges.map((c) => c.streams.contains('Science')).toList(),
    ),
  ];

  List<_MatrixRow> _buildAmenityRows(List<College> colleges) {
    const amenityKeys = [
      'Gym',
      'WiFi',
      'Hostel',
      'Library',
      'Research Labs',
      'Medical',
    ];
    const amenitySearch = [
      'Gym',
      'WiFi',
      'Hostel',
      'Library',
      'Research',
      'Medical',
    ];
    return amenityKeys.asMap().entries.map((e) {
      final key = amenitySearch[e.key];
      return _MatrixRow(
        label: amenityKeys[e.key],
        values: colleges
            .map((c) => c.hasAmenity(key) ? '✓ Yes' : '✗ No')
            .toList(),
        valueType: _ValueType.bool,
        boolValues: colleges.map((c) => c.hasAmenity(key)).toList(),
      );
    }).toList();
  }

  List<_MatrixRow> _buildMautRows(List<College> colleges, UserPreference pref) {
    return [
      _MatrixRow(
        label: 'Match Score',
        values: colleges
            .map(
              (c) => '${(c.mautScore * 100).clamp(0, 100).toStringAsFixed(1)}%',
            )
            .toList(),
        valueType: _ValueType.highlight,
        higherIsBetter: true,
        numericValues: colleges.map((c) => c.mautScore).toList(),
      ),
      _MatrixRow(
        label: 'Placement Wt.',
        values: List.filled(
          colleges.length,
          '${(pref.w1Placement * 100).toStringAsFixed(0)}%',
        ),
        valueType: _ValueType.text,
      ),
      _MatrixRow(
        label: 'Fee Wt.',
        values: List.filled(
          colleges.length,
          '${(pref.w2Fee * 100).toStringAsFixed(0)}%',
        ),
        valueType: _ValueType.text,
      ),
    ];
  }
}

// ── College header card ───────────────────────────────────────────────────────
class _CollegeHeaderCard extends StatelessWidget {
  final College college;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _CollegeHeaderCard({
    required this.college,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isGovt =
        college.type.contains('Government') || college.type.contains('Public');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          border: const Border(
            left: BorderSide(color: Colors.white12, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isGovt
                        ? Colors.amber.withOpacity(0.2)
                        : Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isGovt
                        ? Icons.account_balance_rounded
                        : Icons.school_rounded,
                    color: isGovt ? Colors.amber : Colors.greenAccent,
                    size: 16,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              college.shortName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              college.city,
              style: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                const SizedBox(width: 3),
                Text(
                  college.overallRating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap for details →',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Matrix data models ────────────────────────────────────────────────────────
enum _ValueType { text, highlight, badge, rating, grade, bool }

class _MatrixRow {
  final String label;
  final List<String> values;
  final _ValueType valueType;
  final bool? higherIsBetter;
  final List<double>? numericValues;
  final List<bool>? boolValues;

  const _MatrixRow({
    required this.label,
    required this.values,
    required this.valueType,
    this.higherIsBetter,
    this.numericValues,
    this.boolValues,
  });

  int? get bestIndex {
    if (numericValues == null || higherIsBetter == null) return null;
    if (numericValues!.isEmpty) return null;
    double best = numericValues!.first;
    int idx = 0;
    for (int i = 1; i < numericValues!.length; i++) {
      final v = numericValues![i];
      if (higherIsBetter! ? v > best : v < best) {
        best = v;
        idx = i;
      }
    }
    return idx;
  }
}

// ── Matrix row widget ─────────────────────────────────────────────────────────
class _MatrixRowWidget extends StatelessWidget {
  final _MatrixRow row;
  final bool isEven;
  static const double _colWidth = 180;
  static const double _labelWidth = 140;

  const _MatrixRowWidget({required this.row, required this.isEven});

  @override
  Widget build(BuildContext context) {
    final bestIdx = row.bestIndex;
    return Container(
      color: isEven ? Colors.white : const Color(0xFFF8F9FC),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Label ────────────────────────────────────────────────────
          Container(
            width: _labelWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(
              row.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          // ── Value cells ───────────────────────────────────────────────
          ...row.values.asMap().entries.map((entry) {
            final i = entry.key;
            final isBest = bestIdx == i;
            return _ValueCell(
              value: entry.value,
              valueType: row.valueType,
              isBest: isBest,
              isEven: isEven,
              boolValue: row.boolValues != null && i < row.boolValues!.length
                  ? row.boolValues![i]
                  : null,
            );
          }),
        ],
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  final String value;
  final _ValueType valueType;
  final bool isBest;
  final bool isEven;
  final bool? boolValue;

  static const double _colWidth = 180;

  const _ValueCell({
    required this.value,
    required this.valueType,
    required this.isBest,
    required this.isEven,
    this.boolValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _colWidth,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isBest
            ? const Color(0xFF1A237E).withOpacity(0.06)
            : Colors.transparent,
        border: const Border(
          left: BorderSide(color: Color(0xFFEEEEF5), width: 1),
        ),
      ),
      child: _buildCellContent(),
    );
  }

  Widget _buildCellContent() {
    switch (valueType) {
      case _ValueType.highlight:
        return Row(
          children: [
            if (isBest)
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A237E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isBest
                      ? const Color(0xFF1A237E)
                      : const Color(0xFF1A1A2E),
                ),
              ),
            ),
          ],
        );

      case _ValueType.rating:
        return Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 14),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isBest
                    ? const Color(0xFF1A237E)
                    : const Color(0xFF1A1A2E),
              ),
            ),
          ],
        );

      case _ValueType.grade:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _gradeColor(value).withOpacity(0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: _gradeColor(value),
            ),
          ),
        );

      case _ValueType.badge:
        final isGovt = value.contains('Government') || value.contains('Public');
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isGovt
                ? const Color(0xFF1A237E).withOpacity(0.08)
                : const Color(0xFF00897B).withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            isGovt ? 'Government' : 'Private',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isGovt ? const Color(0xFF1A237E) : const Color(0xFF00897B),
            ),
          ),
        );

      case _ValueType.bool:
        final isTrue = boolValue ?? value.contains('✓');
        return Row(
          children: [
            Icon(
              isTrue ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: 16,
              color: isTrue ? const Color(0xFF2E7D32) : Colors.grey.shade400,
            ),
            const SizedBox(width: 6),
            Text(
              isTrue ? 'Yes' : 'No',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isTrue ? const Color(0xFF2E7D32) : Colors.grey.shade500,
              ),
            ),
          ],
        );

      case _ValueType.text:
      default:
        return Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF3C3C5C),
            fontWeight: FontWeight.w500,
          ),
        );
    }
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'A++':
        return const Color(0xFF1B5E20);
      case 'A+':
        return const Color(0xFF2E7D32);
      case 'A':
        return const Color(0xFF388E3C);
      case 'B++':
        return const Color(0xFF1A237E);
      case 'B+':
        return const Color(0xFF1565C0);
      default:
        return Colors.grey;
    }
  }
}

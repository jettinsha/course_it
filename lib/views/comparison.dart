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

  // ── FIX: A single shared ScrollController drives BOTH the sticky college
  // header row and the matrix body. Previously the header had its own private
  // ScrollController, so swiping the body did not move the header and vice
  // versa. Sharing one controller keeps them perfectly in sync.
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

  // ── Main comparison matrix ─────────────────────────────────────────────
  // Layout:  [sticky label col] | [horizontally-scrolling value cols]
  //
  // The entire right side (header cards + all data rows) is driven by one
  // _horizScroll controller, so header and body always move together.
  Widget _buildComparisonMatrix(
    BuildContext context,
    List<College> colleges,
    UserPreference pref,
  ) {
    return Column(
      children: [
        // ── Pinned college header row (scrolls horizontally with body) ──
        _buildStickyHeader(context, colleges, pref),

        // ── Scrollable matrix body (vertical + horizontal) ──────────────
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed label sidebar
              _buildLabelSidebar(colleges, pref),

              // Horizontally scrollable data columns
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  // Same controller as the header – they stay in sync.
                  controller: _horizScroll,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: _colWidth * colleges.length,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDataSection(
                            title: 'Basic Information',
                            icon: Icons.info_outline_rounded,
                            rows: _buildBasicInfoRows(colleges),
                          ),
                          _buildDataSection(
                            title: 'Fee Structure',
                            icon: Icons.currency_rupee_rounded,
                            rows: _buildFeeRows(colleges),
                          ),
                          _buildDataSection(
                            title: 'Placement Statistics',
                            icon: Icons.trending_up_rounded,
                            rows: _buildPlacementRows(colleges),
                          ),
                          _buildDataSection(
                            title: 'Academic Streams',
                            icon: Icons.school_rounded,
                            rows: _buildStreamRows(colleges),
                          ),
                          _buildDataSection(
                            title: 'Campus Amenities',
                            icon: Icons.apartment_rounded,
                            rows: _buildAmenityRows(colleges),
                          ),
                          _buildDataSection(
                            title: 'MAUT Match Score',
                            icon: Icons.auto_awesome_rounded,
                            rows: _buildMautRows(colleges, pref),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Sticky college header ──────────────────────────────────────────────
  // Uses the SAME _horizScroll so it moves with the data columns.
  Widget _buildStickyHeader(
    BuildContext context,
    List<College> colleges,
    UserPreference pref,
  ) {
    return Container(
      color: const Color(0xFF1A237E),
      child: Row(
        children: [
          // Spacer that aligns over the label sidebar
          Container(
            width: _labelWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: const Text(
              'Metric',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // College header cards scroll with _horizScroll
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _horizScroll, // ← shared controller (the fix)
              physics: const NeverScrollableScrollPhysics(),
              // NeverScrollableScrollPhysics here because the
              // data-column scroll view is the source of truth;
              // this header just mirrors its offset via the
              // shared controller.
              child: Row(
                children: colleges.map((c) {
                  return _CollegeHeaderCard(
                    college: c,
                    onRemove: () => pref.toggleCompare(c.id),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => InstitutionDetailView(college: c),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Fixed label sidebar ────────────────────────────────────────────────
  Widget _buildLabelSidebar(List<College> colleges, UserPreference pref) {
    final allRows = [
      ..._buildBasicInfoRows(colleges),
      ..._buildFeeRows(colleges),
      ..._buildPlacementRows(colleges),
      ..._buildStreamRows(colleges),
      ..._buildAmenityRows(colleges),
      ..._buildMautRows(colleges, pref),
    ];

    // Section headers interspersed with row labels – mirror the data column
    // structure so row heights align perfectly.
    final sections = [
      _SectionMeta(
        'Basic Information',
        Icons.info_outline_rounded,
        _buildBasicInfoRows(colleges).length,
      ),
      _SectionMeta(
        'Fee Structure',
        Icons.currency_rupee_rounded,
        _buildFeeRows(colleges).length,
      ),
      _SectionMeta(
        'Placement Statistics',
        Icons.trending_up_rounded,
        _buildPlacementRows(colleges).length,
      ),
      _SectionMeta(
        'Academic Streams',
        Icons.school_rounded,
        _buildStreamRows(colleges).length,
      ),
      _SectionMeta(
        'Campus Amenities',
        Icons.apartment_rounded,
        _buildAmenityRows(colleges).length,
      ),
      _SectionMeta(
        'MAUT Match Score',
        Icons.auto_awesome_rounded,
        _buildMautRows(colleges, pref).length,
      ),
    ];

    return SizedBox(
      width: _labelWidth,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sections.expand((section) {
            return [
              _LabelSectionHeader(title: section.title, icon: section.icon),
              ...List.generate(section.rowCount, (i) {
                // Find the right label from allRows
                final rowIdx =
                    sections
                        .takeWhile((s) => s != section)
                        .fold(0, (acc, s) => acc + s.rowCount) +
                    i;
                final label = rowIdx < allRows.length
                    ? allRows[rowIdx].label
                    : '';
                return _LabelCell(label: label, isEven: i.isEven);
              }),
            ];
          }).toList(),
        ),
      ),
    );
  }

  // ── Data section builder ───────────────────────────────────────────────
  Widget _buildDataSection({
    required String title,
    required IconData icon,
    required List<_MatrixRow> rows,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DataSectionHeader(title: title, icon: icon),
        ...rows.asMap().entries.map((entry) {
          return _DataRowWidget(row: entry.value, isEven: entry.key.isEven);
        }),
      ],
    );
  }

  // ── Row data builders ──────────────────────────────────────────────────
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
    PlacementStat? latestStat(College c) =>
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
          return s == null
              ? 'N/A'
              : '${s.placementPercent.toStringAsFixed(0)}%';
        }).toList(),
        valueType: _ValueType.highlight,
        higherIsBetter: true,
        numericValues: colleges.map((c) {
          return latestStat(c)?.placementPercent ?? 0;
        }).toList(),
      ),
      _MatrixRow(
        label: 'Median LPA',
        values: colleges.map((c) {
          final s = latestStat(c);
          return s == null ? 'N/A' : '${s.medianLPA.toStringAsFixed(1)} LPA';
        }).toList(),
        valueType: _ValueType.text,
        higherIsBetter: true,
        numericValues: colleges.map((c) {
          return latestStat(c)?.medianLPA ?? 0;
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
      label: 'Engineering',
      values: colleges
          .map((c) => c.streams.contains('Engineering') ? '✓ Yes' : '✗ No')
          .toList(),
      valueType: _ValueType.bool,
      boolValues: colleges
          .map((c) => c.streams.contains('Engineering'))
          .toList(),
    ),
    _MatrixRow(
      label: 'Management',
      values: colleges
          .map((c) => c.streams.contains('Management') ? '✓ Yes' : '✗ No')
          .toList(),
      valueType: _ValueType.bool,
      boolValues: colleges
          .map((c) => c.streams.contains('Management'))
          .toList(),
    ),
    _MatrixRow(
      label: 'Science',
      values: colleges
          .map((c) => c.streams.contains('Science') ? '✓ Yes' : '✗ No')
          .toList(),
      valueType: _ValueType.bool,
      boolValues: colleges.map((c) => c.streams.contains('Science')).toList(),
    ),
  ];

  List<_MatrixRow> _buildAmenityRows(List<College> colleges) {
    const amenityLabels = [
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
    return amenityLabels.asMap().entries.map((e) {
      final key = amenitySearch[e.key];
      return _MatrixRow(
        label: amenityLabels[e.key],
        values: colleges
            .map((c) => c.hasAmenity(key) ? '✓ Yes' : '✗ No')
            .toList(),
        valueType: _ValueType.bool,
        boolValues: colleges.map((c) => c.hasAmenity(key)).toList(),
      );
    }).toList();
  }

  List<_MatrixRow> _buildMautRows(
    List<College> colleges,
    UserPreference pref,
  ) => [
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

  // ── Column width constants ─────────────────────────────────────────────
  static const double _colWidth = 180.0;
  static const double _labelWidth = 140.0;
}

// ── Section metadata for sidebar builder ─────────────────────────────────────
class _SectionMeta {
  final String title;
  final IconData icon;
  final int rowCount;
  const _SectionMeta(this.title, this.icon, this.rowCount);
}

// ── Label sidebar widgets ─────────────────────────────────────────────────────
class _LabelSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _LabelSectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 18, 8, 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF1A237E)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A237E),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelCell extends StatelessWidget {
  final String label;
  final bool isEven;
  const _LabelCell({required this.label, required this.isEven});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      color: isEven ? Colors.white : const Color(0xFFF8F9FC),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

// ── Data section header ───────────────────────────────────────────────────────
class _DataSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _DataSectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF1A237E)),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A237E),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data row widget ───────────────────────────────────────────────────────────
class _DataRowWidget extends StatelessWidget {
  final _MatrixRow row;
  final bool isEven;
  static const double _colWidth = 180.0;

  const _DataRowWidget({required this.row, required this.isEven});

  @override
  Widget build(BuildContext context) {
    final bestIdx = row.bestIndex;
    return Container(
      color: isEven ? Colors.white : const Color(0xFFF8F9FC),
      height: 50,
      child: Row(
        children: row.values.asMap().entries.map((entry) {
          final i = entry.key;
          final isBest = bestIdx == i;
          return _ValueCell(
            value: entry.value,
            valueType: row.valueType,
            isBest: isBest,
            boolValue: row.boolValues != null && i < row.boolValues!.length
                ? row.boolValues![i]
                : null,
          );
        }).toList(),
      ),
    );
  }
}

// ── College header card ───────────────────────────────────────────────────────
class _CollegeHeaderCard extends StatelessWidget {
  final College college;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  static const double _colWidth = 180.0;

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
        width: _colWidth,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          border: const Border(
            left: BorderSide(color: Colors.white12, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
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
                    size: 14,
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
                      size: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              college.shortName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              college.city,
              style: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 11),
                const SizedBox(width: 3),
                Text(
                  college.overallRating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Details →',
                  style: TextStyle(color: Colors.white38, fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Matrix data model ─────────────────────────────────────────────────────────
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

// ── Value cell ────────────────────────────────────────────────────────────────
class _ValueCell extends StatelessWidget {
  final String value;
  final _ValueType valueType;
  final bool isBest;
  final bool? boolValue;

  static const double _colWidth = 180.0;

  const _ValueCell({
    required this.value,
    required this.valueType,
    required this.isBest,
    this.boolValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _colWidth,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isBest
            ? const Color(0xFF1A237E).withOpacity(0.06)
            : Colors.transparent,
        border: const Border(
          left: BorderSide(color: Color(0xFFEEEEF5), width: 1),
        ),
      ),
      child: Align(alignment: Alignment.centerLeft, child: _buildContent()),
    );
  }

  Widget _buildContent() {
    switch (valueType) {
      case _ValueType.highlight:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isBest) ...[
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A237E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                  size: 9,
                ),
              ),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isBest
                      ? const Color(0xFF1A237E)
                      : const Color(0xFF1A1A2E),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );

      case _ValueType.rating:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 13),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: _gradeColor(value).withOpacity(0.12),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: _gradeColor(value),
            ),
          ),
        );

      case _ValueType.badge:
        final isGovt = value.contains('Government') || value.contains('Public');
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isGovt
                ? const Color(0xFF1A237E).withOpacity(0.08)
                : const Color(0xFF00897B).withOpacity(0.08),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            isGovt ? 'Government' : 'Private',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isGovt ? const Color(0xFF1A237E) : const Color(0xFF00897B),
            ),
          ),
        );

      case _ValueType.bool:
        final isTrue = boolValue ?? value.contains('✓');
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isTrue ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: 15,
              color: isTrue ? const Color(0xFF2E7D32) : Colors.grey.shade400,
            ),
            const SizedBox(width: 5),
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
          overflow: TextOverflow.ellipsis,
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

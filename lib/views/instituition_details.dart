// views/institution_detail_view.dart

import 'package:course_it/models/collage_model.dart';
import 'package:flutter/material.dart';

class InstitutionDetailView extends StatefulWidget {
  final College college;
  const InstitutionDetailView({super.key, required this.college});

  @override
  State<InstitutionDetailView> createState() => _InstitutionDetailViewState();
}

class _InstitutionDetailViewState extends State<InstitutionDetailView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  static const _tabs = ['Overview', 'Courses', 'Placements', 'Reviews'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.college;
    final isGovt = c.type.contains('Government') || c.type.contains('Public');

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerScrolled) => [
          // ── Sliver hero header ───────────────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: const Color(0xFF1A237E),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.share_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.bookmark_border_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _buildHeroBackground(c, isGovt),
            ),
          ),

          // ── Tab bar ──────────────────────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              tabBar: TabBar(
                controller: _tabController,
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
                labelColor: const Color(0xFF1A237E),
                unselectedLabelColor: Colors.grey.shade500,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                indicatorColor: const Color(0xFF1A237E),
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.grey.shade200,
              ),
            ),
          ),
        ],

        body: TabBarView(
          controller: _tabController,
          children: [
            _OverviewTab(college: c),
            _CoursesTab(college: c),
            _PlacementsTab(college: c),
            _ReviewsTab(college: c),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBackground(College c, bool isGovt) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isGovt
              ? [
                  const Color(0xFF0D1B6E),
                  const Color(0xFF1A237E),
                  const Color(0xFF283593),
                ]
              : [
                  const Color(0xFF004D40),
                  const Color(0xFF00695C),
                  const Color(0xFF00897B),
                ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  // College avatar
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        c.shortName
                            .substring(
                              0,
                              c.shortName.length > 3 ? 3 : c.shortName.length,
                            )
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${c.city} • Est. ${c.established}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _HeroBadge(
                    label: c.type,
                    icon: isGovt
                        ? Icons.account_balance_rounded
                        : Icons.school_rounded,
                  ),
                  const SizedBox(width: 8),
                  _HeroBadge(
                    label: 'NAAC ${c.naacGrade}',
                    icon: Icons.verified_rounded,
                  ),
                  const SizedBox(width: 8),
                  _HeroBadge(
                    label: '★ ${c.overallRating.toStringAsFixed(1)}',
                    icon: Icons.star_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  const _HeroBadge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate({required this.tabBar});

  @override
  Widget build(BuildContext ctx, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  double get maxExtent => 48;
  @override
  double get minExtent => 48;
  @override
  bool shouldRebuild(covariant _TabBarDelegate old) => false;
}

// ══════════════════════════════════════════════════════════════════════════════
// TAB 0: OVERVIEW
// ══════════════════════════════════════════════════════════════════════════════
class _OverviewTab extends StatelessWidget {
  final College college;
  const _OverviewTab({required this.college});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        // About
        _DetailCard(
          title: 'About',
          icon: Icons.info_outline_rounded,
          child: Text(
            college.description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF3C3C5C),
              height: 1.6,
            ),
          ),
        ),

        // Quick stats
        _DetailCard(
          title: 'At a Glance',
          icon: Icons.dashboard_rounded,
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.0,
            children: [
              _GlanceCell(
                label: 'Type',
                value: college.type,
                icon: Icons.account_balance_rounded,
              ),
              _GlanceCell(
                label: 'NAAC',
                value: 'Grade ${college.naacGrade}',
                icon: Icons.verified_rounded,
              ),
              _GlanceCell(
                label: 'Rating',
                value: '${college.overallRating}/5.0',
                icon: Icons.star_rounded,
              ),
              _GlanceCell(
                label: 'Est.',
                value: college.established.toString(),
                icon: Icons.calendar_today_rounded,
              ),
              _GlanceCell(
                label: 'Courses',
                value: '${college.courses.length} programs',
                icon: Icons.menu_book_rounded,
              ),
              _GlanceCell(
                label: 'Min Fee',
                value:
                    '₹${(college.lowestAnnualFee / 1000).toStringAsFixed(0)}K/yr',
                icon: Icons.currency_rupee_rounded,
              ),
            ],
          ),
        ),

        // Affiliation
        _DetailCard(
          title: 'Affiliation',
          icon: Icons.link_rounded,
          child: Row(
            children: [
              const Icon(
                Icons.account_balance_rounded,
                size: 16,
                color: Color(0xFF1A237E),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  college.affiliation,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A237E),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Amenities
        _DetailCard(
          title: 'Campus Amenities',
          icon: Icons.apartment_rounded,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: college.amenities
                .map((a) => _AmenityChip(label: a))
                .toList(),
          ),
        ),

        // Location
        _DetailCard(
          title: 'Location',
          icon: Icons.location_on_rounded,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E).withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.map_rounded,
                  color: Color(0xFF1A237E),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${college.city}, ${college.district}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const Text(
                      'Kerala, India',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 80),
      ],
    );
  }
}

class _GlanceCell extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _GlanceCell({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E).withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF1A237E)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final String label;
  const _AmenityChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E).withOpacity(0.07),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 12,
            color: Color(0xFF1A237E),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF1A237E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TAB 1: COURSES
// ══════════════════════════════════════════════════════════════════════════════
class _CoursesTab extends StatelessWidget {
  final College college;
  const _CoursesTab({required this.college});

  static const Map<String, Color> _streamColors = {
    'Engineering': Color(0xFF1A237E),
    'Management': Color(0xFF6A1B9A),
    'Science': Color(0xFF00695C),
    'Arts': Color(0xFFAD1457),
    'Medicine': Color(0xFFC62828),
  };

  @override
  Widget build(BuildContext context) {
    // Group courses by stream
    final grouped = <String, List<Course>>{};
    for (final course in college.courses) {
      grouped.putIfAbsent(course.stream, () => []).add(course);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        // Summary
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A237E), Color(0xFF283593)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              _CourseSummaryItem(
                label: 'Total Programs',
                value: '${college.courses.length}',
              ),
              _CourseSummaryDivider(),
              _CourseSummaryItem(
                label: 'Streams',
                value: '${college.streams.length}',
              ),
              _CourseSummaryDivider(),
              _CourseSummaryItem(
                label: 'Min Fee',
                value:
                    '₹${(college.lowestAnnualFee / 1000).toStringAsFixed(0)}K',
              ),
            ],
          ),
        ),

        // Stream groups
        ...grouped.entries.map((entry) {
          final stream = entry.key;
          final courses = entry.value;
          final color = _streamColors[stream] ?? Colors.grey;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      stream,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${courses.length}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...courses.map(
                (course) => _CourseCard(course: course, color: color),
              ),
              const SizedBox(height: 8),
            ],
          );
        }),

        const SizedBox(height: 80),
      ],
    );
  }
}

class _CourseSummaryItem extends StatelessWidget {
  final String label;
  final String value;
  const _CourseSummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _CourseSummaryDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withOpacity(0.2),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  final Color color;
  const _CourseCard({required this.course, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        course.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${course.durationYears} Yrs',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _CourseMetric(
                      label: 'Annual Fee',
                      value:
                          '₹${(course.annualFee / 1000).toStringAsFixed(0)}K',
                      icon: Icons.currency_rupee_rounded,
                      color: const Color(0xFF1565C0),
                    ),
                    const SizedBox(width: 8),
                    _CourseMetric(
                      label: 'Avg LPA',
                      value: '${course.avgLPA.toStringAsFixed(1)}L',
                      icon: Icons.trending_up_rounded,
                      color: const Color(0xFF2E7D32),
                    ),
                    const SizedBox(width: 8),
                    _CourseMetric(
                      label: 'Max LPA',
                      value: '${course.maxLPA.toStringAsFixed(0)}L',
                      icon: Icons.emoji_events_rounded,
                      color: const Color(0xFFE65100),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _CourseMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TAB 2: PLACEMENTS
// ══════════════════════════════════════════════════════════════════════════════
class _PlacementsTab extends StatelessWidget {
  final College college;
  const _PlacementsTab({required this.college});

  @override
  Widget build(BuildContext context) {
    final history = college.placementHistory;
    if (history.isEmpty) {
      return const Center(child: Text('No placement data available'));
    }
    final latest = history.first;

    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        // Hero placement card (latest)
        _LatestPlacementHero(stat: latest),

        const SizedBox(height: 16),

        // LPA distribution bar chart
        _DetailCard(
          title: 'LPA Distribution',
          icon: Icons.bar_chart_rounded,
          child: _LPADistributionChart(stat: latest),
        ),

        // Year-wise history
        _DetailCard(
          title: 'Year-wise Placement Trend',
          icon: Icons.trending_up_rounded,
          child: Column(
            children: history
                .map((s) => _PlacementHistoryRow(stat: s))
                .toList(),
          ),
        ),

        // Detailed stats per year
        ...history.map((s) => _PlacementYearCard(stat: s)),

        const SizedBox(height: 80),
      ],
    );
  }
}

class _LatestPlacementHero extends StatelessWidget {
  final PlacementStat stat;
  const _LatestPlacementHero({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A237E), Color(0xFF283593)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${stat.year} Placement Report',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _HeroPlacementMetric(
                label: 'Avg Package',
                value: '${stat.avgLPA.toStringAsFixed(1)} LPA',
                sub: 'Average CTC',
              ),
              _HeroPlacementMetric(
                label: 'Highest Package',
                value: '${stat.maxLPA.toStringAsFixed(0)} LPA',
                sub: 'Max CTC',
              ),
              _HeroPlacementMetric(
                label: 'Placement',
                value: '${stat.placementPercent.toStringAsFixed(0)}%',
                sub: '${stat.totalPlaced}/${stat.totalStudents} students',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Placement rate bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stat.placementPercent / 100,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPlacementMetric extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  const _HeroPlacementMetric({
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 10),
          ),
          Text(
            sub,
            style: const TextStyle(color: Colors.white38, fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LPADistributionChart extends StatelessWidget {
  final PlacementStat stat;
  const _LPADistributionChart({required this.stat});

  @override
  Widget build(BuildContext context) {
    // Synthetic distribution bands based on stat data
    final bands = [
      _LPABand(label: '< 4 LPA', percent: 0.10, color: const Color(0xFFEF5350)),
      _LPABand(label: '4–6 LPA', percent: 0.30, color: const Color(0xFFFFA726)),
      _LPABand(
        label: '6–10 LPA',
        percent: 0.40,
        color: const Color(0xFF1A237E),
      ),
      _LPABand(
        label: '10–20 LPA',
        percent: 0.15,
        color: const Color(0xFF2E7D32),
      ),
      _LPABand(
        label: '> 20 LPA',
        percent: 0.05,
        color: const Color(0xFFFFB300),
      ),
    ];

    return Column(
      children: bands.map((band) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                child: Text(
                  band.label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: band.percent,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(band.color),
                    minHeight: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 36,
                child: Text(
                  '${(band.percent * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: band.color,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _LPABand {
  final String label;
  final double percent;
  final Color color;
  const _LPABand({
    required this.label,
    required this.percent,
    required this.color,
  });
}

class _PlacementHistoryRow extends StatelessWidget {
  final PlacementStat stat;
  const _PlacementHistoryRow({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              stat.year,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A237E),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: stat.avgLPA / 12.0,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF1A237E),
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${stat.avgLPA.toStringAsFixed(1)} LPA avg  •  ${stat.maxLPA.toStringAsFixed(0)} LPA max',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlacementYearCard extends StatelessWidget {
  final PlacementStat stat;
  const _PlacementYearCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.year,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MiniStat(
                label: 'Avg',
                value: '${stat.avgLPA.toStringAsFixed(1)} L',
                color: const Color(0xFF1565C0),
              ),
              _MiniStat(
                label: 'Median',
                value: '${stat.medianLPA.toStringAsFixed(1)} L',
                color: const Color(0xFF6A1B9A),
              ),
              _MiniStat(
                label: 'Max',
                value: '${stat.maxLPA.toStringAsFixed(0)} L',
                color: const Color(0xFF2E7D32),
              ),
              _MiniStat(
                label: 'Placed',
                value: '${stat.totalPlaced}/${stat.totalStudents}',
                color: const Color(0xFFE65100),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TAB 3: REVIEWS
// ══════════════════════════════════════════════════════════════════════════════
class _ReviewsTab extends StatelessWidget {
  final College college;
  const _ReviewsTab({required this.college});

  @override
  Widget build(BuildContext context) {
    final reviews = college.reviews;

    // Compute avg rating
    final avg = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        // Rating summary card
        _DetailCard(
          title: 'Overall Rating',
          icon: Icons.star_rounded,
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    avg.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A237E),
                      height: 1,
                    ),
                  ),
                  const Text(
                    '/5.0',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (i) {
                      return Icon(
                        i < avg.round()
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: const Color(0xFFFFB300),
                        size: 18,
                      );
                    }),
                  ),
                  Text(
                    '${reviews.length} reviews',
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [5, 4, 3, 2, 1].map((star) {
                    final count = reviews
                        .where((r) => r.rating.round() == star)
                        .length;
                    final frac = reviews.isEmpty ? 0.0 : count / reviews.length;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            '$star',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.star_rounded,
                            size: 11,
                            color: Color(0xFFFFB300),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: frac,
                                backgroundColor: Colors.grey.shade100,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFFB300),
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$count',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Individual reviews
        ...reviews.map((r) => _ReviewCard(review: r)),

        const SizedBox(height: 80),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review.reviewerName[0].toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A237E),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.reviewerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        if (review.isVerified) ...[
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.verified_rounded,
                            size: 13,
                            color: Color(0xFF1A237E),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      review.batch,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Star rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 13,
                      color: Color(0xFFFFB300),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF795548),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF3C3C5C),
              height: 1.55,
            ),
          ),
          if (!review.isVerified) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 12,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(width: 4),
                Text(
                  'Unverified review',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Shared detail card ────────────────────────────────────────────────────────
class _DetailCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _DetailCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(icon, size: 16, color: const Color(0xFF1A237E)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

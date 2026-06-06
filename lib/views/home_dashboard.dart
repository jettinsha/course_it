// views/home_dashboard_view.dart

import 'package:course_it/models/collage_model.dart';
import 'package:course_it/models/user_preferance.dart';
import 'package:course_it/views/instituition_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/discovery_provider.dart';


class HomeDashboardView extends StatefulWidget {
  final VoidCallback onGoToFilters;
  final VoidCallback onGoToCompare;

  const HomeDashboardView({
    super.key,
    required this.onGoToFilters,
    required this.onGoToCompare,
  });

  @override
  State<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _searchFocused = false;

  static const List<String> _streamTabs = [
    'All',
    'Engineering',
    'Management',
    'Science',
    'Arts',
    'Medicine',
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() {
      setState(() => _searchFocused = _searchFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final pref = context.watch<UserPreference>();
    final discovery = context.watch<DiscoveryProvider>();
    final theme = Theme.of(context);

    final colleges = discovery.queryColleges(pref);
    final activeStream = pref.selectedStreams.isEmpty
        ? 'All'
        : pref.selectedStreams.first;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero App Bar ───────────────────────────────────────────────
          _buildSliverAppBar(theme, pref, colleges.length),

          // ── Search + Filters sticky header ────────────────────────────
          SliverToBoxAdapter(child: _buildSearchSection(pref, theme)),

          // ── Stream category chips ──────────────────────────────────────
          SliverToBoxAdapter(
            child: _buildStreamChips(_streamTabs, activeStream, pref),
          ),

          // ── Stats row ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _buildStatsRow(colleges, discovery, pref, theme),
          ),

          // ── Section label ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A237E),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Top Matched Colleges',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${colleges.length} results',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── College cards ─────────────────────────────────────────────
          discovery.isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF1A237E)),
                  ),
                )
              : colleges.isEmpty
              ? SliverFillRemaining(child: _buildEmptyState(theme))
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final college = colleges[index];
                    return _CollegeListCard(
                      college: college,
                      rank: index + 1,
                      onTap: () => _openDetail(context, college),
                      onCompareToggle: () {
                        final added = pref.toggleCompare(college.id);
                        if (!added && pref.compareIds.length >= 3) {
                          _showSnack(context, 'Compare list is full (max 3)');
                        }
                      },
                      isInCompare: pref.isInCompare(college.id),
                    );
                  }, childCount: colleges.length),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // ── Compare FAB ───────────────────────────────────────────────────
      floatingActionButton: pref.compareIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: widget.onGoToCompare,
              backgroundColor: const Color(0xFF1A237E),
              icon: const Icon(
                Icons.compare_arrows_rounded,
                color: Colors.white,
              ),
              label: Text(
                'Compare (${pref.compareIds.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  // ── Sliver App Bar ──────────────────────────────────────────────────────
  Widget _buildSliverAppBar(ThemeData theme, UserPreference pref, int count) {
    return SliverAppBar(
      expandedHeight: 160,
      collapsedHeight: 64,
      pinned: true,
      backgroundColor: const Color(0xFF1A237E),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D1B6E), Color(0xFF283593)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.white70,
                              size: 13,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Kerala, India',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Find Your\nPerfect College',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count institutions matched',
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'CourseIT',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
      ),
    );
  }

  // ── Search section ──────────────────────────────────────────────────────
  Widget _buildSearchSection(UserPreference pref, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.search_rounded,
              color: Color(0xFF1A237E),
              size: 22,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              onChanged: pref.setSearchQuery,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'Search colleges, courses, cities…',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
            ),
          ),
          if (_searchCtrl.text.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 18,
                color: Colors.grey,
              ),
              onPressed: () {
                _searchCtrl.clear();
                pref.setSearchQuery('');
                _searchFocus.unfocus();
              },
            ),
          GestureDetector(
            onTap: widget.onGoToFilters,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stream chips ────────────────────────────────────────────────────────
  Widget _buildStreamChips(
    List<String> tabs,
    String active,
    UserPreference pref,
  ) {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: tabs.length,
        itemBuilder: (ctx, i) {
          final tab = tabs[i];
          final isActive =
              tab == active || (tab == 'All' && pref.selectedStreams.isEmpty);
          return GestureDetector(
            onTap: () {
              if (tab == 'All') {
                for (final s in List.from(pref.selectedStreams)) {
                  pref.toggleStream(s);
                }
              } else {
                if (pref.selectedStreams.isNotEmpty &&
                    pref.selectedStreams.first != tab) {
                  pref.toggleStream(pref.selectedStreams.first);
                }
                pref.toggleStream(tab);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF1A237E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF1A237E)
                      : Colors.grey.shade200,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFF1A237E).withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                tab,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey.shade600,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Stats row ───────────────────────────────────────────────────────────
  Widget _buildStatsRow(
    List<College> colleges,
    DiscoveryProvider discovery,
    UserPreference pref,
    ThemeData theme,
  ) {
    final avgMatch = colleges.isEmpty
        ? 0.0
        : colleges.map((c) => c.mautScore).reduce((a, b) => a + b) /
              colleges.length *
              100;
    final avgFee = colleges.isEmpty
        ? 0.0
        : colleges.map((c) => c.lowestAnnualFee).reduce((a, b) => a + b) /
              colleges.length;
    final avgLPA = colleges.isEmpty
        ? 0.0
        : colleges.map((c) => c.highestAvgLPA).reduce((a, b) => a + b) /
              colleges.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          _StatCard(
            label: 'Avg Match',
            value: '${avgMatch.toStringAsFixed(0)}%',
            icon: Icons.auto_awesome_rounded,
            color: const Color(0xFF1A237E),
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Avg Fee/yr',
            value: '₹${(avgFee / 1000).toStringAsFixed(0)}K',
            icon: Icons.currency_rupee_rounded,
            color: const Color(0xFF00897B),
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Avg LPA',
            value: '${avgLPA.toStringAsFixed(1)} L',
            icon: Icons.trending_up_rounded,
            color: const Color(0xFFE65100),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No colleges matched',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, College college) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InstitutionDetailView(college: college),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF1A237E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
  }
}

// ── Stat Card widget ─────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── College list card ─────────────────────────────────────────────────────────
class _CollegeListCard extends StatelessWidget {
  final College college;
  final int rank;
  final VoidCallback onTap;
  final VoidCallback onCompareToggle;
  final bool isInCompare;

  const _CollegeListCard({
    required this.college,
    required this.rank,
    required this.onTap,
    required this.onCompareToggle,
    required this.isInCompare,
  });

  @override
  Widget build(BuildContext context) {
    final matchPct = (college.mautScore * 100).clamp(0.0, 100.0);
    final isGovt =
        college.type.contains('Government') || college.type.contains('Public');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: isInCompare
              ? Border.all(color: const Color(0xFF1A237E), width: 1.5)
              : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Header strip with gradient ─────────────────────────────
            Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                gradient: LinearGradient(
                  colors: isGovt
                      ? [const Color(0xFF1A237E), const Color(0xFF3949AB)]
                      : [const Color(0xFF00897B), const Color(0xFF26A69A)],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Rank badge ────────────────────────────────────
                      _RankBadge(rank: rank),
                      const SizedBox(width: 12),

                      // ── College info ──────────────────────────────────
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    college.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Color(0xFF1A1A2E),
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                _RatingBadge(rating: college.overallRating),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 13,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${college.city}, ${college.district}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _TypeBadge(type: college.type, isGovt: isGovt),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── MAUT match bar ─────────────────────────────────────
                  _MatchBar(matchPct: matchPct),

                  const SizedBox(height: 12),

                  // ── Key metrics row ───────────────────────────────────
                  Row(
                    children: [
                      _MetricPill(
                        label: 'From',
                        value:
                            '₹${(college.lowestAnnualFee / 1000).toStringAsFixed(0)}K/yr',
                        icon: Icons.currency_rupee_rounded,
                        color: const Color(0xFF1565C0),
                      ),
                      const SizedBox(width: 8),
                      _MetricPill(
                        label: 'Avg LPA',
                        value: '${college.highestAvgLPA.toStringAsFixed(1)}L',
                        icon: Icons.trending_up_rounded,
                        color: const Color(0xFF2E7D32),
                      ),
                      const SizedBox(width: 8),
                      _MetricPill(
                        label: 'Max LPA',
                        value: '${college.overallMaxLPA.toStringAsFixed(0)}L',
                        icon: Icons.emoji_events_rounded,
                        color: const Color(0xFFE65100),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Courses + Compare row ─────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: college.streams
                              .take(3)
                              .map((s) => _StreamChip(stream: s))
                              .toList(),
                        ),
                      ),
                      GestureDetector(
                        onTap: onCompareToggle,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isInCompare
                                ? const Color(0xFF1A237E)
                                : const Color(0xFF1A237E).withOpacity(0.07),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isInCompare
                                    ? Icons.check_rounded
                                    : Icons.compare_arrows_rounded,
                                size: 14,
                                color: isInCompare
                                    ? Colors.white
                                    : const Color(0xFF1A237E),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isInCompare ? 'Added' : 'Compare',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isInCompare
                                      ? Colors.white
                                      : const Color(0xFF1A237E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Micro-component helpers ───────────────────────────────────────────────────

class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: rank <= 3
            ? const Color(0xFF1A237E).withOpacity(0.1)
            : Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '#$rank',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: rank <= 3 ? const Color(0xFF1A237E) : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFB300)),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF795548),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;
  final bool isGovt;
  const _TypeBadge({required this.type, required this.isGovt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isGovt
            ? const Color(0xFF1A237E).withOpacity(0.07)
            : const Color(0xFF00897B).withOpacity(0.07),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isGovt ? 'Govt' : 'Private',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isGovt ? const Color(0xFF1A237E) : const Color(0xFF00897B),
        ),
      ),
    );
  }
}

class _MatchBar extends StatelessWidget {
  final double matchPct;
  const _MatchBar({required this.matchPct});

  Color get _barColor {
    if (matchPct >= 75) return const Color(0xFF2E7D32);
    if (matchPct >= 50) return const Color(0xFF1A237E);
    return const Color(0xFFE65100);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MAUT Match Score',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${matchPct.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12,
                color: _barColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: matchPct / 100,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(_barColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _MetricPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreamChip extends StatelessWidget {
  final String stream;
  const _StreamChip({required this.stream});

  Color _color() {
    switch (stream) {
      case 'Engineering':
        return const Color(0xFF1A237E);
      case 'Management':
        return const Color(0xFF6A1B9A);
      case 'Science':
        return const Color(0xFF00695C);
      case 'Arts':
        return const Color(0xFFAD1457);
      case 'Medicine':
        return const Color(0xFFC62828);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: _color().withOpacity(0.08),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        stream,
        style: TextStyle(
          fontSize: 10,
          color: _color(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

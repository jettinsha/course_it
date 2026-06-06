// views/advanced_filter_view.dart

import 'package:course_it/models/user_preferance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/discovery_provider.dart';

class AdvancedFilterView extends StatefulWidget {
  const AdvancedFilterView({super.key});

  @override
  State<AdvancedFilterView> createState() => _AdvancedFilterViewState();
}

class _AdvancedFilterViewState extends State<AdvancedFilterView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ── Kerala districts ────────────────────────────────────────────────────
  static const List<String> _keralaDistricts = [
    'Thiruvananthapuram',
    'Kollam',
    'Pathanamthitta',
    'Alappuzha',
    'Kottayam',
    'Idukki',
    'Ernakulam',
    'Thrissur',
    'Palakkad',
    'Malappuram',
    'Kozhikode',
    'Wayanad',
    'Kannur',
    'Kasaragod',
  ];

  static const List<String> _streams = [
    'Engineering',
    'Management',
    'Science',
    'Arts',
    'Medicine',
  ];

  static const List<Map<String, dynamic>> _amenities = [
    {'label': 'Gym & Sports Complex', 'icon': Icons.fitness_center_rounded},
    {'label': 'Smart Campus & Free WiFi', 'icon': Icons.wifi_rounded},
    {'label': 'Separate Hostels', 'icon': Icons.hotel_rounded},
    {'label': 'Central Library', 'icon': Icons.local_library_rounded},
    {'label': 'Research Labs', 'icon': Icons.science_rounded},
    {'label': 'Medical Centre', 'icon': Icons.local_hospital_rounded},
    {'label': 'Innovation Hub', 'icon': Icons.lightbulb_rounded},
    {'label': 'Cafeteria', 'icon': Icons.restaurant_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final pref = context.watch<UserPreference>();
    final discovery = context.watch<DiscoveryProvider>();
    final resultCount = discovery.queryColleges(pref).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App bar ──────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFF1A237E),
            elevation: 0,
            title: const Text(
              'Advanced Filters',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            actions: [
              TextButton(
                onPressed: pref.clearFilters,
                child: const Text(
                  'Reset All',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          // ── MAUT Weight configurator ──────────────────────────────────
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Preference Weights (MAUT)',
              subtitle: 'Adjust importance of each factor',
              icon: Icons.tune_rounded,
              child: _MautWeightEditor(pref: pref),
            ),
          ),

          // ── Fee Range ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Annual Tuition Fee',
              subtitle: 'Maximum budget per year',
              icon: Icons.currency_rupee_rounded,
              child: _FeeSlider(pref: pref),
            ),
          ),

          // ── College Type ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Academic Stream',
              subtitle: 'Filter by discipline',
              icon: Icons.school_rounded,
              child: _StreamSelector(streams: _streams, pref: pref),
            ),
          ),

          // ── Kerala Districts ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'District / Location',
              subtitle: 'Select preferred regions in Kerala',
              icon: Icons.map_rounded,
              child: _DistrictSelector(districts: _keralaDistricts, pref: pref),
            ),
          ),

          // ── Amenities ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Campus Amenities',
              subtitle: 'Required facilities on campus',
              icon: Icons.apartment_rounded,
              child: _AmenitySelector(amenities: _amenities, pref: pref),
            ),
          ),

          // ── Active filters summary ────────────────────────────────────
          SliverToBoxAdapter(child: _ActiveFiltersSummary(pref: pref)),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // ── Apply button ─────────────────────────────────────────────────
      bottomNavigationBar: _ApplyBar(resultCount: resultCount),
    );
  }
}

// ── Section card ─────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: const Color(0xFF1A237E)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
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

// ── MAUT Weight editor ────────────────────────────────────────────────────────
class _MautWeightEditor extends StatelessWidget {
  final UserPreference pref;
  const _MautWeightEditor({required this.pref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _WeightRow(
          label: 'Placement (LPA)',
          icon: Icons.work_rounded,
          value: pref.w1Placement,
          color: const Color(0xFF1565C0),
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF1A237E),
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor: const Color(0xFF1A237E),
            overlayColor: const Color(0xFF1A237E).withOpacity(0.15),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: pref.w1Placement,
            min: 0.1,
            max: 0.9,
            divisions: 8,
            onChanged: pref.setWeights,
          ),
        ),
        _WeightRow(
          label: 'Affordability (Fee)',
          icon: Icons.savings_rounded,
          value: pref.w2Fee,
          color: const Color(0xFF00897B),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E).withOpacity(0.04),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: Color(0xFF1A237E),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Placement weight: ${(pref.w1Placement * 100).toStringAsFixed(0)}%  •  Fee weight: ${(pref.w2Fee * 100).toStringAsFixed(0)}%  (sum = 100%)',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF1A237E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeightRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final Color color;
  const _WeightRow({
    required this.label,
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${(value * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Fee slider ────────────────────────────────────────────────────────────────
class _FeeSlider extends StatelessWidget {
  final UserPreference pref;
  const _FeeSlider({required this.pref});

  String _formatFee(double fee) {
    if (fee >= 100000) {
      return '₹${(fee / 100000).toStringAsFixed(1)}L';
    }
    return '₹${(fee / 1000).toStringAsFixed(0)}K';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Min',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const Text(
                  '₹50K',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF1A237E),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Budget Limit',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                Text(
                  _formatFee(pref.maxFee),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const Text(
                  'per year',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Max',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const Text(
                  '₹8L',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF1A237E),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF1A237E),
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayColor: const Color(0xFF1A237E).withOpacity(0.15),
            trackHeight: 6,
          ),
          child: Slider(
            value: pref.maxFee,
            min: 50000,
            max: 800000,
            divisions: 30,
            onChanged: pref.setMaxFee,
          ),
        ),
        const SizedBox(height: 4),
        // ── Fee band labels ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['₹50K', '₹2L', '₹4L', '₹6L', '₹8L']
              .map(
                (l) => Text(
                  l,
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        // ── Fee type indicators ─────────────────────────────────────────
        Row(
          children: [
            _FeeTag(label: 'Govt (< ₹1L)', color: const Color(0xFF1A237E)),
            const SizedBox(width: 8),
            _FeeTag(label: 'Deemed (₹1L–4L)', color: const Color(0xFF00897B)),
            const SizedBox(width: 8),
            _FeeTag(label: 'Private (> ₹4L)', color: const Color(0xFFE65100)),
          ],
        ),
      ],
    );
  }
}

class _FeeTag extends StatelessWidget {
  final String label;
  final Color color;
  const _FeeTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

// ── Stream selector ───────────────────────────────────────────────────────────
class _StreamSelector extends StatelessWidget {
  final List<String> streams;
  final UserPreference pref;
  const _StreamSelector({required this.streams, required this.pref});

  static const Map<String, IconData> _icons = {
    'Engineering': Icons.precision_manufacturing_rounded,
    'Management': Icons.business_center_rounded,
    'Science': Icons.biotech_rounded,
    'Arts': Icons.palette_rounded,
    'Medicine': Icons.medical_services_rounded,
  };

  static const Map<String, Color> _colors = {
    'Engineering': Color(0xFF1A237E),
    'Management': Color(0xFF6A1B9A),
    'Science': Color(0xFF00695C),
    'Arts': Color(0xFFAD1457),
    'Medicine': Color(0xFFC62828),
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: streams.map((stream) {
        final isSelected = pref.selectedStreams.contains(stream);
        final color = _colors[stream] ?? Colors.grey;
        return GestureDetector(
          onTap: () => pref.toggleStream(stream),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade200,
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _icons[stream] ?? Icons.school_rounded,
                  size: 16,
                  color: isSelected ? Colors.white : color,
                ),
                const SizedBox(width: 6),
                Text(
                  stream,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── District selector ─────────────────────────────────────────────────────────
class _DistrictSelector extends StatelessWidget {
  final List<String> districts;
  final UserPreference pref;
  const _DistrictSelector({required this.districts, required this.pref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Quick select row
        Row(
          children: [
            _QuickSelectChip(
              label: 'All Kerala',
              onTap: () {
                for (final d in districts) {
                  if (!pref.selectedDistricts.contains(d)) {
                    pref.toggleDistrict(d);
                  }
                }
              },
            ),
            const SizedBox(width: 8),
            _QuickSelectChip(
              label: 'Clear',
              onTap: () {
                for (final d in List.from(pref.selectedDistricts)) {
                  pref.toggleDistrict(d);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: districts.length,
          itemBuilder: (ctx, i) {
            final district = districts[i];
            final isSelected = pref.selectedDistricts.contains(district);
            return GestureDetector(
              onTap: () => pref.toggleDistrict(district),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1A237E)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1A237E)
                        : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 14,
                      color: isSelected ? Colors.white : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        district,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _QuickSelectChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickSelectChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E).withOpacity(0.07),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Amenity selector ──────────────────────────────────────────────────────────
class _AmenitySelector extends StatelessWidget {
  final List<Map<String, dynamic>> amenities;
  final UserPreference pref;
  const _AmenitySelector({required this.amenities, required this.pref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: amenities.map((amenity) {
        final label = amenity['label'] as String;
        final icon = amenity['icon'] as IconData;
        final isSelected = pref.requiredAmenities.contains(label);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1A237E).withOpacity(0.04)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF1A237E).withOpacity(0.3)
                  : Colors.grey.shade200,
            ),
          ),
          child: CheckboxListTile(
            value: isSelected,
            onChanged: (_) => pref.toggleAmenity(label),
            title: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF1A237E)
                    : const Color(0xFF1A1A2E),
              ),
            ),
            secondary: Icon(
              icon,
              size: 20,
              color: isSelected
                  ? const Color(0xFF1A237E)
                  : Colors.grey.shade400,
            ),
            activeColor: const Color(0xFF1A237E),
            checkboxShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 2,
            ),
            dense: true,
          ),
        );
      }).toList(),
    );
  }
}

// ── Active filters summary ────────────────────────────────────────────────────
class _ActiveFiltersSummary extends StatelessWidget {
  final UserPreference pref;
  const _ActiveFiltersSummary({required this.pref});

  @override
  Widget build(BuildContext context) {
    final chips = <String>[];
    if (pref.maxFee < 800000) {
      chips.add('Fee ≤ ₹${(pref.maxFee / 1000).toStringAsFixed(0)}K');
    }
    chips.addAll(pref.selectedStreams);
    chips.addAll(pref.selectedDistricts);
    chips.addAll(pref.requiredAmenities.map((a) => a.split('&').first.trim()));

    if (chips.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Filters',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: chips
                .map(
                  (chip) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A237E).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      chip,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF1A237E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Apply bar ─────────────────────────────────────────────────────────────────
class _ApplyBar extends StatelessWidget {
  final int resultCount;
  const _ApplyBar({required this.resultCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$resultCount Colleges Found',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const Text(
                  'Based on your filters',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              elevation: 0,
            ),
            child: const Text(
              'View Results',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

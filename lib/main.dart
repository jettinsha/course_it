// main.dart
// CourseIT – Smart Kerala Higher Education Discovery & Comparison Engine
// Architecture: Clean UI + ChangeNotifier state management (no backend dependencies)

import 'package:course_it/models/user_preferance.dart';
import 'package:course_it/providers/discovery_provider.dart';
import 'package:course_it/views/comparison.dart';
import 'package:course_it/views/filter_view.dart';
import 'package:course_it/views/home_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait for consistent UX
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserPreference()),
        ChangeNotifierProvider(create: (_) => DiscoveryProvider()),
      ],
      child: const CourseITApp(),
    ),
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// Root application widget
// ═════════════════════════════════════════════════════════════════════════════
class CourseITApp extends StatelessWidget {
  const CourseITApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CourseIT',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const _AppInitialiser(),
    );
  }

  ThemeData _buildTheme() {
    const primaryColor = Color(0xFF1A237E);
    const secondaryColor = Color(0xFF00897B);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
        background: const Color(0xFFF4F6FB),
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F6FB),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: Colors.grey.shade200,
        thumbColor: Colors.white,
        overlayColor: primaryColor.withOpacity(0.15),
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: Colors.grey.shade400, width: 1.5),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: primaryColor,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 28,
          color: Color(0xFF1A1A2E),
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 22,
          color: Color(0xFF1A1A2E),
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: Color(0xFF1A1A2E),
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xFF1A1A2E),
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          color: Color(0xFF3C3C5C),
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          color: Color(0xFF3C3C5C),
        ),
        bodySmall: TextStyle(
          fontSize: 11,
          color: Colors.grey,
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// App initialiser – seeds data, then shows shell
// ═════════════════════════════════════════════════════════════════════════════
class _AppInitialiser extends StatefulWidget {
  const _AppInitialiser();

  @override
  State<_AppInitialiser> createState() => _AppInitialiserState();
}

class _AppInitialiserState extends State<_AppInitialiser>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
    _init();
  }

  Future<void> _init() async {
    await context.read<DiscoveryProvider>().initialise();
    if (mounted) {
      setState(() => _ready = true);
      _fadeCtrl.forward();
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const _SplashScreen();
    return FadeTransition(
      opacity: _fadeAnim,
      child: const AppShell(),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Splash / loading screen
// ═════════════════════════════════════════════════════════════════════════════
class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _opacityAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D1B6E), Color(0xFF1A237E), Color(0xFF283593)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnim.value,
                child: Transform.scale(
                  scale: _scaleAnim.value,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.3), width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'CourseIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Smart College Discovery · Kerala',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.7)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Loading institutions…',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Main app shell with bottom navigation
// ═════════════════════════════════════════════════════════════════════════════
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final PageController _pageController;

  // Tab animation controllers for icon micro-interactions
  late final List<AnimationController> _iconControllers;
  late final List<Animation<double>> _iconScales;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _iconControllers = List.generate(
      3,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
        lowerBound: 1.0,
        upperBound: 1.25,
      ),
    );
    _iconScales = _iconControllers
        .map((c) =>
            CurvedAnimation(parent: c, curve: Curves.easeOutBack))
        .toList();

    // Animate first tab
    _iconControllers[0].forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _iconControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onNavTap(int index) {
    if (_currentIndex == index) return;

    // Reset old, animate new
    _iconControllers[_currentIndex].reverse();
    _iconControllers[index].forward();

    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goToTab(int index) => _onNavTap(index);

  @override
  Widget build(BuildContext context) {
    final pref = context.watch<UserPreference>();

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeDashboardView(
            onGoToFilters: () => _goToTab(1),
            onGoToCompare: () => _goToTab(2),
          ),
          const AdvancedFilterView(),
          const MatrixComparisonView(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(pref),
    );
  }

  Widget _buildBottomNav(UserPreference pref) {
    final items = [
      _NavItem(
        icon: Icons.explore_rounded,
        activeIcon: Icons.explore_rounded,
        label: 'Discover',
        badge: null,
      ),
      _NavItem(
        icon: Icons.tune_rounded,
        activeIcon: Icons.tune_rounded,
        label: 'Filters',
        badge: _countActiveFilters(pref) > 0
            ? _countActiveFilters(pref).toString()
            : null,
      ),
      _NavItem(
        icon: Icons.compare_arrows_rounded,
        activeIcon: Icons.compare_arrows_rounded,
        label: 'Compare',
        badge: pref.compareIds.isNotEmpty
            ? pref.compareIds.length.toString()
            : null,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isActive = _currentIndex == i;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _onNavTap(i),
                  child: ScaleTransition(
                    scale: _iconScales[i],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF1A237E).withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isActive ? item.activeIcon : item.icon,
                                color: isActive
                                    ? const Color(0xFF1A237E)
                                    : Colors.grey.shade400,
                                size: 24,
                              ),
                            ),
                            if (item.badge != null)
                              Positioned(
                                top: -2,
                                right: -2,
                                child: Container(
                                  width: 17,
                                  height: 17,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE53935),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.badge!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isActive
                                ? const Color(0xFF1A237E)
                                : Colors.grey.shade400,
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  int _countActiveFilters(UserPreference pref) {
    int count = 0;
    if (pref.maxFee < 800000) count++;
    count += pref.selectedStreams.length;
    count += pref.selectedDistricts.length;
    count += pref.requiredAmenities.length;
    return count;
  }
}

// ── Navigation item data class ────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String? badge;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badge,
  });
}
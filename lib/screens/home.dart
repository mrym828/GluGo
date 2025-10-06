import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme.dart';
import '../widgets/shared_components.dart';
import 'package:fl_chart/fl_chart.dart';
import 'log_reading_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _animationController.forward();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_outline : Icons.error_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? AppTheme.successGreen : AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusM),
        margin: const EdgeInsets.all(AppTheme.spacingL),
        duration: const Duration(seconds: 3),
      ),
    );
  }


  void _navigateToLogReading() async {
    HapticFeedback.lightImpact();
    try {
      final result = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LogReadingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
      
      if (result == true) {
        _showSnackBar('Reading logged successfully!');
      }
    } catch (e) {
      _showSnackBar('Failed to navigate', isSuccess: false);
    }
  }

  void _navigateToLogMeal() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/scanner');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WelcomeSection(),
                const SizedBox(height: AppTheme.spacingXL),
                _CurrentGlucoseSection(
                  onLogReading: _navigateToLogReading,
                  onLogMeal: _navigateToLogMeal,
                  ),
                const SizedBox(height: AppTheme.spacingXL),
                _QuickStatsSection(),
                const SizedBox(height: AppTheme.spacingXL),
                _QuickActionsSection(onShowSnackBar: _showSnackBar),
                const SizedBox(height: AppTheme.spacingXL),
                _RecentActivitySection(onShowSnackBar: _showSnackBar),
                const SizedBox(height: AppTheme.spacingXXL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return const SharedAppBar(
      title: 'GluGo',
      showBackButton: false,
      showConnection: true,
    );
  }
}

// Welcome Section Widget
class _WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting = 'Good morning';
    if (hour >= 12 && hour < 17) {
      greeting = 'Good afternoon';
    } else if (hour >= 17) {
      greeting = 'Good evening';
    }

    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingS),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: AppTheme.radiusS,
                ),
                child: Icon(
                  Icons.waving_hand_rounded,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, Maryam',
                      style: AppTheme.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Here\'s your glucose summary for today',
                      style: AppTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: 'Readings',
                  value: '12',
                  accentColor: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(width: AppTheme.spacingXS),
              Expanded(
                child: MetricCard(
                  title: 'In Range',
                  value: '78',
                  unit: '%',
                  accentColor: AppTheme.successGreen,
                ),
              ),
              const SizedBox(width: AppTheme.spacingXS),
              Expanded(
                child: MetricCard(
                  title: 'Average',
                  value: '124',
                  unit: 'mg',
                  accentColor: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurrentGlucoseSection extends StatelessWidget {
  final VoidCallback onLogReading;
  final VoidCallback onLogMeal;

  const _CurrentGlucoseSection({required this.onLogReading,  required this.onLogMeal});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingS),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: AppTheme.radiusS,
                    ),
                    child: Icon(
                      Icons.bloodtype_rounded,
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Text(
                    'Current Glucose',
                    style: AppTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              StatusBadge(
                label: 'Target 80-130',
                color: AppTheme.textSecondary,
                isOutlined: true,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '112',
                style: AppTheme.displayMedium.copyWith(
                  color: AppTheme.successGreen,
                  fontWeight: FontWeight.w800,
                  fontSize: 48,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'mg/dL',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    StatusBadge(
                      label: 'In Range',
                      color: AppTheme.successGreen,
                      icon: Icons.check_circle_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppTheme.successGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Updated 2 minutes ago',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          _GlucoseChart(),
          const SizedBox(height: AppTheme.spacingL),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  label: 'Log Reading',
                  icon: Icons.add_circle_rounded,
                  onPressed: onLogReading,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: ActionButton(
                  label: 'Log Meal',
                  icon: Icons.restaurant_rounded,
                  onPressed: onLogMeal,
                  isPrimary: false,
                  customColor: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// Glucose Chart Widget
class _GlucoseChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withOpacity(0.3),
        borderRadius: AppTheme.radiusM,
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '24-Hour Trend',
                style: AppTheme.labelLarge.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              StatusBadge(
                label: '78% in range',
                color: AppTheme.successGreen,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.borderLight.withOpacity(0.5),
                      strokeWidth: 0.5,
                    );
                  },
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      interval: 6,
                      getTitlesWidget: (value, meta) {
                        final titles = ['00', '06', '12', '18', '24'];
                        final index = (value / 6).round();
                        if (index >= 0 && index < titles.length) {
                          return Text(
                            titles[index],
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textTertiary,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 24,
                minY: 50,
                maxY: 250,
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppTheme.primaryBlue,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: AppTheme.primaryBlue,
                          strokeWidth: 1,
                          strokeColor: AppTheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primaryBlue.withOpacity(0.1),
                          AppTheme.primaryBlue.withOpacity(0.02),
                        ],
                      ),
                    ),
                    spots: const [
                      FlSpot(0, 120),
                      FlSpot(3, 140),
                      FlSpot(6, 110),
                      FlSpot(9, 160),
                      FlSpot(12, 180),
                      FlSpot(15, 130),
                      FlSpot(18, 150),
                      FlSpot(21, 170),
                      FlSpot(24, 140),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Quick Stats Section Widget
class _QuickStatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Today\'s Summary',
        ),
        const SizedBox(height: AppTheme.spacingS),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: 'Time in Range',
                value: '78',
                unit: '%',
                subtitle: 'Goal: >70%',
                icon: Icons.timeline_rounded,
                accentColor: AppTheme.successGreen,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: MetricCard(
                title: 'Variability',
                value: '28',
                unit: '% CV',
                subtitle: 'Low variation',
                icon: Icons.analytics_rounded,
                accentColor: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  final Function(String, {bool isSuccess}) onShowSnackBar;

  const _QuickActionsSection({required this.onShowSnackBar});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Quick Actions',
        ),
        const SizedBox(height: AppTheme.spacingS),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.qr_code_scanner_rounded,
                title: 'Connect Sensor',
                subtitle: 'Scan your device',
                onTap: () => onShowSnackBar('Sensor scan coming soon!'),
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: _ActionCard(
                icon: Icons.camera_alt_rounded,
                title: 'Food Scanner',
                subtitle: 'Identify nutrition',
                onTap: () => onShowSnackBar('Food scanner coming soon!'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: BaseCard(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.08),
                borderRadius: AppTheme.radiusM,
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryBlue,
                size: 28,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            Text(
              title,
              style: AppTheme.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Recent Activity Section Widget
class _RecentActivitySection extends StatelessWidget {
  final Function(String, {bool isSuccess}) onShowSnackBar;

  const _RecentActivitySection({required this.onShowSnackBar});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent Activity',
          action: TextButton.icon(
            onPressed: () => onShowSnackBar('View all coming soon!'),
            label: const Text('View All'),
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryBlue,
              textStyle: AppTheme.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        BaseCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              CustomListItem(
                icon: Icons.bloodtype_rounded,
                iconColor: AppTheme.successGreen,
                title: 'Glucose Reading',
                subtitle: '126 mg/dL • 9:10 AM',
                trailing: StatusBadge(
                  label: 'In Range',
                  color: AppTheme.successGreen,
                ),
              ),
              CustomListItem(
                icon: Icons.restaurant_rounded,
                iconColor: AppTheme.mealColor,
                title: 'Breakfast Logged',
                subtitle: 'Paratha & Egg • Carbs 45g',
                trailing: StatusBadge(
                  label: 'Est. +22',
                  color: AppTheme.warningOrange,
                ),
              ),
              CustomListItem(
                icon: Icons.medication_rounded,
                iconColor: AppTheme.primaryBlue,
                title: 'Medication Reminder',
                subtitle: 'Metformin 500mg at 9:00 AM',
                trailing: StatusBadge(
                  label: 'Upcoming',
                  color: AppTheme.primaryBlue,
                ),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
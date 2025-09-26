import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'log_reading_page.dart';

class GlucoseOverviewScreen extends StatefulWidget {
  const GlucoseOverviewScreen({super.key});

  @override
  State<GlucoseOverviewScreen> createState() => _GlucoseOverviewScreenState();
}

class _GlucoseOverviewScreenState extends State<GlucoseOverviewScreen> 
    with TickerProviderStateMixin {
  String _selectedTimeRange = '24h';
  int _selectedTabIndex = 0;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _timeRanges = ['24h', '7d', '30d', '90d'];
  final List<String> _tabTitles = ['Overview', 'Trends', 'Statistics'];

  // Sample glucose data
  final List<GlucoseReading> _glucoseReadings = [
    GlucoseReading(DateTime.now().subtract(const Duration(hours: 1)), 112, false, false),
    GlucoseReading(DateTime.now().subtract(const Duration(hours: 2)), 126, false, false),
    GlucoseReading(DateTime.now().subtract(const Duration(hours: 3)), 98, false, false),
    GlucoseReading(DateTime.now().subtract(const Duration(hours: 4)), 145, false, false),
    GlucoseReading(DateTime.now().subtract(const Duration(hours: 5)), 189, false, true),
    GlucoseReading(DateTime.now().subtract(const Duration(hours: 6)), 156, false, false),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppTheme.normalAnimation,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.backgroundWhite),
        ),
        backgroundColor: isError ? AppTheme.errorRed : AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.buttonBorderRadius,
        ),
        margin: const EdgeInsets.all(AppTheme.spacingM),
      ),
    );
  }

  void _navigateToLogReading() async {
    HapticFeedback.lightImpact();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LogReadingPage(),
      ),
    );
    
    if (result == true) {
      _showSnackBar('Reading logged successfully!');
    }
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
          child: Column(
            children: [
              _buildTimeRangeSelector(),
              _buildTabSelector(),
              Expanded(
                child: _buildTabContent(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryBlue,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        'Glucose Overview',
        style: AppTheme.appBarTitleStyle,
      ),
      actions: [
        IconButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            _showSnackBar('Export feature coming soon!');
          },
          icon: const Icon(
            Icons.file_download_outlined,
            color: AppTheme.backgroundWhite,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            right: AppTheme.spacingL,
            top: AppTheme.spacingS,
            bottom: AppTheme.spacingS,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingS,
          ),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: AppTheme.chipBorderRadius,
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.successGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Connected',
                style: AppTheme.captionStyle.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingL),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: AppTheme.buttonBorderRadius,
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: _timeRanges.map((range) {
          final isSelected = _selectedTimeRange == range;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedTimeRange = range);
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: AppTheme.fastAnimation,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                  borderRadius: AppTheme.chipBorderRadius,
                ),
                child: Text(
                  range,
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyMedium.copyWith(
                    color: isSelected ? AppTheme.backgroundWhite : AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      child: Row(
        children: _tabTitles.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final isSelected = _selectedTabIndex == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedTabIndex = index);
                HapticFeedback.selectionClick();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyMedium.copyWith(
                    color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildTrendsTab();
      case 2:
        return _buildStatisticsTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentGlucoseCard(),
          const SizedBox(height: AppTheme.spacingL),
          _buildGlucoseChart(),
          const SizedBox(height: AppTheme.spacingL),
          _buildQuickStats(),
          const SizedBox(height: AppTheme.spacingL),
          _buildRecentReadings(),
          const SizedBox(height: 100), // Bottom padding for FAB
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          _buildDetailedChart(),
          const SizedBox(height: AppTheme.spacingL),
          _buildTrendAnalysis(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          _buildStatisticsGrid(),
          const SizedBox(height: AppTheme.spacingL),
          _buildTimeInRangeChart(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCurrentGlucoseCard() {
    final currentReading = _glucoseReadings.first;
    final glucoseColor = AppTheme.getGlucoseColor(currentReading.value);
    final glucoseStatus = AppTheme.getGlucoseStatus(currentReading.value);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: AppTheme.cardBorderRadius,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Reading',
                style: AppTheme.headingSmall,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: glucoseColor.withOpacity(0.1),
                  borderRadius: AppTheme.chipBorderRadius,
                  border: Border.all(
                    color: glucoseColor.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  glucoseStatus,
                  style: AppTheme.captionStyle.copyWith(
                    color: glucoseColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currentReading.value.toInt().toString(),
                style: AppTheme.glucoseValueStyle.copyWith(color: glucoseColor),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: Text(
                  'mg/dL',
                  style: AppTheme.glucoseUnitStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 16,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Updated ${_getTimeAgo(currentReading.timestamp)}',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlucoseChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: AppTheme.cardBorderRadius,
        boxShadow: AppTheme.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Glucose Trend',
            style: AppTheme.headingSmall.copyWith(fontSize: 16),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.borderLight,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 4,
                      getTitlesWidget: (value, meta) {
                        final hours = ['6h', '4h', '2h', 'Now'];
                        final index = (value / 4).round();
                        if (index >= 0 && index < hours.length) {
                          return Text(
                            hours[index],
                            style: AppTheme.captionStyle.copyWith(
                              color: AppTheme.neutralGray,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: AppTheme.captionStyle.copyWith(
                            color: AppTheme.neutralGray,
                          ),
                        );
                      },
                    ),
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
                maxX: 12,
                minY: 50,
                maxY: 250,
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: AppTheme.primaryBlue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        final glucoseValue = spot.y;
                        final color = AppTheme.getGlucoseColor(glucoseValue);
                        return FlDotCirclePainter(
                          radius: 4,
                          color: color,
                          strokeWidth: 2,
                          strokeColor: AppTheme.backgroundWhite,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primaryBlue.withOpacity(0.15),
                          AppTheme.primaryBlue.withOpacity(0.02),
                        ],
                      ),
                    ),
                    spots: _glucoseReadings.reversed.toList().asMap().entries.map((entry) {
                      return FlSpot(entry.key * 2.0, entry.value.value);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Average',
            value: '124',
            unit: 'mg/dL',
            color: AppTheme.primaryBlue,
            icon: Icons.analytics_rounded,
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: _buildStatCard(
            title: 'Time in Range',
            value: '78',
            unit: '%',
            color: AppTheme.successGreen,
            icon: Icons.trending_up_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: AppTheme.cardBorderRadius,
        boxShadow: AppTheme.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                icon,
                color: color,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReadings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Readings',
          style: AppTheme.headingMedium,
        ),
        const SizedBox(height: AppTheme.spacingM),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: AppTheme.cardBorderRadius,
            boxShadow: AppTheme.lightShadow,
          ),
          child: Column(
            children: _glucoseReadings.take(5).map((reading) {
              final isLast = reading == _glucoseReadings.take(5).last;
              return _buildReadingItem(reading, isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildReadingItem(GlucoseReading reading, bool isLast) {
    final glucoseColor = AppTheme.getGlucoseColor(reading.value);
    final glucoseStatus = AppTheme.getGlucoseStatus(reading.value);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: AppTheme.borderLight,
                  width: 1,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: glucoseColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${reading.value.toInt()} mg/dL',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getTimeAgo(reading.timestamp),
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: glucoseColor.withOpacity(0.1),
              borderRadius: AppTheme.chipBorderRadius,
            ),
            child: Text(
              glucoseStatus,
              style: AppTheme.captionStyle.copyWith(
                color: glucoseColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedChart() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: AppTheme.cardBorderRadius,
        boxShadow: AppTheme.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Glucose Trends',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Expanded(
            child: Center(
              child: Text(
                'Detailed chart implementation\ncoming soon!',
                textAlign: TextAlign.center,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendAnalysis() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: AppTheme.cardBorderRadius,
        boxShadow: AppTheme.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trend Analysis',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'AI-powered trend analysis\ncoming soon!',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppTheme.spacingM,
      mainAxisSpacing: AppTheme.spacingM,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          title: 'Avg Glucose',
          value: '124',
          unit: 'mg/dL',
          color: AppTheme.primaryBlue,
          icon: Icons.analytics_rounded,
        ),
        _buildStatCard(
          title: 'Time in Range',
          value: '78',
          unit: '%',
          color: AppTheme.successGreen,
          icon: Icons.trending_up_rounded,
        ),
        _buildStatCard(
          title: 'Low Events',
          value: '2',
          unit: 'times',
          color: AppTheme.glucoseLow,
          icon: Icons.trending_down_rounded,
        ),
        _buildStatCard(
          title: 'High Events',
          value: '5',
          unit: 'times',
          color: AppTheme.glucoseHigh,
          icon: Icons.trending_up_rounded,
        ),
      ],
    );
  }

  Widget _buildTimeInRangeChart() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: AppTheme.cardBorderRadius,
        boxShadow: AppTheme.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time in Range Distribution',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: AppTheme.spacingL),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 78,
                    color: AppTheme.successGreen,
                    title: '78%\nIn Range',
                    titleStyle: AppTheme.bodySmall.copyWith(
                      color: AppTheme.backgroundWhite,
                      fontWeight: FontWeight.w600,
                    ),
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: 15,
                    color: AppTheme.glucoseHigh,
                    title: '15%\nHigh',
                    titleStyle: AppTheme.bodySmall.copyWith(
                      color: AppTheme.backgroundWhite,
                      fontWeight: FontWeight.w600,
                    ),
                    radius: 50,
                  ),
                  PieChartSectionData(
                    value: 7,
                    color: AppTheme.glucoseLow,
                    title: '7%\nLow',
                    titleStyle: AppTheme.bodySmall.copyWith(
                      color: AppTheme.backgroundWhite,
                      fontWeight: FontWeight.w600,
                    ),
                    radius: 50,
                  ),
                ],
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _navigateToLogReading,
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: AppTheme.backgroundWhite,
      icon: const Icon(Icons.add_rounded),
      label: const Text(
        'Log Reading',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class GlucoseReading {
  final DateTime timestamp;
  final double value;
  final bool isLow;
  final bool isHigh;

  GlucoseReading(this.timestamp, this.value, this.isLow, this.isHigh);
}

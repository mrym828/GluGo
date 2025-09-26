import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme.dart';

class LogReadingPage extends StatefulWidget {
  const LogReadingPage({super.key});

  @override
  State<LogReadingPage> createState() => _LogReadingPageState();
}

class _LogReadingPageState extends State<LogReadingPage> 
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _glucoseController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDateTime = DateTime.now();
  String _selectedMealTiming = 'Before Meal';
  String _selectedMoodLevel = 'Good';
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _mealTimings = [
    'Before Meal',
    'After Meal',
    'Fasting',
    'Bedtime',
    'Random',
  ];

  final List<String> _moodLevels = [
    'Excellent',
    'Good',
    'Fair',
    'Poor',
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
    _glucoseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.backgroundWhite),
        ),
        backgroundColor: isError ? AppTheme.errorRed : AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.buttonBorderRadius,
        ),
        margin: const EdgeInsets.all(AppTheme.spacingM),
      ),
    );
  }

  void _selectDateTime() async {
    HapticFeedback.selectionClick();
    
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppTheme.primaryBlue,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveReading() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.heavyImpact();

    // Simulate saving
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (mounted) {
      _showSnackBar('Glucose reading saved successfully!');
      Navigator.pop(context, true);
    }
  }

  Color _getGlucoseInputColor() {
    final text = _glucoseController.text;
    if (text.isEmpty) return AppTheme.textSecondary;
    
    final value = double.tryParse(text);
    if (value == null) return AppTheme.textSecondary;
    
    return AppTheme.getGlucoseColor(value);
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppTheme.spacingXL),
                  _buildGlucoseInputCard(),
                  const SizedBox(height: AppTheme.spacingL),
                  _buildDateTimeCard(),
                  const SizedBox(height: AppTheme.spacingL),
                  _buildMealTimingCard(),
                  const SizedBox(height: AppTheme.spacingL),
                  _buildMoodCard(),
                  const SizedBox(height: AppTheme.spacingL),
                  _buildNotesCard(),
                  const SizedBox(height: AppTheme.spacingXL),
                  _buildSaveButton(),
                  const SizedBox(height: AppTheme.spacingL),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryBlue,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: AppTheme.backgroundWhite,
        ),
      ),
      title: Text(
        'Log Reading',
        style: AppTheme.appBarTitleStyle,
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            _showSnackBar('Quick scan feature coming soon!');
          },
          child: Text(
            'Scan',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.backgroundWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Glucose Reading',
          style: AppTheme.headingLarge,
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          'Enter your glucose measurement and additional details',
          style: AppTheme.bodyLarge.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildGlucoseInputCard() {
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
            children: [
              Icon(
                Icons.bloodtype_rounded,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingM),
              Text(
                'Glucose Level',
                style: AppTheme.headingSmall,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _glucoseController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: _getGlucoseInputColor(),
                    letterSpacing: -1,
                  ),
                  decoration: InputDecoration(
                    hintText: '000',
                    hintStyle: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.neutralLightGray,
                      letterSpacing: -1,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppTheme.inputBorderRadius,
                      borderSide: BorderSide(color: AppTheme.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppTheme.inputBorderRadius,
                      borderSide: BorderSide(color: AppTheme.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppTheme.inputBorderRadius,
                      borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingL,
                      vertical: AppTheme.spacingL,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter glucose level';
                    }
                    final glucose = double.tryParse(value);
                    if (glucose == null) {
                      return 'Please enter a valid number';
                    }
                    if (glucose < 20 || glucose > 600) {
                      return 'Please enter a realistic glucose level (20-600)';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {}); // Trigger rebuild to update color
                  },
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingL),
                child: Text(
                  'mg/dL',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          if (_glucoseController.text.isNotEmpty)
            AnimatedContainer(
              duration: AppTheme.fastAnimation,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              decoration: BoxDecoration(
                color: _getGlucoseInputColor().withOpacity(0.1),
                borderRadius: AppTheme.chipBorderRadius,
                border: Border.all(
                  color: _getGlucoseInputColor().withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getGlucoseStatusIcon(),
                    color: _getGlucoseInputColor(),
                    size: 16,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    _getGlucoseStatusText(),
                    style: AppTheme.bodySmall.copyWith(
                      color: _getGlucoseInputColor(),
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

  Widget _buildDateTimeCard() {
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
            children: [
              Icon(
                Icons.access_time_rounded,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingM),
              Text(
                'Date & Time',
                style: AppTheme.headingSmall,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          GestureDetector(
            onTap: _selectDateTime,
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: AppTheme.inputBorderRadius,
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(_selectedDateTime),
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatTime(_selectedDateTime),
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_rounded,
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTimingCard() {
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
            children: [
              Icon(
                Icons.restaurant_rounded,
                color: AppTheme.mealColor,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingM),
              Text(
                'Meal Timing',
                style: AppTheme.headingSmall,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          Wrap(
            spacing: AppTheme.spacingS,
            runSpacing: AppTheme.spacingS,
            children: _mealTimings.map((timing) {
              final isSelected = _selectedMealTiming == timing;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedMealTiming = timing);
                  HapticFeedback.selectionClick();
                },
                child: AnimatedContainer(
                  duration: AppTheme.fastAnimation,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppTheme.mealColor.withOpacity(0.1)
                        : AppTheme.surfaceLight,
                    borderRadius: AppTheme.chipBorderRadius,
                    border: Border.all(
                      color: isSelected 
                          ? AppTheme.mealColor.withOpacity(0.3)
                          : AppTheme.borderLight,
                    ),
                  ),
                  child: Text(
                    timing,
                    style: AppTheme.bodyMedium.copyWith(
                      color: isSelected ? AppTheme.mealColor : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard() {
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
            children: [
              Icon(
                Icons.mood_rounded,
                color: AppTheme.successGreen,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingM),
              Text(
                'How are you feeling?',
                style: AppTheme.headingSmall,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          Row(
            children: _moodLevels.map((mood) {
              final isSelected = _selectedMoodLevel == mood;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedMoodLevel = mood);
                    HapticFeedback.selectionClick();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppTheme.successGreen.withOpacity(0.1)
                          : AppTheme.surfaceLight,
                      borderRadius: AppTheme.chipBorderRadius,
                      border: Border.all(
                        color: isSelected 
                            ? AppTheme.successGreen.withOpacity(0.3)
                            : AppTheme.borderLight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getMoodIcon(mood),
                          color: isSelected ? AppTheme.successGreen : AppTheme.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        Text(
                          mood,
                          style: AppTheme.bodySmall.copyWith(
                            color: isSelected ? AppTheme.successGreen : AppTheme.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
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
            children: [
              Icon(
                Icons.note_add_rounded,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingM),
              Text(
                'Notes (Optional)',
                style: AppTheme.headingSmall,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Add any additional notes about this reading...',
              hintStyle: AppTheme.bodyMedium.copyWith(
                color: AppTheme.neutralGray,
              ),
              border: OutlineInputBorder(
                borderRadius: AppTheme.inputBorderRadius,
                borderSide: BorderSide(color: AppTheme.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppTheme.inputBorderRadius,
                borderSide: BorderSide(color: AppTheme.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppTheme.inputBorderRadius,
                borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _saveReading,
        icon: _isLoading 
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppTheme.backgroundWhite,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.save_rounded, size: 20),
        label: Text(
          _isLoading ? 'Saving...' : 'Save Reading',
          style: AppTheme.buttonTextStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: AppTheme.backgroundWhite,
          disabledBackgroundColor: AppTheme.neutralGray,
        ),
      ),
    );
  }

  IconData _getGlucoseStatusIcon() {
    final text = _glucoseController.text;
    if (text.isEmpty) return Icons.info_outline_rounded;
    
    final value = double.tryParse(text);
    if (value == null) return Icons.info_outline_rounded;
    
    if (value < 70) {
      return Icons.trending_down_rounded;
    } else if (value > 180) {
      return Icons.trending_up_rounded;
    } else {
      return Icons.check_circle_outline_rounded;
    }
  }

  String _getGlucoseStatusText() {
    final text = _glucoseController.text;
    if (text.isEmpty) return 'Enter glucose level';
    
    final value = double.tryParse(text);
    if (value == null) return 'Invalid number';
    
    return AppTheme.getGlucoseStatus(value);
  }

  IconData _getMoodIcon(String mood) {
    switch (mood) {
      case 'Excellent':
        return Icons.sentiment_very_satisfied_rounded;
      case 'Good':
        return Icons.sentiment_satisfied_rounded;
      case 'Fair':
        return Icons.sentiment_neutral_rounded;
      case 'Poor':
        return Icons.sentiment_dissatisfied_rounded;
      default:
        return Icons.sentiment_neutral_rounded;
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (date == today) {
      return 'Today';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}

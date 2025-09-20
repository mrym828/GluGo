import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme.dart';

class ProfileSetScreen extends StatefulWidget {
  const ProfileSetScreen({super.key});

  @override
  State<ProfileSetScreen> createState() => _ProfileSetScreenState();
}

class _ProfileSetScreenState extends State<ProfileSetScreen> {
  int _currentStep = 0;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Step 1: Basic Info
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _gender = '';
  String _activityLevel = '';

  // Step 2: Diabetes Info
  String _diabetesType = '';
  final _diagnosisYearController = TextEditingController();
  String _medicationType = '';
  final _hba1cController = TextEditingController();
  bool _usesCGM = false;
  String _cgmBrand = '';

  // Step 3: Goals & Preferences
  final _targetGlucoseMinController = TextEditingController();
  final _targetGlucoseMaxController = TextEditingController();
  List<String> _selectedGoals = [];
  List<String> _selectedNotifications = [];

  final List<String> _availableGoals = [
    'Improve HbA1c levels',
    'Reduce glucose spikes',
    'Better meal planning',
    'Increase exercise consistency',
    'Weight management',
    'Better sleep patterns'
  ];

  final List<String> _availableNotifications = [
    'High glucose alerts',
    'Low glucose alerts',
    'Medication reminders',
    'Meal logging reminders',
    'Exercise reminders',
    'Weekly progress reports'
  ];

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _diagnosisYearController.dispose();
    _hba1cController.dispose();
    _targetGlucoseMinController.dispose();
    _targetGlucoseMaxController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_validateStep1()) {
        setState(() => _currentStep++);
        HapticFeedback.lightImpact();
      }
    } else if (_currentStep == 1) {
      if (_validateStep2()) {
        setState(() => _currentStep++);
        HapticFeedback.lightImpact();
      }
    } else if (_currentStep == 2) {
      _completeSetup();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      HapticFeedback.lightImpact();
    }
  }

  bool _validateStep1() {
    if (_ageController.text.isEmpty || _weightController.text.isEmpty ||
        _heightController.text.isEmpty || _gender.isEmpty || _activityLevel.isEmpty) {
      _showSnackBar('Please fill in all required fields', isError: true);
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    if (_diabetesType.isEmpty || _diagnosisYearController.text.isEmpty || _medicationType.isEmpty) {
      _showSnackBar('Please fill in all required fields', isError: true);
      return false;
    }
    return true;
  }

  void _completeSetup() async {
    if (_targetGlucoseMinController.text.isEmpty || _targetGlucoseMaxController.text.isEmpty) {
      _showSnackBar('Please set your target glucose range', isError: true);
      return;
    }
    
    setState(() => _isLoading = true);
    HapticFeedback.heavyImpact();
    
    // Simulate saving profile data
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    _showSnackBar('Profile setup completed successfully!', isError: false);
    
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor,
              const Color(0xFF8FB8FE),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Progress indicator
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 4,
                        decoration: BoxDecoration(
                          color: index <= _currentStep 
                              ? Colors.white 
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              
              Text(
                "Setup Your Profile",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Step ${_currentStep + 1} of 3",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: _buildCurrentStep(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildNavigationButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildDiabetesInfoStep();
      case 2:
        return _buildGoalsStep();
      default:
        return Container();
    }
  }

  Widget _buildBasicInfoStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Basic Information",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2563EB),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Age",
              prefixIcon: const Icon(Icons.cake_outlined, color: Color(0xFF2563EB)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Weight (kg)",
                    prefixIcon: const Icon(Icons.monitor_weight_outlined, color: Color(0xFF2563EB)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Height (cm)",
                    prefixIcon: const Icon(Icons.height, color: Color(0xFF2563EB)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildGenderButton("Male")),
              const SizedBox(width: 12),
              Expanded(child: _buildGenderButton("Female")),
              const SizedBox(width: 12),
              Expanded(child: _buildGenderButton("Other")),
            ],
          ),
          const SizedBox(height: 24),

          const Text("Activity Level", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          _buildActivityButton("Sedentary", "Little to no exercise"),
          const SizedBox(height: 8),
          _buildActivityButton("Lightly Active", "Light exercise 1-3 days/week"),
          const SizedBox(height: 8),
          _buildActivityButton("Moderately Active", "Moderate exercise 3-5 days/week"),
          const SizedBox(height: 8),
          _buildActivityButton("Very Active", "Heavy exercise 6-7 days/week"),
        ],
      ),
    );
  }

  Widget _buildDiabetesInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Diabetes Information",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2563EB),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        const Text("Diabetes Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildDiabetesTypeButton("Type 1")),
            const SizedBox(width: 12),
            Expanded(child: _buildDiabetesTypeButton("Type 2")),
            const SizedBox(width: 12),
            Expanded(child: _buildDiabetesTypeButton("Prediabetes")),
          ],
        ),
        const SizedBox(height: 20),

        TextFormField(
          controller: _diagnosisYearController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Year of Diagnosis",
            prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF2563EB)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 20),

        const Text("Current Medication", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        _buildMedicationButton("Insulin", Icons.medical_services),
        const SizedBox(height: 8),
        _buildMedicationButton("Metformin", Icons.medication),
        const SizedBox(height: 8),
        _buildMedicationButton("Other oral medication", Icons.local_pharmacy),
        const SizedBox(height: 8),
        _buildMedicationButton("Diet and exercise only", Icons.fitness_center),
        const SizedBox(height: 20),

        TextFormField(
          controller: _hba1cController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Latest HbA1c (%) - Optional",
            prefixIcon: const Icon(Icons.biotech, color: Color(0xFF2563EB)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Checkbox(
              value: _usesCGM,
              onChanged: (value) => setState(() => _usesCGM = value ?? false),
              activeColor: const Color(0xFF2563EB),
            ),
            const Expanded(
              child: Text("I currently use a Continuous Glucose Monitor (CGM)"),
            ),
          ],
        ),
        
        if (_usesCGM) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _cgmBrand.isEmpty ? null : _cgmBrand,
            decoration: InputDecoration(
              labelText: "CGM Brand",
              prefixIcon: const Icon(Icons.device_hub, color: Color(0xFF2563EB)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            items: ['Freestyle Libre', 'Dexcom', 'Medtronic', 'Other']
                .map((brand) => DropdownMenuItem(value: brand, child: Text(brand)))
                .toList(),
            onChanged: (value) => setState(() => _cgmBrand = value ?? ''),
          ),
        ],
      ],
    );
  }

  Widget _buildGoalsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Goals & Preferences",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2563EB),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        const Text("Target Glucose Range (mg/dL)", 
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _targetGlucoseMinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Min",
                  hintText: "70",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _targetGlucoseMaxController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Max",
                  hintText: "180",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        const Text("Health Goals", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        ..._availableGoals.map((goal) => _buildGoalCheckbox(goal)),
        const SizedBox(height: 24),

        const Text("Notification Preferences", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        ..._availableNotifications.map((notification) => _buildNotificationCheckbox(notification)),
      ],
    );
  }

  Widget _buildGenderButton(String gender) {
    final isSelected = _gender == gender;
    return GestureDetector(
      onTap: () => setState(() => _gender = gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          gender,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityButton(String level, String description) {
    final isSelected = _activityLevel == level;
    return GestureDetector(
      onTap: () => setState(() => _activityLevel = level),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB).withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.grey[300]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              level,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF2563EB) : Colors.black87,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiabetesTypeButton(String type) {
    final isSelected = _diabetesType == type;
    return GestureDetector(
      onTap: () => setState(() => _diabetesType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          type,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationButton(String medication, IconData icon) {
    final isSelected = _medicationType == medication;
    return GestureDetector(
      onTap: () => setState(() => _medicationType = medication),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB).withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF2563EB) : Colors.grey[600]),
            const SizedBox(width: 12),
            Text(
              medication,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF2563EB) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCheckbox(String goal) {
    final isSelected = _selectedGoals.contains(goal);
    return CheckboxListTile(
      value: isSelected,
      onChanged: (value) {
        setState(() {
          if (value ?? false) {
            _selectedGoals.add(goal);
          } else {
            _selectedGoals.remove(goal);
          }
        });
      },
      title: Text(goal),
      activeColor: const Color(0xFF2563EB),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildNotificationCheckbox(String notification) {
    final isSelected = _selectedNotifications.contains(notification);
    return CheckboxListTile(
      value: isSelected,
      onChanged: (value) {
        setState(() {
          if (value ?? false) {
            _selectedNotifications.add(notification);
          } else {
            _selectedNotifications.remove(notification);
          }
        });
      },
      title: Text(notification),
      activeColor: const Color(0xFF2563EB),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2563EB)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Previous",
                style: TextStyle(color: Color(0xFF2563EB), fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          flex: _currentStep == 0 ? 1 : 1,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    _currentStep == 2 ? "Complete Setup" : "Next",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }
}
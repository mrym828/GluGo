import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme.dart';

class LogReadingPage extends StatefulWidget {
const LogReadingPage({super.key});

@override
State<LogReadingPage> createState() => _LogReadingPageState();
}

class _LogReadingPageState extends State<LogReadingPage> {
final _formKey = GlobalKey<FormState>();
final _glucoseController = TextEditingController();
final _notesController = TextEditingController();

DateTime _selectedDateTime = DateTime.now();
String _selectedMealTiming = 'Before Meal';
String _selectedMoodLevel = 'Good';
String _unit = 'mg/dL';
bool _isLoading = false;

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
void dispose() {
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
final date = await showDatePicker(
context: context,
initialDate: _selectedDateTime,
firstDate: DateTime.now().subtract(const Duration(days: 30)),
lastDate: DateTime.now(),
);

if (date != null && mounted) {
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
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
body: Form(
key: _formKey,
child: SingleChildScrollView(
padding: const EdgeInsets.all(AppTheme.spacingL),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_buildHeader(),
const SizedBox(height: AppTheme.spacingXL),
_buildGlucoseInputCard(),
const SizedBox(height: AppTheme.spacingL),
_buildDateTimeChip(),
const SizedBox(height: AppTheme.spacingL),
_buildMealTimingCard(),
const SizedBox(height: AppTheme.spacingL),
_buildMoodCard(),
const SizedBox(height: AppTheme.spacingL),
_buildNotesCard(),
const SizedBox(height: 100), // space for sticky button
],
),
),
),
bottomNavigationBar: _buildSaveButton(),
);
}

PreferredSizeWidget _buildAppBar() {
return AppBar(
backgroundColor: AppTheme.primaryBlue,
elevation: 0,
leading: IconButton(
onPressed: () => Navigator.pop(context),
icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
),
title: Text('Log Reading',),
actions: [
TextButton(
onPressed: () {
_showSnackBar('Quick scan feature coming soon!');
},
child: Text(
'Scan',
style: AppTheme.bodyMedium.copyWith(
color: Colors.white,
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
Text('New Glucose Reading', ),
const SizedBox(height: AppTheme.spacingS),
Text(
'Enter your glucose measurement and details',
style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
),
],
);
}

Widget _buildGlucoseInputCard() {
return Container(
padding: const EdgeInsets.all(AppTheme.spacingL),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: AppTheme.cardBorderRadius,
boxShadow: AppTheme.lightShadow,
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text('Glucose Level'),
const SizedBox(height: AppTheme.spacingM),
Row(
children: [
Expanded(
child: TextFormField(
controller: _glucoseController,
keyboardType:
const TextInputType.numberWithOptions(decimal: true),
style: TextStyle(
fontSize: 36,
fontWeight: FontWeight.bold,
color: _getGlucoseInputColor(),
),
decoration: const InputDecoration(
hintText: '---',
border: InputBorder.none,
),
validator: (value) {
if (value == null || value.isEmpty) {
return 'Please enter glucose level';
}
final glucose = double.tryParse(value);
if (glucose == null) return 'Enter a valid number';
if (glucose < 20 || glucose > 600) {
return 'Enter realistic glucose (20-600)';
}
return null;
},
onChanged: (_) => setState(() {}),
),
),
DropdownButton<String>(
value: _unit,
underline: const SizedBox(),
items: ['mg/dL', 'mmol/L']
.map((u) => DropdownMenuItem(value: u, child: Text(u)))
.toList(),
onChanged: (value) {
if (value != null) setState(() => _unit = value);
},
),
],
),
if (_glucoseController.text.isNotEmpty)
Padding(
padding: const EdgeInsets.only(top: AppTheme.spacingM),
child: Chip(
backgroundColor: _getGlucoseInputColor().withOpacity(0.1),
label: Text(
_getGlucoseStatusText(),
style: TextStyle(
color: _getGlucoseInputColor(),
fontWeight: FontWeight.w600,
),
),
),
),
],
),
);
}

Widget _buildDateTimeChip() {
return GestureDetector(
onTap: _selectDateTime,
child: Chip(
backgroundColor: AppTheme.surface,
avatar: const Icon(Icons.access_time, color: Colors.blue),
label: Text(
'${_formatDate(_selectedDateTime)}, ${_formatTime(_selectedDateTime)}',
style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
),
),
);
}

Widget _buildMealTimingCard() {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text('Meal Timing'),
const SizedBox(height: AppTheme.spacingM),
Wrap(
spacing: AppTheme.spacingS,
children: _mealTimings.map((timing) {
final isSelected = _selectedMealTiming == timing;
return ChoiceChip(
label: Text(timing),
selected: isSelected,
onSelected: (_) =>
setState(() => _selectedMealTiming = timing),
selectedColor: Colors.blue.withOpacity(0.2),
);
}).toList(),
),
],
);
}

Widget _buildMoodCard() {
final moodIcons = {
'Excellent': '😃',
'Good': '🙂',
'Fair': '😐',
'Poor': '😔',
};

return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('How are you feeling?'),
    const SizedBox(height: AppTheme.spacingM),
    Wrap(
      spacing: AppTheme.spacingS,
      children: _moodLevels.map((mood) {
        final isSelected = _selectedMoodLevel == mood;
        return ChoiceChip(
          label: Text('${moodIcons[mood]} $mood'),
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedMoodLevel = mood),
          selectedColor: Colors.green.withOpacity(0.2),
        );
      }).toList(),
    ),
  ],
);

}

Widget _buildNotesCard() {
return TextFormField(
controller: _notesController,
maxLines: null,
decoration: InputDecoration(
hintText: 'Any notes? (e.g. after exercise, felt dizzy)',
border: OutlineInputBorder(
borderRadius: AppTheme.inputBorderRadius,
),
),
);
}

Widget _buildSaveButton() {
return SafeArea(
child: Padding(
padding: const EdgeInsets.all(AppTheme.spacingL),
child: SizedBox(
width: double.infinity,
height: 56,
child: ElevatedButton(
onPressed: _isLoading ? null : _saveReading,
style: ElevatedButton.styleFrom(
backgroundColor: AppTheme.primaryBlue,
shape: RoundedRectangleBorder(
borderRadius: AppTheme.buttonBorderRadius,
),
),
child: _isLoading
? const CircularProgressIndicator(color: Colors.white)
: const Text(
'Save Reading',
style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
),
),
),
),
);
}

String _getGlucoseStatusText() {
final text = _glucoseController.text;
if (text.isEmpty) return 'Enter glucose';
final value = double.tryParse(text);
if (value == null) return 'Invalid number';
return AppTheme.getGlucoseStatus(value);
}

String _formatDate(DateTime dt) {
final today = DateTime.now();
if (dt.day == today.day &&
dt.month == today.month &&
dt.year == today.year) {
return 'Today';
}
return '${dt.month}/${dt.day}/${dt.year}';
}

String _formatTime(DateTime dt) {
final hour = dt.hour;
final minute = dt.minute.toString().padLeft(2, '0');
final period = hour >= 12 ? 'PM' : 'AM';
final displayHour = hour % 12 == 0 ? 12 : hour % 12;
return '$displayHour:$minute $period';
}
}

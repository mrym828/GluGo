import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static BuildContext? get context => navigatorKey.currentContext;
  
  static void navigateToHome() {
    HapticFeedback.lightImpact();
    navigatorKey.currentState?.pushReplacementNamed('/home');
  }
  
  static void navigateToGlucose() {
    HapticFeedback.lightImpact();
    navigatorKey.currentState?.pushReplacementNamed('/glucose');
  }
  
  static void navigateToScan() {
    HapticFeedback.lightImpact();
    navigatorKey.currentState?.pushReplacementNamed('/scan');
  }
  
  static void navigateToInsights() {
    HapticFeedback.lightImpact();
    navigatorKey.currentState?.pushReplacementNamed('/insights');
  }
  
  static void navigateToProfile() {
    HapticFeedback.lightImpact();
    navigatorKey.currentState?.pushReplacementNamed('/profile');
  }
  
  static void showSnackBar(String message, {bool isError = false}) {
    if (context != null) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : const Color(0xFF2563EB),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}

// Navigation state management
class NavigationState extends ChangeNotifier {
  int _currentIndex = 0;
  
  int get currentIndex => _currentIndex;
  
  void setIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
      
      // Navigate based on index
      switch (index) {
        case 0:
          NavigationService.navigateToHome();
          break;
        case 1:
          NavigationService.navigateToGlucose();
          break;
        case 2:
          NavigationService.navigateToScan();
          break;
        case 3:
          NavigationService.navigateToInsights();
          break;
        case 4:
          NavigationService.navigateToProfile();
          break;
      }
    }
  }
}

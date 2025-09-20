import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/sign_up.dart';
import 'screens/profile_setup.dart';
import 'screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const GlugoApp());
}

class GlugoApp extends StatelessWidget {
  const GlugoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glugo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/profile': (context) => const ProfileSetupScreen(),
        '/profileSetUp': (context) => const ProfileSetScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}


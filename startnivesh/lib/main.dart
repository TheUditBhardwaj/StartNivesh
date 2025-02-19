import 'package:flutter/material.dart';
import 'Screen/auth/role_selection_screen.dart';
import 'Screen/auth/splash_screen.dart';
import 'Screen/auth/login_screen.dart';
import 'Screen/auth/signup_screen.dart';
import 'Screen/auth/startup_profile_setup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StartNivesh',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/selectRole': (context) => const RoleSelectionScreen(),
        '/startup-profile-setup': (context) => const StartupProfileSetupScreen(),
        // '/investor-profile-setup': (context) => const InvestorProfileSetupScreen(),
        // '/mentor-profile-setup': (context) => const MentorProfileSetupScreen(),
      },
    );
  }
}
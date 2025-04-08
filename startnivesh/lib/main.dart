import 'package:flutter/material.dart';
import 'Screen/auth/role_selection_screen.dart';
import 'Screen/auth/splash_screen.dart';
import 'Screen/auth/login_screen.dart';
import 'Screen/auth/signup_screen.dart';
import 'Screen/auth/startup_profile_setup_screen.dart';
import 'Screen/startup/application_form_screen.dart';
import 'Screen/startup/file_upload_screen.dart';
import 'Screen/auth/Complete_setup.dart';
import 'Screen/auth/investor_profile_setup_screen.dart';
import 'Screen/home.dart';
import 'Screen/auth/mentor_profile_setup_screen.dart';
import 'Screen/Investor_bar.dart';
import 'Screen/home_investor.dart';
import 'Screen/IComplete_setup.dart';

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
        '/startup-profile-setup': (context) =>  StartupProfileSetupScreen(),
        '/applicationForm': (context) => const ApplicationFormScreen(),
        '/fileUpload': (context) => const FileUploadScreen(),
        '/completeSetup': (context) =>  CompleteSetupScreen(),
        '/investor-profile-setup': (context) => const InvestorProfileScreen(),
        '/mentor-profile-setup': (context) => const MentorProfileScreen(),
        '/home': (context) =>  HomeScreen(),
        '/investor_screen': (context) => const InvestorsScreen(),
        '/home_investor': (context) =>  IHomeScreen(),
        '/IncompleteSetup': (context) =>  ICompleteSetupScreen(),
      },
    );
  }
}
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
import 'Screen/angelInvestor.dart';
import 'Screen/venture.dart';
import 'Screen/corprate.dart';
import 'Screen/internation.dart';
import 'package:startnivesh/Screen/mentor_home.dart';
import 'Screen/Mcomplete.dart';
import 'Screen/news.dart';
import 'Screen/homeContent.dart';
import 'Screen/corprate.dart';
import 'Screen/chatbot.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {  // Added async keyword here
  WidgetsFlutterBinding.ensureInitialized();  // Add this line to ensure Flutter is initialized
  await dotenv.load(fileName: ".env");
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
        '/angel-investors': (context) => const AngelInvestorsScreen(userId: "founder-uid-123"),
        '/corporate-investors': (context) => const CorporateeInvestorsScreen(userId: "founder-uid-123"),
        '/venture-capital': (context) => const VentureCapitalScreen(userId: "founder-uid-123"),
        '/international-investors': (context) => const InternationallInvestorsScreen(userId: "founder-uid-123"),
        '/mentor-home': (context) => const MHomeScreen(),
        '/mentor-complete-setup': (context) =>  MCompleteSetupScreen(),
        '/news': (context) => const NewsWidget(),
        '/homeContent': (context) => const HomeContentt(),
        '/chatbot': (context) => const ChatBotScreen(),
      },
    );
  }
}
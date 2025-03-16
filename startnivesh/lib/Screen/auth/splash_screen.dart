import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:startnivesh/main.dart';
import 'package:startnivesh/Screen/auth/login_screen.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();

    // Navigate to login screen after 3.5 seconds
    Timer(const Duration(milliseconds: 3500), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.easeInOut;
            var curveTween = CurveTween(curve: curve);
            var fadeTween = Tween(begin: 0.0, end: 1.0);
            var fadeAnimation = animation.drive(curveTween).drive(fadeTween);
            return FadeTransition(opacity: fadeAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.deepPurple.shade900,
              Colors.deepPurple.shade700,
            ],
            stops: const [0.1, 0.6, 0.9],
          ),
        ),
        child: Stack(
          children: [
            // Background effects - optional, remove if affecting logo visibility
            Positioned.fill(
              child: Opacity(
                opacity: 0.1, // Reduced opacity
                child: Image.asset(
                  "assets/images/pattern.png", // Optional, can be removed
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Animated circles in the background (simulating particles) - reduced intensity
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              right: 30,
              child: _buildShiningCircle(18, Colors.purple.shade300.withOpacity(0.5), 3000),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: 40,
              child: _buildShiningCircle(12, Colors.deepPurpleAccent.withOpacity(0.5), 4000),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.2,
              right: 60,
              child: _buildShiningCircle(15, Colors.purpleAccent.withOpacity(0.5), 3500),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              left: 50,
              child: _buildShiningCircle(10, Colors.purple.shade200.withOpacity(0.5), 2500),
            ),

            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // App Logo with improved visibility
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurpleAccent.withOpacity(0.5),
                                  blurRadius: 25,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipOval(
                                child: Image(
                                  image: const AssetImage("assets/images/appLogo.png"),
                                  fit: BoxFit.contain, // Changed to contain for better visibility
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Animated Text with improved styling
                          Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Start",
                                    style: GoogleFonts.poppins(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 5,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Nivesh",
                                    style: GoogleFonts.poppins(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurpleAccent.shade100,
                                      letterSpacing: 1.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 5,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Subtitle with improved styling
                          Transform.translate(
                            offset: Offset(0, _slideAnimation.value * 1.2),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "Connecting Startups with Investors",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Loading indicator
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.deepPurpleAccent.shade100,
                              ),
                              strokeWidth: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Version text at the bottom
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "v1.0.0",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create animated shining circles
  Widget _buildShiningCircle(double size, Color color, int duration) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: Duration(milliseconds: duration),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value * 0.5, // Reduced opacity
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4), // Reduced shadow intensity
                  blurRadius: 10 * value,
                  spreadRadius: 2 * value,
                ),
              ],
            ),
          ),
        );
      },
      onEnd: () => setState(() {}), // Restart the animation
    );
  }
}
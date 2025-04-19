import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:startnivesh/main.dart';

class MCompleteSetupScreen extends StatefulWidget {
  @override
  _MCompleteSetupScreenState createState() => _MCompleteSetupScreenState();
}

class _MCompleteSetupScreenState extends State<MCompleteSetupScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3,milliseconds: 10), () {
      Navigator.pushReplacementNamed(context,'/mentor-home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/success.json', width: 350, height: 350),
            const SizedBox(height: 10),
            const Text("Completed!", style: TextStyle(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 10),
            const Text("You're all set.", style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
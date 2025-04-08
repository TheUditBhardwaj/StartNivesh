import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:startnivesh/main.dart';

class ICompleteSetupScreen extends StatefulWidget {
  @override
  _ICompleteSetupScreenState createState() => _ICompleteSetupScreenState();
}

class _ICompleteSetupScreenState extends State<ICompleteSetupScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3,milliseconds: 10), () {
      Navigator.pushReplacementNamed(context,'/home_investor');
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
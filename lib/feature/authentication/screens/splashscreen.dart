import 'package:bigwelt/feature/authentication/screens/authScreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  /// navigate login screen
  navigateLoginScreen(){
    Future.delayed(const Duration(seconds: 1),(){
      return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthScreen(),),(route) => false,);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateLoginScreen();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
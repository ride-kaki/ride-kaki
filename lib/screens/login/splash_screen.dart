import 'package:flutter/material.dart';
import 'package:ride_kaki/screens/home/home_screen.dart';
import 'package:ride_kaki/screens/login/login_screen.dart';
import 'package:ride_kaki/supabase/snackbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _redirectCalled = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(
      // add 2 second delay for splash screen
      const Duration(seconds: 2),
    );
    if (_redirectCalled || !mounted) {
      return;
    }

    _redirectCalled = true;
    final session = supabase.auth.currentSession;
    if (session != null) {
      Navigator.of(context).pushAndRemoveUntil(
        HomeScreen.route(),
        (_) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        LoginScreen.route(),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

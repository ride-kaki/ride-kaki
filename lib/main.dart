import 'package:flutter/material.dart';
import 'package:ride_kaki/screens/home/home_screen.dart';
import 'package:ride_kaki/screens/login/account_screen.dart';
import 'package:ride_kaki/screens/login/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tjaovrapeckaepoabxpa.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRqYW92cmFwZWNrYWVwb2FieHBhIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzQ3MjA3NzQsImV4cCI6MTk5MDI5Njc3NH0.egGtBcCRLRtSO2ZCuCaCfZOwSYgbZg28XJsAXWDTWTk',
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ride Kaki',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => ResultScreen(),
      },
    );
  }
}

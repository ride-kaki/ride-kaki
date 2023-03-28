import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL', fallback: 'INVALID_KEY'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY', fallback: 'INVALID_KEY'),
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
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,

        // appbar and bottom appbar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          surfaceTintColor: Colors.white,
        ),
      ),
      home: SplashScreen(),
    );
  }
}

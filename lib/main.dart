import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// Note: FlutterFire-generated `firebase_options.dart` wasn't present.
// Initialize Firebase without explicit platform options so the platform
// default configuration (Android/iOS) is used. If you need web support,
// regenerate `firebase_options.dart` with the FlutterFire CLI and restore
// the explicit options here.

// Screens
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'auth/forgot_password_screen.dart';
import 'core/auth_gate.dart';
import 'screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file (must be created at project root)
  await dotenv.load(fileName: ".env");

  // Initialize Firebase (use default platform configuration)
  await Firebase.initializeApp();

  runApp(MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggingIn = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/forgot';

    if (user == null) {
      // If the user is not logged in, allow access only to auth-related routes.
      // Redirect to /login if they try to access anything else.
      return isLoggingIn ? null : '/login';
    }

    // If the user is logged in and tries to access an auth-related route,
    // redirect them to the dashboard.
    if (isLoggingIn) {
      return '/dashboard';
    }

    // No redirection needed
    return null;
  },
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Agricultural Alert System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
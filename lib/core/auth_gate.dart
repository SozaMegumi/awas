// lib/core/auth_gate.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading indicator while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (user == null) {
            // Not logged in → redirect to /login
            if (GoRouter.of(context).location != '/login') {
              GoRouter.of(context).go('/login');
            }
          } else {
            // Logged in → redirect to /dashboard
            if (GoRouter.of(context).location != '/dashboard') {
              GoRouter.of(context).go('/dashboard');
            }
          }
        });

        // Temporary placeholder while redirecting
        return const SizedBox.shrink();
      },
    );
  }
}

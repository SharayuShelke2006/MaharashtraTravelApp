import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/welcome_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/auth_gate.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/admin/upload_places.dart';
import '../../screens/place/place_detail_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
    ),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
  GoRoute(
  path: "/place",
  builder: (context, state) {
    final data = state.extra as Map<String, dynamic>;

    return PlaceDetailScreen(
      data: data,
    );
  },
),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(path: "/home", builder: (context, state) => const HomeScreen()),
     GoRoute(
        path: "/forgot-password",
        builder: (context, state) =>
            const ForgotPasswordScreen(),
      ),
      GoRoute(
  path: "/upload",
  builder: (context, state) => const UploadPlacesScreen(),
),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
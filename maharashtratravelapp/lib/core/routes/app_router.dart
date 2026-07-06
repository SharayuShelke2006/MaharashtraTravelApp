import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/welcome_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/auth_gate.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/admin/upload_places.dart';
import '../../screens/place/place_detail_screen.dart';
import '../../screens/explore/explore_screen.dart';
import '../../screens/hidden_gems/hidden_gem_screen.dart';
import '../../screens/hidden_gems/hidden_gem_detail_screen.dart';
import '../../screens/hidden_gems/hidden_gem_form_screen.dart';
import '../../screens/blogs/show_blog_screen.dart';
import '../../screens/blogs/create_blog_screen.dart';
import '../../screens/profile/saved_place_screen.dart';
import '../../screens/profile/liked_blog_screen.dart';
import '../../screens/profile/drafts_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
   
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
    ),
    GoRoute(
      path: '/hidden-gems',
      builder: (context, state) => const HiddenGemScreen(),
    ),
    GoRoute(
      path:'/explore',
      builder: (context, state) => const ExploreScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/drafts',
      builder: (context, state) => const DraftsScreen(),
    ),
    GoRoute(
      path: '/blog-create',
      builder: (context, state) => const CreateBlogScreen(),
    ),
    GoRoute(
      path:'/liked-blogs',
      builder: (context, state) => const LikedBlogsScreen(),
    ),
    GoRoute(
      path: '/saved-places',
      builder: (context, state) => const SavedPlacesScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/hidden-gem-form',
      builder: (context, state) => const HiddenGemFormScreen(), 
    ),
    GoRoute(
      path:'/blogs',
      builder: (context, state) =>  BlogScreen(),
    ),
    GoRoute(
      path: '/create-blog',
      builder: (context, state) => const CreateBlogScreen(),
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
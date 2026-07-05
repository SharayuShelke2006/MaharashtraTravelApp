import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // FIX: Path assets me change kiya tha isliye yahan update kiya
  await dotenv.load(fileName: "assets/.env");
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MaharashtraTravelApp(),
    ),
  );
}

class MaharashtraTravelApp extends StatelessWidget {
  const MaharashtraTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Vatruhi",
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,

      // 🔽 FIX: Flutter Quill ke liye Localizations Delegates add kiye
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate, // <-- Main fix for quill toolbar
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
    );
  }
}
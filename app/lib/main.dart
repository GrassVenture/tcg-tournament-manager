import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await FirebaseService.initializeFirebase();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    // Firebase接続に失敗してもアプリは起動する（オフラインモード）
  }
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'TCG Tournament Manager',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

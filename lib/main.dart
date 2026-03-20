import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'screens/home_screen.dart';
import 'services/checklist_service.dart';
import 'theme/app_theme.dart';
import 'managers/app_open_ad_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await MobileAds.instance.initialize();
  
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPrefs),
    ],
    child: const MotoApp(),
  ));
}

class MotoApp extends StatefulWidget {
  const MotoApp({super.key});

  @override
  State<MotoApp> createState() => _MotoAppState();
}

class _MotoAppState extends State<MotoApp> with WidgetsBindingObserver {
  late AppOpenAdManager _appOpenAdManager;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _appOpenAdManager = AppOpenAdManager()..loadAd();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _appOpenAdManager.showAdIfAvailable();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _appOpenAdManager.showAdIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}

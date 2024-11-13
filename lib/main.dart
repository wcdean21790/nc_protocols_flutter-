import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:n_c_protocols/pages/home_page/home_page_widget.dart';
import 'package:n_c_protocols/provider/revenuecat.dart';
import 'package:n_c_protocols/service/ad_mob_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'api/purchase_api.dart';
import 'globals.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase import
// Import other Firebase services if needed
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Request tracking authorization
  final status = await AppTrackingTransparency.requestTrackingAuthorization();

  // Initialize Mobile Ads SDK
  await MobileAds.instance.initialize();

  // Initialize other services
  await PurchaseApi.init();
  await GlobalVariables.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<RevenueCatProvider>(
          create: (_) => RevenueCatProvider(),
        ),
        // Add other providers if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  late Directory appDocumentsDirectory;
  InterstitialAd? _interstitialAd;
  BannerAd? _banner;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await initializeAppDocumentsDirectory();
    await PurchaseApi.init();
    _createBannerAd();
    _createInterstitialAd();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstTimeOpen();
      _checkSubscriptionStatus();
    });
  }

  Future<void> _checkSubscriptionStatus() async {
    await PurchaseApi.refreshPurchaseInfo();
  }

  Future<void> initializeAppDocumentsDirectory() async {
    appDocumentsDirectory = await getApplicationDocumentsDirectory();
  }

  void setLocale(String language) {
    setState(() => _locale = Locale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() => _themeMode = mode);

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  Future<void> _checkFirstTimeOpen() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTimeOpen = prefs.getBool('First_Time_Open') ?? true;

    if (isFirstTimeOpen) {
      _showFirstTimeDialog();
      await prefs.setBool('First_Time_Open', false);
    }
  }

  void _showFirstTimeDialog() {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xFF242935),
            title: Text('Welcome!', style: TextStyle(color: Colors.white)),
            content: Text(
              'Thank you for installing NC Protocols. This app is designed to provide you with the best experience.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NC Protocols',
      navigatorKey: _navigatorKey,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: _themeMode,
      home: HomePageWidget(),
      builder: EasyLoading.init(),
    );
  }
}

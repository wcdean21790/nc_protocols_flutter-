import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:n_c_protocols/pages/home_page/home_page_widget.dart';
import 'package:n_c_protocols/provider/revenuecat.dart';
import 'package:n_c_protocols/service/ad_mob_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'api/purchase_api.dart';
import 'globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await PurchaseApi.init();
  usePathUrlStrategy();
  await GlobalVariables.initialize();

  EasyLoading.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme

  late Directory appDocumentsDirectory;
  InterstitialAd? _interstitialAd;
  BannerAd? _banner;

  // Add a GlobalKey to manage the context safely
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    _createInterstitialAd();
    initializeAppDocumentsDirectory();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstTimeOpen(); // Ensure that this is called after everything is ready
    });
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
    print("USERs FIRST TIME!");
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTimeOpen = prefs.getBool('First_Time_Open') ?? true;
    print('Users first time: $isFirstTimeOpen');
    if (isFirstTimeOpen) {
      // Show alert dialog if it's the first time opening the app
      _showFirstTimeDialog();

      // Set 'First_Time_Open' to false so this doesn't happen again
      await prefs.setBool('First_Time_Open', true);
    }
  }

  void _showFirstTimeDialog() {
    // Use the navigatorKey to access the correct context
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xFF242935), // Set background color
            title: Text(
              'Welcome!',
              style: TextStyle(color: Colors.white), // Change text color for visibility
            ),
            content: Text(
              'Thank you for installing NC Protocols. Viewing the protocols in this app is a free resource for all users, however, the extra tools provided require payment as this supports further development of the app.\n'
                  'Please email ncprotocols@gmail.com with any questions, comments, or concerns.',
              style: TextStyle(color: Colors.white), // Change content text color for visibility
            ),
            contentPadding: EdgeInsets.all(16.0),
            actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
            actions: [
              Center( // Wrap the button in a Center widget
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white), // Set button text color
                  ),
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
    return Container(
      child: MaterialApp(
        title: 'NC Protocols',
        navigatorKey: _navigatorKey, // Attach the navigator key here
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: _locale,
        supportedLocales: const [Locale('en', '')],
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: _themeMode,
        home: HomePageWidget(), // Set your home page widget here
        builder: EasyLoading.init(),
      ),
    );
  }

}





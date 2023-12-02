import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:n_c_protocols/provider/revenuecat.dart';
import 'package:n_c_protocols/service/ad_mob_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'api/purchase_api.dart';
import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'flutter_flow/nav/nav.dart';
import 'globals.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await PurchaseApi.init();
  usePathUrlStrategy();
  await GlobalVariables.initialize();
  await initFirebase();
  EasyLoading.init();
  await FlutterFlowTheme.initialize();

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

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late Directory appDocumentsDirectory;

  InterstitialAd? _interstitialAd;
  BannerAd? _banner;


  @override
  void initState() {
    print("Ad Status: ${GlobalVariables.globalPurchaseAds}");
    _createBannerAd();
    _createInterstitialAd();
    super.initState();
    initializeAppDocumentsDirectory(); // Call this method to initialize appDocumentsDirectory
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
  }

  Future<void> initializeAppDocumentsDirectory() async {
    appDocumentsDirectory = await getApplicationDocumentsDirectory();
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });


  @override
  Widget build(BuildContext context) {
    final Gradient backgroundGradient = LinearGradient(
      colors: [Colors.blue, Colors.black],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: backgroundGradient,
      ),
      child: MaterialApp.router(
        title: 'NC Protocols',
        localizationsDelegates: [
          FFLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: _locale,
        supportedLocales: const [Locale('en', '')],
        theme: ThemeData(
          brightness: Brightness.light,
          scrollbarTheme: ScrollbarThemeData(),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scrollbarTheme: ScrollbarThemeData(),
        ),
        themeMode: _themeMode,
        routerConfig: _router,
        builder: EasyLoading.init(), // Initialize EasyLoading
      ),
    );
  }


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
  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }




}

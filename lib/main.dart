import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    _createInterstitialAd();
    initializeAppDocumentsDirectory();
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


  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp.router(
        title: 'NC Protocols',
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
        routerDelegate: _DummyRouterDelegate(),
        routeInformationParser: _DummyRouteInformationParser(),
        builder: EasyLoading.init(),
      ),

    );
  }


}

class _DummyRouterDelegate extends RouterDelegate<Object> with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(child: HomePageWidget()), // Use your actual home page widget here
      ],
      onPopPage: (route, result) => false,
    );
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();
}

class _DummyRouteInformationParser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(RouteInformation routeInformation) async {
    return Object();
  }
}



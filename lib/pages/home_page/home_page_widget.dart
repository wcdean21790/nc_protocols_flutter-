import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:n_c_protocols/index.dart';
import 'package:n_c_protocols/pages/category_listview.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import '../../globals.dart';
import '../More_Category.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'home_page_model.dart';
import 'navigationbar.dart'; // Import the path_provider library
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  BannerAd? _bannerAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-9944401739416572/9028378015'
      : 'ca-app-pub-9944401739416572/9028378015';
  late HomePageModel _model;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  String agencyName = GlobalVariables.globalAgencyName;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF242935), // Set the background color of Scaffold to transparent
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: Color(0xFF242935),
            centerTitle: true,
            title: Text(
              '${GlobalVariables.globalAgencyName} Protocols',
              style: GoogleFonts.poppins().override(
                fontFamily: 'Work Sans',
                color: Color(0xFFFFFFFF),
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: IconButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => MajorListViewWidget(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const beginOpacity = 0.0;
                          const endOpacity = 1.0;
                          var opacityTween = Tween<double>(begin: beginOpacity, end: endOpacity);
                          var fadeAnimation = animation.drive(opacityTween);
                          return FadeTransition(
                            opacity: fadeAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  icon: ClipOval(
                    child: Image.asset(
                      'assets/images/settingsicon.png',
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF242935),
                ),
              ),
              SafeArea(
                top: true,
                child: Align(
                  alignment: AlignmentDirectional(0.00, 0.00),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(25.0, 25.0, 25.0, 25.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          CategoryListViewWidget(agencyName: GlobalVariables.globalAgencyName),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const beginOpacity = 0.0;
                                        const endOpacity = 1.0;
                                        var opacityTween = Tween<double>(begin: beginOpacity, end: endOpacity);
                                        var fadeAnimation = animation.drive(opacityTween);
                                        return FadeTransition(
                                          opacity: fadeAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                text: 'Protocols',
                                options: FFButtonOptions(
                                  alignment: Alignment.center,
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: Colors.transparent,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                    fontFamily: 'Readex Pro',
                                    color: Color(0xFF10DCFF),
                                  ),
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(25.0, 25.0, 25.0, 50.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          MoreListViewWidget(agencyName: GlobalVariables.globalAgencyName),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const beginOpacity = 0.0;
                                        const endOpacity = 1.0;
                                        var opacityTween = Tween<double>(begin: beginOpacity, end: endOpacity);
                                        var fadeAnimation = animation.drive(opacityTween);
                                        return FadeTransition(
                                          opacity: fadeAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                text: 'More',
                                options: FFButtonOptions(
                                  alignment: Alignment.center,
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: Color(0x00F1F4F8),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                    fontFamily: 'Readex Pro',
                                    color: Color(0xFF6CDCFF),
                                  ),
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image(
                                image: NetworkImage(GlobalVariables.globalAgencyLogo),
                                width: 350.0,
                                height: 400.0,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Display the local asset image if there is an error loading the network image
                                  return Image.asset(
                                    'assets/icon/statelogo.jpg',
                                    width: 350.0,
                                    height: 400.0,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),

                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        // Add any additional widgets here as needed
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalVariables.initialize(); // Initialize global variables from SharedPreferences

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      home: HomePageWidget(), // Your app's home page
    );
  }
}

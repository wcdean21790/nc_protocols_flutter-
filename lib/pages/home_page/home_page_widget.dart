import 'package:flutter/foundation.dart';
import 'package:n_c_protocols/index.dart';
import 'package:n_c_protocols/pages/category_listview.dart';
import 'package:n_c_protocols/pages/protocol_listview.dart';
import '../../globals.dart';
import '../info.dart';
import '../tools.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';
import 'dart:io'; // Import the dart:io library
import 'package:path_provider/path_provider.dart';

import 'navigationbar.dart'; // Import the path_provider library

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
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
        backgroundColor: Colors.black,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.00, 0.00),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(1.00, 0.00),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 15.0),
                              child: Text(
                                '${GlobalVariables.globalAgencyName} Protocols',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                          child: FFButtonWidget(
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
                            text: '\n',
                            icon: Image.asset(
                              'assets/images/settingsicon.png',
                              width: 40.0,
                              height: 40.0,
                            ),
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsets.zero, // Set padding to zero to eliminate extra padding
                              iconPadding: EdgeInsets.all(5.0), // Add icon padding if needed
                              color: Colors.black,
                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0.0,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),

                        ),
                      ],
                    ),
                  ),
                ),
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
                                pageBuilder: (context, animation, secondaryAnimation) => CategoryListViewWidget(
                                  agencyName: GlobalVariables.globalAgencyName,
                                ),

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
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            color: Color(0x00F1F4F8),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                              fontFamily: 'Readex Pro',
                              color: Color(0xFF54D9E6),
                            ),
                            elevation: 3.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(25.0, 25.0, 25.0, 25.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            print('Button pressed ...');
                          },
                          text: 'More',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            color: Color(0x00F1F4F8),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                              fontFamily: 'Readex Pro',
                              color: Color(0xFFD7B47A),
                            ),
                            elevation: 3.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          GlobalVariables.globalAgencyLogo,
                          width: 350.0,
                          height: 375.0,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.00, 0.00),

                ),
              ],
            ),
          ),
        ),
          bottomNavigationBar: BottomBar()
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

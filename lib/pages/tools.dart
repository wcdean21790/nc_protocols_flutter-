import 'package:flutter/material.dart';
import 'package:n_c_protocols/globals.dart';
import 'package:n_c_protocols/pages/protocol_listview.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'home_page/home_page_widget.dart';
import 'info.dart';

class ToolsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tools',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Column( // Wrap your existing content in a Column
          children: [
            Expanded(
              child: Center(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Implement the action for the first button.
                          },
                          child: Text('Button 1'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Implement the action for the second button.
                          },
                          child: Text('Button 2'),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Implement the action for the third button.
                          },
                          child: Text('Button 3'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Implement the action for the fourth button.
                          },
                          child: Text('Button 4'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Color(0x00F1F4F8),
                  ),
                  child: FFButtonWidget(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePageWidget()),
                      );
                    },

                    text: '',
                    icon: Image.asset(
                      'assets/images/homeicon.png',
                      width: 35.0,
                      height: 35.0, // Adjust the width and height as needed
                    ),
                    options: FFButtonOptions(
                      height: 40.0,
                      padding: EdgeInsetsDirectional.fromSTEB(
                          24.0, 0.0, 24.0, 0.0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: Color(0x00F1F4F8),
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
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
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Color(0x00F1F4F8),
                  ),
                  child: FFButtonWidget(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProtocolListViewWidget(agencyName: GlobalVariables.globalAgencyName)),
                      );
                    },
                    text: '',
                    icon: Image.asset(
                      'assets/images/protocolicon.png',
                      width: 40.0,
                      height: 40.0, // Adjust the width and height as needed
                    ),
                    options: FFButtonOptions(
                      height: 40.0,
                      padding: EdgeInsetsDirectional.fromSTEB(
                          24.0, 0.0, 24.0, 0.0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: Color(0x00F1F4F8),
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
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
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Color(0x00F1F4F8),
                  ),
                  child: FFButtonWidget(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ToolsWidget(), // Use ToolsWidget as the destination widget
                        ),
                      );
                    },

                    text: '',
                    icon: Image.asset(
                      'assets/images/toolboxicon.png',
                      width: 30.0,
                      height: 30.0, // Adjust the width and height as needed
                    ),
                    options: FFButtonOptions(
                      height: 40.0,
                      padding: EdgeInsetsDirectional.fromSTEB(
                          24.0, 0.0, 24.0, 0.0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: Color(0x00F1F4F8),
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
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
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Color(0x00F1F4F8),
                  ),
                  child: FFButtonWidget(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Info(), // Replace with the name of your Info widget
                        ),
                      );
                    },

                    text: '',
                    icon: Image.asset(
                      'assets/images/infoicon.png',
                      width: 35.0,
                      height: 35.0, // Adjust the width and height as needed
                    ),
                    options: FFButtonOptions(
                      height: 40.0,
                      padding: EdgeInsetsDirectional.fromSTEB(
                          24.0, 0.0, 24.0, 0.0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: Color(0x00F1F4F8),
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

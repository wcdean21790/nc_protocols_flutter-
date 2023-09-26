import 'package:flutter/material.dart';
import 'package:n_c_protocols/globals.dart';
import 'package:n_c_protocols/pages/home_page/navigationbar.dart';
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
        child: Column(
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
            // Custom Navigation Row
            BottomBar()
          ],
        ),
      ),
    );
  }

}

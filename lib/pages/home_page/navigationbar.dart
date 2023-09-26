import 'package:flutter/material.dart';

import '../../globals.dart';
import '../info.dart';
import '../protocol_listview.dart';
import '../tools.dart';
import 'home_page_widget.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: Colors.black, // Set the background color of the bottom app bar to black
        child: Container(
      width: double.infinity,
      height: 100.0,
      decoration: BoxDecoration(
        color: Color(0x00F1F4F8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BottomBarButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePageWidget()),
              );
            },
            iconPath: 'assets/images/homeicon.png',
          ),
          BottomBarButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProtocolListViewWidget(agencyName: GlobalVariables.globalAgencyName),
                ),
              );
            },
            iconPath: 'assets/images/protocolicon.png',
          ),
          BottomBarButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ToolsWidget(),
                ),
              );
            },
            iconPath: 'assets/images/toolboxicon.png',
          ),
          BottomBarButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Info(),
                ),
              );
            },
            iconPath: 'assets/images/infoicon.png',
          ),
        ],
      ),
    ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String iconPath;

  const BottomBarButton({
    Key? key,
    required this.onPressed,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: Color(0x00F1F4F8),
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            width: 35.0,
            height: 35.0,
          ),
        ),
      ),
    );
  }
}

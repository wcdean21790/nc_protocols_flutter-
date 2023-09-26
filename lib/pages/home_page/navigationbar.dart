import 'package:flutter/material.dart';

import '../../globals.dart';
import '../info.dart';
import '../protocol_listview.dart';
import '../tools.dart';
import 'home_page_widget.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iconSize = 50.0; // Set the desired width and height for the icons

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
            CustomBottomButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageWidget()),
                );
              },
              iconPath: 'assets/images/homeicon.png',
              iconSize: iconSize,
            ),
            CustomBottomButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProtocolListViewWidget(agencyName: GlobalVariables.globalAgencyName),
                  ),
                );
              },
              iconPath: 'assets/images/protocolicon.png',
              iconSize: iconSize,
            ),
            CustomBottomButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToolsWidget(),
                  ),
                );
              },
              iconPath: 'assets/images/toolboxicon.png',
              iconSize: iconSize,
            ),
            CustomBottomButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Info(),
                  ),
                );
              },
              iconPath: 'assets/images/infoicon.png',
              iconSize: iconSize,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBottomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String iconPath;
  final double iconSize;

  CustomBottomButton({
    required this.onPressed,
    required this.iconPath,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Image.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
          ),
          // You can add labels or text here if needed
        ],
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

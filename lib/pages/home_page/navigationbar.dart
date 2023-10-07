import 'package:flutter/material.dart';
import 'package:n_c_protocols/pages/category_listview.dart';
import '../../globals.dart';
import '../favorites.dart';
import '../info.dart';
import 'home_page_widget.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iconSize = 40.0; // Set the desired width and height for the icons

    return Container(
      width: double.infinity,
      height: 50.0,
      color: Colors.grey,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomBottomButton(
            onPressed: () async {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => HomePageWidget(),
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
            iconPath: 'assets/images/homeicon.png',
            iconSize: iconSize,
          ),
          CustomBottomButton(
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
            iconPath: 'assets/images/protocolsicon.png',
            iconSize: iconSize,
          ),
          CustomBottomButton(
            onPressed: () async {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FavoriteProtocols(globalFavorites: []),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const beginOpacity = 0.0;
                    const endOpacity = 1.0;
                    var opacityTween = Tween<double>(
                        begin: beginOpacity, end: endOpacity);
                    var fadeAnimation = animation.drive(opacityTween);
                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            iconPath: 'assets/images/favicon.png',
            iconSize: iconSize,
          ),
          CustomBottomButton(
            onPressed: () async {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => Info(),
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
            iconPath: 'assets/images/infoicon.png',
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }
}

class CustomBottomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String iconPath;
  final double iconSize;

  CustomBottomButton({
    required this.onPressed,
    required this.iconPath,
    required this.iconSize,
  });

  @override
  _CustomBottomButtonState createState() => _CustomBottomButtonState();
}

class _CustomBottomButtonState extends State<CustomBottomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isPressed = !_isPressed;
        });
        widget.onPressed();
      },
      style: ElevatedButton.styleFrom(
        primary: _isPressed ? Colors.grey : Colors.transparent,
        elevation: 0, // Remove the button elevation
      ),
      child: Image.asset(
        widget.iconPath,
        width: widget.iconSize,
        height: widget.iconSize,
      ),
    );
  }
}

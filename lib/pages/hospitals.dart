import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import '../flutter_flow/flutter_flow_widgets.dart';
import '../globals.dart';
import '../service/ad_mob_service.dart';
import 'home_page/navigationbar.dart';

class Hospitals extends StatefulWidget {
  @override
  _HospitalsState createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {
  BannerAd? _banner;
  // Define a list of hospitals with their names and coordinates
  List<Hospital> hospitals = [
    Hospital(name: "Cone Health - Alamance Regional Medical Center", latitude: 36.06129754540937, longitude: -79.50215638771189),
    Hospital(name: "Cone Health Moses Cone", latitude: 36.09123683635794, longitude: -79.78616303379232),
    Hospital(name: "UNC Hospital", latitude: 35.90392278050185, longitude: -79.04941949150852),
    Hospital(name: "Duke University Hospital", latitude: 36.00925462128271, longitude: -78.93696168569467),
    Hospital(name: "UNC Hillsborough ER", latitude: 36.03696325204471, longitude: -79.09099812558286),
    Hospital(name: "Wesley Long Hospital", latitude: 36.08372606680398, longitude: -79.82668127440466),
    Hospital(name: "Cone Health Women’s & Children’s Center", latitude: 36.091306265390514, longitude: -79.78622738974549),
    Hospital(name: "Chatham Hospital", latitude: 35.723240436678076, longitude: -79.42073430377586),
    Hospital(name: "Duke Regional Hospital", latitude: 36.036401971145594, longitude: -78.90097867440635),
    Hospital(name: "Wake Forest Baptist Medical Center", latitude: 36.08993682939037, longitude: -80.27123644372246),
    Hospital(name: "Iredell Hospital", latitude: 35.799904, longitude: -80.878134),
    Hospital(name: "Catawba Hospital", latitude: 37.39161413558794, longitude: -80.11102167744363),
    Hospital(name: "Frye Regional Hospital", latitude: 35.7376768435094, longitude: -81.33706221797276),
    Hospital(name: "Caldwell Memorial Hospital", latitude: 35.910716348002154, longitude: -81.53542496689955),
    Hospital(name: "Wilkes Regional Hospital", latitude: 36.15929354960109, longitude: -81.1583428296019),
    Hospital(name: "Novant Health Clemmons Medical Center", latitude: 36.028526, longitude: -80.397784),
    Hospital(name: "Novant Health Kernersville Medical Center", latitude: 36.091465, longitude: -80.043946),
    Hospital(name: "Novant Health Forsyth Medical Center", latitude: 36.076771, longitude: -80.296311),
    Hospital(name: "Wake Forest Davie Medical Center", latitude: 36.009647, longitude: -80.447787),
    Hospital(name: "Atrium Cabarius Hospital", latitude: 35.43664363655893, longitude: -80.60198446336052),
    Hospital(name: "Atrium Charlotte Hospital", latitude: 35.203945135859456, longitude: -80.83932669381709),
    Hospital(name: "Catawaba Center", latitude: 35.71433, longitude: -81.26721),
    Hospital(name: "Atrium CMC Hunterville Hospital", latitude: 35.43941, longitude: -80.86677),
    Hospital(name: "Atrium CMC Mercy Hospital", latitude: 35.21019, longitude: -80.82091),
    Hospital(name: "Davis Regional Hospital", latitude: 35.81884, longitude: -80.82916),
    Hospital(name: "Hugh Catham Hospital", latitude: 36.26203, longitude: -80.83850),
    Hospital(name: "Iredell Memorial Hospital", latitude: 35.79993401941696, longitude: -80.87814737378224),
    Hospital(name: "Lake Norman Regional Hospital", latitude: 35.54944, longitude: -80.85415),
    Hospital(name: "Novant Huntersville Hospital", latitude: 35.40630, longitude: -80.86060),
    Hospital(name: "Rowan Regional Hospital", latitude: 35.68131243508168, longitude: -80.47138289044727)
  ];

  void initState() {
    super.initState();
    _createBannerAd();

  }


  Widget buildAdContainer() {
    print("Ad Status: ${GlobalVariables.globalPurchaseAds}");
    if (GlobalVariables.globalPurchaseAds != "True") {
      return _banner == null
          ? Container()
          : Container(
        margin: const EdgeInsets.only(bottom: 15),
        height: 52,
        child: AdWidget(ad: _banner!),
      );
    } else {
      // Return an empty container or another widget if ads are disabled
      return Container();
    }
  }
  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  Future<void> launchMaps(double hospitalLat, double hospitalLong) async {
    final String mapsUrl = 'https://www.google.com/maps/search/?api=1&query=$hospitalLat,$hospitalLong';

    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      throw 'Could not launch $mapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort hospitals alphabetically by name
    hospitals.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Hospitals',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white, // Set the underline color to white
          ),

          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF242935),
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 10,
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: hospitals.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 25); // Adjust the height for space between buttons
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return buildHospitalButton(hospitals[index]);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          buildAdContainer(),
        ],
      ),

      bottomNavigationBar: BottomBar(),
      backgroundColor: Color(0xFF242935), // Set the background color to black
    );
  }


  Widget buildHospitalButton(Hospital hospital) {
    return SizedBox(
      width: 250,
      child: FFButtonWidget(
        onPressed: () {
          launchMaps(hospital.latitude, hospital.longitude);
        },
        text: hospital.name,
        options: FFButtonOptions(
          alignment: Alignment.center,
          height: 40.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          color: Color(0xFF242935),
          textStyle: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 14,
          ),
          elevation: 3.0,
          borderSide: BorderSide(
            color: Color(0xFF000000), // Black outline
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
        ),
      ),

    );
  }


}

// Define a class to represent a hospital
class Hospital {
  final String name;
  final double latitude;
  final double longitude;

  Hospital({required this.name, required this.latitude, required this.longitude});
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../components/custom_flutter_toast.dart';
import '../../constants/injector.dart';
import '../../configs/shared_prefence_manager.dart';
import '../home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final SharedPreferencesManager _sharedPreferencesManager =
  //     locator<SharedPreferencesManager>();

  String firebase_token = '';

  startTime(bool isLocationAccept) async {
    try {
      var _duration = new Duration(seconds: 2);

      return new Timer(_duration, navigationPage);
    } catch (error, stacktrace) {
      print("Splash screen startTime() ERROR!!!");
      print(error);
      print(stacktrace);
      // Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("splash screen opened");
    // if (state == AppLifecycleState.resumed) {
    //   startTime();
    // }
  }

  void navigationPage() {
    if (mounted) {
      try {
        // _sharedPreferencesManager.clearKey("lng");
        // _sharedPreferencesManager.clearKey("lat");
        // _sharedPreferencesManager.putString("lat",'11');
        // _sharedPreferencesManager.putString("lng",'6');

        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        // if (dynamic_link_type == "sparring") {
        //   Navigator.pushReplacementNamed(
        //       context, SparringDetailScreen.routeName,
        //       arguments: y);

        // } else if (dynamic_link_type == "open_play") {
        //   Navigator.pushReplacementNamed(
        //       context, OpenPlayDetailScreen.routeName,
        //       arguments: y);
        // } else if (dynamic_link_type == "news_info") {
        //   Navigator.pushReplacementNamed(
        //       context, NewsDetailScreen.routeName,
        //       arguments: y);
        // } else if (dynamic_link_type == "news_info_outer") {
        //   Navigator.pushReplacementNamed(
        //       context, NewsWebviewScreen.routeName,
        //       arguments: y);
        // } else {
        //   Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        // }
      } catch (error, stacktrace) {
        print("Splash screen ERROR!!!");
        print(error);
        print(stacktrace);

        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    }
  }

  bool isLocationAccept = false;
  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    super.initState();
    locationPermission();
  }

  Future<void> locationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Get.snackbar('', 'Location Permission Denied');
        customFlutterToast(
            context: context,
            msg: 'Location Permission Denied',
            customToastType: CustomToastType.ERROR);
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    } else {
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      } else {
        setState(() {
          isLocationAccept = true;
        });
      }
    }

    startTime(isLocationAccept);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double heightScreen = mediaQueryData.size.height;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Container(
        color: Colors.blue.shade50,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildWidgetImageTop(heightScreen),
                _buildWidgetImageBottom(heightScreen),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: heightScreen * 0.4),
              child: Center(
                  child: Column(
                children: [
                  Icon(Icons.location_searching, size: 64),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Get My Location',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetImageTop(double heightScreen) {
    return Container(
      height: heightScreen * 0.2,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/bg_vector_top.png'),
        fit: BoxFit.cover,
      )),
    );
  }

  Widget _buildWidgetImageBottom(double heightScreen) {
    return Container(
      height: heightScreen * 0.2,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/bg_vector_bottom.png'),
        fit: BoxFit.cover,
      )),
    );
  }
}

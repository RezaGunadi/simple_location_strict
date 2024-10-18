import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as locationPackage;
import 'dart:developer';
import 'package:geocoding/geocoding.dart' as geocodingPackage;
import 'package:my_location/components/skeleton.dart';

import '../components/custom_flutter_toast.dart';
import '../components/loading_dialog_widget.dart';
import '../configs/shared_prefence_manager.dart';
import '../constants/injector.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key key}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final SharedPreferencesManager _sharedPreferencesManager =
      locator<SharedPreferencesManager>();

  List<String> dummyAvatars = ['', '', ''];
  String title = '';
  String description = '';
  String btnLabel = '';
  dynamic mainRouteName;

  bool buildInit = false;
  double lat = -6.202043;
  double lng = 107.089183;

  places.GoogleMapsPlaces _places = places.GoogleMapsPlaces(
      baseUrl: "https://api-new.ayo.co.id/service/google-map-api");
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Marker marker;
  int _markerIdCounter = 0;
  Completer<GoogleMapController> _mapController = Completer();
  BitmapDescriptor pinLocationIcon;
  double myLat = -6;
  double myLng = 107;

  Future _dataUsersListFuture;
  bool isLoading = true;

  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    LatLng position = LatLng(lat, lng);

    if ([position] != null) {
      MarkerId markerId = MarkerId(_markerIdVal());
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
        icon: pinLocationIcon,
        zIndex: 20.0,
        anchor: Offset(0.5, 0.5),
      );
      setState(() {
        _markers[markerId] = marker;
      });

      Future.delayed(Duration(seconds: 1), () async {
        GoogleMapController controller = await _mapController.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 20.0,
            ),
          ),
        );
      });
    }
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  locationPackage.Location location;
  locationPackage.LocationData currentLocation;
  double distance;
  bool isDistanceValid = false;

  Set<Circle> _circles = HashSet<Circle>();

  Future<void> getPosition() async {
    _circles.add(
      Circle(
        circleId: CircleId('id_circle'),
        center: LatLng(lat, lng),
        radius: 50,
        fillColor: Colors.redAccent.withOpacity(0.4),
        strokeWidth: 3,
        strokeColor: Colors.redAccent,
      ),
    );
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
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    print('getCurrentPosition');
    print(permission);
    print('getCurrentPosition');
    // var position = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true,);
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
        timeLimit: Duration(seconds: 5));

    print('getCurrentPosition1');
    // if (position != null) {
    try {
      print('getCurrentPosition2');
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      setState(() {
        myLat = position.latitude;
        myLng = position.longitude;
      });
      // // modalSetState(() {
      // if (placemarks != null) {
      //   if (placemarks.length > 0) {
      print(placemarks[0].subAdministrativeArea);
      print('placemarks[0].subAdministrativeArea');
      userCity = placemarks[0].subAdministrativeArea;
      userAddress = placemarks[0].street;
      userProfince = placemarks[0].administrativeArea;
      //   }
      // }
      // });

      // location.onLocationChanged.listen((locationPackage.LocationData cLoc) {
      //   currentLocation = cLoc;

      distance = Geolocator.distanceBetween(lat, lng, myLat, myLng);

      print('lewat 1');
      if (distance <= 50) {
        if (!isDistanceValid)
          setState(() {
            isDistanceValid = true;
          });
      } else {
        if (isDistanceValid)
          setState(() {
            isDistanceValid = false;
            //    isDistanceValid = true;
          });
      }
      print('lewat 2');
      // isDistanceValid = true;

      // print(
      //     " ====== currentLocation${currentLocation.latitude} + ${currentLocation.longitude}");
      // print(" ====== distance$distance");

      // log(" ====== currentLocation${currentLocation.latitude} + ${currentLocation.longitude}");
      // log(" ====== distance$distance");
      // });
    } catch (err) {
      print(err);
    }
    Future.delayed(
      Duration(
        seconds: 2,
      ),
      () {
        setState(() {
          isLoading = false;
        });
      },
    );
    print('lewat 3');
    // }
  }

  String userCity = '';
  String userAddress = '';
  String userProfince = '';
  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 0.5),
            'assets/images/ayo-pin.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    location = new locationPackage.Location();
    getPosition();
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Check-in ke Pertandingan',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        backgroundColor: Colors.blue.shade400,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCardWidget(),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardWidget() {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
                color: Colors.black26,
                height: 280,
                width: double.infinity,
                child: isLoading
                    ? Skeleton(
                        height: 280,
                        width: double.infinity,
                      )
                    : GoogleMap(
                        circles: _circles,
                        markers: Set<Marker>.of(_markers.values),
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(lat, lng),
                          zoom: 1.0,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                      )),
            Container(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 8),
                  Text(
                    isDistanceValid
                        ? (distance.round().toString()) + 'meter dari lokasi'
                        : 'Lokasi kamu belum sesuai, nih',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Pastikan Kamu sudah berada di lokasi sebelum memulai absen, ya.',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  isDistanceValid
                      ? GestureDetector(
                          onTap: () async {
                            String lastAbsen = _sharedPreferencesManager
                                .getString('last_absen');
                            if (lastAbsen == null) {
                              customFlutterToast(
                                context: context,
                                msg: 'Absen hari ini berhasil',
                                customToastType: CustomToastType.SUCCESS,
                              );
                            } else {
                              if (DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()) ==
                                  lastAbsen) {
                                customFlutterToast(
                                  context: context,
                                  msg: 'Absen hari ini berhasil',
                                  customToastType: CustomToastType.INFO,
                                );
                              } else {
                                customFlutterToast(
                                  context: context,
                                  msg: 'Absen hari ini berhasil',
                                  customToastType: CustomToastType.SUCCESS,
                                );
                              }
                            }
                            _sharedPreferencesManager.putString(
                                'last_absen',
                                DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()));
                          },
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Konfirmasi',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.blue.shade400, width: 3),
                            ),
                            child: Center(
                              child: Text(
                                'Kembali',
                                style: TextStyle(
                                    color: Colors.blue.shade400, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

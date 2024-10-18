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
import '../constants/color.dart';
import '../constants/injector.dart';
import 'location_detail/location_detail_screen.dart';

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

  List<Map<String, dynamic>> listLokasi = [];
  TextEditingController name = new TextEditingController();
  TextEditingController lat = new TextEditingController();
  TextEditingController lng = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        // titleSpacing: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.keyboard_arrow_left),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        automaticallyImplyLeading: false,
        title: Text(
          'List Store',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade400,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardWidget(screenWidth, screenHeight),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildCardWidget(double screenWidth, double screenHeight) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TextFormField(
            controller: name,
            style: TextStyle(
              color: ColorBase.black100,
              fontFamily: 'Rubik',
              fontSize: ScreenUtil().scaleText * 14,
            ),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(
                color: ColorBase.black80,
                fontFamily: 'Rubik',
                fontSize: ScreenUtil().scaleText * 12,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: ColorBase.black40),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorBase.black40),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorBase.secondaryRed),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Container(
                width: (screenWidth - 64) / 2,
                child: TextFormField(
                  controller: lat,
                  style: TextStyle(
                    color: ColorBase.black100,
                    fontFamily: 'Rubik',
                    fontSize: ScreenUtil().scaleText * 14,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Lat',
                    labelStyle: TextStyle(
                      color: ColorBase.black80,
                      fontFamily: 'Rubik',
                      fontSize: ScreenUtil().scaleText * 12,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorBase.black40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorBase.black40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Container(
                width: (screenWidth - 64) / 2,
                child: TextFormField(
                  controller: lng,
                  style: TextStyle(
                    color: ColorBase.black100,
                    fontFamily: 'Rubik',
                    fontSize: ScreenUtil().scaleText * 14,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Lng',
                    labelStyle: TextStyle(
                      color: ColorBase.black80,
                      fontFamily: 'Rubik',
                      fontSize: ScreenUtil().scaleText * 12,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorBase.black40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorBase.black40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                listLokasi.add({
                  'name': name.text,
                  'lat': double.parse(lat.text),
                  'lng': double.parse(lng.text),
                });
                name.text = '';
                lat.text = '';
                lng.text = '';
              });
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.all(14),
              alignment: Alignment.center,
              child: Text(
                'Tambah Lokasi Outlet',
                style: TextStyle(color: ColorBase.primaryWhite, fontSize: 14),
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Divider(
            color: ColorBase.black60,
            endIndent: 1,
            thickness: 1,
            height: 1,
          ),
          Divider(
            color: ColorBase.black60,
            endIndent: 1,
            thickness: 1,
            height: 1,
          ),
          SizedBox(
            height: 24,
          ),
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var element in listLokasi)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, LocationDetailScreen.routeName,
                            arguments: {
                              'name': element['name'],
                              'lat': double.parse(element['lat'].toString()),
                              'lng': double.parse(element['lng'].toString()),
                            });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 3, top: 3),
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 8,
                                  color: ColorBase.black40,
                                  spreadRadius: 2)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: screenWidth - 144,
                              child: Text(
                                element['name'],
                                style: TextStyle(
                                    color: ColorBase.black100, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                                child: Icon(
                              Icons.fingerprint,
                              size: 20,
                            )),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

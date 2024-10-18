import 'package:flutter/material.dart';

import 'location_detail_content.dart';

class LocationDetailScreen extends StatefulWidget {
  static const routeName = '/location_detail';

  @override
  LocationDetailScreenState createState() => LocationDetailScreenState();
}

class LocationDetailScreenState extends State<LocationDetailScreen> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  double lat = 0;
  double lng = 0;
  String name = '';
  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    lat = args['lat'];
    lng = args['lng'];
    name = args['name'];
    return LocationDetailContent(
      lat: lat,
      lng: lng,
      name: name,
    );
  }
}

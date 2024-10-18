import 'package:flutter/material.dart';

import 'home_content.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;

    return HomeContent();
  }
}

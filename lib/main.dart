import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_location/screens/home_screen.dart';
import 'package:my_location/screens/location_detail/location_detail_screen.dart';
import 'package:my_location/screens/splash/splash_screen.dart';

import 'components/dismiss_keyboard.dart';
import 'constants/injector.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Get My Location APP',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      // primarySwatch: Colors.blue.shade50,
      ),
      home: const MyHomePage(title: 'Get My Location APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key,  this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return   ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return DismissKeyboard(
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false, 
              // supportedLocales: [const Locale('en'), const Locale('id')],
              locale: Locale('id'),
              home: SplashScreen(),
              routes: {
                HomeScreen.routeName: (ctx) => HomeScreen(),
                LocationDetailScreen.routeName: (ctx) => LocationDetailScreen(),
                
              },
            ),
          );
        });
  }
}

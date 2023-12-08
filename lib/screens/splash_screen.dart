import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_project_app/screens/login_screen.dart';
import 'package:flutter_firebase_project_app/screens/tabs_screen.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  GetStorage _getStorage = GetStorage();
  openNextPage(BuildContext context) {
    Timer(Duration(milliseconds: 2000),  (){
      if (_getStorage.read('token') == null || _getStorage.read('token') == '') {
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      }  else {
        Navigator.pushReplacementNamed(context, TabsScreen.id);
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openNextPage(context);
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

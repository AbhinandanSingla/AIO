import 'package:dbms/pages/collectedScreen.dart';
import 'package:dbms/pages/laundry.dart';
import 'package:dbms/pages/laundryScreen.dart';
import 'package:dbms/pages/loginScreen.dart';
import 'package:dbms/pages/teacher.dart';
import 'package:dbms/services/sharedpreferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SharedPref pref = SharedPref();
    pref.init();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: LoginScreen()),
    );
  }
}

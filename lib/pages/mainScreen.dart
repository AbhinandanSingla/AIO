import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'AttendanceScreen.dart';
import 'laundry.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (barcodeScanRes == '-1') {
      print('cancel');
    } else {
      print("5555555555555555555555555555555555" + barcodeScanRes);
    }
    if (!mounted) return;
    print('$barcodeScanRes +++++ step 1');
  }

  Dio dio = Dio();

  // void nfc() async {
  //   var availability = await FlutterNfcKit.nfcAvailability;
  //   late NFCTag tag;
  //   if (availability != NFCAvailability.available) {
  //     print('No NFC is available');
  //   } else {
  //     print('available');
  //   }
  //   try {
  //     tag = await FlutterNfcKit.poll(
  //         timeout: const Duration(seconds: 10),
  //         iosMultipleTagMessage: "Multiple tags found!",
  //         iosAlertMessage: "Scan your tag");
  //
  //     print(jsonEncode(tag));
  //     print(tag.id);
  //     Fluttertoast.showToast(
  //         msg: "Bitich your id is ${tag.id}",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   } on PlatformException {}
  //   await FlutterNfcKit.finish();
  // }

  Future<bool> attendance(String? rollno, String? nfc) async {
    var status = false;
    await dio.post('http://127.0.0.1:8000/attendance',
        data: {nfc: nfc, rollno: rollno}).then((value) {
      print(value.data);
      return status = value.data.status;
    });
    return status;
  }

  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    AttendanceScreen(),
    LaundryScreen()
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar:
            BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Attendance'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Laundry'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Get out'),
        ], currentIndex: _selectedIndex, onTap: _onItemTapped),
        body: _widgetOptions.elementAt(_selectedIndex));
  }

  @override
  void dispose() async {
    super.dispose();
    // await FlutterNfcKit.finish();
  }
}

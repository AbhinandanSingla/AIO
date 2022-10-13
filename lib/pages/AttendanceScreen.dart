import 'package:dbms/services/authenciate.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key, this.userType, this.uid}) : super(key: key);
  final String? userType;
  final String? uid;

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Dio dio = Dio();
  bool attendance = false;

  timer() {
    setState(() => {attendance = true});
    Future.delayed(Duration(seconds: 2)).then((value) => {
          setState(() => {attendance = false})
        });
  }

  Future scanBarcodeNormal() async {
    String barcodeScanRes = "102183001";
    try {
      // barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      //     '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (barcodeScanRes == '-1') {
      if (kDebugMode) {
        print('cancel');
      }
    } else {
      if (kDebugMode) {
        return barcodeScanRes;
      }
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (ctx) => LoginScreen()));
    }
    if (!mounted) return '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Mark Your',
                style: GoogleFonts.lato(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  height: 2,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                'Attendance!',
                style: GoogleFonts.lato(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lotties/barcode.json'),
                  TextButton(
                    child: Text('Scan Barcode',
                        style: GoogleFonts.openSans(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      scanBarcodeNormal().then((value) async => {
                            print(value),
                            print(widget.userType),
                            if (widget.userType == 'caretaker')
                              {
                                print("+++++++++++++++"),
                                print(widget.uid),
                                await AuthService()
                                    .markAttendance(
                                        rollno: value, uid: widget.uid)
                                    .then((val) => {timer()})
                              }
                          });
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.only(
                              bottom: 15, left: 20, top: 15, right: 20)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox()
          ],
        ),
        attendance
            ? Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lotties/done.json'),
                    SizedBox(height: 20),
                    Text(
                      'Attendance Marked',
                      style: GoogleFonts.roboto(
                          fontSize: 30,
                          color: Colors.red,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 50)
                  ],
                ))
            : Container(),
      ],
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // FlutterNfcKit.finish();
  }
}

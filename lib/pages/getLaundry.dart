import 'package:dbms/pages/collectedScreen.dart';
import 'package:dbms/pages/laundry.dart';
import 'package:dbms/pages/laundryScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LaundryScan extends StatefulWidget {
  const LaundryScan({Key? key, this.uid, this.usertype}) : super(key: key);
  final String? uid;
  final String? usertype;

  @override
  State<LaundryScan> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<LaundryScan> {
  Dio dio = Dio();
  bool attendance = false;

  timer() {
    setState(() => {attendance = true});
    Future.delayed(Duration(seconds: 2)).then((value) => {
          setState(() => {attendance = false})
        });
  }

  Future scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (barcodeScanRes == '-1') {
      if (kDebugMode) {
        print("++++++++++++++++++++++++++++++++");
        return '-1';
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
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            centerTitle: true,
            title: Text("${widget.usertype}"),
            leading: BackButton()),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Scan Your',
                            style: GoogleFonts.roboto(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              height: 2,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Id Card!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              color: Colors.red,
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                            ),
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
                            if (widget.usertype == "Collect Laundry") {
                              scanBarcodeNormal().then((value) async => {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                CollectCloth(rollno: value)))
                                  });
                            } else {
                              scanBarcodeNormal().then((value) async => {
                                    if (value != '-1')
                                      {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (ctx) => LaundryScreen(
                                                      uid: widget.uid,
                                                      rollno: value,
                                                    )))
                                      }
                                  });
                            }
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.only(
                                    bottom: 15, left: 20, top: 15, right: 20)),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
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
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // FlutterNfcKit.finish();
  }
}

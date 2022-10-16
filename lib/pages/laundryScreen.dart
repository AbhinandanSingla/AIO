import 'package:dbms/pages/collectedScreen.dart';
import 'package:dbms/pages/getLaundry.dart';
import 'package:dbms/pages/loginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MainLaundryScreen extends StatelessWidget {
  const MainLaundryScreen({Key? key, this.uid}) : super(key: key);
  final uid;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
        onPressed: () => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const LoginScreen()))
        },
      )),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lotties/cloth.json'),
            SizedBox(height: 30),
            Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6), color: Colors.blue),
                child: TextButton(
                  onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (btx) => LaundryScan(
                              uid: uid,
                              usertype: "collection",
                            )))
                  },
                  child: Text("Get Laundry",
                      style: GoogleFonts.roboto(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                )),
            SizedBox(height: 20),
            Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6), color: Colors.blue),
                child: TextButton(
                  onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (btx) => LaundryScan(
                              uid: uid,
                            )))
                  },
                  child: Text("Give Laundry",
                      style: GoogleFonts.roboto(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                )),
          ]),
    );
  }
}

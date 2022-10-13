import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollectCloth extends StatelessWidget {
  CollectCloth({Key? key}) : super(key: key);
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  testData() async {
    var data = await _firestore
        .collection('laundry')
        .where('isCollected', isEqualTo: false)
        .get();
    print(data.docs);
  }

  @override
  Widget build(BuildContext context) {
    // testData();
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20),
            child: Text(
              "Pending Cloths",
              style: GoogleFonts.openSans(
                  fontSize: 30, fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder(
              stream: _firestore
                  .collection('laundry')
                  .where('isCollected', isEqualTo: false)
                  .get()
                  .asStream(),
              builder: (context, snapshot) {

                return ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Text("10 Oct 2020",
                          style: GoogleFonts.openSans(fontSize: 20)),
                      trailing: Container(
                          child: Text(
                        'Taken',
                        style: GoogleFonts.openSans(fontSize: 20),
                      )),
                    )
                  ],
                );
              })
        ],
      )),
    );
  }
}

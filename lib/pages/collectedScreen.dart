import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbms/pages/getLaundry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollectCloth extends StatefulWidget {
  const CollectCloth({Key? key, this.rollno, this.uid}) : super(key: key);
  final String? rollno;
  final String? uid;

  @override
  State<CollectCloth> createState() => _CollectClothState();
}

class _CollectClothState extends State<CollectCloth> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  update(doc) async {
    await _firestore
        .collection('laundry')
        .doc(doc)
        .update({"isCollected": true});
  }

  @override
  Widget build(BuildContext context) {
    // testData();
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
        onPressed: () => {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => LaundryScan(
                    uid: widget.uid,
                    usertype: "collection",
                  )))
        },
      )),
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
                  .where('Student_rollno', isEqualTo: widget.rollno)
                  .where('isCollected', isEqualTo: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                var monthNames = [
                  "January",
                  "February",
                  "March",
                  "April",
                  "May",
                  "June",
                  "July",
                  "August",
                  "September",
                  "October",
                  "November",
                  "December"
                ];
                var days = [
                  'Sunday',
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday'
                ];

                if (snapshot.data == null) {
                  return Container();
                } else {
                  DateTime time = snapshot.data.docs[0]
                      .data()["cloth_given_timestamp"]
                      .toDate();
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (ctx, index) => ListTile(
                      title: Text(
                          "${time.day} ${monthNames[time.month - 1]} ${time.year}",
                          style: GoogleFonts.openSans(fontSize: 20)),
                      subtitle: Text(days[time.weekday]),
                      trailing: Container(
                          padding: EdgeInsets.only(
                              left: 20, bottom: 0, right: 20, top: 0),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                            onPressed: () {
                              update(snapshot.data.docs[index].id);
                            },
                            child: Text("Collected",
                                style: GoogleFonts.openSans(
                                    color: Colors.black, fontSize: 20)),
                          )),
                    ),
                  );
                }
              })
        ],
      )),
    );
  }
}

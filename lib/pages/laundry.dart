import 'package:dbms/pages/getLaundry.dart';
import 'package:dbms/services/authenciate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LaundryScreen extends StatefulWidget {
  LaundryScreen({Key? key, this.rollno, this.uid}) : super(key: key);
  final String? rollno;
  final String? uid;

  @override
  State<LaundryScreen> createState() => _LaundryScreenState();
}

class _LaundryScreenState extends State<LaundryScreen> {
  bool given = false;

  timer() {
    setState(() => {given = true});
    Future.delayed(Duration(seconds: 2)).then((value) => {
          setState(() => {given = false}),
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => LaundryScan(
                    usertype: "laundry",
                    uid: widget.uid,
                  )))
        });
  }

  final GlobalKey<FormState> _key = GlobalKey();
  List laundryData = [
    {'id': 1, 'name': 'Jeans', 'img': 'assets/images/outfits/jeans.png'},
    {'id': 2, 'name': 'Pent', 'img': 'assets/images/outfits/pent.png'},
    {'id': 3, 'name': 'Pyjama', 'img': 'assets/images/outfits/pyjama.png'},
    {'id': 4, 'name': 'Shorts', 'img': 'assets/images/outfits/shorts.png'},
    {'id': 5, 'name': 'Shirts', 'img': 'assets/images/outfits/shirt.png'},
    {'id': 6, 'name': 'T-Shirts', 'img': 'assets/images/outfits/tshirt.png'},
    {'id': 6, 'name': 'Kurta/Salwar', 'img': 'assets/images/outfits/jeans.png'},
    {'id': 6, 'name': 'Skirt', 'img': 'assets/images/outfits/jeans.png'},
    {'id': 6, 'name': 'Dupatta', 'img': 'assets/images/outfits/jeans.png'},
    {'id': 6, 'name': 'Bed Sheet', 'img': 'assets/images/outfits/jeans.png'},
    {'id': 6, 'name': 'Pillow Cover', 'img': 'assets/images/outfits/jeans.png'},
    {
      'id': 6,
      'name': 'Tower/H-Towel',
      'img': 'assets/images/outfits/jeans.png'
    },
    {'id': 6, 'name': 'Turban', 'img': 'assets/images/outfits/jeans.png'},
    {'id': 6, 'name': 'Uppar Hood', 'img': 'assets/images/outfits/jeans.png'},
  ];
  final DataCollector dc = Get.put(DataCollector());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text('Laundry'),
          centerTitle: true,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: BackButton()),
      body: Form(
        key: _key,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: laundryData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 10, right: 10, left: 10, bottom: 10),
                          leading: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.blueGrey.shade200,
                                      blurRadius: 15,
                                      spreadRadius: 0.5,
                                      offset: Offset(0, 0))
                                ],
                                borderRadius: BorderRadius.circular(8)),
                            child: Image.asset(laundryData[index]['img']),
                          ),
                          title: Text(
                            laundryData[index]['name'],
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          trailing: LaundryBtn(index: index),
                        );
                      }),
                ),
                SizedBox(height: 20),
                TextButton(
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(Size(size.width * 0.9, 60)),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    print(widget.uid);
                    print(widget.rollno);
                    AuthService()
                        .giveLaundry(dc.laundryData, widget.rollno, widget.uid)
                        .then((val) => {timer()});
                    print(dc.laundryData);
                  },
                  child:
                      Text('Submit', style: GoogleFonts.poppins(fontSize: 18)),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
            given
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
                          'Next Person',
                          style: GoogleFonts.roboto(
                              fontSize: 30,
                              color: Colors.red,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 50)
                      ],
                    ))
                : Container()
          ],
        ),
      ),
    );
  }
}

class LaundryBtn extends StatefulWidget {
  LaundryBtn({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;

  @override
  State<LaundryBtn> createState() => _LaundryBtnState();
}

class _LaundryBtnState extends State<LaundryBtn> {
  int quantity = 0;
  final DataCollector dc = Get.put(DataCollector());

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      width: 100,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: 1)),
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      if (quantity != 10) {
                        quantity++;
                        dc.laundryData[widget.index]['quantity'] = quantity;
                      }
                    });
                  },
                  child: Text('+'),
                ),
              ),
              Text(quantity.toString(),
                  style: GoogleFonts.openSans(fontSize: 18)),
              Container(
                width: 38,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      if (quantity != 0) {
                        --quantity;
                        dc.laundryData[widget.index]['quantity'] = quantity;
                      }
                    });
                  },
                  child: Text('-', style: GoogleFonts.roboto(fontSize: 18)),
                ),
              )
            ]),
      ),
    );
  }
}

class DataCollector extends GetxController {
  List laundryData = [
    {'id': 1, 'name': 'Jeans', 'quantity': 0},
    {'id': 2, 'name': 'Pent', 'quantity': 0},
    {'id': 3, 'name': 'Pyjama', 'quantity': 0},
    {'id': 4, 'name': 'Shorts', 'quantity': 0},
    {'id': 5, 'name': 'Shirts', 'quantity': 0},
    {'id': 6, 'name': 'T-Shirts', 'quantity': 0},
    {'id': 7, 'name': 'Kurta/Salwar', 'quantity': 0},
    {'id': 8, 'name': 'Skirt', 'quantity': 0},
    {'id': 9, 'name': 'Dupatta', 'quantity': 0},
    {'id': 10, 'name': 'Bed Sheet', 'quantity': 0},
    {'id': 11, 'name': 'Pillow Cover', 'quantity': 0},
    {'id': 12, 'name': 'Tower/H-Towel', 'quantity': 0},
    {'id': 13, 'name': 'Turban', 'quantity': 0},
    {'id': 14, 'name': 'Uppar Hood', 'quantity': 0},
  ].obs;
}

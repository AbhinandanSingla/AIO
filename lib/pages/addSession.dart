import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddSession extends StatefulWidget {
  final String? uid;

  const AddSession({Key? key, this.uid}) : super(key: key);

  @override
  State<AddSession> createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {
  TextEditingController subjectName = TextEditingController();
  TextEditingController RoomNo = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FocusNode sn = FocusNode();
  FocusNode rm = FocusNode();

  testOnly() {
    _firestore
        .collection('teacher')
        .doc('oJCzAmKRn0lOwQAj03II')
        .collection('session')
        .doc()
        .set({
      'subjectName': '',
      'startTime': '',
      'endTime': '',
      'attendance': [],
    });
  }

  @override
  void initState() {
    startTime.text = ""; //set the initial value of text field
    endTime.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:
          AppBar(title: Text("Add Session"), backgroundColor: Colors.redAccent),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              SizedBox(height: 10),
              TextField(
                focusNode: sn,
                controller: subjectName,
                cursorColor: Colors.redAccent,
                decoration: InputDecoration(
                  focusColor: Colors.redAccent,
                  labelStyle: TextStyle(
                      color: sn.hasFocus ? Colors.redAccent : Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid, color: Colors.redAccent),
                  ),
                  prefixIcon: Icon(Icons.book, color: Colors.redAccent),
                  label: Text("Subject Name"),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                focusNode: rm,
                controller: RoomNo,
                cursorColor: Colors.redAccent,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.room, color: Colors.redAccent),
                  focusColor: Colors.redAccent,
                  labelStyle: TextStyle(
                      color: rm.hasFocus ? Colors.redAccent : Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid, color: Colors.redAccent),
                  ),
                  label: Text("Room No"),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: startTime,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.timer_sharp, color: Colors.redAccent),
                  label: Text("Start Time"),
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );

                  if (pickedTime != null) {
                    // print(pickedTime);
                    // print(pickedTime.format(context)); //output 10:51 PM
                    // DateTime parsedTime = DateFormat.jm()
                    //     .parse(pickedTime.format(context).toString());
                    // //converting to DateTime so that we can further format on different pattern.
                    // print(parsedTime); //output 1970-01-01 22:53:00.000
                    // String formattedTime =
                    //     DateFormat('HH:mm a').format(parsedTime);
                    // print(formattedTime); //output 14:59:00
                    // //DateFormat() is from intl package, you can format the time on any pattern you need.

                    setState(() {
                      startTime.text = pickedTime
                          .format(context); //set the value of text field.
                    });
                  } else {
                    print("Time is not selected");
                  }
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: endTime,
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );

                  if (pickedTime != null) {
                    print(pickedTime.format(context)); //output 10:51 PM
                    // DateTime parsedTime = DateFormat.jm()
                    //     .parse(pickedTime.format(context).toString());
                    //converting to DateTime so that we can further format on different pattern.
                    // print(parsedTime); //output 1970-01-01 22:53:00.000
                    // String formattedTime =
                    //     DateFormat('HH:mm a').format(parsedTime);
                    // print(formattedTime); //output 14:59:00
                    //DateFormat() is from intl package, you can format the time on any pattern you need.

                    setState(() {
                      endTime.text = pickedTime
                          .format(context); //set the value of text field.
                    });
                  } else {
                    print("Time is not selected");
                  }
                },
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.share_arrival_time, color: Colors.redAccent),
                  label: Text("End Time"),
                ),
              ),
              SizedBox(height: 50),
              Container(
                  width: size.width * 0.9,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                      onPressed: () async {
                        await _firestore
                            .collection('teacher')
                            .doc(widget.uid)
                            .collection('sessions')
                            .doc()
                            .set({
                          'subjectName': subjectName.value.text,
                          'startTime': startTime.value.text,
                          'endTime': endTime.value.text,
                          'attendance': [],
                          'roomNo': RoomNo.value.text
                        }).then((value) => Navigator.of(context).pop());
                      },
                      child: Text(
                        "Submit",
                        style: GoogleFonts.inter(
                            letterSpacing: 1,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )))
            ],
          ),
        ),
      )),
    );
  }
}

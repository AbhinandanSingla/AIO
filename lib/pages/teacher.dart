import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbms/pages/addSession.dart';
import 'package:dbms/pages/loginScreen.dart';
import 'package:dbms/pages/markAttendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key, this.uid}) : super(key: key);
  final String? uid;

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => LoginScreen())),
            icon: Icon(Icons.add_to_home_screen_rounded)),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        title: Text(
          "Sessions",
          style: GoogleFonts.roboto(
              fontSize: 25, color: Colors.white.withOpacity(0.8)),
        ),
      ),
      floatingActionButton: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(50)),
        child: Center(
            child: IconButton(
          icon: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => AddSession(uid: widget.uid)));
          },
        )),
      ),
      body: SafeArea(
          child: StreamBuilder(
              stream: _firestore
                  .collection('teacher')
                  .doc(widget.uid)
                  .collection('sessions')
                  .snapshots(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data.docs[index].data();
                      return Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              offset: Offset(0, 20),
                              blurRadius: 50,
                              spreadRadius: 4)
                        ]),
                        child: Dismissible(onDismissed: (direction)=>{

                        },
                          background: Container(
                            color: Colors.redAccent,alignment: Alignment.bottomRight,
                            child: Icon(Icons.delete_forever),
                          ),
                          key: Key(index.toString()),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                onTap: () => {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => MarkAttendance(
                                          uid: widget.uid,
                                          sessionId:
                                              snapshot.data.docs[index].id,
                                          subjectName: data['subjectName'])))
                                },
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.redAccent,
                                  child: Center(
                                      child: Text(
                                    data['subjectName'][0],
                                    style: GoogleFonts.openSans(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  )),
                                ),
                                title: Text(data['subjectName'],
                                    style: GoogleFonts.roboto(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.redAccent)),
                                subtitle: Text('Room No - ${data['roomNo']}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Text(
                                  "${data['startTime']} - ${data['endTime']} ",
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      );
                    });
              })),
    );
  }
}

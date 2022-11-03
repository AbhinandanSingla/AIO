import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbms/pages/AttendanceScreen.dart';
import 'package:dbms/pages/getLaundry.dart';
import 'package:dbms/pages/laundryScreen.dart';
import 'package:dbms/pages/teacher.dart';
import 'package:dbms/services/authenciate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/cabin.svg', width: 60),
                  Text(
                    'Sign In to continue',
                    style:
                        GoogleFonts.openSans(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  // Container(
                  //   child: TextField(
                  //     style: GoogleFonts.openSans(
                  //       fontSize: 18,
                  //     ),
                  //     cursorColor: Colors.amber,
                  //     decoration: InputDecoration(
                  //         focusedBorder: UnderlineInputBorder(
                  //             borderSide: BorderSide(color: Colors.redAccent)),
                  //         focusColor: Colors.red,
                  //         fillColor: Colors.red,
                  //         hoverColor: Colors.red,
                  //         label: Text(
                  //           'Username',
                  //           style: GoogleFonts.openSans(
                  //               color: Colors.redAccent,
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.w500),
                  //         )),
                  //     obscureText: true,
                  //   ),
                  //   padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                  //   decoration: BoxDecoration(),
                  // ),

                  Container(
                    child: TextField(
                      controller: _username,
                      onChanged: (text) => {},
                      enabled: true,
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                      ),
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent)),
                          focusColor: Colors.red,
                          fillColor: Colors.red,
                          hoverColor: Colors.red,
                          label: Text(
                            'Username',
                            style: GoogleFonts.openSans(
                                color: Colors.redAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                  ),
                  Container(
                    child: TextField(
                      controller: _password,
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                      ),
                      onChanged: (text) => {},
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent)),
                          focusColor: Colors.red,
                          fillColor: Colors.red,
                          hoverColor: Colors.red,
                          label: Text(
                            'Password',
                            style: GoogleFonts.openSans(
                                color: Colors.redAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )),
                      obscureText: true,
                    ),
                    margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: TextButton(
                      onPressed: () async {
                        if (kDebugMode) {
                          print(_username);
                        }
                        if (kDebugMode) {
                          print(_password);
                        }

                        // final message = await AuthService().registration(
                        //   email: "laundry_k@thapar.edu",
                        //   password: "123456789",
                        //   userType: 'laundry',
                        //   hostel: 'k',
                        // );

                        AuthService()
                            .login(
                                email: _username.value.text,
                                password: _password.value.text)
                            .then((value) => {
                                  if (value['status'] == 200)
                                    {
                                      if (value['data'].get("userType") ==
                                          'caretaker')
                                        {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      AttendanceScreen(
                                                          userType:
                                                              value['data'].get(
                                                                  "userType"),
                                                          uid: value['user']
                                                              .user
                                                              .uid,
                                                          hostel: value['data']
                                                              .get("hostel"))))
                                        }
                                      else if (value['data'].get("userType") ==
                                          'laundry')
                                        {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      MainLaundryScreen(
                                                        uid: value['user']
                                                            .user
                                                            .uid,
                                                        hostel: value['data']
                                                            .get("hostel"),
                                                      )))
                                        }
                                      else if (value['data'].get("userType") ==
                                          'teacher')
                                        {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      TeacherScreen(
                                                        uid: value['user']
                                                            .user
                                                            .uid,
                                                      )))
                                        }
                                    }
                                });
                      },
                      child: Text('Sign in',
                          style: GoogleFonts.openSans(
                              fontSize: 20, color: Colors.white)),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.redAccent),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(20))),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

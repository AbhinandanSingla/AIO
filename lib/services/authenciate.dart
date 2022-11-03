import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

enum userType { none, caretaker, laundry, teacher }

class AuthService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late UserCredential user;
  late DocumentSnapshot data;

  Future<String?> registration({
    required String email,
    required String password,
    required String userType,
  }) async {
    try {
      user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firestore.collection('user').doc(user.user?.uid).set({
        "username": user.user?.email,
        "userType": userType,
      });
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future login({
    required String email,
    required String password,
  }) async {
    try {
      user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      data = await _firestore.collection('user').doc(user.user?.uid).get();
      return {"status": 200, "user": user, "data": data};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e.code);
        return {"status": 401, "message": 'No user found for that email.'};
      } else if (e.code == 'wrong-password') {
        print("${e.code}+++++++++++++++++++++++++++++++++++++++");
        return {
          "status": 402,
          "message": 'Wrong password provided for that user.'
        };
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> markAttendance({String? rollno, String? uid}) async {
    bool lateEntry = false;
    await _firestore
        .collection('hostel attendance')
        .doc("K")
        .collection('attendance')
        .doc()
        .set({
      "caretakerId": uid,
      "time": DateTime.now(),
      "rollno": rollno,
      "lateEntry": lateEntry,
    });
    print("sucesss");
    return 'success';
  }

  classAttendance({String? uid, String? sessionID, String? rollno}) async {
    int status = 400;
    await _firestore
        .collection("teacher")
        .doc(uid)
        .collection("sessions")
        .doc(sessionID)
        .update({
      'attendance': FieldValue.arrayUnion([rollno])
    }).then((value) => status = 200);
    return status;
  }

  giveLaundry(List laundrylist, String? rollno, String? uid) async {
    try {
      await _firestore.collection('laundry').doc().set({
        "Student_clothdata": laundrylist,
        "Student_rollno": rollno,
        "isCollected": false,
        "cloth_given_timestamp": DateTime.now(),
        "laundryID": uid
      });
      return 'success';
    } catch (e) {
      print(e);
      return "error";
    }
  }
}

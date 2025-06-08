import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthServer{
  String namee;
  String emaill;
  int phonee;
  String passwordd;
  String? UID;
  AuthServer(this.namee,this.emaill,this.phonee,this.passwordd);


  void  recive(){
    //CHECKING And Reading
print (namee);
print(emaill);
print(phonee);
print(passwordd);
  }


Future<void>CreatAccount() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {//object
    UserCredential userCredential= await auth.createUserWithEmailAndPassword(email: emaill, password: passwordd);
    UID=userCredential.user?.uid;
    print("Account Created!");
  }
   catch (e) {
   print("Error to Create Account");
throw Exception("Error to create Account");
  }
}

  Future<void> sendDataToDB() async {

   if (UID==null) {
     print("do you forget creating account?");
     throw Exception("UID IS NULL");
   }

   try{
      FirebaseFirestore firestore = FirebaseFirestore.instance;

        await firestore.collection("users").doc(UID).set({
          'name': namee,
          'email': emaill,
          'phone number': phonee,
          'uid': UID,
        });

        print("User data saved to Firestore!");

    } catch (e) {
      print("Error sending data to Firestore: $e");
      throw Exception("Error to send data to fire base.");
    }
  }
}
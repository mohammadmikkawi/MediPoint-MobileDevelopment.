import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training_1/db/auth_service.dart';


class AuthServiceForgetPassword{
  String emailAuth;

  AuthServiceForgetPassword(this.emailAuth);

  void checke2(){

    print(emailAuth);

  }

  Future<bool> sendRestData()async{
    try{
      FirebaseAuth.instance.sendPasswordResetEmail(email: emailAuth);
      return true;
    }
    catch(e){
      print("Error to send");
      return false;
    }
  }
}
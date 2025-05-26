import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training_1/db/auth_service.dart';


class AuthServiceLogin{
  String  emailDB;
  String  passwordDB;
  String key;

  AuthServiceLogin(this.emailDB,this.passwordDB,this.key);

  void checkDB(){
    print(emailDB);
    print(passwordDB);
    print(key);

    const doctorCode="0000";
    if(key !=doctorCode){


      throw Exception("The key is not correct");

    }
    else{
      print("correct key");
    }
}

Future<bool>login()async{
try {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailDB, password: passwordDB);
return true;

}
catch(e){
return false;
}


}
}
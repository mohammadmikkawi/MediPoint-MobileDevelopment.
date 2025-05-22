import 'package:flutter/material.dart';
import 'package:training_1/Services/signup-service.dart';
import 'package:training_1/Widgets/login.dart';
import 'package:flutter/services.dart';
import 'package:training_1/db/auth_forgetpassword_service.dart';
import 'package:training_1/db/auth_login_service.dart';
import 'package:training_1/db/auth_service.dart';




class ForgetPasswordService{
  String emailFP;
  ForgetPasswordService(this.emailFP);


  void Cheked(){
    print (emailFP);
  }

bool notNull() {
    if (emailFP == null ||emailFP!.isEmpty )
    {
return false;
      }

    else {
      return true;
    }
    }


  bool checkEmail()
  {
    if (emailFP.contains('@')&&emailFP.contains('.')){
      return true;
    }
    else{
      throw Exception("Email not correct");
    }
  }

Future<bool>sendDt ()async{
    AuthServiceForgetPassword authServiceForgetPassword=AuthServiceForgetPassword(emailFP);
      authServiceForgetPassword.emailAuth;//check

 return authServiceForgetPassword.sendRestData();//send

    }
}
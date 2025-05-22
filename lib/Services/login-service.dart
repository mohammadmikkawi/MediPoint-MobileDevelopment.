import 'package:flutter/material.dart';
import 'package:training_1/Services/signup-service.dart';
import 'package:training_1/Widgets/login.dart';
import 'package:flutter/services.dart';
import 'package:training_1/db/auth_login_service.dart';
import 'package:training_1/db/auth_service.dart';

class LoginService{
  String email;
  String password;

  LoginService(this.email,this.password );


  bool notNull() {
    if (email == null || email!.isEmpty ||
        password == null || password!.isEmpty){
      return false;
    }
    else{
    return true;
    }
  }

  bool checkEmail()
  {
    if (email.contains('@')&&email.contains('.')){
      return true;
    }
    else{
      throw Exception("Email not correct");
    }
  }
  void checkPassword2() {
    if (password.length>9){
      throw Exception("the password must be 6 letters  or less");
    }
  }



Future<bool>SendDataToLoginAutherSarver()async
{

 AuthServiceLogin authServiceLogin=AuthServiceLogin(email, password);
 authServiceLogin.checkDB();

 bool result =await authServiceLogin.login();
 return result;
}
}
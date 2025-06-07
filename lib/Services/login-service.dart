import 'package:flutter/material.dart';
import 'package:training_1/Services/signup-service.dart';
import 'package:training_1/Widgets/login.dart';
import 'package:flutter/services.dart';
import 'package:training_1/db/auth_login_service.dart';
import 'package:training_1/db/auth_service.dart';

class LoginService{
  String email;
  String password;
String code;
String ?uid;

  LoginService(this.email,this.password,this.code );


  bool notNull() {
    if (email.isEmpty ||
        password.isEmpty || code.isEmpty)
    {
      return false;
    }
    else{
    return true;
    }
  }


  bool checkEmail()
  {
    return email.contains('@')&&email.contains('.');
  }

  bool checkPassword2() {
    return password.length>=8;
  }


  Future<bool>SendDataToLoginAutherSarver()async
{

 AuthServiceLogin authServiceLogin=AuthServiceLogin(email, password,code);
 authServiceLogin.checkDB();

 bool result1 =await authServiceLogin.login();

if (result1){
uid =authServiceLogin.getUid();
}

return result1;


}

  getUid(){
    return uid;
  }

}
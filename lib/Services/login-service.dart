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

  void notNull() {
    if (email == null  || password == null ||
        password == null) {
      throw Exception("data is empty!");
    }
  }

  void check(){
    print(email);
    print(password);
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
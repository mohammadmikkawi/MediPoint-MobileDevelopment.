import 'package:flutter/widgets.dart';
import 'package:training_1/Widgets/Signup.dart';
import 'package:training_1/db/auth_service.dart';


class SignupService {
  String name;
  String email;
int phoneNumber;
String password;
String checkPassword;
String?uid;

SignupService({required this.name,required this.email,required this.phoneNumber, required this.password,required this.checkPassword});

  bool notNull() {
    if ( name.isEmpty ||
         email.isEmpty ||
        password.isEmpty ) {
      return false;
    }
    return true;
  }


  bool checkEmail()
  {
 return email.contains('@')&&email.contains('.');
}

bool checkPassword2() {
    return password.length>=8;
    }


bool checkPasswordEquility(){
return password==checkPassword;
}

Future<bool> sendDatatoAuthServes()async{
  AuthServer a=AuthServer(name,email,phoneNumber,password);
  try {
    //send
    a.recive();
    print("data is sent");
    await a.CreatAccount();
    await a.sendDataToDB();
    return true;
  }

  catch(e){
    print("error of sending");
    return false;
  }
}
}
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
    if (name == null || name!.isEmpty ||
        email == null || email!.isEmpty ||
        password == null || password!.isEmpty ) {
      return false;
    }
    return true;
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

bool ?checkPasswordEquility(){
  if (password==checkPassword){
    return true;
  }
  else{
    throw Exception("not equal");
  }
}

Future<bool> sendDatatoAuthServes()async{
  AuthServer a=AuthServer(name,email,phoneNumber,password);
  try {
  //send
a.recive();
    print("data is sent");
   await a.CreatAccount();
    await a.sendDataToDB();
 uid=a.getUid();

if(uid!=null){
   print(uid);
   return true;
 }
else{
  return false;
 }
  }
  catch(e){
    print("error of sending");
    return false;
  }
}
}
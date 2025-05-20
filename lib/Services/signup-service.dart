import 'package:flutter/widgets.dart';
import 'package:training_1/Widgets/Signup.dart';


class SignupService {
  String name;
  String email;
int phoneNumber;
String password;
String checkPassword;

SignupService({required this.name,required this.email,required this.phoneNumber, required this.password,required this.checkPassword});

void process() {
  if (name == null || email ==null || phoneNumber == null ||
      password == null) {
    throw Exception("data is empty!");
  }
  else {
    print(name);
    print(email);
    print(email);
    print(phoneNumber);
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
    if (password.length>6){
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
}
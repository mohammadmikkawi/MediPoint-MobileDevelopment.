import 'package:flutter/material.dart';
import 'package:training_1/Widgets/Signup.dart';
import 'login.dart';




class Description extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
return Container(
    child:Center(
    child:Text("Enter your email address to reset your password. ",
  style: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  )
  ),
    ),
);
  }

}



 class Forgetpassword extends StatelessWidget{

    TextEditingController _eamil=TextEditingController();

   @override
  Widget build(BuildContext context) {
return Scaffold(
    resizeToAvoidBottomInset: true,
body:Column(
  children: [
    SizedBox(height:80),
Logo(250, 250),
SizedBox(width: 20,),
Description(),
SizedBox(height:30 ,width:44 ,),
Field(hinttext: "Enter Your Email",controller: _eamil,),

SizedBox(height: 30,),
Button("Send", 200,onPressed: (){





},),
    SizedBox(height: 250,),
Doyouforgetyourpassword("Log in Page",Login()),
  ],
)
);

  }
 }
import 'package:flutter/material.dart';
import 'package:training_1/Services/forgetpassword_service.dart';
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
Button("Send", 200,onPressed: () async
{

  try {
    String emailForgeted = _eamil.text;
    ForgetPasswordService forgetpassword = ForgetPasswordService(emailForgeted);

bool tery= forgetpassword.notNull();

    if(!tery){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("The empty value is invalid."),
              backgroundColor:Colors.red,
          )
      );
    }
    forgetpassword.Cheked();
    print("Data Sent!");


    if(!forgetpassword.checkEmail()){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email is not correct"), backgroundColor: Colors.red),
      );
      return false;
    }

    if(! forgetpassword.notNull()){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("The empty value is invalid."),
            backgroundColor:Colors.red,
          )
      );
      return false;
    }
    print("Data Processed!");

bool tery4=await forgetpassword.sendDt();
if(tery4){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Password reset link sent! Check your email."),
        backgroundColor:Colors.green,
      )
  );
}
else{
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to send reset link."),
        backgroundColor:Colors.red,
      )

  );
}
  }
   catch(e){
     ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Please Check Your Email!")),
     );
   }
},),
    SizedBox(height: 250,),
Doyouforgetyourpassword("Log in Page",Login()),
  ],
)
);
  }
 }
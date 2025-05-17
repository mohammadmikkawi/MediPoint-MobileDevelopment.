import 'package:flutter/material.dart';
import 'package:training_1/Widgets/WelcomePage.dart';
import 'package:training_1/Widgets/forgetpassword.dart';
import 'Signup.dart';

class Titleofpage2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Padding(padding: EdgeInsets.only(top:100),
      child: Center(
          child: Text('Log in',
            style:TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold
            ),
          )
      ),
    );

  }
}

class Text2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Text("Don't Have An Account Yet?");
  }
}


class Doyouforgetyourpassword extends StatelessWidget{
  @override
   String num5;
  final Widget page;
  Doyouforgetyourpassword(this.num5,this.page);

  Widget build(BuildContext context) {
    return  Container(
child:GestureDetector(
  onTap:() {
Navigator.push(context,//مكاني الحالي
  MaterialPageRoute(builder:(context)=>page),
   );
  },
        child: Text(num5,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            )

        )
    )
    );
  }
}


//Main Feature
 class  Login extends StatelessWidget{

   final TextEditingController _emailController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Stack(
          children: [
            SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: 20,),
            Titleofpage2(),
            SizedBox(height: 5,),
            Logo(300,300),
            SizedBox(height: 0,),
 Field (hinttext: "Enter your Email",controller:_emailController),
            SizedBox(height: 10,),
            Field (hinttext: "Enter your Password",controller: _passwordController,),
            SizedBox(height: 10,),
Doyouforgetyourpassword("Forget Password?",Forgetpassword()),
            SizedBox(height: 15,),
Button("Log in",300,onPressed: (){




},),
            SizedBox(height: 25,),
            ortext(),
            SizedBox(height: 20,),
            icons(),
            SizedBox(height: 25,),
Text2(),
            SizedBox(height: 2,),
            Flowbutton(Signup(),"Sign Up Page",15,200)
          ]
    )
    ),
            Positioned(
              top: 60,
             left: 20,
              child: Flowbutton(WelcomPage(), "Back", 20, 150),
            )
    ]
    ),

        );
  }
}
import 'package:flutter/material.dart';
import 'package:training_1/Services/login-service.dart';
import 'package:training_1/Widgets/WelcomePage.dart';
import 'package:training_1/Widgets/forgetpassword.dart';
import 'Signup.dart';
import 'package:training_1/Services//auth_provider.dart';
import 'package:provider/provider.dart';



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
  final String num5;
  final Widget page;
  @override
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
final TextEditingController _codeController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        body:Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
            child: Column(
            children: [
              SizedBox(height: 5,),
            Titleofpage2(),
            SizedBox(height: 5,),
            Logo(200,200),
            SizedBox(height: 1,),

 Field (hinttext: "Enter your Email",controller:_emailController),
            SizedBox(height: 10,),
            Field (hinttext: "Enter your Password",controller: _passwordController,),
            SizedBox(height: 10,),
              Field (hinttext: "Enter your Code",controller: _codeController,),
              SizedBox(height: 10,),
Doyouforgetyourpassword("Forget Password?",Forgetpassword()),
              SizedBox(height: 10,),

Button("Log in",500,
  onPressed:() async {
    try {
      String emailLog = _emailController.text;
      String passwordLog = _passwordController.text;
     String securecode=_codeController.text;

      LoginService loginn = LoginService(emailLog, passwordLog,securecode);


      if(! loginn.notNull()){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("The empty value is invalid."),
              backgroundColor:Colors.red,
            )
        );
        return false;
      }
      print("data sent");



      if( !loginn.checkEmail()){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email is not correct"), backgroundColor: Colors.red),
        );
        return false;
      }

      if(!loginn.checkPassword2()){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password must be at least 8 characters."), backgroundColor: Colors.red),
        );
        return false;
      }
print("Processing Done!");


bool success=await  loginn.SendDataToLoginAutherSarver();
      print("Data sent to Auth_login_service");

if(success) {
 // String? providerState = loginn.getUid();
  //if (providerState != null)

   // final authProvider = Provider.of<AuthProvider>(context, listen: false);
   // authProvider.setUid(providerState);
   //print("uid saved in provider.");

  Navigator.push
    (context, //مكاني الحالي
    MaterialPageRoute(builder: (context) => WelcomPage()),
  );
}
else{
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login Field"),
        backgroundColor: Colors.red,
      )
  );
}
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(

SnackBar(content:Text("Login failed with error: $e")
          )
      );
    }
  },
),
            SizedBox(height: 20,),
            ortext(),
            SizedBox(height: 1,),
            icons(),
            SizedBox(height: 10,),
Text2(),
            SizedBox(height: 1,),
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
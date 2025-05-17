import 'package:flutter/material.dart';
import 'package:training_1/Services/signup-service.dart';
import 'package:training_1/Widgets/login.dart';
import 'package:flutter/services.dart';

//Widget 1
class Titleofpage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
return  Padding(padding: EdgeInsets.only(top:70),
  child: Center(
    child: Text('Sign up',
style:TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold
),

    )
  ),
);
  }
}


//Widget 2
class Logo extends StatelessWidget{
 double? num;
 double? num2;
 Logo(this.num,this.num2);

 @override
  Widget build(BuildContext context) {
return Center(

 child: Image.asset('assets/logo.png',width:num ,height: num2),
);
  }
}



//Widget 3
 class Field extends StatelessWidget{
   String? hinttext;
   final TextEditingController controller;
   Field({this.hinttext,required this.controller});


  @override
  Widget build(BuildContext context) {
return Container(
width:390,
height: 50,
child: TextField(
controller:controller ,
  decoration:InputDecoration(
    hintText:hinttext,
  border: OutlineInputBorder(),
  ),
),
);
  }
}


//Widget 4-Sign Up Button.
class Button extends StatelessWidget {
  String name;
  double num3;
  final Function onPressed;
  Button(this.name, this.num3,{ required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: num3,
        child:
        ElevatedButton(onPressed: ()
        {
            onPressed();
        },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0077B6)
            ),
            child: Text(name,
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white
                )
            )
        )
    );
  }
}


//Widget 5
class ortext extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
return Center(
  child: Text("OR",style:TextStyle(
    color: Colors.black,
    fontSize:20
  )
  ),

);

  }
}
class Signupwithtext extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Sign Up With:",style:TextStyle(
          color: Colors.black,
          fontSize:17
      )
      ),

    );

  }
}


class icons extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
return Container(
  child: Row(
    mainAxisAlignment:MainAxisAlignment.center ,
    children: [
      SizedBox(width: 20,),
      Image.asset(
'assets/apple.png'
      ),
      SizedBox(width: 20,),
Image.asset('assets/google.png'),
      SizedBox(width: 20,),
      Image.asset('assets/facebook.png')
    ],
    
  ),

);
  }
}


 class Flowbutton extends StatelessWidget{
  final Widget keey;
  String titlee;
double num6;
double num7;
 Flowbutton(this.keey,this.titlee,this.num6,this.num7);
  @override
  Widget build(BuildContext context) {
 return  Container(
   width: num7,
   child:ElevatedButton(onPressed:(){
Navigator.push(context,//الحالي
    MaterialPageRoute(builder: (context) =>keey));
   },
style: ElevatedButton.styleFrom(
  backgroundColor: Color(0xFF0077B6)
),
       child:Text(titlee,
         style:TextStyle(
           fontSize: num6,
           color:Colors.white,
           fontWeight: FontWeight.bold
         )) ),
 );

  }
}




//Main Feature
class Signup extends StatelessWidget{
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
body:Column(
  children: [
   Titleofpage(),
    Logo(200,150),
    SizedBox(height: 1,),
Field(hinttext: "Full Name",controller:_fullNameController),
SizedBox(height: 12,),
    Field(hinttext: "Enter Your Email",controller:_emailController ,),
    SizedBox(height: 12,),
    Field(hinttext: "Enter Your Phone Number",controller: _phoneController,),
    SizedBox(height: 12,),
    Field(hinttext: "Enter Your Password",controller: _passwordController,),
    SizedBox(height: 12,),
    Field(hinttext: "Confirm Password",controller: _confirmPasswordController,),
    SizedBox(height: 20,),


Button("Sign Up", 200,onPressed:(){
  try {

    String fullName = _fullNameController.text;
    String email2=_emailController.text;
String phone2=_phoneController.text;
int phone=int.parse(phone2);
String password2=_passwordController.text;
String password3=_confirmPasswordController.text;


SignupService service=SignupService(name: fullName, email: email2, phoneNumber: phone, password: password2,checkPassword: password3);
service.process();
print("done");
service.checkEmail();
service.checkPassword2();
service.checkPasswordEquility();
  }

  catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please fill all fields or check your email.")),

    );
  }


}
  ,),
    SizedBox(height: 20,),
    SizedBox(height: 25,),
    SizedBox(height: 18,),
    ortext(),
    SizedBox(height: 5,),
    Signupwithtext(),
    SizedBox(height: 10,),
   icons(),
    SizedBox(height: 20,),
   Flowbutton(Login(),"Log in Page",15,200),

  ],
)
   );
  }
}
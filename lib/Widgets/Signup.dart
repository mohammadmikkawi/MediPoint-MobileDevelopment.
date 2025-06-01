import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_1/Services/signup-service.dart';
import 'package:training_1/Widgets/login.dart';
import 'package:flutter/services.dart';
import 'package:training_1/db/auth_service.dart';
import 'package:training_1/Services//auth_provider.dart';
import 'package:provider/provider.dart';

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
width:MediaQuery.of(context).size.width*0.9,
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
        width: MediaQuery.of(context).size.width*0.5,

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
return Padding(
  padding: EdgeInsets.only(top: 1),
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
    return Padding(
      padding: EdgeInsets.only(top: 3),
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
return Padding(
padding: EdgeInsets.only(top:1),
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
            Logo(170,150),
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


            Button("Sign Up", 200,
              onPressed:() async {
              try {

                String fullName = _fullNameController.text;
                String email2=_emailController.text;
                String phone2=_phoneController.text;
                int phone=int.parse(phone2);
                String password2=_passwordController.text;
                String password3=_confirmPasswordController.text;

                SignupService service=SignupService(name: fullName, email: email2, phoneNumber: phone, password: password2,checkPassword: password3);
                //processing steps

               bool tery2= service.notNull();
               if(!tery2){
                 ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text("The empty value is invalid."),
                       backgroundColor:Colors.red,
                     )
                 );
               }
                service.checkPasswordEquility();
                service.checkPassword;
                service.checkEmail();
print("Processing Is Done!");

   bool success =await service.sendDatatoAuthServes();
   if(success){
     String ?uid=service.uid;
if(uid!=null){
  Provider.of< AuthProvider>(context,listen: false).setUid(uid);
}
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
      content: Text("Account is created Successfully"),
backgroundColor:Colors.green,
  )
);
   }
   else{
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text("Account Not created"),
       backgroundColor: Colors.red,
     )
     );
   }
              }

              catch(e){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please fill all fields or check your email.")),

                );
              }
            }
              ,),
            SizedBox(height: 6,),
            ortext(),
            SizedBox(height: 5,),
            Signupwithtext(),
            SizedBox(height: 5,),
            icons(),
            SizedBox(height: 2,),
            Flowbutton(Login(),"Log in Page",15,200),
          ],
        )
    );
  }
}
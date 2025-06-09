import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:training_1/Services/signup-service.dart';
import 'package:training_1/Widgets/login.dart';
import 'package:flutter/services.dart';
import 'package:training_1/db/auth_service.dart';
import 'package:training_1/db/auth_provider.dart';
import 'package:provider/provider.dart';

//Widget 1
class Titleofpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 70),
      child: Center(
        child: Text(
          'Sign up',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

//Widget 2
class Logo extends StatelessWidget {
  double? num;
  double? num2;
  Logo(this.num, this.num2);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/logo.png', width: num, height: num2),
    );
  }
}

//Widget 3
class Field extends StatelessWidget {
  String? hinttext;
  final TextEditingController controller;
  Field({this.hinttext, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hinttext,
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
  Button(this.name, this.num3, {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,

      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0077B6)),
        child: Text(name, style: TextStyle(fontSize: 40, color: Colors.white)),
      ),
    );
  }
}

//Widget 5
class ortext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1),
      child: Text("OR", style: TextStyle(color: Colors.black, fontSize: 20)),
    );
  }
}

class Signupwithtext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3),
      child: Text(
        "Sign Up With:",
        style: TextStyle(color: Colors.black, fontSize: 17),
      ),
    );
  }
}

class icons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 20),
          Image.asset('assets/apple.png'),
          SizedBox(width: 20),
          Image.asset('assets/google.png'),
          SizedBox(width: 20),
          Image.asset('assets/facebook.png'),
        ],
      ),
    );
  }
}

class Flowbutton extends StatelessWidget {
  final Widget keey;
  String titlee;
  double num6;
  double num7;
  Flowbutton(this.keey, this.titlee, this.num6, this.num7);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: num7,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context, //الحالي
            MaterialPageRoute(builder: (context) => keey),
          );
        },
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0077B6)),
        child: Text(
          titlee,
          style: TextStyle(
            fontSize: num6,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

//Main Feature
class Signup extends StatelessWidget {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Titleofpage(),
                Logo(150, 150),
                SizedBox(height: 8),
                Field(hinttext: "Full Name", controller: _fullNameController),
                SizedBox(height: 12),
                Field(
                  hinttext: "Enter Your Email",
                  controller: _emailController,
                ),
                SizedBox(height: 12),
                Field(
                  hinttext: "Enter Your Phone Number",
                  controller: _phoneController,
                ),
                SizedBox(height: 12),
                Field(
                  hinttext: "Enter Your Password",
                  controller: _passwordController,
                ),
                SizedBox(height: 12),
                Field(
                  hinttext: "Confirm Password",
                  controller: _confirmPasswordController,
                ),
                SizedBox(height: 20),
                Button(
                  "Sign Up",
                  200,
                  onPressed: () async {
                    try {
                      String fullName = _fullNameController.text;
                      String email2 = _emailController.text;
                      String phone2 = _phoneController.text;
                      int phone = int.parse(phone2);
                      String password2 = _passwordController.text;
                      String password3 = _confirmPasswordController.text;

                      SignupService service = SignupService(
                        name: fullName,
                        email: email2,
                        phoneNumber: phone,
                        password: password2,
                        checkPassword: password3,
                      );

                      if (!service.notNull()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("The empty value is invalid."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (!service.checkEmail()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Email is not correct"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (!service.checkPassword2()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Password must be at least 8 characters.",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (!service.checkPasswordEquility()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Password do not match."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      print("Processing Is Done!");

                      bool success = await service.sendDatatoAuthServes();
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Account is created Successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Account Not created"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      print("Error during signup: $e");

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill all fields."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),

                SizedBox(height: 12),
                ortext(),
                SizedBox(height: 4),
                Signupwithtext(),
                SizedBox(height: 4),
                icons(),
                SizedBox(height: 16),
                Flowbutton(Login(), "Login", 20, 200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:training_1/Services/login-service.dart';
import 'package:training_1/Widgets/WelcomePage.dart';
import 'package:training_1/Widgets/forgetpassword.dart';
import 'Signup.dart';

class Titleofpage2 extends StatelessWidget {
  const Titleofpage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: const Center(
        child: Text(
          'Log in',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Text2 extends StatelessWidget {
  const Text2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Don't Have An Account Yet?");
  }
}

class Doyouforgetyourpassword extends StatelessWidget {
  final String num5;
  final Widget page;

  const Doyouforgetyourpassword(this.num5, this.page, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(
          num5,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 5),
                Titleofpage2(),
                const SizedBox(height: 5),
                Logo(250, 250),
                const SizedBox(height: 1),
                Field(
                  hinttext: "Enter your Email",
                  controller: _emailController,
                ),
                const SizedBox(height: 10),
                Field(
                  hinttext: "Enter your Password",
                  controller: _passwordController,
                ),
                const SizedBox(height: 10),
                Doyouforgetyourpassword("Forget Password?", Forgetpassword()),
                const SizedBox(height: 10),
                Button(
                  "Log in",
                  500,
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    bool success = await loginUser(email, password);

                    if (success) {
                      Navigator.pushReplacementNamed(context, '/homeD');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login failed'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                ortext(),
                const SizedBox(height: 1),
                icons(),
                const SizedBox(height: 10),
                Text2(),
                const SizedBox(height: 1),
                Flowbutton(Signup(), "Sign Up Page", 15, 200),
              ],
            ),
          ),
          Positioned(
            top: 60,
            left: 20,
            child: Flowbutton(WelcomPage(), "Back", 20, 150),
          ),
        ],
      ),
    );
  }
}

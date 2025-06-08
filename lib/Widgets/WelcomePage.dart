import 'package:flutter/material.dart';
import 'package:training_1/Widgets/Signup.dart';
import 'package:training_1/Widgets/login.dart';

class Introduction extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
return Text(
  "Welcome! Are you Patient Or Doctor? "
,
    style: TextStyle(
    fontSize: 20,
  fontWeight: FontWeight.bold,
      color: Colors.black,
    )
);
  }
}

class WelcomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    if (screenWidth > 600) {
      return Scaffold(body: _buildLandscapeLayout());
    } else {

      return Scaffold(
        body: orientation == Orientation.portrait
            ? _buildPortraitLayout()
            : _buildLandscapeLayout(),
      );
    }
  }

  Widget _buildPortraitLayout() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1979A9), Color(0xFFBBE8FF)]),
      ),
      child: Column(
        children: [
          SizedBox(height: 70),
          Logo(400, 400),
          SizedBox(height: 40, width: 100),
          Introduction(),
          SizedBox(height: 50, width: 200),
          Flowbutton(Login(), "Patient", 40, 300),
          SizedBox(height: 20, width: 200),
          Flowbutton(Login(), "Doctor", 40, 300),
        ],
      ),
    );
  }


  Widget _buildLandscapeLayout() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1979A9), Color(0xFFBBE8FF)]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Logo(250, 250)),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Introduction(),
                SizedBox(height: 20),
                Flowbutton(Login(), "Patient", 40, 300),
                SizedBox(height: 10),
                Flowbutton(Login(), "Doctor", 40, 300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
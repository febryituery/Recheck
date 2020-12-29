import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 2000), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue[400]],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
            image: DecorationImage(
                image: AssetImage('images/bg.png'), fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 120,
                ),
                Text(
                  'Recheck',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Camar',
                    fontSize: 45,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child: Image(
                    image: AssetImage('images/checkup.png'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Medical Check-Up for Your Future Health',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 21),
                ),
                SizedBox(
                  height: 120,
                ),
                LinearPercentIndicator(
                  animation: true,
                  alignment: MainAxisAlignment.center,
                  width: 250.0,
                  lineHeight: 4.0,
                  percent: 1.0,
                  animationDuration: 2000,
                  backgroundColor: Colors.grey,
                  progressColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

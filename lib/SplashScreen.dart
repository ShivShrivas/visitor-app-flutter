import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visitor_app_flutter/MyHomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required String title}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 4000), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: "Login Page"),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:Color.fromRGBO(255, 255, 255, 1.0),
      body: Container(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                    Column(
                      children: [
                      Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0)
                        ,child:  Image.asset("assets/images/splash_bg.png"),),

                      Column(
                        children: [
                          Text("Welcome",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w300),),
                          Text("to",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),),
                          Text("Visitor App",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Color.fromRGBO(
                              132, 135, 250, 1.0)),),
                        ],
                      ),
                    ],),
                      Padding(padding: EdgeInsets.all(10),child:   GestureDetector(
                        onTap: (){
                        },
                        child:  Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(143, 148, 251, 1),
                                    Color.fromRGBO(143, 148, 251, .6),
                                  ]
                              )
                          ),
                          child: Center(
                            child: Text("Get Started", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: 'RaleWay',fontSize: 20),),
                          ),
                        ),
                      ),
                        )
                    ,
                      Text("Version:2.0",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300),),


                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
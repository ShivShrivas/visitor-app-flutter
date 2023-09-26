import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visitor_app_flutter/MyHomePage.dart';
import 'package:visitor_app_flutter/NotificationService.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required String title}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  var GSMId;
  NotificationService notificationService=NotificationService();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    notificationService.isTokenRefresh();
    notificationService.getDeviceToken().then((value){
      setState(() {
        print("GSMID"+value);
        GSMId=value;
      });
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
    Timer(Duration(milliseconds: 2000), () {
      Navigator.of(context).push(_createRoute());
    });
  }
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>MyHomePage(title: "Login Page", GSMID: GSMId??"",),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 10);
        const end = Offset.zero;
        const curve = Curves.bounceIn;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:Color.fromRGBO(255, 255, 255, 1.0),
      body: Container(
        color:  Color.fromRGBO(112, 90, 255, 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Padding(padding: EdgeInsets.only(left: 20.0,right: 20.0,top:MediaQuery.of(context).size.height/3.9)
                  ,child:  Image.asset("assets/images/splasg_ic.png"),),

                Column(
                  children: [
                    Text("Welcome",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w300,fontFamily: 'Abel',color: Colors.white),),
                    Text("to",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300,fontFamily: 'Abel',color: Colors.white),),
                    Text("Visitor App",style: TextStyle(fontSize: 30,fontFamily: 'Abel',color: Color.fromRGBO(
                        255, 255, 255, 1.0)),),
                    SizedBox(height: 20,),
                    Padding(padding: EdgeInsets.all(10),child:   GestureDetector(
                      onTap: (){
                      },
                      child:  Card(
                        elevation: 7,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(255, 255, 255, 1.0),
                                    Color.fromRGBO(
                                        230, 228, 255, 1.0),
                                  ]
                              )
                          ),
                          child: Center(
                            child: Text("Get Started", style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold,fontFamily: 'RaleWay',fontSize: 20),),
                          ),
                        ),
                      ),
                    ),
                    )
                    ,
                    Text("Version:2.0",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300,color: Colors.white70),),

                  ],
                ),
              ],),
      ),
    );
  }
}
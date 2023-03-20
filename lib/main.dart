import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:visitor_app_flutter/DashBoard.dart';
import 'package:visitor_app_flutter/models/LoginResponse.dart';
import 'package:http/http.dart' as http;
import 'Animation/FadeAnimation.dart';
import 'network/api_service.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int _counter = 0;

  Future<void> logIn(String userId, String password) async {
    print(userId);
    print(password);
    Map<String, dynamic> body = { 'UserName': userId,
      'Password': password,
      'LastLoginWith': 'W',
      'DisplayCode': 'RAMFAG',
      'GroupCode': '01',
      'SocietyCode': '002'};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    final url = Uri.parse(
        'http://stonemen.bsninfotech.org/api/LoginApi/UserAuthentication');
    final headers = {'Content-Type': 'application/json'};
    var response = (await http.post(
      url,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    ));
    print(response);
    final List<dynamic> parsed = json.decode(response.body);
    final loginResponse = LoginResponse.fromJson(parsed[0]);

  if(loginResponse.userName!=null){
    _sendDataToSecondScreen(context,loginResponse);
  }else{
  }

  }

  void _sendDataToSecondScreen(BuildContext context, LoginResponse loginResponse) {

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(loginResponse: loginResponse, LoginResponse: loginResponse,),
        ));
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(1, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-1.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.3, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-2.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.5, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        child: FadeAnimation(1.6, Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text("Login to Visitor App", style: TextStyle( shadows: <Shadow>[
                            Shadow(
                            offset: Offset(2.0, 2.0),
                              blurRadius: 5.0,
                              color: Colors.white38,
                            )],color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold,fontFamily: "Nexa"),),
                          ),
                        )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(1.8, Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(122, 106, 217, 0.2),
                                  blurRadius: 40.0,
                                  offset: Offset(4, 10),
                                spreadRadius: 5.0
                              )
                            ]
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.deepPurple.shade50))
                              ),
                              child: TextField(
                                controller:userIdController ,
                                style: TextStyle(
                                    fontSize: 20
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "User ID",
                                    hintStyle: TextStyle(color: Colors.grey[400],fontSize: 18),
                                    icon: Icon(Icons.account_circle),
                                  iconColor: Colors.deepPurple.shade100

                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                controller: passwordController,
                                style: TextStyle(
                                  fontSize: 20

                                ),
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey[400],fontSize: 18),
                                    icon: Icon(Icons.lock_open_sharp),
                                    iconColor: Colors.deepPurple.shade100,


                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                      SizedBox(height: 70,),
                      GestureDetector(
                        onTap: (){
                          logIn(userIdController.text.toString(),passwordController.text.toString());
                        },
                        child: FadeAnimation(5, Container(
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
                            child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: 'RaleWay',),),
                          ),
                        )),
                      ),

                      SizedBox(height: 70,),
                      FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
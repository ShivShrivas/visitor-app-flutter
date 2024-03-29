import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'DashBoard.dart';
import 'models/LoginResponse.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage( {super.key, required this.title,required this.GSMID});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title,GSMID;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool _loading=false;
  late bool _passwordVisible=false;
  late double _progressValue;

  @override
  void initState() {
    super.initState();
    _loading = false;
    _progressValue = 0.0;
  }
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int _counter = 0;

  Future<void> logIn(String userId, String password) async {
    print(userId);
    print(password);
    print(widget.GSMID);

    Map<String, dynamic> body = { 'UserName': userId,
      'Password': password,
      'LastLoginWith': 'W',
      'DisplayCode': 'RAMFAG',
      'GroupCode': '01',
      'SocietyCode': '002',
      'GSMID':widget.GSMID
       };
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
   if(LoginResponse.fromJson(json.decode(response.body)[0]).userId!=0 ||LoginResponse.fromJson(json.decode(response.body)[0]).userId!=null){
     final List<dynamic> parsed = json.decode(response.body);

     final loginResponse = LoginResponse.fromJson(parsed[0]);
     print("login response ${loginResponse.userId}");
     if(loginResponse.userId!=0 && loginResponse.userId!=null){
       SharedPreferences pref = await SharedPreferences.getInstance();
       Clipboard.setData(ClipboardData(text: widget.GSMID));
       String user = jsonEncode(loginResponse);
       print("userdata $user");
       pref.setString('userData', user);
       pref.setString("token", widget.GSMID);
       _sendDataToSecondScreen(context,loginResponse);
       setState(() {
         _loading=false;
       });
     }else{
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         content: Text("User Id or Password Incorrect"),
       ));
       setState(() {
         _loading=false;
       });
     }
   }else{
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
       content: Text("Something went wrong"),
     ));
     setState(() {
       _loading=false;
     });
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

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.maxFinite,
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
                        width: 200,
                        height: 200,
                        child:
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 100,),
                              Text("Welcome",style: TextStyle(color:Colors.white70,fontSize: 26,fontWeight: FontWeight.w300),),
                              Text("to",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color: Colors.white60),),
                              Text("Visitor App",style: TextStyle(fontSize: 35,fontWeight: FontWeight.w500,color: Colors.white),),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 120,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')
                              )
                          ),
                        ),
                      ),
                      Positioned(
                        child:Container(
                          margin: EdgeInsets.only(top: 50),

                        ),
                      )
                    ],
                  ),
                ),

         Text("┬┴┬┴┬┴┤Login Here├┬┴┬┴┬┴┬", style:     TextStyle(
           fontSize: 20,
           color: Colors.deepPurple,

           shadows: [
             Shadow(
               blurRadius: 10.0,
               color: Colors.deepPurpleAccent,
               offset: Offset(5.0, 5.0),
             ),
           ],
         )
           ,),

                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.deepPurple),
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
                                onTap: (){
                                  setState(() {
                                    _loading=false;
                                  });
                                },
                                controller:userIdController ,
                                style: TextStyle(
                                    fontSize:16
                                ),
                                scrollPadding: EdgeInsets.only(bottom:40),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "User ID",
                                    hintStyle: TextStyle(color: Colors.grey[400],fontSize: 16),
                                    icon: Icon(Icons.account_circle),
                                    iconColor: Colors.deepPurple.shade300

                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                onTap: (){
                                  setState(() {
                                    _loading=false;
                                  });
                                },
                                controller: passwordController,

                                obscureText: !_passwordVisible,
                                style: TextStyle(
                                    fontSize: 16

                                ),
                                scrollPadding: EdgeInsets.only(bottom:40),

                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey[400],fontSize: 16),
                                  icon: Icon(Icons.lock_open_sharp),
                                  iconColor: Colors.deepPurple.shade300,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.deepPurpleAccent.shade100,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),

                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 40,),
                      !_loading? GestureDetector(
                        onTap: () async {
                            if(userIdController.text.length>1 && passwordController.text.length>1){
                              setState((){
                                _loading=true;
                              });
                              await logIn(userIdController.text.toString(),passwordController.text.toString());
                              setState((){
                                _loading=false;
                              });

                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please Enter User ID and Password properly"),
                              ));
                            }

                        },
                        child:  Card(
                          elevation: 10,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(143, 148, 251, 1),
                                      Color.fromRGBO(143, 148, 251, .6),
                                    ]
                                )
                            ),
                            child: Center(
                              child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: 'RaleWay',fontSize: 18),),
                            ),
                          ),
                        ),
                      ):Center(child:CircularProgressIndicator()),

                      SizedBox(height: 20,),
                      Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  void _updateProgress() {



  }
}
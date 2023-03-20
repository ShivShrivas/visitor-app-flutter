import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visitor_app_flutter/models/LoginResponse.dart';

import 'gridDashboard.dart';

class Dashboard extends StatefulWidget {
  final LoginResponse loginResponse;

  const Dashboard({Key? key, required this.loginResponse, required LoginResponse LoginResponse}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Column(
        children: <Widget>[
          SizedBox(height: 80),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "My Family",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Home",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Color(0xffa29aac),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  alignment: Alignment.topCenter,
                  icon: Image.asset("assets/images/notification.png", width: 24),
                )
              ],
            ),
          ),
          SizedBox(height:100),

          SizedBox.expand(

            child: Text("Choose Operation",style: TextStyle(fontSize: 20,backgroundColor: Colors.white),),
          ),

          SizedBox(height:20),

          //TODO Grid Dashboard
          GridDashboard()
        ],
      ),
    );
  }
}
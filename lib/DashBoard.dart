import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visitor_app_flutter/NotificationPage.dart';
import 'package:visitor_app_flutter/models/LoginResponse.dart';
import 'package:http/http.dart' as http;
import 'package:visitor_app_flutter/models/PurposeResponse.dart';

import 'gridDashboard.dart';

class Dashboard extends StatefulWidget {
  final LoginResponse loginResponse;

  const Dashboard({Key? key, required this.loginResponse, required LoginResponse LoginResponse}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<PurposeResponse> _currencies=<PurposeResponse>[];

  Future<void> getPurposeResponse() async {
    Map<String, dynamic> body = {"Action":5,"FYId":1,"SessionId":1,"RelationshipId":1};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    final url = Uri.parse(
        'http://stonemen.bsninfotech.org/Api/VisitorTransactionApi/GetAppointment');
    final headers = {'Content-Type': 'application/json'};
    var response = (await http.post(
      url,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    ));
    print(response);
    final List<dynamic> parsed = json.decode(response.body);
    print(response.body);


   setState(() {
     _currencies=(json.decode(response.body) as List).map((i) =>
         PurposeResponse.fromJson(i)).toList();
   });
    print(_currencies[0].purposeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[

          Padding(padding: EdgeInsets.all(0),
          child:   Container(

            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill
                )
            ),
            height: 270,
            child: SizedBox(

              height: 230,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(child:
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {

                                  },
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    // child:  Image.network('https://picsum.photos/250?image=9'),
                                    width: 60.0,
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: AssetImage('assets/images/img.png'),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(75.0)),
                                        boxShadow: [
                                          BoxShadow(blurRadius: 2.0, color: Colors.black)
                                        ]),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 230,
                                    child: Text(
                                      widget.loginResponse.userName,
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 4),
                                  Text(
                                    widget.loginResponse.schoolAddress,
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),)
                        ,
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationPage(),
                                ));
                          },
                          alignment: Alignment.centerLeft,
                          icon: Image.asset("assets/images/notification.png", width: 24),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: Container(),
                  ),
                  

                ],
              ),
            ),
          ), ),



          SizedBox(height:60,
          child: Text(

            "Choose an Operation",style: TextStyle(
fontSize: 20,color: Colors.indigo
          ),)),

          //TODO Grid Dashboard
          GridDashboard()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.indigoAccent,
        onPressed: (){
          getPurposeResponse();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Schedule Meetings'),
                  content: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.account_box),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.email),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Mobile',
                              icon: Icon(Icons.call ),
                            ),
                          ), TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Meeting with',
                              icon: Icon(Icons.people ),
                            ),
                          ),

                         Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Icon(Icons.speaker_notes,color: Colors.grey,),

                             DropdownButton(

                               // hint: Text('Choose Company'), // Not necessary for Option 1
                               onChanged: (newValue) {
                                 setState(() {
                                   print(_currencies);
                                   // here i have taken the boolen variable to show and hide the list if you have not seleted the value from the dropdown the it will show the text and if selected the it will show you the list.
                                 });
                                 print(_currencies);
                               },
                               items: _currencies.map((company) {
                                 return DropdownMenuItem(
                                   child: new Text(company.purposeName.toString()),
                                   value: company.code,
                                 );
                               }).toList(),
                             ),
                           ],
                         ),

                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Time',
                              icon: Icon(Icons.watch_later ),
                            ),
                          ), TextFormField(
                            onTap: () async {
                              print("done");
                              TimeOfDay? time = await getTime(
                                context: context,
                                title: "Select Your Time",
                              );
                              print(time);

                            },
                            decoration: InputDecoration(
                              labelText: 'Date',
                              icon: Icon(Icons.calendar_month ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  actions: [
                    MaterialButton(
                        child: Text("Submit"),
                        onPressed: () {
                          // your code
                        })
                  ],
                );
              });
        },
      ),
    );
  }

  Future<TimeOfDay?> getTime({
    required BuildContext context,
    String? title,
    TimeOfDay? initialTime,
    String? cancelText,
    String? confirmText,
  }) async {
    TimeOfDay? time = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      cancelText: cancelText ?? "Cancel",
      confirmText: confirmText ?? "Save",
      helpText: title ?? "Select time",
      builder: (context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    return time;
  }

}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visitor_app_flutter/NotificationPage.dart';
import 'package:visitor_app_flutter/UserProfile.dart';
import 'package:visitor_app_flutter/models/LoginResponse.dart';
import 'package:http/http.dart' as http;
import 'package:visitor_app_flutter/models/PurposeResponse.dart';

import 'gridDashboard.dart';

class Dashboard extends StatefulWidget {
  final LoginResponse loginResponse;

  const Dashboard(
      {Key? key,
      required this.loginResponse,
      required LoginResponse LoginResponse})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
   late List<PurposeResponse> currencies;
   late final List<String> purposes;

    String selectedPurpose="";

TextEditingController timeController=TextEditingController();
TextEditingController dateController=TextEditingController();




  Future<void> getPurposeResponse() async {
    Map<String, dynamic> body = {
      "Action": 5,
      "FYId": 1,
      "SessionId": 1,
      "RelationshipId": 1
    };
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
      currencies = (json.decode(response.body) as List)
          .map((i) => PurposeResponse.fromJson(i))
          .toList();
       purposes = currencies.map((currencies) => currencies.purposeName.toString()).toList();

    });
    print(currencies[0].purposeName);
  }

  @override
  void initState() {
    setState(() {
      getPurposeResponse();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(

                  image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fill)),
              height: 280,
              child:Column(
                children: [
                  SizedBox(
                    height: 260,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => UserProfile(),
                                              ));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          clipBehavior: Clip.antiAlias,
                                          child:  Image.network('${widget.loginResponse.branchLogo.replaceAll("../", "http://stonemen.bsninfotech.org/")}'),
                                          width: 70.0,
                                          height: 70.0,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                           
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(75.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.black)
                                              ]),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 200,
                                          child: Text(
                                            widget.loginResponse.userName,
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          widget.loginResponse.schoolAddress,
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NotificationPage(),
                                      ));
                                },
                                alignment: Alignment.centerLeft,
                                icon: Image.asset("assets/images/notification.png",
                                    width: 24),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Text("Last Login : ${widget.loginResponse.lastLogin}",style: TextStyle(color: Colors.white),),


                      ],
                    ),
                  ),

                ],
              ),

            ),
          ),

          SizedBox(
              height: 60,
              child: Text(
                "Choose an Operation",
                style: TextStyle(fontSize: 20, color: Colors.indigo),
              )),

          //TODO Grid Dashboard
          GridDashboard()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.indigoAccent,
        onPressed: () {

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Schedule A Meeting'),
                  content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    return Padding(
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
                                icon: Icon(Icons.call),
                              ),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Meeting with',
                                icon: Icon(Icons.people),
                              ),
                            ),
                            Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.speaker_notes,
                                  color: Colors.grey,
                                ),
                                Container(
                                  height: 60,
                                  width: 200,
                                  child: DropdownButton<String>(
                                    alignment: Alignment.center,
                                    value: selectedPurpose,
                                    items: [
                                      const DropdownMenuItem(child: Text('Select Purpose'),
                                          value: ""),
                                      ...currencies.map<DropdownMenuItem<String>>((data){
                                        return DropdownMenuItem(
                                          child:Text(data.purposeName! ),
                                          value: data.purposeName!,
                                        );

                                      }).toList(),

                                    ],
                                    onChanged: (data) {
                                      print(data);
                                      setState(() {
                                        selectedPurpose = data!;
                                        print(selectedPurpose);
                                      });

                                    },


                                    // hint: const Text(
                                    //   "Select Purpose",
                                    //   style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontSize: 11,
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                  ),
                                )

                              ],
                            ),
                            TextFormField(
                              controller: timeController,

                              onTap: () async {
                                print("done");
                                TimeOfDay? time = await getTime(
                                  context: context,
                                  title: "Select Your Time",

                                );
                                final localizations = MaterialLocalizations.of(context);
                                final formattedTimeOfDay = localizations.formatTimeOfDay(time!);
                                timeController.text=formattedTimeOfDay;
                                print(time);

                              },
                              decoration: InputDecoration(
                                labelText: 'Time',
                                icon: Icon(Icons.watch_later),
                              ),

                            ),
                            TextFormField(
                              controller: dateController,
                              onTap: () async{
                                DateTime? date = DateTime(1900);
                                FocusScope.of(context).requestFocus(FocusNode());
                                date = await showDatePicker(
                                    context: context,
                                    initialDate:DateTime.now(),
                                    firstDate:DateTime(1900),
                                    lastDate: DateTime(2100));

                                dateController.text = "${date?.toLocal()}".split(' ')[0];


                              },
                              decoration: InputDecoration(

                                labelText: 'Date',
                                icon: Icon(Icons.calendar_month),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              // your code
                            }),

                        MaterialButton(
                            child: Text("Schedule", style: TextStyle(
                              color: Colors.indigo
                            ),),
                            onPressed: () {
                              // your code
                            }),
                      ],
                    )

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

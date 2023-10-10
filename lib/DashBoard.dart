import 'dart:convert';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor_app_flutter/MyHomePage.dart';
import 'package:visitor_app_flutter/SplashScreen.dart';
import 'package:visitor_app_flutter/models/MeetingWithResponse.dart';
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
  late List<MeetingWithResponse> meetingWithResponseList;
  late List<String> meetingWithPerson;
  late final List<String> purposes;
  final _formKey = GlobalKey<FormState>();
  String selectedPurpose = "";
  String selectedPerson = "";

  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();


  Future<void> getMeetingWithResponse() async {
    print("relationship id ${widget.loginResponse.relationshipId}");
    Map<String, dynamic> body = {
      "Action": 7,
      "FYId": 1,
      "SessionId": 1,
      "RelationshipId": widget.loginResponse.relationshipId
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    final url = Uri.parse(
        'http://stonemen.bsninfotech.org/Api/VisitorTransactionApi/GetVisitor');
    final headers = {'Content-Type': 'application/json'};
    var response = (await http.post(
      url,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    ));
    print(response);
    final List<dynamic> parsed = json.decode(response.body);
    print("Data of meeting with  ${response.body}");

    setState(() {
      meetingWithResponseList = (json.decode(response.body) as List)
          .map((i) => MeetingWithResponse.fromJson(i))
          .toList();
      meetingWithPerson =
          meetingWithResponseList.map((meetingWithResponseList) =>
              meetingWithResponseList.name.toString()).toList();
    });
    print(meetingWithPerson[0]);
  }

  Future<void> scheduleAmeeting(String name, String email, String mobile,
      String time, String date, BuildContext dialogContext) async {
    print(date + "T" + time.split(" ")[0] + ":00");
    print("person code"+selectedPerson);
    Map<String, dynamic> body = {
      "TransID": "",
      "MeetingDate": "${date}T${time.split(" ")[0]}:00",
      "PVNo": "000005",
      "MobileNo": mobile,
      "EmailId": email,
      "VisitorName": name,
      "PurposeId": selectedPurpose,
      "AuthorizedOrOtherPersonCode": selectedPerson.split("|")[0],
      "StatusId": 1,
      "Showtime": "${time.split(" ")[0]}:00",
      "RelationshipId": widget.loginResponse.relationshipId,
      "SessionId": "1",
      "FYId": "1",
      "CreatedBy": widget.loginResponse.userId,
      "UpdatedBy": widget.loginResponse.userId,
      "Action": "1"
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    final url = Uri.parse(
        'http://stonemen.bsninfotech.org/Api/VisitorTransactionApi/InsertUpdateDeleteAppointment');
    final headers = {'Content-Type': 'application/json'};
    var response = (await http.post(
      url,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    ));
    print(response.body);

    if (response.body == '"1"') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting Schedule Successfully')),

      );
      SendNotificationToHost(name, selectedPurpose, mobile, selectedPerson);
      setState(() {
        Navigator.pop(dialogContext);
        nameController.clear();
        emailController.clear();
        mobileController.clear();
        timeController.clear();
        dateController.clear();

      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
      Navigator.pop(dialogContext);
    }
  }

  Future<void> getPurposeResponse() async {
    Map<String, dynamic> body = {
      "Action": 5,
      "FYId": 1,
      "SessionId": 1,
      "RelationshipId": widget.loginResponse.relationshipId
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
      purposes =
          currencies.map((currencies) => currencies.purposeName.toString())
              .toList();
    });
    print(currencies[0].purposeName);
  }

  @override
  void initState() {
    setState(() {
      getPurposeResponse();
      getMeetingWithResponse();
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
              child: Column(
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
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           UserProfile(),
                                          //     ));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          clipBehavior: Clip.antiAlias,
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
                                          child: setImage(
                                              widget.loginResponse.branchLogo),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
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
                                  showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                      content: Text('Are you sure you want to exit?'),
                                      actions: <Widget>[
                                    MaterialButton(
                                    child: Text("YES"),
                                    onPressed: () async {
                                      SharedPreferences pref =await SharedPreferences.getInstance() ;
                                      pref.setString('userData', "");
                                      pref.setString("token", "");
                                     // SystemNavigator.pop();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SplashScreen(title: ""),
                                          ));
                                    }),
                                    MaterialButton(
                                    child: Text("NO"),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    })
    ]
                                    );
                                  });
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           NotificationPage(),
                                  //     ));
                                },
                                alignment: Alignment.centerLeft,
                                icon: Icon(Icons.logout,color: Colors.white,),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Text("Last Login : ${widget.loginResponse.lastLogin}",
                          style: TextStyle(color: Colors.white),),


                      ],
                    ),
                  ),

                ],
              ),

            ),
          ),

          Container(
              padding: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 8),
              child: Container(
                  padding: EdgeInsets.all(6),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff5731ff),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      padding: EdgeInsets.all(10),
                      child: Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 7,
                                  spreadRadius: 12)
                            ]),
                        width: double.infinity,
                        height: 22,
                        child: Center(
                          child: Text("Choose an option", style: TextStyle(
                              fontSize: 16, color: Colors.deepPurple),),
                        ),
                      )))),

          //TODO Grid Dashboard
          GridDashboard(relationShipId: widget.loginResponse.relationshipId,userId:widget.loginResponse.userId)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.indigoAccent,
        onPressed: () {
          if(currencies!=null ||  meetingWithResponseList!=null){
            if(meetingWithResponseList.length!=0  &&  currencies.length!=0 ){
              showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text('Schedule A Meeting'),
                      content: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: nameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Enter Name";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Name',
                                        icon: Icon(Icons.account_box),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: emailController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Enter Email";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        icon: Icon(Icons.email),
                                      ),
                                    ),
                                    TextFormField(
                                      maxLength: 10,
                                      controller: mobileController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Enter Mobile Number";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Mobile',
                                        icon: Icon(Icons.call),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,

                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
                                        Expanded(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            alignment: Alignment.center,
                                            value: selectedPerson,
                                            items: [
                                              const DropdownMenuItem(child: Text(
                                                'Meeting With',
                                                style: TextStyle(fontSize: 14),),
                                                  value: ""),
                                              ...meetingWithResponseList.map<
                                                  DropdownMenuItem<String>>((data) {
                                                return DropdownMenuItem(
                                                  child: Text(data.name??"",
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                  value: data.code,
                                                );
                                              }).toList(),

                                            ],
                                            onChanged: (data) {
                                              print(data);
                                              setState(() {
                                                selectedPerson = data!;
                                                print(selectedPerson);
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
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.speaker_notes,
                                          color: Colors.grey,
                                        ),
                                        Expanded(
                                          child: DropdownButton<String>(
                                            isExpanded: true,

                                            alignment: Alignment.center,
                                            value: selectedPurpose,
                                            items: [
                                              const DropdownMenuItem(child: Text(
                                                  'Select Purpose',
                                                  style: TextStyle(fontSize: 14)),
                                                  value: ""),
                                              ...currencies.map<
                                                  DropdownMenuItem<String>>((data) {
                                                return DropdownMenuItem(
                                                  child: Text(data.purposeName??"",
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                  value: data.code.toString(),
                                                );
                                              }).toList(),

                                            ],
                                            onChanged: (data) {
                                              print(data);
                                              setState(() {
                                                selectedPurpose = data??"";
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Enter Time";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onTap: () async {
                                        print("done");
                                        TimeOfDay? time = await getTime(
                                          context: context,
                                          title: "Select Your Time",

                                        );
                                        final localizations = MaterialLocalizations
                                            .of(context);
                                        final formattedTimeOfDay = localizations
                                            .formatTimeOfDay(time!);
                                        switch(int.parse(formattedTimeOfDay.split(":")[0])<=9){
                                          case true:
                                            timeController.text = "0"+formattedTimeOfDay;
                                            break;
                                          case false:
                                            timeController.text = formattedTimeOfDay;
                                            break;
                                        }


                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Time',
                                        icon: Icon(Icons.watch_later),
                                      ),

                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Enter Date";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: dateController,
                                      onTap: () async {
                                        DateTime? date = DateTime(1900);
                                        FocusScope.of(context).requestFocus(
                                            FocusNode());
                                        date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100));

                                        dateController.text =
                                        "${date?.toLocal()}".split(' ')[0];
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
                                  Navigator.of(context).pop(true);
                                }),

                            MaterialButton(
                                child: Text("Schedule", style: TextStyle(
                                    color: Colors.indigo
                                ),),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    scheduleAmeeting(nameController.value.text,
                                        emailController.value.text,
                                        mobileController.value.text,
                                        timeController.value.text,
                                        dateController.value.text, dialogContext);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Processing Data')),
                                    );
                                  }
                                }),
                          ],
                        )

                      ],
                    );
                  });
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("can't found meeting with person and purpose also please check")));

            }

          }else{
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("can't found meeting with person and purpose also please check")));

          }

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

  setImage(String url) {
    if (url != null) {
      if (url != "") {
        return Image.network(
            '${url.replaceAll("../", "http://stonemen.bsninfotech.org/")}');
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> SendNotificationToHost(String name, String selectedPurpose,
      String mobile, String selectedPerson) async {
    String? GSMID = "";
    String? purpose = "";
    print("name $name");
    print("selectedPurpose $selectedPurpose");
    print("selectedPerson $selectedPerson");


    for (var i = 0; i < meetingWithResponseList.length; i++) {
      print("selectedPerson ${meetingWithResponseList[i].code}== $selectedPerson");
      if (meetingWithResponseList[i].code == selectedPerson) {
        print("GSMID selected${meetingWithResponseList[i].GSMId}");

        GSMID = meetingWithResponseList[i].GSMId;
      }
    }

      for (var i = 0; i < currencies.length; i++) {
        print("selectedpurpose ${currencies[i].code}== $selectedPurpose");

        if (currencies[i].code == selectedPurpose) {
         print("purpose selected${currencies[i].purposeName}");
          purpose = currencies[i].purposeName;
        }
      }
      print("GSMID if got $GSMID");
      print("GSMID if got $purpose");
        Map<String, dynamic> body = {
          "deviceId": GSMID,
          "VisitorName": name,
          "PurposeId": purpose,
          "MobileNo": mobile
        };
        String jsonBody = json.encode(body);
        final encoding = Encoding.getByName('utf-8');
        final url = Uri.parse(
            'http://stonemen.bsninfotech.org/Api/VisitorTransactionApi/SendVisitorNotificationtToMobile');
        final headers = {'Content-Type': 'application/json'};
        var response = (await http.post(
          url,
          headers: headers,
          body: jsonBody,
          encoding: encoding,
        ));
        print(response);

        print("send notification  ${response.body}");
      }

      // currencies


}

//update Attendence set sginin=' ' where id=
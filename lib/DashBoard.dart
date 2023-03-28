import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    String selectedPurpose="";
    String selectedPerson="";

TextEditingController timeController=TextEditingController();
TextEditingController dateController=TextEditingController();
TextEditingController nameController=TextEditingController();
TextEditingController emailController=TextEditingController();
TextEditingController mobileController=TextEditingController();




   Future<void> getMeetingWithResponse() async {
     Map<String, dynamic> body = {
       "Action": 6,
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
       meetingWithResponseList = (json.decode(response.body) as List)
           .map((i) => MeetingWithResponse.fromJson(i))
           .toList();
       meetingWithPerson = meetingWithResponseList.map((meetingWithResponseList) => meetingWithResponseList.name.toString()).toList();

     });
     print(meetingWithPerson[0]);
   }

  Future<void> scheduleAmeeting(String name, String email, String mobile, String time, String date, BuildContext dialogContext) async {

    Map<String, dynamic> body = {
    "TransID":"","MeetingDate":date,"PVNo":"000005","MobileNo":mobile,
    "EmailId":email,"VisitorName":name,"PurposeId":"2",
    "AuthorizedOrOtherPersonCode":"00000002","StatusId":1,
    "RelationshipId": widget.loginResponse.relationshipId,"SessionId":"1","FYId":"1",
    "CreatedBy":"400","UpdatedBy":"400","Action":"1"
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

    if(response.body=='"1"'){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting Schedule Successfully')),

      );
      setState(() {
        Navigator.pop(dialogContext);
        nameController.clear();
        emailController.clear();
        mobileController.clear();
        timeController.clear();
        dateController.clear();

      });
    }else{
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
       purposes = currencies.map((currencies) => currencies.purposeName.toString()).toList();

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
                                          child:  setImage(widget.loginResponse.branchLogo),
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
          GridDashboard(relationShipId:widget.loginResponse.relationshipId)
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
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Schedule A Meeting'),
                  content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: nameController,
                              validator: (value){
                                if(value==null || value.isEmpty){
                                  return "Please Enter Name";
                                }else{
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
                              validator: (value){
                                if(value==null || value.isEmpty){
                                  return "Please Enter Email";
                                }else{
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                icon: Icon(Icons.email),
                              ),
                            ),
                            TextFormField(
                              controller: mobileController,
                              validator: (value){
                                if(value==null || value.isEmpty){
                                  return "Please Enter Mobile Number";
                                }else{
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

                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                Container(
                                  height: 60,
                                  width: 200,
                                  child: DropdownButton<String>(
                                    alignment: Alignment.center,
                                    value: selectedPerson,
                                    items: [
                                      const DropdownMenuItem(child: Text('Meeting With',style: TextStyle(fontSize: 14),),
                                          value: ""),
                                      ...meetingWithResponseList.map<DropdownMenuItem<String>>((data){
                                        return DropdownMenuItem(
                                          child:Text(data.name!,style: TextStyle(fontSize: 14) ),
                                          value: data.name!,
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                      const DropdownMenuItem(child: Text('Select Purpose',style: TextStyle(fontSize: 14)),
                                          value: ""),
                                      ...currencies.map<DropdownMenuItem<String>>((data){
                                        return DropdownMenuItem(
                                          child:Text(data.purposeName! ,style: TextStyle(fontSize: 14)),
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
                              validator: (value){
                                if(value==null || value.isEmpty){
                                  return "Please Enter Time";
                                }else{
                                  return null;
                                }
                              },
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
                              validator: (value){
                                if(value==null || value.isEmpty){
                                  return "Please Enter Date";
                                }else{
                                  return null;
                                }
                              },
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
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                scheduleAmeeting(nameController.value.text,emailController.value.text,mobileController.value.text,timeController.value.text,dateController.value.text,dialogContext);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Processing Data')),
                                );

                              }


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

  setImage(String url) {
    if(url!=null){
      return Image.network('${url.replaceAll("../", "http://stonemen.bsninfotech.org/")}');

    }else{
       return  null;
     }
  }
}

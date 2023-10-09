import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:visitor_app_flutter/models/ActionableListResponse.dart';

import 'ActionableList.dart';

class ActionableDetailsPage extends StatefulWidget {
  final ActionableListResponse listResponse;
  final int relationShipId;
  final int userId;
  const ActionableDetailsPage({Key? key, required this.listResponse,required this.userId,required this.relationShipId}) : super(key: key);

  @override
  State<ActionableDetailsPage> createState() => _ActionableDetailsPageState();
}

class _ActionableDetailsPageState extends State<ActionableDetailsPage> {
  final _formKeyRemark = GlobalKey<FormState>();

  TextEditingController remarkController = TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    print("listResponse ${jsonEncode(widget.listResponse)}");
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Actionable Page'),
      ),
      body: SingleChildScrollView(
        child: new Container(
          height: _height-60,
          child: new Stack(
            children: <Widget>[
              new Container(

                decoration: new BoxDecoration(
                    gradient: new LinearGradient(colors: [
                      const Color(0xFF6769A9),
                      const Color(0xFFB5B7FA),
                      const Color(0xFFFFFFFF),
                    ], begin: Alignment.topLeft, end: Alignment.center)),
              ),
              new Scaffold(
                backgroundColor: Colors.transparent,
                body: new Container(
                  child: new Stack(
                    children: <Widget>[
                      new Align(
                        alignment: Alignment.center,
                        child: new Padding(
                          padding: new EdgeInsets.only(top: _height / 15),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new CircleAvatar(
                                backgroundImage:
                                new AssetImage('assets/images/user.png'),
                                foregroundImage: setImage(widget.listResponse.photo),
                                radius: _height / 10,
                              ),
                              new SizedBox(
                                height: _height / 50,
                              ),
                              new Text(
                                widget.listResponse.visitorName,
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.indigo.shade700,
                                    fontWeight: FontWeight.bold),
                              ),
                              new SizedBox(
                                height: _height / 60,
                              ),
                              new Text(
                               "Meeting date: "+ widget.listResponse.meetingDate,
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.indigo.shade700,),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.only(top: _height / 2.2),
                        child: new Container(
                          color: Colors.white,
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: _height / 2.6,
                            left: _width / 20,
                            right: _width / 20),
                        child: new Column(

                          children: <Widget>[
                            new Container(
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    new BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 2.0,
                                        offset: new Offset(0.0, 2.0))
                                  ]),
                              child: new Padding(
                                padding: new EdgeInsets.all(_width / 20),
                                child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      headerChild('Email', widget.listResponse.emailId),
                                      headerChild('Mobile', widget.listResponse.mobileNo),
                                    ]),
                              ),
                            ),
                      SizedBox(height: 30,),
                      Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.symmetric(horizontal: 2.0),
                                              child: Icon(
                                                Icons.meeting_room,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                              text: "Meeting with",
                                              style:
                                              TextStyle(fontSize: 15, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                      child: Text(
                                        widget.listResponse.name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(horizontal: 2.0),
                                                child: Icon(
                                                  Icons.timelapse,
                                                  size: 15,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                                text: "Meeting on",
                                                style:
                                                TextStyle(fontSize: 15, color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          "Date: " +
                                              widget.listResponse.meetingDate
                                                  .toString()
                                                  .replaceFirst("T", " Time: "),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(horizontal: 2.0),
                                                child: Icon(
                                                  Icons.note_alt_rounded,
                                                  size: 15,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                                text: "Meeting Purpose",
                                                style:
                                                TextStyle(fontSize: 15, color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          widget.listResponse.purposeName,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.symmetric(horizontal: 2.0),
                                              child: Icon(
                                                Icons.credit_card,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                              text: "Physical Visitor Pass Name",
                                              style:
                                              TextStyle(fontSize: 15, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                      child: Text(
                                        widget.listResponse.physicalVisitorPassName,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(horizontal: 2.0),
                                                child: Icon(
                                                  Icons.add_card_sharp,
                                                  size: 15,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                                text: "Goverment Name",
                                                style:
                                                TextStyle(fontSize: 15, color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(

                                              widget.listResponse.govermentName
                                                  ,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(horizontal: 2.0),
                                                child: Icon(
                                                  Icons.note_alt_rounded,
                                                  size: 15,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                                text: "Belonging Name",
                                                style:
                                                TextStyle(fontSize: 15, color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          widget.listResponse.belongingName,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: _height/15,),

                     Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  new Padding(
                                    padding: new EdgeInsets.only(top: 0),
                                    child: GestureDetector(
                                      onTap: (){
                                        openDialogForRemarks("Reject",3);
                                      },
                                      child: new Container(
                                        width: _width / 5,
                                        height: _height / 20,
                                        decoration: new BoxDecoration(
                                            color: const Color(0xFFFF0A31),
                                            borderRadius: new BorderRadius.all(
                                                new Radius.circular(_height / 90)),
                                            boxShadow: [
                                              new BoxShadow(
                                                  color: Colors.red.shade100,
                                                  blurRadius: 2.0,
                                                  offset: new Offset(3, 3.0))
                                            ]),
                                        child: new Center(
                                          child: new Text('REJECT',
                                              style: new TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  new Padding(
                                    padding: new EdgeInsets.only(top: 0),
                                    child: GestureDetector(
                                      onTap: (){
                                        openDialogForRemarks("Allow",6);

                                      },
                                      child: new Container(
                                        width: _width / 5,
                                        height: _height / 20,
                                        decoration: new BoxDecoration(
                                            color: const Color(0xFF01BE09),
                                            borderRadius: new BorderRadius.all(
                                                new Radius.circular(_height / 90)),
                                            boxShadow: [
                                              new BoxShadow(
                                                  color: Colors.green.shade100,
                                                  blurRadius: 2.0,
                                                  offset: new Offset(3, 3.0))
                                            ]),
                                        child: new Center(
                                          child: new Text('ALLOW',
                                              style: new TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // new Padding(
                                  //   padding: new EdgeInsets.only(top: 0),
                                  //   child: GestureDetector(
                                  //     onTap: (){
                                  //       openDialogForRemarks("WALK IN",4);
                                  //
                                  //     },
                                  //     child: new Container(
                                  //       width: _width / 5,
                                  //       height: _height / 20,
                                  //       decoration: new BoxDecoration(
                                  //           color: const Color(0xFF3058F8),
                                  //           borderRadius: new BorderRadius.all(
                                  //               new Radius.circular(_height / 90)),
                                  //           boxShadow: [
                                  //             new BoxShadow(
                                  //                 color: Colors.blueAccent.shade100,
                                  //                 blurRadius: 2.0,
                                  //                 offset: new Offset(3, 3.0))
                                  //           ]),
                                  //       child: new Center(
                                  //         child: new Text('WALK IN',
                                  //             style: new TextStyle(
                                  //                 fontSize: 12.0,
                                  //                 color: Colors.white,
                                  //                 fontWeight: FontWeight.bold)),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // new Padding(
                                  //   padding: new EdgeInsets.only(top: 0),
                                  //   child: GestureDetector(
                                  //     onTap: (){
                                  //       openDialogForRemarks("ON WAIT",5);
                                  //     },
                                  //     child: new Container(
                                  //       width: _width / 5,
                                  //       height: _height / 20,
                                  //       decoration: new
                                  //       BoxDecoration(
                                  //           color: const Color(0xFFFFE70E),
                                  //           borderRadius: new BorderRadius.all(
                                  //               new Radius.circular(_height / 90)),
                                  //           boxShadow: [
                                  //             new BoxShadow(
                                  //                 color: Colors.yellow.shade100,
                                  //                 blurRadius: 2.0,
                                  //                 offset: new Offset(3, 3.0))
                                  //           ]),
                                  //       child: new Center(
                                  //         child: new Text('ON WAIT',
                                  //             style: new TextStyle(
                                  //                 fontSize: 12.0,
                                  //                 color: Colors.black,
                                  //                 fontWeight: FontWeight.bold)),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),

                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerChild(String header, String value) => new Expanded(
      child:  Column(
        children: <Widget>[
           Text(header),
           SizedBox(
            height: 8.0,
          ),
           Text(
            '$value',
            style:  TextStyle(
                fontSize: 14.0,
                color: const Color(0xFF8C88FF),
                fontWeight: FontWeight.bold),
          )
        ],
      ));

  Widget infoChild(double width, IconData icon, data) =>  Padding(
    padding:  EdgeInsets.only(bottom: 8.0),
    child:  InkWell(
      child:  Row(
        children: <Widget>[
           SizedBox(
            width: width / 20,
          ),
           Icon(
            icon,
            color: const Color(0xFF8C88FF),
            size: 20.0,
          ),
           SizedBox(
            width: width / 20,
          ),
           Text(data,style: TextStyle(fontSize: 16),)
        ],
      ),
      onTap: () {
        print('Info Object selected');
      },
    ),
  );

  Future<void> setStatus(String s, int i, String remark,BuildContext dialogContext) async {
      print(widget.listResponse.transId);
    Map<String, dynamic> body =
    {"Action":1,"RelationshipId":8,"FYId":1, "PTransId":widget.listResponse.transId,"SessionId":1, "Status":i, "Remarks":remark, "isAction":i,"TransId":""};
    String jsonBody = json.encode(body);
    print(body);
    final encoding = Encoding.getByName('utf-8');
    final url = Uri.parse(
        'http://stonemen.bsninfotech.org/Api/VisitorTransactionApi/InsertVisitorNotificationGenerate');
    final headers = {'Content-Type': 'application/json'};
    var response = (await http.post(
    url,
    headers: headers,
    body: jsonBody,
        encoding: encoding,
    ));

    if(response.body=='"1"'){
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Person ${s}ed!!')),

      );
      setState(() {
        Navigator.pop(dialogContext);
        remarkController.clear();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActionableList(relationShipId: widget.relationShipId,userId:widget.userId),
            ));


      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
      Navigator.pop(dialogContext);

    }

  }

  Future openDialogForRemarks(String s, int i) {
    return showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            scrollable: true,
            title: Text('Enter A Remark',style: TextStyle(fontSize: 17),),
            content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Form(
                  key: _formKeyRemark,
                  child: Column(
                    children: <Widget>[
                      TextFormField(

                        controller: remarkController,
                        validator: (value){
                          if(value==null || value.isEmpty){
                            return "Please Enter Remark";
                          }else{
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Remarks',
                          icon: Icon(Icons.note_alt),
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
                      child: Text("Save", style: TextStyle(
                          color: Colors.indigo
                      ),),
                      onPressed: () {
                        if (_formKeyRemark.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          setStatus(s, i,remarkController.text,dialogContext);
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
  }
}
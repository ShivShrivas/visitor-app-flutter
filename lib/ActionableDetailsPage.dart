import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:visitor_app_flutter/models/ActionableListResponse.dart';

class ActionableDetailsPage extends StatefulWidget {
  final ActionableListResponse listResponse;
  const ActionableDetailsPage({Key? key, required this.listResponse}) : super(key: key);

  @override
  State<ActionableDetailsPage> createState() => _ActionableDetailsPageState();
}

class _ActionableDetailsPageState extends State<ActionableDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Actionable Page'),
      ),
      body: SingleChildScrollView(
        child: new Container(
          height: _height,
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
                                new AssetImage('assets/images/img.png'),
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
                            new Padding(
                              padding: new EdgeInsets.only(top: _height / 20),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  infoChild(
                                      _width, Icons.person, widget.listResponse.name),
                                  infoChild(_width, Icons.note, widget.listResponse.purposeName),
                                  infoChild(
                                      _width, Icons.connect_without_contact, widget.listResponse.belongingName),
                                  infoChild(_width, Icons.chat_bubble,
                                      widget.listResponse.remark),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Padding(
                                        padding: new EdgeInsets.only(top: _height / 30),
                                        child: GestureDetector(
                                          onTap: (){

                                            setStatus("Reject",3);
                                          },
                                          child: new Container(
                                            width: _width / 2.5,
                                            height: _height / 20,
                                            decoration: new BoxDecoration(
                                                color: const Color(0xFFFF0A31),
                                                borderRadius: new BorderRadius.all(
                                                    new Radius.circular(_height / 60)),
                                                boxShadow: [
                                                  new BoxShadow(
                                                      color: Colors.black87,
                                                      blurRadius: 2.0,
                                                      offset: new Offset(0.0, 1.0))
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
                                        padding: new EdgeInsets.only(top: _height / 30),
                                        child: GestureDetector(
                                          onTap: (){
                                            setStatus("Allow",6);
                                          },
                                          child: new Container(
                                            width: _width / 2.5,
                                            height: _height / 20,
                                            decoration: new BoxDecoration(
                                                color: const Color(0xFF01BE09),
                                                borderRadius: new BorderRadius.all(
                                                    new Radius.circular(_height / 60)),
                                                boxShadow: [
                                                  new BoxShadow(
                                                      color: Colors.black87,
                                                      blurRadius: 2.0,
                                                      offset: new Offset(0.0, 1.0))
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
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Padding(
                                        padding: new EdgeInsets.only(top: _height / 30),
                                        child: GestureDetector(
                                          onTap: (){
                                            setStatus("WALK IN",4);
                                          },
                                          child: new Container(
                                            width: _width / 2.5,
                                            height: _height / 20,
                                            decoration: new BoxDecoration(
                                                color: const Color(0xFF3058F8),
                                                borderRadius: new BorderRadius.all(
                                                    new Radius.circular(_height / 60)),
                                                boxShadow: [
                                                  new BoxShadow(
                                                      color: Colors.black87,
                                                      blurRadius: 2.0,
                                                      offset: new Offset(0.0, 1.0))
                                                ]),
                                            child: new Center(
                                              child: new Text('WALK IN',
                                                  style: new TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.only(top: _height / 30),
                                        child: GestureDetector(
                                          onTap: (){
                                            setStatus("ON WAIT",5);
                                          },
                                          child: new Container(
                                            width: _width / 2.5,
                                            height: _height / 20,
                                            decoration: new
                                            BoxDecoration(
                                                color: const Color(0xFFFFE70E),
                                                borderRadius: new BorderRadius.all(
                                                    new Radius.circular(_height / 60)),
                                                boxShadow: [
                                                  new BoxShadow(
                                                      color: Colors.black87,
                                                      blurRadius: 2.0,
                                                      offset: new Offset(0.0, 1.0))
                                                ]),
                                            child: new Center(
                                              child: new Text('ON WAIT',
                                                  style: new TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
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
      child: new Column(
        children: <Widget>[
          new Text(header),
          new SizedBox(
            height: 8.0,
          ),
          new Text(
            '$value',
            style: new TextStyle(
                fontSize: 14.0,
                color: const Color(0xFF8C88FF),
                fontWeight: FontWeight.bold),
          )
        ],
      ));

  Widget infoChild(double width, IconData icon, data) => new Padding(
    padding: new EdgeInsets.only(bottom: 8.0),
    child: new InkWell(
      child: new Row(
        children: <Widget>[
          new SizedBox(
            width: width / 10,
          ),
          new Icon(
            icon,
            color: const Color(0xFF8C88FF),
            size: 25.0,
          ),
          new SizedBox(
            width: width / 20,
          ),
          new Text(data)
        ],
      ),
      onTap: () {
        print('Info Object selected');
      },
    ),
  );

  Future<void> setStatus(String s, int i) async {

    Map<String, dynamic> body =
    {"Action":1,"RelationshipId":8,"FYId":1, "VTransId":widget.listResponse.transId,"SessionId":1, "Status":s, "Remarks":"It will be dynamic", "isAction":i};
    String jsonBody = json.encode(body);
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('In Response you got ${response.body}. Your status is ${s} and status id is ${i}'),
    ));


  }
}
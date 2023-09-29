import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visitor_app_flutter/ActionableDetailsPage.dart';
import 'package:visitor_app_flutter/models/ActionableListResponse.dart';

class ActionableList extends StatefulWidget {
  final int relationShipId;
  final int userId;
  const ActionableList({Key? key, required this.relationShipId,required this.userId}) : super(key: key);

  @override
  State<ActionableList> createState() => _ActionableListState();
}


class _ActionableListState extends State<ActionableList> {

  late String fromDateGlobal;
  late String toDateGlobal;
  bool _isLoading = true;
  late List<ActionableListResponse> listSchduleMeeting;
  DateTime selectedDate = DateTime.now();
  TextEditingController _FromDate = new TextEditingController();
  TextEditingController _ToDate = new TextEditingController();

  Future<Null> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate:DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {

        selectedDate = picked;
        _FromDate.value = TextEditingValue(text:  "${picked?.toLocal()}".split(' ')[0]);
        fromDateGlobal=_FromDate.text.toString();
       // getScheduleMeetingList(fromDateGlobal, toDateGlobal);

      });
  }

  Future<Null> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;

        _ToDate.value = TextEditingValue(text: "${picked?.toLocal()}".split(' ')[0]);
        toDateGlobal=_ToDate.text.toString();

       // getScheduleMeetingList(fromDateGlobal, toDateGlobal);


      });
  }

  void getDates() {
    var fromDate = new DateTime.now().subtract(Duration(days: 30));
    var toDate = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');

    setState(() {
      fromDateGlobal = formatter.format(fromDate).toString();
      toDateGlobal = formatter.format(toDate).toString();

    });
  }

// 2016-01-25
  Future<void> getScheduleMeetingList(String fromDate, String toDate) async {
    print("from date " + fromDate);
    print("to date: " + toDate);

    Map<String, dynamic> body =
    {"Action":15,"FYId":1,"FromDate":fromDate,"UserId":widget.userId.toString(),"PurposeId":"","ToDate":toDate,"SessionId":1,
      "RelationshipId": widget.relationShipId.toString()
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    final url = Uri.parse(
        'http://stonemen.bsninfotech.org/Api/VisitorTransactionApi/GetVisitorList');
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
      listSchduleMeeting = (json.decode(response.body) as List)
          .map((e) => ActionableListResponse.fromJson(e))
          .toList();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDates();
    getScheduleMeetingList(fromDateGlobal, toDateGlobal);
    setState(() {
      getDates();
      getScheduleMeetingList(fromDateGlobal, toDateGlobal);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Actionable List'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectFromDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _FromDate,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            hintText: fromDateGlobal,
                            prefixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectToDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _ToDate,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            hintText: toDateGlobal,
                            prefixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: (){
                        getScheduleMeetingList(fromDateGlobal, toDateGlobal);
                        _isLoading=true;
                      },
                      child: new Container(
                        width: _width / 5,
                        height: _height / 20,
                        decoration: new BoxDecoration(
                            color: const Color(0xFF0A5CFF),
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(_height / 90)),
                            boxShadow: [
                              new BoxShadow(
                                  color: Colors.blueAccent.shade100,
                                  blurRadius: 2.0,
                                  offset: new Offset(3, 3.0))
                            ]),
                        child: new Center(
                          child: new Text('Search',
                              style: new TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  )
                ]),
          ),
          Expanded(
            child: !_isLoading
                ? Center(
              child: ListView.builder(
                itemCount: listSchduleMeeting.length,
                itemBuilder: (context, index) {
                  return visitorItemCard(context, index);
                },
              ),
            )
                : Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget visitorItemCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ActionableDetailsPage(listResponse: listSchduleMeeting[index],userId:widget.userId,relationShipId:widget.relationShipId),
            ));
      },
      child: Card(
        elevation: 4,
        color: Color.fromRGBO(224, 255, 201, 1.0),
        margin: EdgeInsets.all(5),
        shadowColor: Color.fromRGBO(241, 255, 230, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // if you need this
        ),


          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2.0, 0, 0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        child: Icon(
                                          Icons.person,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                        text: listSchduleMeeting[index]
                                            .visitorName
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Icon(
                                      Icons.mail,
                                      size: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                    text: listSchduleMeeting[index]
                                        .emailId
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.indigo)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: .2,
                  indent: 8,
                  endIndent: 8,
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                            listSchduleMeeting[index].authPersionName.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                                listSchduleMeeting[index]
                                    .meetingDate
                                    .toString()
                                    .replaceFirst("T", " Time: "),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                            listSchduleMeeting[index].purposeName.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
}
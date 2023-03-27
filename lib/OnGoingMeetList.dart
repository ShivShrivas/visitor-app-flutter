import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnGoingMeetList extends StatefulWidget {
  const OnGoingMeetList({Key? key}) : super(key: key);

  @override
  State<OnGoingMeetList> createState() => _OnGoingMeetListState();
}

class _OnGoingMeetListState extends State<OnGoingMeetList> {

  @override
  void initState() {
    // TODO: implement initState
   getOnGoingList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('On Going Meeting'),
      ),
        body: Center(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, i){

                return visitorItemCard();

            },
          ),
        )
    );
  }

  Widget visitorItemCard() {
    return Card(
      color: Color.fromRGBO(213, 222, 255, 1.0),
      margin: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // if you need this
        side: BorderSide(
          color: Colors.grey.withOpacity(.2),
          width: 1,
        ),
      ),
      child: Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 13.0, 8.0, 0),
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
                        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                        child: Text(
                          'Mohit Kumar Gupta',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        'Alpha 1, Greater Noida',
                        style: TextStyle(color: Colors.grey),
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
                    Text(
                      'Meeting with',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Text(
                      'Gaurav Nigam',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Meeting On',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Text(
                      '28 Feb 2020 at 1:36 PM',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Meet Purpose',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Text(
                      'General Meeting',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
    );
  }

  void getOnGoingList() {}
}

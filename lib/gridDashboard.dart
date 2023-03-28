import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visitor_app_flutter/ActionableList.dart';
import 'package:visitor_app_flutter/CompleteMeetList.dart';
import 'package:visitor_app_flutter/OnGoingMeetList.dart';
import 'package:visitor_app_flutter/ScheduleMeetList.dart';

class GridDashboard extends StatefulWidget {
  final int relationShipId;
  const GridDashboard({Key? key, required this.relationShipId}) : super(key: key);

  @override
  State<GridDashboard> createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  Items item1 = new Items(
      title: "Actionable List",
      subtitle: "Actionable List find here",
      event: "",
      img: "assets/images/guest_list.png");

  Items item2 = new Items(
    title: "Ongoing Meeting",
    subtitle: "Ongoing meeting list",
    event: "4 Items",
    img: "assets/images/ongoingmeeting.png",
  );
  Items item3 = new Items(
    title: "Schedule Meeting",
    subtitle: "Schedule Meetings are here",
    event: "",
    img: "assets/images/calendar.png",
  );
  Items item4 = new Items(
    title: "Complete Meeting",
    subtitle: "completed meeting list",
    event: "",
    img: "assets/images/agreement.png",
  );



  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4];
    var color = Color.fromRGBO(203, 205, 255, 1.0);
    return Flexible(
      child: GridView.count(
        childAspectRatio: 1.0,
        padding: EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: myList.map((data) {
          return GestureDetector(
            onTap: (){
              if(data.title.compareTo("Actionable List")==0){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActionableList(),
                    ));
              }else if(data.title.compareTo("Ongoing Meeting")==0){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnGoingMeetList(relationShipId: widget.relationShipId,),
                    ));
              }else if(data.title.compareTo("Schedule Meeting")==0){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleMeetList(relationShipId: widget.relationShipId,),
                    ));
              }else if(data.title.compareTo("Complete Meeting")==0){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplteteMeetList(relationShipId: widget.relationShipId,),
                    ));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.white,
                    Color.fromRGBO(158, 162, 255, 1.0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigoAccent.shade100,
                    blurRadius: 10.0,
                  ),
                ],
                color: Color.fromRGBO(169, 171, 255, 1.0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(data.img, width: 42),
                  SizedBox(height: 14),
                  Text(
                    data.title,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    data.subtitle,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    data.event,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ) ;



        }).toList(),
      ),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Items({required this.title, required this.subtitle, required this.event, required this.img});
}




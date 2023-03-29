import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor_app_flutter/models/LoginResponse.dart';

import 'Utils/AdaptiveTextSize.dart';

class UserProfile extends StatefulWidget {

  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
    LoginResponse user=LoginResponse(0, "",  0,  "",  "",  0, "", 0,  "",  "",  0,  0,  0,  false,  false,  "",  "",  "",  "",  "", "",  "",  "",  "",  "",  "",  "",  "",  "",  "",  "",  "",  "",  "",  "",  "",  0,  "",  "",  "",  0,  "");
  @override
   getDataFromSP() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map json = jsonDecode(pref.getString("userData").toString());
    setState(() {
      user = LoginResponse.fromJson(json);
    });



  }
@override
  void initState() {
  getDataFromSP();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(

          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [


                  Colors.white,
                  Colors.white38
  ]
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                 ListTile(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.arrow_back),

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(

                      padding: EdgeInsets.all(5),
                      clipBehavior: Clip.antiAlias,
                      child:  setImage(user.branchLogo),
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
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.userName.toString(),

                      style:
                      TextStyle(fontWeight: FontWeight.w900, fontSize:
                      AdaptiveTextSize().getadaptiveTextSize(context, 20)),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [Text("Login As: ${user.loginAs}")],
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                     Text(

                        user.schoolName.toString()+"\n"+user.schoolAddress.toString(),
                        style: TextStyle(fontSize:
                        AdaptiveTextSize().getadaptiveTextSize(context, 15)),
                      textAlign: TextAlign.center,),


                  ],
                ),const SizedBox(
                  height: 15,
                ),
                Container(

                  child: Expanded(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                            color: Colors.white70,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: const ListTile(
                              leading: Icon(
                                Icons.privacy_tip_sharp,
                                color: Colors.black54,
                              ),
                              title: Text(
                                'Privacy',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            color: Colors.white70,
                            margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: const ListTile(
                              leading:
                              Icon(Icons.help_outline, color: Colors.black54),
                              title: Text(
                                'Help & Support',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            color: Colors.white70,
                            margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: const ListTile(
                              leading: Icon(
                                Icons.privacy_tip_sharp,
                                color: Colors.black54,
                              ),
                              title: Text(
                                'Settings',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios_outlined),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            color: Colors.white70,
                            margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: const ListTile(
                              leading: Icon(
                                Icons.add_reaction_sharp,
                                color: Colors.black54,
                              ),
                              title: Text(
                                'Invite a Friend',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            color: Colors.white70,
                            margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: const ListTile(
                              leading: Icon(
                                Icons.logout,
                                color: Colors.black54,
                              ),
                              title: Text(
                                'Logout',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios_outlined),
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ));
  }


    setImage(String url) {
      if(url!=null){
        return Image.network('${url.replaceAll("../", "http://stonemen.bsninfotech.org/")}');

      }else{
        return  null;
      }
    }
}
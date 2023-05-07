import 'dart:ffi';

class MeetingWithResponse {
  String? code;
String? name;
String? departmentName;
String? AuthorizedName;
String? FilterName;
String? GSMId;
int? UserId;
  MeetingWithResponse({
      required this.code,
      required this.name,
      required this.departmentName,
      required this.AuthorizedName,
      required this.FilterName,
      required this.UserId,
      required this.GSMId,


  });

  MeetingWithResponse.fromJson(dynamic json) {
    code = json['Code'];
    name = json['Name'];
    departmentName = json['DepartmentName'];
    AuthorizedName = json['AuthorizedName'];
    FilterName = json['FilterName'];
    UserId = json['UserId'];
    GSMId = json['GSMId'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Code'] = code;
    map['Name'] = name;
    map['DepartmentName'] = departmentName;
    map['AuthorizedName'] = AuthorizedName;
    map['FilterName'] = FilterName;
    map['UserId'] = UserId;
    map['GSMId'] = GSMId;
    return map;
  }

}
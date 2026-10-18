
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
    // Tolerant parsing: the API may send numbers as strings or vice versa.
    code = json['Code']?.toString();
    name = json['Name']?.toString();
    departmentName = json['DepartmentName']?.toString();
    AuthorizedName = json['AuthorizedName']?.toString();
    FilterName = json['FilterName']?.toString();
    UserId = int.tryParse('${json['UserId'] ?? ''}');
    GSMId = json['GSMId']?.toString();
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
class MeetingWithResponse {
  String? code;
String? name;
String? departmentName;
  MeetingWithResponse({
      required this.code,
      required this.name,
      required this.departmentName,});

  MeetingWithResponse.fromJson(dynamic json) {
    code = json['Code'];
    name = json['Name'];
    departmentName = json['DepartmentName'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Code'] = code;
    map['Name'] = name;
    map['DepartmentName'] = departmentName;
    return map;
  }

}
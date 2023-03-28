
 class ScheduleMeetingResponse {
  ScheduleMeetingResponse({
      required this.transId,
      required this.visitorName,
      required this.purposeId,
      required this.purposeName,
      required this.personListCode,
      required this.personName,
      required this.vDate,
      required this.meetingDate,
      required this.pVNo,
      required this.emailId,
      required this.mobileNo,});

  ScheduleMeetingResponse.fromJson(dynamic json) {
    transId = json['TransId'];
    visitorName = json['VisitorName'];
    purposeId = json['PurposeId'];
    purposeName = json['PurposeName'];
    personListCode = json['PersonListCode'];
    personName = json['PersonName'];
    vDate = json['VDate'];
    meetingDate = json['MeetingDate'];
    pVNo = json['PVNo'];
    emailId = json['EmailId'];
    mobileNo = json['MobileNo'];
  }
  String? transId;
  String? visitorName;
  int? purposeId;
  String? purposeName;
  String? personListCode;
  String? personName;
  String? vDate;
  String? meetingDate;
  String? pVNo;
  String? emailId;
  String? mobileNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TransId'] = transId;
    map['VisitorName'] = visitorName;
    map['PurposeId'] = purposeId;
    map['PurposeName'] = purposeName;
    map['PersonListCode'] = personListCode;
    map['PersonName'] = personName;
    map['VDate'] = vDate;
    map['MeetingDate'] = meetingDate;
    map['PVNo'] = pVNo;
    map['EmailId'] = emailId;
    map['MobileNo'] = mobileNo;
    return map;
  }

}
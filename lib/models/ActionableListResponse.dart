class ActionableListResponse {
  ActionableListResponse({
      required this.authPersionName,
      required this.transId,
      required this.photo,
      required this.visitorName,
      required this.purposeName,
      required this.physicalVisitorPassName,
      required this.govermentName,
      required this.vDate,
      required this.name,
      required this.meetingDate,
      required this.pVNo,
      required this.belongingCode,
      required this.belongingName,
      required this.emailId,
      required this.mobileNo,
      required this.status,
      required this.remark,});

  ActionableListResponse.fromJson(dynamic json) {
    authPersionName = json['AuthPersionName']??"";
    transId = json['TransId']??"";
    visitorName = json['VisitorName']??"";
    purposeName = json['PurposeName']??"";
    physicalVisitorPassName = json['PhysicalVisitorPassName']??"";
    govermentName = json['GovermentName']??"";
    vDate = json['VDate']??"";
    name = json['Name']??"";
    meetingDate = json['MeetingDate']??"";
    pVNo = json['PVNo']??"";
    belongingCode = json['BelongingCode']??"";
    belongingName = json['BelongingName']??"";
    emailId = json['EmailId']??"";
    mobileNo = json['MobileNo']??"";
    status = json['Status']??"";
    remark = json['Remark']??"";
    photo = json['Photo']??"";
  }
 late String authPersionName;
 late String transId;
 late String visitorName;
 late String purposeName;
 late String physicalVisitorPassName;
 late String govermentName;
 late String vDate;
 late String name;
 late String meetingDate;
 late String pVNo;
 late String belongingCode;
 late String belongingName;
 late String emailId;
 late String mobileNo;
 late String status;
 late String remark;
 late String photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AuthPersionName'] = authPersionName??"";
    map['TransId'] = transId??"";
    map['VisitorName'] = visitorName??"";
    map['PurposeName'] = purposeName??"";
    map['PhysicalVisitorPassName'] = physicalVisitorPassName??"";
    map['GovermentName'] = govermentName??"";
    map['VDate'] = vDate??"";
    map['Name'] = name??"";
    map['MeetingDate'] = meetingDate??"";
    map['PVNo'] = pVNo??"";
    map['BelongingCode'] = belongingCode??"";
    map['BelongingName'] = belongingName??"";
    map['EmailId'] = emailId??"";
    map['MobileNo'] = mobileNo??"";
    map['Status'] = status??"";
    map['Remark'] = remark??"";
    map['Photo'] = photo??"";
    return map;
  }

}
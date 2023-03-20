class LoginResponse {
  late int userId;
  late String userName;
  late int userTypeId;
  late String loginAs;
  late String lastLogin;
  late int activeAcademicYearId;
  late String activeAcademicYear;
  late int activeFinancialYearId;
  late String activeFinancialYear;
  late String displayCode;
  late int relationshipId;
  late int isHO;
  late int isSchool;
  late bool isCollege;
  late bool isSociety;
  late String branchLogo;
  late String groupCode;
  late String societyCode;
  late String schoolCode;
  late String branchCode;
  late String schoolName;
  late String schoolAddress;
  late String societyName;
  late dynamic schoolLiveWebSiteUrl;
  late dynamic schoolContactNo;
  late dynamic schoolEmailId;
  late dynamic bankFeePayMode;
  late dynamic chqInfavourof;
  late String profilePic;
  late String mobileNo;
  late String emailId;
  late String code;
  late String departmentCode;
  late String designationCode;
  late String designation;
  late String affiliationNo;
  late int affiliationDate;
  late String schoolStatus;
  late String schoolNo;
  late String srNo;
  late int state;
  late String response;

  LoginResponse({
     required this.userId,
     required this.userName,
     required this.userTypeId,
     required this.loginAs,
     required this.lastLogin,
     required this.activeAcademicYearId,
     required this.activeAcademicYear,
     required this.activeFinancialYearId,
     required this.activeFinancialYear,
     required this.displayCode,
     required this.relationshipId,
     required this.isHO,
     required this.isSchool,
     required this.isCollege,
     required this.isSociety,
     required this.branchLogo,
     required this.groupCode,
     required this.societyCode,
     required this.schoolCode,
     required this.branchCode,
     required this.schoolName,
     required this.schoolAddress,
     required this.societyName,
     required this.schoolLiveWebSiteUrl,
     required this.schoolContactNo,
     required this.schoolEmailId,
     required this.bankFeePayMode,
     required this.chqInfavourof,
     required this.profilePic,
     required this.mobileNo,
     required this.emailId,
     required this.code,
     required this.departmentCode,
     required this.designationCode,
     required this.designation,
     required this.affiliationNo,
     required this.affiliationDate,
     required this.schoolStatus,
     required this.schoolNo,
     required this.srNo,
     required this.state,
     required this.response,});

  LoginResponse.fromJson(dynamic json) {
    userId = json['UserId'];
    userName = json['UserName'];
    userTypeId = json['UserTypeId'];
    loginAs = json['loginAs'];
    lastLogin = json['LastLogin'];
    activeAcademicYearId = json['ActiveAcademicYearId'];
    activeAcademicYear = json['ActiveAcademicYear'];
    activeFinancialYearId = json['ActiveFinancialYearId'];
    activeFinancialYear = json['ActiveFinancialYear'];
    displayCode = json['DisplayCode'];
    relationshipId = json['RelationshipId'];
    isHO = json['IsHO'];
    isSchool = json['IsSchool'];
    isCollege = json['IsCollege'];
    isSociety = json['IsSociety'];
    branchLogo = json['BranchLogo'];
    groupCode = json['GroupCode'];
    societyCode = json['SocietyCode'];
    schoolCode = json['SchoolCode'];
    branchCode = json['BranchCode'];
    schoolName = json['SchoolName'];
    schoolAddress = json['SchoolAddress'];
    societyName = json['SocietyName'];
    schoolLiveWebSiteUrl = json['SchoolLiveWebSiteUrl'];
    schoolContactNo = json['SchoolContactNo'];
    schoolEmailId = json['SchoolEmailId'];
    bankFeePayMode = json['BankFeePayMode'];
    chqInfavourof = json['ChqInfavourof'];
    profilePic = json['ProfilePic'];
    mobileNo = json['MobileNo'];
    emailId = json['EmailId'];
    code = json['Code'];
    departmentCode = json['DepartmentCode'];
    designationCode = json['DesignationCode'];
    designation = json['Designation'];
    affiliationNo = json['AffiliationNo'];
    affiliationDate = json['AffiliationDate'];
    schoolStatus = json['SchoolStatus'];
    schoolNo = json['SchoolNo'];
    srNo = json['SrNo'];
    state = json['State'];
    response = json['Response'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['UserId'] = userId;
    map['UserName'] = userName;
    map['UserTypeId'] = userTypeId;
    map['loginAs'] = loginAs;
    map['LastLogin'] = lastLogin;
    map['ActiveAcademicYearId'] = activeAcademicYearId;
    map['ActiveAcademicYear'] = activeAcademicYear;
    map['ActiveFinancialYearId'] = activeFinancialYearId;
    map['ActiveFinancialYear'] = activeFinancialYear;
    map['DisplayCode'] = displayCode;
    map['RelationshipId'] = relationshipId;
    map['IsHO'] = isHO;
    map['IsSchool'] = isSchool;
    map['IsCollege'] = isCollege;
    map['IsSociety'] = isSociety;
    map['BranchLogo'] = branchLogo;
    map['GroupCode'] = groupCode;
    map['SocietyCode'] = societyCode;
    map['SchoolCode'] = schoolCode;
    map['BranchCode'] = branchCode;
    map['SchoolName'] = schoolName;
    map['SchoolAddress'] = schoolAddress;
    map['SocietyName'] = societyName;
    map['SchoolLiveWebSiteUrl'] = schoolLiveWebSiteUrl;
    map['SchoolContactNo'] = schoolContactNo;
    map['SchoolEmailId'] = schoolEmailId;
    map['BankFeePayMode'] = bankFeePayMode;
    map['ChqInfavourof'] = chqInfavourof;
    map['ProfilePic'] = profilePic;
    map['MobileNo'] = mobileNo;
    map['EmailId'] = emailId;
    map['Code'] = code;
    map['DepartmentCode'] = departmentCode;
    map['DesignationCode'] = designationCode;
    map['Designation'] = designation;
    map['AffiliationNo'] = affiliationNo;
    map['AffiliationDate'] = affiliationDate;
    map['SchoolStatus'] = schoolStatus;
    map['SchoolNo'] = schoolNo;
    map['SrNo'] = srNo;
    map['State'] = state;
    map['Response'] = response;
    return map;
  }

}
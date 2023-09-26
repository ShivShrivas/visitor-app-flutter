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


 LoginResponse(
      this.userId,
      this.userName,
      this.userTypeId,
      this.loginAs,
      this.lastLogin,
      this.activeAcademicYearId,
      this.activeAcademicYear,
      this.activeFinancialYearId,
      this.activeFinancialYear,
      this.displayCode,
      this.relationshipId,
      this.isHO,
      this.isSchool,
      this.isCollege,
      this.isSociety,
      this.branchLogo,
      this.groupCode,
      this.societyCode,
      this.schoolCode,
      this.branchCode,
      this.schoolName,
      this.schoolAddress,
      this.societyName,
      this.schoolLiveWebSiteUrl,
      this.schoolContactNo,
      this.schoolEmailId,
      this.bankFeePayMode,
      this.chqInfavourof,
      this.profilePic,
      this.mobileNo,
      this.emailId,
      this.code,
      this.departmentCode,
      this.designationCode,
      this.designation,
      this.affiliationNo,
      this.affiliationDate,
      this.schoolStatus,
      this.schoolNo,
      this.srNo,
      this.state,
      this.response);



  LoginResponse.fromJson(dynamic json) {
    userId = json['UserId']??0;
    userName = json['UserName']??"";
    userTypeId = json['UserTypeId']??0;
    loginAs = json['loginAs']??"";
    lastLogin = json['LastLogin']??"";
    activeAcademicYearId = json['ActiveAcademicYearId']??0;
    activeAcademicYear = json['ActiveAcademicYear']??'';
    activeFinancialYearId = json['ActiveFinancialYearId']??0;
    activeFinancialYear = json['ActiveFinancialYear']??"";
    displayCode = json['DisplayCode'];
    relationshipId = json['RelationshipId']??0;
    isHO = json['IsHO']??0;
    isSchool = json['IsSchool']??0;
    isCollege = json['IsCollege']??false;
    isSociety = json['IsSociety']??false;
    branchLogo = json['BranchLogo']??"";
    groupCode = json['GroupCode']??"";
    societyCode = json['SocietyCode']??"";
    schoolCode = json['SchoolCode']??"";
    branchCode = json['BranchCode']??"";
    schoolName = json['SchoolName']??"";
    schoolAddress = json['SchoolAddress']??"";
    societyName = json['SocietyName']??"";
    schoolLiveWebSiteUrl = json['SchoolLiveWebSiteUrl'];
    schoolContactNo = json['SchoolContactNo'];
    schoolEmailId = json['SchoolEmailId'];
    bankFeePayMode = json['BankFeePayMode'];
    chqInfavourof = json['ChqInfavourof'];
    profilePic = json['ProfilePic']??"";
    mobileNo = json['MobileNo']??"";
    emailId = json['EmailId']??"";
    code = json['Code']??"";
    departmentCode = json['DepartmentCode']??"";
    designationCode = json['DesignationCode']??"";
    designation = json['Designation']??"";
    affiliationNo = json['AffiliationNo']??"";
    affiliationDate = json['AffiliationDate']??0;
    schoolStatus = json['SchoolStatus']??"";
    schoolNo = json['SchoolNo']??"";
    srNo = json['SrNo']??"";
    state = json['State']??0;
    response = json['Response']??"";
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
    map['BranchLogo'] = branchLogo??"";
    map['GroupCode'] = groupCode??"";
    map['SocietyCode'] = societyCode??"";
    map['SchoolCode'] = schoolCode??"";
    map['BranchCode'] = branchCode??"";
    map['SchoolName'] = schoolName??"";
    map['SchoolAddress'] = schoolAddress??"";
    map['SocietyName'] = societyName??"";
    map['SchoolLiveWebSiteUrl'] = schoolLiveWebSiteUrl;
    map['SchoolContactNo'] = schoolContactNo;
    map['SchoolEmailId'] = schoolEmailId;
    map['BankFeePayMode'] = bankFeePayMode;
    map['ChqInfavourof'] = chqInfavourof;
    map['ProfilePic'] = profilePic;
    map['MobileNo'] = mobileNo??"";
    map['EmailId'] = emailId??"";
    map['Code'] = code??"";
    map['DepartmentCode'] = departmentCode??"";
    map['DesignationCode'] = designationCode??"";
    map['Designation'] = designation??"";
    map['AffiliationNo'] = affiliationNo??"";
    map['AffiliationDate'] = affiliationDate??"";
    map['SchoolStatus'] = schoolStatus??"";
    map['SchoolNo'] = schoolNo??"";
    map['SrNo'] = srNo??"";
    map['State'] = state??"";
    map['Response'] = response??"";
    return map;
  }

}
// ============================================================================
// TEMPORARY LOGIN BYPASS  —  REMOVE WHEN THE LOGIN API IS FIXED
// ----------------------------------------------------------------------------
// While kBypassLogin is true, tapping "Login" skips the UserAuthentication API
// and signs in with the mock user below, so the UI can be designed/tested.
//
// To remove the bypass later:
//   1. Set kBypassLogin = false (or delete this file), and
//   2. Delete the "TEMP LOGIN BYPASS" block at the top of logIn() in
//      MyHomePage.dart and its import of 'Utils/DevConfig.dart'.
//   3. Log out once (or clear app data) so the saved mock user is dropped.
// ============================================================================

import '../models/LoginResponse.dart';


const bool kBypassLogin = true;

LoginResponse mockLoginResponse() {
  return LoginResponse.fromJson({
    'UserId': 1,
    'UserName': 'SAdmin (Demo)',
    'UserTypeId': 1,
    'loginAs': 'Admin',
    'LastLogin': '18/10/2026 10:00 AM',
    'ActiveAcademicYearId': 1,
    'ActiveAcademicYear': '2026-27',
    'ActiveFinancialYearId': 1,
    'ActiveFinancialYear': '2026-27',
    'DisplayCode': 'RAMFAG',
    'RelationshipId': 1,
    'IsHO': 0,
    'IsSchool': 1,
    'IsCollege': false,
    'IsSociety': false,
    'BranchLogo': '',
    'GroupCode': '01',
    'SocietyCode': '002',
    'SchoolCode': '',
    'BranchCode': '',
    'SchoolName': 'Demo School',
    'SchoolAddress': 'Demo Address, City',
    'SocietyName': 'Demo Society',
    'ProfilePic': '',
    'MobileNo': '9999999999',
    'EmailId': 'demo@example.com',
    'Code': '',
    'DepartmentCode': '',
    'DesignationCode': '',
    'Designation': 'Administrator',
    'AffiliationNo': '',
    'AffiliationDate': 0,
    'SchoolStatus': '',
    'SchoolNo': '',
    'SrNo': '',
    'State': 0,
    'Response': 'Success',
  });
}

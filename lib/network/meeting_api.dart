import 'dart:async';
import 'dart:convert';

import 'api_logger.dart';
import 'package:intl/intl.dart';

import '../models/ActionableListResponse.dart';
import '../models/ScheduleMeetingResponse.dart';

/// All meeting-list API calls in one place.
/// Request bodies are unchanged from the original screens.
class MeetingApi {
  MeetingApi._();

  static final DateFormat apiDate = DateFormat('dd-MM-yyyy');

  static Future<List<dynamic>> _postForList(
      String url, Map<String, dynamic> body) async {
    final response = await apiClient
        .post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(body),
          encoding: Encoding.getByName('utf-8'),
        );
    final decoded = json.decode(response.body);
    if (decoded is List) return decoded;
    throw Exception('Unexpected response: ${response.statusCode}');
  }

  static Future<List<ActionableListResponse>> actionable(
      int relationShipId, int userId, String fromDate, String toDate) async {
    final data = await _postForList(
      'http://stonemen.bsninfotech.org/Api/VisitorTransactionApi/GetVisitorList',
      {
        "Action": 15,
        "FYId": 1,
        "FromDate": fromDate,
        "UserId": userId.toString(),
        "PurposeId": "",
        "ToDate": toDate,
        "SessionId": 1,
        "RelationshipId": relationShipId.toString()
      },
    );
    return data.map((e) => ActionableListResponse.fromJson(e)).toList();
  }

  static Future<List<ScheduleMeetingResponse>> _report(String url, int action,
      int statusId, int relationShipId, int userId, String fromDate,
      String toDate) async {
    final data = await _postForList(url, {
      "Action": action,
      "StatusId": statusId,
      "FromDate": fromDate,
      "ToDate": toDate,
      "userId": userId,
      "SessionId": "1",
      "FYId": "1",
      "RelationshipId": relationShipId.toString()
    });
    return data.map((e) => ScheduleMeetingResponse.fromJson(e)).toList();
  }

  static Future<List<ScheduleMeetingResponse>> ongoing(
          int relationShipId, int userId, String fromDate, String toDate) =>
      _report(
          'https://stonemen.bsninfotech.org/Api/VisitorTransactionApi/MeetingReport',
          21, 1, relationShipId, userId, fromDate, toDate);

  static Future<List<ScheduleMeetingResponse>> scheduled(
          int relationShipId, int userId, String fromDate, String toDate) =>
      _report(
          'http://stonemen.bsninfotech.org/Api/VisitorDashBoardApi/GetScheduleMeetingMeeting',
          9, 1, relationShipId, userId, fromDate, toDate);

  static Future<List<ScheduleMeetingResponse>> completed(
          int relationShipId, int userId, String fromDate, String toDate) =>
      _report(
          'https://stonemen.bsninfotech.org/Api/VisitorTransactionApi/MeetingReport',
          13, 2, relationShipId, userId, fromDate, toDate);
}

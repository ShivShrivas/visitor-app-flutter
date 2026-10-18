class PurposeResponse {
  int? code;
  String? purposeName;

  PurposeResponse({this.code, this.purposeName});

  PurposeResponse.fromJson(Map<String, dynamic> json) {
    code = int.tryParse('${json['Code'] ?? ''}');
    purposeName = json['PurposeName']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['PurposeName'] = this.purposeName;
    return data;
  }
}
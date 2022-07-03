import 'dart:convert';

class GetScheduleApiResponse {
  final String? msg;
  var errors;
  final bool? success;
  final List<ScheduleDetails>? data;

  GetScheduleApiResponse({
    this.data,
    this.errors,
    this.msg,
    this.success,
  });

  factory GetScheduleApiResponse.fromJson(String str) =>
      GetScheduleApiResponse.fromMap(jsonDecode(str));

  factory GetScheduleApiResponse.fromMap(Map<String, dynamic> json) =>
      GetScheduleApiResponse(
          data: json['data'] == null
              ? null
              : List<ScheduleDetails>.from(
                  json["data"].map((x) => ScheduleDetails.fromMap(x))),
          errors: json['errors'] == null ? null : json['errors'],
          msg: json['msg'] == null ? null : json['msg'],
          success: json['success'] == null ? null : json['success']);
}

class ScheduleDetails {
  final String? id;
  final String? name;
  final String? startTime;
  final String? endTime;
  final String? date;

  ScheduleDetails({
    this.id,
    this.name,
    this.startTime,
    this.endTime,
    this.date,
  });

  factory ScheduleDetails.fromJson(String str) =>
      ScheduleDetails.fromMap(jsonDecode(str));

  factory ScheduleDetails.fromMap(Map<String, dynamic> json) => ScheduleDetails(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        endTime: json["startTime"] == null ? null : json["startTime"],
        startTime: json["endTime"] == null ? null : json["endTime"],
        date: json["date"] == null ? null : json["date"],
      );
}

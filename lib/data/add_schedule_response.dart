import 'dart:convert';

class AddScheduleResponse {
  final String? msg;
  List errors;
  final bool? success;
  final Map<String, dynamic>? data;

  AddScheduleResponse(
      {required this.data,
      required this.errors,
      required this.msg,
      required this.success});

  factory AddScheduleResponse.fromJson(String str) =>
      AddScheduleResponse.fromMap(jsonDecode(str));

  factory AddScheduleResponse.fromMap(Map<String, dynamic> json) =>
      AddScheduleResponse(
          data: json['data'] == null ? null : json['data'],
          errors: json['errors'] == null ? null : json['errors'],
          msg: json['msg'] == null ? null : json['msg'],
          success: json['success'] == null ? null : json['success']);
}

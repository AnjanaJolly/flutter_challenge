import 'dart:convert';

class AddScheduleRequest {
  String? name;
  String? startTime;
  String? endTime;
  String? date;
  AddScheduleRequest(
      {required this.name,
      required this.date,
      required this.startTime,
      required this.endTime});

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "date": date == null ? null : date,
        "startTime": startTime == null ? null : startTime,
        "endTime": endTime == null ? null : endTime,
      };
}

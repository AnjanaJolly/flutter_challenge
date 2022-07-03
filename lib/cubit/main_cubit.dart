import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/data/add_schedule_request.dart';
import 'package:flutter_challenge/data/add_schedule_response.dart';
import 'package:flutter_challenge/data/get_schedules_response.dart';
import 'package:intl/intl.dart';

import '../utils/app_utils.dart';
import 'main_cubit_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit([MainState? initialState])
      : super(initialState ?? GetSchedulesInitialState());
  List<ScheduleDetails> schedules = [];
  final client = Dio();

  var dailySchedules;

  List<ScheduleDetails> getDailySchedules(String date) {
    dailySchedules =
        schedules.where((element) => element.date == date).toList();
    // dailySchedules.sort((a, b) => AppUtils.parseTime(
    //         DateFormat.jm().format(DateFormat("hh:mm:ss").parse(a.startTime!)))
    //     .compareTo(AppUtils.parseTime(DateFormat.jm()
    //         .format(DateFormat("hh:mm:ss").parse(b.startTime!)))));
    return dailySchedules;
  }

  Future getSchedues() async {
    emit(LoadingState());
    try {
      final response = await client.getUri(
          Uri.parse('https://alpha.classaccess.io/api/challenge/v1/schedule/'));

      if (response.statusCode == 200) {
        print(jsonDecode(response.toString()));
        emit(GetSchedulesMainState());
        schedules = GetScheduleApiResponse.fromJson(response.toString()).data!;
        print(schedules);
        return schedules;
      } else {
        emit(GetScheduleFailureState(msg: response.data));

        return response;
      }
    } catch (e) {
      emit(GetScheduleFailureState(msg: e.toString()));
    }
  }

  Future addSchedule(
      {String? name, String? date, String? startTime, String? endTime}) async {
    emit(LoadingState());
    try {
      var payLoad = AddScheduleRequest(
          name: name, date: date, startTime: startTime, endTime: endTime);

      var response = await client.post(
          'https://alpha.classaccess.io/api/challenge/v1/save/schedule/',
          data: payLoad.toJson());
      if (response.statusCode == 200) {
        print(response.data);
        var data = AddScheduleResponse.fromJson(response.toString());
        emit(AddScheduleSuccessState(msg: data.msg!));
      } else {
        emit(
          AddScheduleFailureState(
              msg: AddScheduleResponse.fromJson(response.data).msg!),
        );
      }
    } catch (error) {
      emit(AddScheduleFailureState(msg: 'Bad Request'));
      print(error);
    }
  }
}

import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {}

class GetSchedulesInitialState extends MainState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoadingState extends MainState {
  LoadingState();

  @override
  List<Object?> get props => [];
}

class GetSchedulesMainState extends MainState {
  final int time;
  final int status;
  final String msg;

  GetSchedulesMainState({this.time = 0, this.status = -1, this.msg = ""});

  GetSchedulesMainState copyWith({
    final int? status,
    final String? msg,
  }) {
    return GetSchedulesMainState(
      time: DateTime.now().millisecondsSinceEpoch,
      status: status ?? this.status,
      msg: msg ?? this.msg,
    );
  }

  @override
  List<Object?> get props => [time, status, msg];
}

class GetScheduleFailureState extends MainState {
  final String msg;

  GetScheduleFailureState({this.msg = ""});
  @override
  List<Object?> get props => [msg];
}

class AddScheduleFailureState extends MainState {
  final String msg;

  AddScheduleFailureState({this.msg = ''});

  @override
  List<Object?> get props => [msg];
}

class AddScheduleSuccessState extends MainState {
  final String msg;
  AddScheduleSuccessState({this.msg = ''});
  @override
  List<Object?> get props => [msg];
}

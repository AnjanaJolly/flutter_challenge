import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/cubit/main_cubit.dart';
import 'package:flutter_challenge/cubit/main_cubit_state.dart';
import 'package:flutter_challenge/utils/app_loader.dart';
import 'package:flutter_challenge/widgets/add_schedule_widget.dart';
import 'package:flutter_challenge/widgets/alert_dialog.dart';
import 'package:flutter_challenge/widgets/app_widgets.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  var client = Dio();
  TextEditingController nameController = TextEditingController();
  final GlobalKey<ScaffoldState> _modelScaffoldKey = GlobalKey<ScaffoldState>();
  late MainCubit _cubit;
  DateTime now = DateTime.now();
  String? _selectedTime;
  var selectedDate;
  var fromDate;
  var toDate;
  DateTime? _dateTime;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  var weekdays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];
  AppLoader appLoader = AppLoader();

  @override
  void initState() {
    _dateTime = DateTime.now();
    _startTime = TimeOfDay.now();
    _endTime = TimeOfDay.now();
    _cubit = context.read<MainCubit>();
    _cubit.dailySchedules = [];
    _cubit.getSchedues().then((value) =>
        _cubit.getDailySchedules(DateFormat('dd/MM/yyyy').format(now)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingButton(),
        body: BlocListener<MainCubit, MainState>(
          listener: (context, state) {
            if (state is LoadingState) {
              appLoader.show(context);
              return;
            } else if (state is GetSchedulesMainState) {
              appLoader.hide(context);
            } else if (state is GetScheduleFailureState) {
              appLoader.hide(context);
              BotToast.showText(text: state.msg);
            } else if (state is AddScheduleSuccessState) {
              appLoader.hide(context);
              Navigator.of(context).pop();
              _cubit.getSchedues();
              BotToast.showText(text: state.msg);
            } else if (state is AddScheduleFailureState) {
              appLoader.hide(context);
              BotToast.showText(text: state.msg);
            }
          },
          child: BlocBuilder<MainCubit, MainState>(
            builder: (context, state) {
              return body();
            },
          ),
        ),
      ),
    );
  }

  Widget FloatingButton() => FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext ctx) {
              return AddScheduleWidget(
                cubit: _cubit,
                nameController: nameController,
                startTime: _startTime?.format(context) ??
                    TimeOfDay.now().format(context),
                endTime: _endTime?.format(context) ??
                    TimeOfDay.now().format(context),
                date: _dateTime,
              );
            },
          );
        },
        child: const Icon(Icons.add),
      );

  Widget body() {
    return SingleChildScrollView(
        child: Column(
            //
            children: [
          Container(
            margin: EdgeInsets.only(top: 25, left: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppWidgets.text(
                    string: DateFormat.yMMMM().format(now).toUpperCase(),
                    weight: FontWeight.w600,
                    textColor: Colors.black,
                    size: 22),
                const SizedBox(height: 16.0),
                getWeekView(),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          getDailySchedules,
        ]));
  }

  get getDailySchedules => Container(
        padding: EdgeInsets.only(top: 27, left: 39, bottom: 40),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppWidgets.scheduleBackground),
        width: double.infinity,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _cubit.dailySchedules.length,
            itemBuilder: (BuildContextctx, int i) {
              var item = _cubit.dailySchedules[i];
              var startTime = item.startTime == null
                  ? ''
                  : item.startTime.contains('M')
                      ? item.startTime.toString()
                      : DateFormat.jm().format(
                          DateFormat("hh:mm:ss").parse(item.startTime!));
              var endTime = item.endTime == null
                  ? ''
                  : item.endTime.contains('M')
                      ? item.endTime.toString()
                      : DateFormat.jm()
                          .format(DateFormat("hh:mm:ss").parse(item.endTime!));

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppWidgets.ScheduleWidget('$startTime - $endTime',
                      item.name == null ? '' : item.name!),
                  const SizedBox(
                    height: 20,
                  )
                ],
              );
            }),
      );

  getWeekView() {
    if (fromDate == null) {
      DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
      fromDate = getDate(now.subtract(Duration(days: now.weekday - 1)));
      toDate =
          getDate(now.add(Duration(days: DateTime.daysPerWeek - now.weekday)));
      selectedDate = DateTime(now.year, now.month, now.day);
    }

    getDate(String day, String date, bool isSelected,
        Function(DateTime) callback, DateTime dateTime) {
      return Expanded(
        child: InkWell(
          onTap: () => callback(dateTime),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppWidgets.text(
                string: day,
                weight: FontWeight.w500,
                textColor: Colors.black,
                size: 12,
              ),
              const SizedBox(height: 4),
              Container(
                height: 31,
                width: 31,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppWidgets.themeBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(44.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 9),
                child: AppWidgets.text(
                  string: date,
                  weight: FontWeight.w600,
                  textColor:
                      isSelected ? AppWidgets.backgroundColor : Colors.black,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<Widget> widgets = [];
    for (var date1 = fromDate;
        date1.millisecondsSinceEpoch <= toDate.millisecondsSinceEpoch;
        date1 = date1.add(Duration(days: 1))) {
      widgets.add(getDate(
        weekdays[date1.weekday - 1],
        "${date1.day}",
        date1.day == selectedDate.day,
        (dateTime) {
          // clicked
          if (selectedDate.day == dateTime.day) {
            return;
          }
          selectedDate = dateTime;
          _cubit
              .getDailySchedules(DateFormat('dd/MM/yyyy').format(selectedDate));
          setState(() {});
        },
        date1,
      ));
    }

    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: widgets,
      ),
    );
  }
}

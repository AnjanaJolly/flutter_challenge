import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/cubit/main_cubit.dart';
import 'package:intl/intl.dart';

import 'alert_dialog.dart';
import 'app_widgets.dart';

class AddScheduleWidget extends StatefulWidget {
  TextEditingController nameController = TextEditingController();
  String? startTime;
  String? endTime;
  DateTime? date;
  MainCubit cubit;
  AddScheduleWidget(
      {Key? key,
      required this.nameController,
      required this.endTime,
      required this.startTime,
      required this.cubit,
      required this.date})
      : super(key: key);

  @override
  State<AddScheduleWidget> createState() => _AddScheduleWidgetState();
}

class _AddScheduleWidgetState extends State<AddScheduleWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: StatefulBuilder(builder: (context, StateSetter setState) {
        return Container(
            padding: EdgeInsets.only(top: 28, left: 25, right: 16, bottom: 45),
            width: double.infinity,
            color: AppWidgets.backgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                addScheduleHeader,
                const SizedBox(
                  height: 30,
                ),
                nameTextField(setState),
                const SizedBox(
                  height: 20,
                ),
                dateTimeSelector,
                const SizedBox(
                  height: 20,
                ),
                AppWidgets.Button(
                    onPressed: widget.nameController.text.trim().isEmpty
                        ? () {
                            print('snack');
                            BotToast.showText(text: 'Name can\'t be empty');
                          }
                        : () {
                            checkSchedules(
                                    DateFormat('dd/MM/yyyy')
                                        .format(widget.date!),
                                    timeFormatter(context, widget.startTime),
                                    timeFormatter(context, widget.endTime))
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext c) {
                                      return CustomAlertDialog();
                                    })
                                : (getTimeDifference(
                                            DateFormat.jm()
                                                .parse(widget.startTime!),
                                            DateFormat.jm()
                                                .parse(widget.endTime!)) ==
                                        false)
                                    ? BotToast.showText(
                                        text:
                                            'EndTime should be greater than start time')
                                    : widget.cubit
                                        .addSchedule(
                                            name: widget.nameController.text,
                                            date: DateFormat('dd/MM/yyyy')
                                                .format(widget.date!),
                                            startTime: timeFormatter(
                                                context, widget.startTime),
                                            endTime: timeFormatter(
                                                context, widget.endTime))
                                        .then((value) {
                                        widget.cubit.getDailySchedules(
                                          DateFormat('dd/MM/yyyy')
                                              .format(widget.date!),
                                        );
                                        setState(() {});
                                      });
                          },
                    label: 'Add Schedule'),
              ],
            ));
      }),
    );
  }

  bool getTimeDifference(startTime, endTime) {
    bool result = false;
    int startTimeInt = (startTime.hour * 60 + startTime.minute) * 60;
    int EndTimeInt = (endTime.hour * 60 + endTime.minute) * 60;
    int dif = EndTimeInt - startTimeInt;

    if (EndTimeInt > startTimeInt) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  timeFormatter(context, time) {
    DateTime parsedTime = DateFormat.jm().parse(time);

    String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
    print(formattedTime);
    return formattedTime;
    //output 14:59:00
  }

  checkSchedules(date, start, end) {
    print('checking');
    bool alreadyScheduled = false;
    var list = widget.cubit.getDailySchedules(date);
    for (var i in list) {
      if (i.startTime == start || i.endTime == end) {
        alreadyScheduled = true;
        break;
      } else {
        alreadyScheduled = false;
        break;
      }
    }
    print(alreadyScheduled);
    return alreadyScheduled;
  }

  Widget get dateTimeSelector => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgets.text(
              string: 'Date & time',
              weight: FontWeight.w500,
              textColor: Colors.black,
              size: 13),
          const SizedBox(
            height: 4,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppWidgets.textFieldBackground),
            padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
            child: Column(
              children: [
                timeSelector(
                  'Start Time',
                  widget.startTime ?? TimeOfDay.now().format(context),
                  () async {
                    final TimeOfDay? result = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (result != null) {
                      setState(() {
                        widget.startTime = result.format(context);
                        print(widget.startTime);
                      });
                    }
                  },
                ),
                seperator,
                timeSelector(
                  'End Time',
                  widget.endTime ?? TimeOfDay.now().format(context),
                  () async {
                    final TimeOfDay? result = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (result != null) {
                      setState(() {
                        widget.endTime = result.format(context);
                      });
                    }
                  },
                ),
                seperator,
                timeSelector(
                    'Date',
                    DateFormat('dd/MM/yyyy')
                        .format(widget.date ?? DateTime.now()), () async {
                  final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: widget.date!,
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101));
                  if (picked != null && picked != widget.date) {
                    setState(() {
                      widget.date = picked;
                    });
                  }
                })
              ],
            ),
          ),
        ],
      );

  Widget get seperator => Container(
        margin: EdgeInsets.only(top: 15, bottom: 15),
        height: .5,
        width: double.infinity,
        color: Colors.grey,
      );

  Widget timeSelector(label, displayTime, void Function()? onTap) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppWidgets.text(
              string: label,
              weight: FontWeight.w400,
              textColor: Colors.black,
              size: 14),
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                AppWidgets.text(
                    string: displayTime ?? '',
                    weight: FontWeight.w400,
                    textColor: AppWidgets.themeBlue,
                    size: 16),
                const Icon(Icons.keyboard_arrow_right),
                const SizedBox(
                  height: 13,
                )
              ],
            ),
          )
        ],
      );

  Widget get addScheduleHeader =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        AppWidgets.text(
            string: 'Add Schedule',
            weight: FontWeight.w500,
            textColor: const Color.fromRGBO(5, 77, 185, 1),
            size: 16),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.close, color: Color.fromRGBO(50, 50, 50, 1)),
        ),
      ]);

  Widget nameTextField(setter) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgets.text(
              string: 'Name',
              weight: FontWeight.w500,
              textColor: Colors.black,
              size: 13),
          const SizedBox(
            height: 4,
          ),
          AppWidgets.textField(
            onChanged: (v) {
              setter(() {});
            },
            controller: widget.nameController,
            keyboardType: TextInputType.name,
          ),
        ],
      );
}

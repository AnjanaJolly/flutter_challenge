import 'package:flutter/material.dart';

import 'app_widgets.dart';

class CustomAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppWidgets.backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 2,
            spreadRadius: 2,
            color: Colors.black26,
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      width: 311,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgets.text(
                string:
                    'This overlaps with another schedule and can’t be saved.',
                weight: FontWeight.w600,
                textColor: AppWidgets.redAccent,
                size: 25),
            const SizedBox(
              height: 5,
            ),
            AppWidgets.text(
                string: 'Please modify and try again.',
                weight: FontWeight.w500,
                textColor: AppWidgets.themeBlue,
                size: 18),
            const SizedBox(
              height: 5,
            ),
            AppWidgets.Button(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: 'Okay')
          ]),
    );

    //  AlertDialog(
    //   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    //   title: AppWidgets.text(
    //       string: 'This overlaps another schedule and can\'t be saved',
    //       weight: FontWeight.w600,
    //       textColor: AppWidgets.redAccent,
    //       size: 22),
    //   content: AppWidgets.text(
    //       string: 'Please modify and try again',
    //       weight: FontWeight.w500,
    //       textColor: AppWidgets.themeBlue,
    //       size: 16),
    //   backgroundColor: AppWidgets.backgroundColor,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
    //   insetPadding: EdgeInsets.all(20),
    //   titlePadding: EdgeInsets.fromLTRB(20, 16, 20, 0),
    //   buttonPadding: EdgeInsets.zero,
    //   actionsPadding: EdgeInsets.all(16),
    //   actionsAlignment: MainAxisAlignment.center,
    //   actions: [
    //     AppWidgets.Button(
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //         },
    //         label: 'Okay')
    //   ],
    // );
  }
}

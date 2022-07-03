import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppWidgets {
  static const Color backgroundColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color themeBlue = Color.fromRGBO(47, 128, 237, 1);
  static const Color scheduleBlue = Color.fromRGBO(187, 222, 251, 1);
  static const Color textFieldBackground = Color.fromRGBO(229, 239, 255, 1);
  static const Color scheduleBackground = Color.fromRGBO(245, 245, 245, 1);
  static const redAccent = Color(0xFFE53935);

  static Widget text({
    required String string,
    required FontWeight weight,
    required Color textColor,
    required double size,
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
  }) {
    return Text(
      string,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.clip,
      style: TextStyle(
        color: textColor,
        fontSize: size,
        fontFamily: 'Euclid Circular B',
        fontWeight: weight,
        overflow: TextOverflow.clip,
      ),
    );
  }

  static Widget textField(
      {required TextEditingController controller,
      required TextInputType keyboardType,
      bool enabled = true,
      bool autofocus = false,
      List<TextInputFormatter>? inputFormatter,
      TextInputAction? textInputAction,
      Color borderColor = Colors.transparent,
      TextStyle? textStyle,
      TextStyle? hintTextStyle,
      double height = 48,
      void Function(String)? onChanged}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: AppWidgets.textFieldBackground,
              // color: backgroundColor,
              border:
                  Border.all(color: borderColor, width: 1), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(3.0)), // set rounded corner radius
            ),
            child: TextFormField(
              onChanged: onChanged,
              enabled: enabled,
              autofocus: autofocus,
              controller: controller,

              textInputAction: textInputAction,
              // maxLines: isObscureText ? 1 : null,
              style: textStyle ??
                  const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Euclid Circular B',
                  ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget ScheduleWidget(String time, String schedule) {
    return Row(
      children: [
        SizedBox(
          height: 74,
          width: 55,
          child: Stack(children: [
            Container(
              padding: EdgeInsets.only(top: 27, left: 30),
              decoration: BoxDecoration(
                  color: AppWidgets.scheduleBlue,
                  borderRadius: BorderRadius.circular(30)),
            ),
            const Center(
              child: Icon(
                Icons.today,
                color: Colors.blue,
              ),
            )
          ]),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppWidgets.text(
                string: time,
                weight: FontWeight.w500,
                textColor: Color.fromRGBO(66, 66, 66, 1),
                size: 18),
            AppWidgets.text(
                string: schedule,
                weight: FontWeight.w500,
                textColor: Color.fromRGBO(33, 33, 33, 1),
                size: 22)
          ],
        )
      ],
    );
  }

  static void snackBar(String message, BuildContext scaffoldContext) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(snackBar);
  }

  static Widget Button(
      {required void Function()? onPressed, required String label}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 56),
          elevation: 0,
          primary: AppWidgets.themeBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
        ),
        onPressed: onPressed,
        child: AppWidgets.text(
            string: label,
            weight: FontWeight.w500,
            textColor: AppWidgets.backgroundColor,
            size: 18));
  }
}

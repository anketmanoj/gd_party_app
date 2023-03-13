import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return "$date";
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return "$time";
  }
}

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.lines,
    required this.onSubmit,
    this.prefixIcon,
    this.hide,
    this.suffixIcon,
    this.showPrefixText,
    this.showHintText,
    this.keyboardTypeVal,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final int? lines;
  final Function(String) onSubmit;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? hide;
  final String? showPrefixText;
  final String? showHintText;
  final TextInputType? keyboardTypeVal;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onSubmit,
      obscureText: hide ?? false,
      maxLines: lines ?? 1,
      textAlign: TextAlign.start,
      keyboardType: keyboardTypeVal ?? TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        prefixText: showPrefixText,
        hintText: showHintText,
        hintStyle: TextStyle(
          fontSize: 10,
        ),
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      style: TextStyle(color: Colors.black),
      validator: validator ??
          (val) {
            return null;
          },
    );
  }
}

class SubmitButton extends StatelessWidget {
  void Function()? function;
  String text;
  Color color;

  SubmitButton({
    Key? key,
    required this.function,
    this.color = Colors.black,
    this.text = "Submit",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

Widget customTextFormField(context, controller, void validator(String input), void onSaved(String input), hintText, Widget icon, bool isObscure) {
  return TextFormField(
    controller: controller,
    validator: validator,
    onSaved: onSaved,
    decoration: InputDecoration(
      hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 3,
        ),
      ),
      prefixIcon: Padding(
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).primaryColor),
          child: icon,
        ),
        padding: EdgeInsets.only(left: 30, right: 10),
      )
    ),
    obscureText: isObscure,
  );
}
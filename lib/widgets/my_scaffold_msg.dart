import 'package:flutter/material.dart';
import 'package:voice_recorder/widgets/project_constants.dart';

showSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: snackSuccessTextColor),
      ),
      backgroundColor: snackSuccessBGColor,
      showCloseIcon: true,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

showUnSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: snackUnSuccessTextColor),
      ),
      backgroundColor: snackUnSuccessBGColor,
      showCloseIcon: true,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

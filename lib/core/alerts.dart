import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../main.dart';
import 'colors.dart';

void showToast({required String message, required Color color}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: white,
      fontSize: 16.0);
}

//Display snack bar
void showSnackBar(String message) {
  final snackBarContent = SnackBar(
    //padding: EdgeInsets.only(bottom: 16.0),
    content: Text(message),
    action: SnackBarAction(
        label: 'OK',
        onPressed: () => snackBarKey.currentState
            ?.hideCurrentSnackBar(reason: SnackBarClosedReason.hide)),
  );
  snackBarKey.currentState?.showSnackBar(snackBarContent);
}

Future<dynamic> showAlertDialog(String message, BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      });
}

Future<void> showAlert(
    String title, String message, BuildContext context)
async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

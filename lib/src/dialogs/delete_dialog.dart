import 'package:drone_assist/src/helper/dimensions.dart';
import 'package:flutter/material.dart';

void showDeleteDialog(context, String checkpoint) {
  double vpH = getViewportHeight(context);
  double vpW = getViewportWidth(context);
  showDialog(
    context: context,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return AlertDialog(
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Icon(
          Icons.check_circle_outline_outlined,
          color: Colors.green,
          size: vpH * 0.05,
        ),
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'Delete Checkpoint!',
              style: TextStyle(
                fontFamily: "Averia Serif Libre",
                fontSize: vpW * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text:
                      '\n\nAre you sure you want to delete `$checkpoint` checkpoint.',
                  style: TextStyle(
                    fontSize: vpW * 0.04,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Nutino Sans",
                    color: Colors.black,
                  ),
                )
              ]),
        ),
        actions: [
          TextButton(
            child: Text(
              'CANCEL',
              style: TextStyle(
                fontFamily: "Averia Serif Libre",
              ),
            ),
            onPressed: () {},
          ),
          TextButton(
            child: Text(
              'DELETE',
              style: TextStyle(
                  fontFamily: "Averia Serif Libre", color: Colors.red),
            ),
            onPressed: () {},
          ),
        ],
      );
    },
  );
}

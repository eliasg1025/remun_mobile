import 'package:flutter/material.dart';

buildAlertBox(BuildContext context, String title, String content) {

  final height = MediaQuery.of(context).size.height * 0.12;
  final letterColor = Colors.amber[900];
  final backgroundColor = Colors.amber[200];

  return Container(
    decoration: BoxDecoration(
      
      border: Border.all(
        color: backgroundColor,
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: backgroundColor,
    ),
    width: MediaQuery.of(context).size.width - 40,
    height: height,
    padding: EdgeInsets.all(10),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: <Widget>[
                      Icon(Icons.warning,
                        color: letterColor,
                      ),
                      Text(
                        title.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: letterColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(content.toString(),
                      style: TextStyle(fontSize: 14, color: letterColor))
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

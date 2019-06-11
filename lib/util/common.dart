import 'package:flutter/material.dart';

Container buildErrorCard(String msg) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(40),
    child: Card(
      child: Padding(
          padding: EdgeInsets.all(20),
          child: ListTile(
            leading: Icon(
              Icons.cancel,
              color: Colors.red,
            ),
            title: Text(
              msg,
              style: TextStyle(fontSize: 20),
            ),
          )),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:nice_teacher/dio.dart';
import 'package:nice_teacher/index.dart';

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => IndexPage()),
                (Route<dynamic> route) => false);
          },
        ),
        title: Text("评教完成"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(20),
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: _buildList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildList() {
    List<Widget> ncList = [];
    List<Widget> acList = [];
    List<Widget> ucList = [];

    for (var teacher in teachers) {
      ListTile tile = ListTile(
        title: Text(teacher["name"] + "-" + teacher["course_name"]),
      );
      if (teacher["need_evaluate"]) {
        ncList.add(tile);
      } else if (teacher["evaluated"]) {
        acList.add(tile);
      } else {
        ucList.add(tile);
      }
    }

    return <Widget>[
          ListTile(
            leading: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            title: Text("本次完成的评教："),
          ),
          Divider(),
        ] +
        ncList +
        [
          ListTile(
            leading: Icon(
              Icons.warning,
              color: Colors.yellow,
            ),
            title: Text("未完成的评教："),
          ),
          Divider(),
        ] +
        ucList +
        [
          ListTile(
            leading: Icon(
              Icons.storage,
              color: Colors.blue,
            ),
            title: Text("已完成的评教："),
          ),
          Divider(),
        ] +
        acList;
  }
}

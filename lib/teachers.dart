import 'package:flutter/material.dart';
import 'package:nice_teacher/dio.dart';
import 'package:nice_teacher/result.dart';

class TeacherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TeacherState();
  }
}

class _TeacherState extends State<TeacherPage> {
  List<Widget> _teacherCards = [];

  @override
  void initState() {
    super.initState();
    _buildTeacherCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("确认需要自动好评的教师列表"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _submit,
          )
        ],
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: _teacherCards,
          ),
        ),
      ),
    );
  }

  void _buildTeacherCards() {
    for (var teacher in teachers) {
      if (teacher["evaluated"]) {
        continue;
      }
      setState(() {
        _teacherCards
            .add(_buildTeacherCard(teacher["name"], teacher["course_name"]));
      });
    }
  }

  Card _buildTeacherCard(String name, String course) {
    return Card(
      key: ValueKey(name + course),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(name[0]),
        ),
        title: Text(name + " - " + course),
        trailing: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            for (var teacher in teachers) {
              if (teacher["course_name"] == course) {
                teacher["need_evaluate"] = false;
              }
            }
            setState(() {
              _teacherCards
                  .removeWhere((Widget w) => w.key == ValueKey(name + course));
            });
          },
        ),
      ),
    );
  }

  void _submit() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => Center(
              child: CircularProgressIndicator(),
            ));
    for (var teacher in teachers) {
      if (teacher["need_evaluate"]) {
        completeQuestionnaire(teacher["id"], teacher["course_id"]);
      }
    }
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => ResultPage()),
        (Route<dynamic> route) => false);
  }
}

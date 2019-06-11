import 'package:flutter/material.dart';
import 'package:nice_teacher/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nice_teacher/login.dart';
import 'package:nice_teacher/teachers.dart';

void toIndexPage(context) {
  Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: IndexPage(),
            );
          }),
      (Route<dynamic> route) => false);
}

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("\"好老师\"快速评教服务"),
        centerTitle: true,
        elevation: 0,
        leading: Container(),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Hi, " + (level == 0 ? "老板" : name),
                    style: TextStyle(color: Colors.white, fontSize: 48),
                  ),
                ),
                _buildEntrance(context),
                // Place holder
                SizedBox(
                  height: 48,
                ),
              ],
            ),
            _buildUserSwitcher(context),
          ],
        ),
      ),
    );
  }

  Positioned _buildUserSwitcher(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 1,
      right: 1,
      child: FlatButton(
        onPressed: () {
          _logout();
        },
        child: Text(
          "切换用户",
          style: TextStyle(
            color: Theme.of(context).buttonColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: LoginPage(),
            );
          }),
      (Route<dynamic> route) => false,
    );
  }

  DecoratedBox _buildEntrance(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: IconButton(
        onPressed: _enter,
        icon: Icon(Icons.person),
        color: Theme.of(context).primaryColor,
        iconSize: 78,
        padding: EdgeInsets.all(42),
      ),
    );
  }

  void _enter() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => Center(
              child: CircularProgressIndicator(),
            ));
    await getTeachersInfo();
    Navigator.pop(context);

    if (teachers == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) => Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: ListTile(
                        leading: Icon(
                          Icons.report_problem,
                          color: Colors.yellow,
                        ),
                        title: Text("我觉得你的网有点问题🤔"),
                      ),
                    ),
                  ),
                ),
              ));
    }

    for (var teacher in teachers) {
      if (!teacher["evaluated"]) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => TeacherPage()));
        return;
      }
    }
    showDialog(
        context: context,
        builder: (BuildContext context) => Center(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text("评教已经评完啦"),
                    ),
                  ),
                ),
              ),
            ));
  }
}

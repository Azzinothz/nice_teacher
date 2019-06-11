import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nice_teacher/dio.dart';
import 'package:nice_teacher/util/common.dart';
import 'package:nice_teacher/index.dart';

class LoginPage extends StatefulWidget {
  /// Creates a login page
  ///
  /// After user's first login, App would save the token and relevant data locally
  /// User can choose to log out in the index page
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  TextEditingController _usernameCtrl = TextEditingController();
  TextEditingController _passwordCtrl = TextEditingController();

  Scaffold _page = Scaffold(
    body: Container(
      color: Colors.purple,
    ),
  );

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  @override
  Widget build(BuildContext context) {
    return _page;
  }

  void _getToken() async {
    /// Get token from local storage, if succeeds, push to the next page
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");

    if (token != null) {
      name = prefs.getString("name");
      stuID = prefs.getString("stu_id");
      level = prefs.getInt("level");
      toIndexPage(context);
      return;
    } else {
      setState(() {
        _page = _buildLoginPage();
      });
      return;
    }
  }

  void _submit() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => Center(
              child: CircularProgressIndicator(),
            ));
    int code = await setToken(_usernameCtrl.text, _passwordCtrl.text);
    Navigator.pop(context);
    switch (code) {
      case 200:
        toIndexPage(context);
        break;
      case 403:
        showDialog(
          context: context,
          builder: (BuildContext context) => buildErrorCard("用户名或密码错误"),
        );
        break;
      case 404:
        showDialog(
          context: context,
          builder: (BuildContext context) => buildErrorCard("抱歉，你未获得使用权限"),
        );
        break;
    }
    setState(() {
      _passwordCtrl.text = "";
    });
    return;
  }

  Scaffold _buildLoginPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.purple,
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTextField("请输入学号", _usernameCtrl, false, Icons.person),
                _buildTextField("请输入密码", _passwordCtrl, true, Icons.lock),
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: Text(
                          "登录",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildTextField(String hint, TextEditingController controller,
      bool isPassword, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(icon: Icon(icon), hintText: hint),
        obscureText: isPassword,
      ),
    );
  }
}

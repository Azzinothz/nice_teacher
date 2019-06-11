import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio dio = Dio();

// const baseURL = "http://101.132.144.204:8082";
const baseURL = "http://192.168.43.239:8082";
String token = "";
String name = "";
String stuID = "";

dynamic teachers;

int level = -1;

Future<int> setToken(String username, String password) async {
  String url = baseURL + "/api/authorization/token";
  Map json = {
    "username": username,
    "password": password,
  };
  try {
    Response response = await dio.post(url, data: json);
    token = response.data["token"];
    name = response.data["name"];
    stuID = response.data["stu_id"];
    level = response.data["level"];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    prefs.setString("name", name);
    prefs.setString("stu_id", stuID);
    prefs.setInt("level", level);
    return 200;
  } on DioError catch (e) {
    return e.response.statusCode;
  }
}

Future getTeachersInfo() async {
  String url = baseURL + "/api/jwxt/evaluation";
  try {
    Response response = await dio.get(url,
        options: Options(headers: {"Authorization": "Bearer " + token}));
    teachers = response.data;
    for (var teacher in teachers) {
      if (teacher["evaluated"]) {
        teacher["need_evaluate"] = false;
      } else {
        teacher["need_evaluate"] = true;
      }
    }
    return teachers;
  } catch (e) {
    print(e);
    return null;
  }
}

void completeQuestionnaire(String id, String courseID) async {
  String url = baseURL + "/api/jwxt/evaluation";
  try {
    await dio.post(url,
        data: {
          "id": id,
          "course_id": courseID,
        },
        options: Options(headers: {"Authorization": "Bearer " + token}));
  } catch (e) {
    print(e);
  }
}

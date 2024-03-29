import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:zeucpcm/models/response_model.dart';

class PCMServices {
  // static const ROOT = 'http://localhost:3000/pcm/api/users';

  static const ROOT =
      'https://zeuc-pcm-a36a8febd3ba.herokuapp.com/pcm/api/users';

  static Future<dynamic> checkin(req) async {
    try {
      final response = await http.post(
        Uri.parse(ROOT + "/checkin"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(req),
      );

      if (200 == response.statusCode || 201 == response.statusCode) {
        ResponseModel rsp = parseResponse(response.body);
        if (rsp != null) {
          return rsp;
        } else {
          print("Invalid cheking");
          return {
            "success": false,
            "message": "User account not found.",
            "responseBody": {"message": "User account not found."}
          };
        }
      } else {
        ResponseModel rsp = parseResponse(response.body);
        return rsp;
      }
    } catch (e) {
      print(e);
      print("API DOWN");
      return {};
    }
  }

  static Future<dynamic> meals(req) async {
    try {
      final response = await http.post(
        Uri.parse(ROOT + "/meals"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(req),
      );

      if (200 == response.statusCode || 201 == response.statusCode) {
        ResponseModel rsp = parseResponse(response.body);
        return rsp;
            } else {
        ResponseModel rsp = parseResponse(response.body);
        return rsp;
      }
    } catch (e) {
      print(e);
      print("API DOWN");
      return {};
    }
  }

  static Future<dynamic> login(req) async {
    try {
      final response = await http.post(
        Uri.parse(ROOT + "/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(req),
      );

      print(response.statusCode);
      if (200 == response.statusCode || 201 == response.statusCode) {
        ResponseModel rsp = parseResponse(response.body);
        print(rsp);
        if (rsp != null) {
          return rsp;
        } else {
          print("Invalid username/password");
          return {
            "success": false,
            "message": "User account not found.",
            "responseBody": {"message": "User account not found."}
          };
        }
      } else {
        ResponseModel rsp = parseResponse(response.body);
        return rsp;
      }
    } catch (e) {
      print(e);
      print("API DOWN");
      return {};
    }
  }

  static Future<dynamic> signup(req) async {
    try {
      final response = await http.post(
        Uri.parse(ROOT + "/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(req),
      );
      print(req);

      print("----------->>>>");
      print(response.body);
      if (200 == response.statusCode || 201 == response.statusCode) {
        ResponseModel rsp = parseResponse(response.body);
        print(rsp);
        if (rsp != null) {
          return rsp;
        } else {
          print("Invalid username/password");
          return {
            "success": false,
            "message": "User account not found.",
            "responseBody": {"message": "User account not found."}
          };
        }
      } else {
        ResponseModel rsp = parseResponse(response.body);
        return rsp;
      }
    } catch (e) {
      print(e);
      print("API DOWN");
      return {};
    }
  }

  static Future<dynamic> forgotpassowrd(req) async {
    try {
      final response = await http.post(
        Uri.parse(ROOT),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(req),
      );

      print(response.statusCode);
      if (200 == response.statusCode || 201 == response.statusCode) {
        ResponseModel rsp = parseResponse(response.body);
        print(rsp);
        if (rsp != null) {
          return rsp;
        } else {
          print("Invalid username/password");
          return {
            "success": false,
            "message": "User account not found.",
            "responseBody": {"message": "User account not found."}
          };
        }
      } else {
        ResponseModel rsp = parseResponse(response.body);
        return rsp;
      }
    } catch (e) {
      print(e);
      print("API DOWN");
      return {};
    }
  }

  static ResponseModel parseResponse(String responseBody) {
    final Map<String, dynamic> parsed = json.decode(responseBody);
    final responseBodyMap = parsed;
    return ResponseModel.fromJson(responseBodyMap);
  }
}

import 'package:dio/dio.dart';
import 'package:mule/config/config.dart';
import 'package:mule/models/req/forgotPassword/forgot_password_req.dart';
import 'package:mule/models/req/login/login_data.dart';
import 'package:mule/models/req/signup/signup_data.dart';

class HttpClient {
  Dio _dio;

  HttpClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Config.BASE_URL,
        contentType: 'application/json',
        // We don't need to validate the state of any reques that is made because we want to react to non-success statusses.
        validateStatus: (status) => true,
      ),
    );
  }

  handleSignup(SignupData data) async {
    final res = await makePostRequest('/authentication/signup', data.toMap());

    if (res.statusCode == 201) {
      final token = res.data['token'];
      await Config.saveToken('Bearer $token');
    }
    return res;
  }

  handleLogin(LoginData data) async {
    final res = await makePostRequest('/authentication/login', data.toMap());

    if (res.statusCode == 200) {
      final token = res.data['token'];
      await Config.saveToken('Bearer $token');
    }
    return res;
  }

  Future<Response> makeGetRequest(String path) async {
    return await _dio.get(path);
  }

  handleSignOut() async {
    String token = await Config.getToken();
    _dio.delete(
      '/authentication/logout',
      options: Options(
        headers: {
          'Authorization': token,
        },
      ),
    );
  }

  Future<Response> makePostRequest(
      String path, Map<String, dynamic> data) async {
    return await _dio.post(
      path,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Response> handleForgotPassword(
      ForgotPasswordReq forgotPasswordReq) async {
    final Response res = await makePostRequest(
        '/authentication/request-reset', forgotPasswordReq.toMap());
    return res;
  }
}

HttpClient httpClient = new HttpClient();

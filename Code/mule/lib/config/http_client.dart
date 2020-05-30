import 'package:dio/dio.dart';
import 'package:mule/config/config.dart';
import 'package:mule/models/signup/signup_data.dart';

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

    // TODO Save the token!!
    if (res.statusCode == 201) {
      final token = res.data['token'];
      print('Token is $token');
    }
    return res;
  }

  String _addSlashToEndingOfUrl(String urlPath) {
    if (urlPath.endsWith('/')) {
      return urlPath;
    }
    return urlPath + '/';
  }

  Future<Response> makeGetRequest(String path) async {
    return await _dio.get(path);
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

  // returns the response
  Future<Response> doLogin(String username, String password) async {
    String path = '/users/login';
    return await makePostRequest(
        path, {'username': username, 'password': password});
  }
}

HttpClient httpClient = new HttpClient();

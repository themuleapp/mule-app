import 'package:dio/dio.dart';
import 'package:mule/config/config.dart';
import 'package:mule/models/data/location_data.dart';
import 'package:mule/models/req/changePassword/change_password_req.dart';
import 'package:mule/models/req/deleteAccount/delete_account_req.dart';
import 'package:mule/models/req/forgotPassword/forgot_password_req.dart';
import 'package:mule/models/req/login/login_data.dart';
import 'package:mule/models/req/signup/signup_data.dart';
import 'package:mule/models/req/verifyPassword/verify_password.dart';
import 'package:mule/models/req/verifyTokenAndEmail/verify_token_and_email_req.dart';
import 'package:mule/models/res/mulesAroundRes/mules_around_res.dart';

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

  Future<Response> _makeGetRequest(String path) async {
    return await _dio.get(path);
  }

  Future<Response> _makeAuthenticatedGetRequest(String path) async {
    final String token = await Config.getToken();
    return await _dio.get(path,
        options: Options(headers: {'Authorization': token}));
  }

  Future<Response> _makeAuthenticatedPostRequest(
      String path, Map<String, dynamic> data) async {
    final String token = await Config.getToken();
    return await _dio.post(
      path,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      ),
    );
  }

  Future<Response> _makePostRequest(
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

  handleSignup(SignupData data) async {
    final res = await _makePostRequest('/authentication/signup', data.toMap());

    if (res.statusCode == 201) {
      final token = res.data['token'];
      await Config.saveToken('Bearer $token');
    }
    return res;
  }

  handleLogin(LoginData data) async {
    final res = await _makePostRequest('/authentication/login', data.toMap());

    if (res.statusCode == 200) {
      final token = res.data['token'];
      await Config.saveToken('Bearer $token');
    }
    return res;
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

  Future<Response> handleRequestOtp(ForgotPasswordReq forgotPasswordReq) async {
    final Response res = await _makePostRequest(
        '/authentication/request-reset', forgotPasswordReq.toMap());
    return res;
  }

  Future<Response> handleReRequestOtp(
      ForgotPasswordReq forgotPasswordReq) async {
    final Response res = await _makePostRequest(
        '/authentication/resend-reset-token', forgotPasswordReq.toMap());
    return res;
  }

  Future<Response> handleVerifyTokenAndEmail(
      VerifyTokenAndEmailReq verifyTokenAndEmailReq) async {
    final Response res = await _makePostRequest(
        '/authentication/verify-reset-token-email',
        verifyTokenAndEmailReq.toMap());
    return res;
  }

  Future<Response> handleResetPassword(
      VerifyPasswordReq verifyPasswordReq) async {
    final Response res = await _makePostRequest(
        '/authentication/reset-forgotten-password', verifyPasswordReq.toMap());
    return res;
  }

  // Authenticated requests

  Future<Response> handleChangePassword(
      ChangePasswordReq changePasswordReq) async {
    final Response res = await _makeAuthenticatedPostRequest(
        '/authentication/change-password', changePasswordReq.toMap());
    return res;
  }

  Future<Response> handleDeleteAccount(
      DeleteAccountReq deleteAccountReq) async {
    String token = await Config.getToken();

    return await _dio.delete(
      '/authentication/delete-account',
      data: deleteAccountReq.toMap(),
      options: Options(
        headers: {
          'Authorization': token,
        },
      ),
    );
  }

  Future<Response> handleGetProfileData() async {
    return await _makeAuthenticatedGetRequest('/profile');
  }

  Future<bool> handleUpdateLocation(LocationData locationData) async {
    Response res = await _makeAuthenticatedPostRequest(
        '/location/update', locationData.toMap());
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  getMulesAroundMeLocation(LocationData locationData) async {
    Response res = await _makeAuthenticatedPostRequest(
        '/location/mules-nearby', locationData.toMap());
    if (res.statusCode != 200) {
      return null;
    }

    MulesAroundRes mulesAroundRes = MulesAroundRes.fromJson(res.data);
    print(mulesAroundRes.numMules);
    print(mulesAroundRes.mules);
    return mulesAroundRes;
  }
}

HttpClient httpClient = new HttpClient();

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:m3rady/core/controllers/auth/auth_controller.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/storage.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'network_helper.dart';

class DioHelper {
  static Dio? dio;

  /// Auto show errors
  static bool isAutoShowErrors = true;

  /// Set user auth token
  static var userAuthenticationToken;

  /// Initialize dio
  static Future init() async {
    /// Get user language code from storage
    String userLocale =
        await LocalStorage.get('userLocale') ?? config['defaultLocale'];

    /// Get user auth token
    userAuthenticationToken = await Authentication.getUserAuthToken();

    /// Set headers
    var headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $userAuthenticationToken",
      "X-localization": userLocale,
    };

    /// Set dio
    dio = Dio(
      BaseOptions(
        baseUrl: "${config['baseAPIsURL']}/",
        followRedirects: true,
        connectTimeout: 20000,
        sendTimeout: 20000,
        receiveTimeout: 20000,
        receiveDataWhenStatusError: true,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: headers,
        validateStatus: (status) {
          return status! < 800;
        },
      ),
    );
  }

  /// Handle response
  static handleResponse(response) async {
    try {
      /// Convert response form json
      response = jsonDecode(response.toString());

      /// Handle errors
      if (response['status'] == false) {
        /// Check authentication errors
        if (response['statusCode'] == 401) {
          /// User unauthenticated
          await Authentication.unsetAuthToken();
        }

        /// If any errors returned
        if (isAutoShowErrors == true &&
            response['data']?['errors'] != null &&
            response['data']?['errors'].length > 0) {
          /// Auto show errors
          CErrorDialog(
            errors: response['data']!['errors'],
          );
        }
      }
    } catch (e) {
      /// Set response
      response = {'status': false};

      /// Auto show errors
      if (isAutoShowErrors == true) {
        CSomethingWentWrongDialog();
      }

      /// Stop loader
      MainLoader.set(false);
    }

    return response;
  }

  /// Handle data to formData
  static Future dataToFormData({
    files,
    String? fromDataAttributeName,
    Map? data,
  }) async {
    /// If files
    /// Handle if array or file
    if (files is Map && files.length > 0) {
      /// Set attribute name
      fromDataAttributeName =
          fromDataAttributeName == null ? 'files' : fromDataAttributeName;

      /// Set files data form
      List filesDataForm = [];

      /// Add each file
      for (int key in files.keys) {
        await MultipartFile.fromFile(
          files[key].path,
          filename: files[key].path.split('/').last,
        ).then((fileFromData) {
          /// Set file data form
          filesDataForm.add({
            'file': fileFromData,
          });
        });
      }

      return FormData.fromMap({
        fromDataAttributeName: filesDataForm,
        ...(data ?? {}),
      });
    } else if (files is File) {
      /// Set attribute name
      fromDataAttributeName =
          fromDataAttributeName == null ? 'file' : fromDataAttributeName;

      return FormData.fromMap({
        fromDataAttributeName: {
          'file': await MultipartFile.fromFile(
            files.path,
            filename: files.path.split('/').last,
          ),
        },
        ...(data ?? {}),
      });
    } else {
      return FormData.fromMap({
        ...(data ?? {}),
      });
    }
  }

  /// GET
  static Future get(
    String url, {
    Map<String, dynamic>? parameters,
    int? page = 1,
    int? limit,
    bool returnRawResponse = false,
    bool applyUserTypeInUrl = false,
  }) async {
    /// Check network connection
    if (GlobalVariables.isDeviceConnectedToTheInternet.value == false) {
      await NetworkHelper.check();
    }

    /// add user type to the url
    if (applyUserTypeInUrl == true) {
      /// Get fcm token
      String userType = await Authentication.getUserType();
      url = "$userType/$url";
    }

    /// Set pagination limit

    if (parameters != null) {
      if (limit != null && limit > 0) {
        parameters['limit'] = limit;
      }
      parameters['page'] = page;
    } else {
      if (limit != null && limit > 0) {
        parameters = {
          'limit': limit,
          'page': page,
        };
      } else {
        parameters = {
          'page': page,
        };
      }
    }

    /// Send request
    var response = await dio?.get(
      url,
      queryParameters: parameters,
    );

      print("[API] GET: $url");

    return (returnRawResponse ? response : await handleResponse(response));
  }

  /// POST
  static Future post(
    url, {
    parameters,
    data,
    returnRawResponse = false,
    applyUserTypeInUrl = false,
  }) async {
    /// Check network connection
    if (GlobalVariables.isDeviceConnectedToTheInternet.value == false) {
      await NetworkHelper.check();
    }

    /// add user type to the url
    if (applyUserTypeInUrl == true) {
      /// Get fcm token
      String userType = await Authentication.getUserType();
      url = "$userType/$url";
    }

    /// Send request
    var response = await dio?.post(
      url,
      queryParameters: parameters,
      data: data,
    );

    if (config['isDebugMode']) print("[API] POST: $url");

    return (returnRawResponse ? response : await handleResponse(response));
  }

  /// PUT
  static Future put(
    url, {
    parameters,
    data,
    returnRawResponse = false,
    applyUserTypeInUrl = false,
  }) async {
    /// Check network connection
    if (GlobalVariables.isDeviceConnectedToTheInternet.value == false) {
      await NetworkHelper.check();
    }

    /// add user type to the url
    if (applyUserTypeInUrl == true) {
      /// Get fcm token
      String userType = await Authentication.getUserType();
      url = "$userType/$url";
    }

    /// Send request
    var response = await dio?.put(
      url,
      queryParameters: parameters,
      data: data,
    );

    if (config['isDebugMode']) print("[API] PUT: $url");

    return (returnRawResponse ? response : await handleResponse(response));
  }

  /// PATCH
  static Future patch(
    url, {
    parameters,
    data,
    returnRawResponse = false,
    applyUserTypeInUrl = false,
  }) async {
    /// Check network connection
    if (GlobalVariables.isDeviceConnectedToTheInternet.value == false) {
      await NetworkHelper.check();
    }

    /// add user type to the url
    if (applyUserTypeInUrl == true) {
      /// Get fcm token
      String userType = await Authentication.getUserType();
      url = "$userType/$url";
    }

    /// Send request
    var response = await dio?.patch(
      url,
      queryParameters: parameters,
      data: data,
    );

    if (config['isDebugMode']) print("[API] PATCH: $url");

    return (returnRawResponse ? response : await handleResponse(response));
  }

  /// DELETE
  static Future delete(
    url, {
    parameters,
    returnRawResponse = false,
    applyUserTypeInUrl = false,
  }) async {
    /// Check network connection
    if (GlobalVariables.isDeviceConnectedToTheInternet.value == false) {
      await NetworkHelper.check();
    }

    /// add user type to the url
    if (applyUserTypeInUrl == true) {
      /// Get fcm token
      String userType = await Authentication.getUserType();
      url = "$userType/$url";
    }

    /// Send request
    var response = await dio?.delete(
      url,
      queryParameters: parameters,
    );

    if (config['isDebugMode']) print("[API] DELETE: $url");

    return (returnRawResponse ? response : await handleResponse(response));
  }

  /// Download file
  static Future download(
    String url,
    String fileName, {
    Function(int count, int total)? showDownloadProgress,
  }) async {
    var cancelToken = CancelToken();
    try {
      await dio?.download(
        url,
        "./${config['cacheSavePath']}/$fileName",
        onReceiveProgress: showDownloadProgress,
        cancelToken: cancelToken,
      );
    } catch (e) {
      print(e);
    }
  }
}

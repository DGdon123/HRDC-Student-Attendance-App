// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

class DioException implements Exception {
  DioException.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.unknown:
        message = "Connection failed due to internet connection";
        break;
      case DioErrorType.badResponse:
        message = _handleError(
            dioError.response!.statusCode!, dioError.response!.data);
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String? message;

  String _handleError(int statuscode, dynamic error) {
    switch (statuscode) {
      case 400:
        return error["message"] ??
            error["success"] ??
            error["email"] ??
            "Error";
      case 401:
        return error["message"] ?? "error";
      case 404:
        return error["message"] ?? error["error"] ?? "Not found";
      case 406:
        return error["message"] ?? error["error"] ?? "Error";
      case 422:
        return error["message"] ?? error["error"] ?? "Error";

      case 500:
        return "Internal server error";
      default:
        return "Something went wrong";
    }
  }
}

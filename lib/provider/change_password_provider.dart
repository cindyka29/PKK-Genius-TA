import 'package:flutter/material.dart';
import 'package:pkk/data/api/user_function.dart';

class ChangePasswordProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> changePassword({
    // required String oldPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final isSuccess = await UserFunction.changePassword(
      // oldPassword: oldPassword,
      newPassword: newPassword,
    );
    if (!isSuccess) {
      _errorMessage = 'Gagal ubah sandi';
    }
    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }
}

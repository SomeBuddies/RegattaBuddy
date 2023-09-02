import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:regatta_buddy/models/user_data.dart';
import 'package:regatta_buddy/services/authentication_service.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';

class UserProvider with ChangeNotifier {
  Logger logger = getLogger('UserProvider');
  final AuthenticationService loginService = Get.find<AuthenticationService>();

  UserData? _user;

  UserData? get user {
    initializeUserDataIfAuthenticated();
    return _user;
  }

  void setUser(UserData user) {
    _user = user;
    notifyListeners();
  }

  void initializeUserDataIfAuthenticated() {
    if (_user != null) {
      return;
    }

    loginService.fetchCurrentUserData().then((userData) {
      if (userData != null) {
        setUser(userData);
      }
    });
  }

  void loadUserData() {
    logger.i('Loading user data from Firestore');
    loginService.fetchCurrentUserData().then((userData) {
      if (userData != null) {
        setUser(userData);
      }
    });
  }
}

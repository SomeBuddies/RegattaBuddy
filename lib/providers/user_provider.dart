import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:regatta_buddy/models/user_data.dart';
import 'package:regatta_buddy/services/authentication_service.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';

class UserProvider with ChangeNotifier {
  Logger logger = getLogger('UserProvider');
  final AuthenticationService authenticationService;

  UserData? _user;

  UserProvider(this.authenticationService);

  UserData? get user {
    initializeUserDataIfAuthenticated();
    return _user;
  }

  void setUser(UserData user) {
    _user = user;
    notifyListeners();
  }

  Future<void> initializeUserDataIfAuthenticated() async {
    if (_user != null) {
      return;
    }

    await authenticationService.fetchCurrentUserData().then((userData) {
      if (userData != null) {
        setUser(userData);
      }
    });
  }

  Future<void> loadUserData() async {
    logger.i('Loading user data from Firestore');
    await authenticationService.fetchCurrentUserData().then((userData) {
      if (userData != null) {
        setUser(userData);
      }
    });
  }
}

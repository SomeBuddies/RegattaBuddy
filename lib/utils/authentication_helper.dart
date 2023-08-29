import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:regatta_buddy/pages/login_page.dart';

void handleAuthProtectedRoute(page) {
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    Get.toNamed(LoginPage.route);
  } else {
    Get.toNamed(page);
  }
}

void verifyUserIsAuthenticated() {
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    Get.toNamed(LoginPage.route);
  }
}

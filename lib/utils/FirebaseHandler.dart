import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHandler {
  static String? getUID() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
}

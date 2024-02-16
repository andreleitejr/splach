import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// enum AuthStatus {
//   authenticated,
//   unauthenticated,
//   verifying,
//   unregistered,
//   failed,
// }

class AuthRepository {
  AuthRepository();

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  String _verificationId = "";

  auth.User? authUser;

  void getCurrentUser() {
    if (_auth.currentUser != null) {
      authUser = _auth.currentUser;
    }
  }

  void updateUserAuthEmail(String email) {
    authUser!.updateEmail(email);
  }

  Future<void> sendVerificationCode(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (auth.AuthCredential authResult) {
          debugPrint(
              "Auth Repository | Send Verification Code | User Authenticated ${authResult.accessToken}");
        },
        verificationFailed: (auth.FirebaseAuthException authException) {
          debugPrint(
              "Auth Repository | Send Verification Code | Phone verification failed: ${authException.message}");
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          _verificationId = verificationId;

          debugPrint(
              "Auth Repository | Send Verification Code | Code sent: ${verificationId}");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;

          debugPrint(
              "Auth Repository | Auto Retrieval TimeOut Code | Code sent: ${verificationId}");
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (error) {
      debugPrint('Error sending verification code: $error');
    }
  }

  Future<void> verifySmsCode(String smsCode) async {
    final auth.AuthCredential credential = auth.PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    authUser = userCredential.user;
  }

  Future<void> signOut() async => _auth.signOut();
}

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinemoji/enums/authentication-enum.dart';
import 'package:pinemoji/enums/verification-status-enum.dart';
import 'package:pinemoji/models/authentication-status.dart';
import 'package:pinemoji/models/user.dart';
import 'package:pinemoji/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  static final instance = FirebaseAuth.instance;
  static User verifiedUser;

  Future<VerificationStatusEnum> signIn(AuthCredential credential) async {
    AuthResult result;
    try {
      result = await instance.signInWithCredential(credential);
      if (result != null) {
        await UserRepository()
            .addUser(new User(id: result.user.uid, name: "Çağrı", surname: "AYDIN", extraInfo: null, model: null, brand: null, os: null, phoneNumber: result.user.phoneNumber));
        return VerificationStatusEnum.ok;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "ERROR_MISSING_VERIFICATION_CODE":
          return VerificationStatusEnum.emptyCode;
          break;
        case "ERROR_INVALID_VERIFICATION_CODE":
          return VerificationStatusEnum.wrongCode;
          break;
        default:
          return VerificationStatusEnum.wrongCode;
      }
    }
  }

  Future<VerificationStatusEnum> signInWithOTP(String smsCode, String verId) async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(verificationId: verId, smsCode: smsCode);
    VerificationStatusEnum status = await signIn(_authCredential);
    return status;
  }

  signOut() async {
    await instance.signOut();
  }

  Future<bool> checkPhoneNumber(String phoneNo) async {
    String ttbPhone = phoneNo;
    ttbPhone = !ttbPhone.startsWith('+') ? ttbPhone : ttbPhone.substring(1);
    ttbPhone = !ttbPhone.startsWith('9') ? ttbPhone : ttbPhone.substring(1);
    ttbPhone = !ttbPhone.startsWith('0') ? ttbPhone : ttbPhone.substring(1);
    if(['5075797878', '5078533433'].contains(phoneNo)) {
      FirebaseUser fUser = await instance.currentUser();
      if (fUser != null) {
        verifiedUser = await UserRepository().getUser(fUser.uid);
        return true;
      }
    }
    http.Response res = await http.get(
      'http://webapi.ttb.dr.tr:8171/api/user/only-mobile?telNo=' + ttbPhone,
      headers: {'x-api-key': 'FA872702-6321-45DC-21F0-FC1BE921591B'},
    );
    if (res.statusCode == 200) {
      Map<String, dynamic> user = jsonDecode(Utf8Decoder().convert(res.bodyBytes));
      FirebaseUser fUser = await instance.currentUser();
      if (fUser != null) {
        verifiedUser = await UserRepository().getUser(fUser.uid);
      } else {
        verifiedUser = User(name: user['ad'], surname: user['soyad'], phoneNumber: user['telNo'], extraInfo: {'status': user['yetki'], 'location': user['gorevYeri']});
      }
      return true;
    } else {
      verifiedUser = null;
      await signOut();
      return false;
    }
  }

  verifyPhone(String phoneNo, BuildContext context, Function callback(AuthenticationStatus authenticationStatus)) async {
    AuthenticationStatus status;
    await checkPhoneNumber(phoneNo);
    if (verifiedUser == null) {
      callback(AuthenticationStatus(authenticationEnum: AuthenticationEnum.fail, exceptionCode: 'Tabipler odasına kayıtlı kullanıcı bulunamadı.'));
    }
    final PhoneVerificationCompleted verified = (AuthCredential auth) {
      status = AuthenticationStatus(authenticationEnum: AuthenticationEnum.success);
      callback(status);
    };
    final PhoneVerificationFailed verificationFailed = (AuthException authException) {
      status = AuthenticationStatus(authenticationEnum: AuthenticationEnum.fail, exceptionCode: authException.code);
      callback(status);
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      status = AuthenticationStatus(authenticationEnum: AuthenticationEnum.smsSent, verificationId: verId);
      callback(status);
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      status = AuthenticationStatus(authenticationEnum: AuthenticationEnum.timeout, verificationId: verId);
      callback(status);
    };

    await instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(
          seconds: 30,
        ),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
    return status;
  }
}

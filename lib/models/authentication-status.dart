import 'package:pinemoji/enums/authentication-enum.dart';

class AuthenticationStatus {
  final AuthenticationEnum authenticationEnum;
  final String verificationId;
  final String exceptionCode;

  AuthenticationStatus(
      {this.authenticationEnum, this.verificationId, this.exceptionCode});
}

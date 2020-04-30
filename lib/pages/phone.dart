import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/pages/validation-code.dart';
import 'package:pinemoji/widgets/outcome-button.dart';

class PhoneValidationPage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  String phoneNo, verificationId;

  final TextEditingController phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    "assets/right.png",
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            Container(
              height: height * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Container(
                      child: Text(
                        "Odamız İle\nPaylaşmış\nOlduğunuz Cep\nTelefonu Numaranızı\nGiriniz.",
                        style: TextStyle(
                          fontSize: (height * 0.04).toInt().toDouble(),
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: height * 0.33,
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: height * 0.022,
                      ),
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            hintText: "05xx xxx xx xx"),
                        style: TextStyle(
                          fontSize: (height * 0.04).toInt().toDouble(),
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor,
                          Colors.white
                        ])),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
              child: OutcomeButton(
                text: "İlerle",
                action: () {
                  verifyPhone('+9' + phoneController.text, context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo, context) async {
    final PhoneVerificationCompleted verified = (AuthCredential auth) {};
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('${authException.message}');
      // with empty phone number
      pushToValidationPage(context);
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(
          seconds: 30,
        ),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  pushToValidationPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ValidationCodePage(verificationId: verificationId);
        },
      ),
    );
  }
}

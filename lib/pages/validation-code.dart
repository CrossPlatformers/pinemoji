import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/pages/bottom-navigation.dart';
import 'package:pinemoji/widgets/outcome-button.dart';

class ValidationCodePage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  String verificationId, status;
  final TextEditingController codeController = new TextEditingController();

  ValidationCodePage({this.verificationId});

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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/left.png",
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
                        "Telefonunuza\nGönderdiğimiz Kodu\nGiriniz.",
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
                  width: height * 0.22,
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: height * 0.022,
                      ),
                      TextField(
                        controller: codeController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            hintText: "xx xx xx"),
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (height * 0.04).toInt().toDouble(),
                        ),
                      ),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor,
                          Colors.white
                        ])),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
              child: OutcomeButton(
                text: "Giriş Yap",
                action: () {
                  _signInWithPhoneNumber(codeController.text, context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signInWithPhoneNumber(String smsCode, BuildContext context) async {
    var _authCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      AuthResult authStatus = await _auth.signInWithCredential(_authCredential);
      if (authStatus != null) {
        // login operaitions
      }
      // with empty or wrong verification code
      pushToLandingPage(context);
    } catch (e) {
      pushToLandingPage(context);
    }
  }

  Future pushToLandingPage(BuildContext context) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return BottomNavigation();
        },
      ),
      (Route<dynamic> route) => false,
    );
  }
}

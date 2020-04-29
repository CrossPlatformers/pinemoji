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
    final double width = MediaQuery.of(context).size.width;
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
                    fit: BoxFit.fitHeight,
                  ),
                ],
              ),
            ),
            Container(
              height: 240,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Container(
                      child: Text(
                        "Telefonunuza\nGönderdiğimiz Kodu\nGiriniz.",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
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
                  width: 280,
                  padding: EdgeInsets.fromLTRB(0, 20, 20, 60),
                  child: Column(
                    children: <Widget>[
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
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 32),
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

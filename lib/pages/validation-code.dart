import 'package:flutter/material.dart';
import 'package:pinemoji/enums/verification-status-enum.dart';
import 'package:pinemoji/pages/bottom-navigation.dart';
import 'package:pinemoji/services/authentication-service.dart';
import 'package:pinemoji/widgets/outcome-button.dart';

class ValidationCodePage extends StatefulWidget {
  String verificationId;

  ValidationCodePage({this.verificationId});

  @override
  _ValidationCodePageState createState() => _ValidationCodePageState();
}

class _ValidationCodePageState extends State<ValidationCodePage> {
  final _scaffOldState = GlobalKey<ScaffoldState>();
  bool hasLoading = false;

  final TextEditingController codeController = new TextEditingController();

  GlobalKey buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    hasLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffOldState,
      body: !hasLoading
          ? GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    height: height,
                    width: width,
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
                                "assets/welcome-left.png",
                                height: double.infinity,
                                fit: BoxFit.fill,
                                width: width - height * 0.1,
                              ),
                              SizedBox(
                                width: height * 0.1,
                              )
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
                                      fontSize:
                                          (height * 0.04).toInt().toDouble(),
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
                                    onTap: () => Scrollable.ensureVisible(
                                      buttonKey.currentContext,
                                      curve: Curves.easeIn,
                                      duration: Duration(
                                        milliseconds: 300,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                        counterText: "",
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        hintText: "xx xx xx"),
                                    textAlign: TextAlign.end,
                                    maxLength: 6,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          (height * 0.04).toInt().toDouble(),
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
                            key: buttonKey,
                            text: "Giriş Yap",
                            action: () {
                              signInWithPhoneNumber(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: Colors.white70,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Giriş Yapılıyor...",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
            ),
    );
  }

  signInWithPhoneNumber(BuildContext context) async {
    setState(() {
      hasLoading = true;
    });
    VerificationStatusEnum status = await AuthenticationService()
        .signInWithOTP(codeController.text, widget.verificationId);
    switch (status) {
      case VerificationStatusEnum.ok:
        pushToLandingPage(context);
        break;
      case VerificationStatusEnum.wrongCode:
        showWarning('Yanlış kod girdiniz, tekrar deneyiniz.');
        break;
      case VerificationStatusEnum.emptyCode:
        showWarning('Boş kod giremezsiniz, tekrar deneyiniz.');
        break;
      default:
        showWarning('Yanlış kod girdiniz, tekrar deneyiniz.');
    }
    setState(() {
      hasLoading = false;
    });
  }

  showWarning(String text) {
    _scaffOldState.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  pushToLandingPage(BuildContext context) {
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

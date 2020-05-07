import 'package:flutter/material.dart';
import 'package:pinemoji/enums/authentication-enum.dart';
import 'package:pinemoji/helpers/string-helper.dart';
import 'package:pinemoji/pages/validation-code.dart';
import 'package:pinemoji/services/authentication-service.dart';
import 'package:pinemoji/widgets/outcome-button.dart';

class PhoneValidationPage extends StatefulWidget {
  @override
  _PhoneValidationPageState createState() => _PhoneValidationPageState();
}

class _PhoneValidationPageState extends State<PhoneValidationPage> {
  String phoneNo;
  bool isLoading = false;

  final _scaffOldState = GlobalKey<ScaffoldState>();

  final TextEditingController phoneController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffOldState,
      body: !isLoading
          ? GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: SafeArea(
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
                          SizedBox(
                            width: height * 0.1,
                          ),
                          Image.asset(
                            "assets/welcome-right.png",
                            height: double.infinity,
                            fit: BoxFit.fill,
                            width: width - height * 0.1,
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
                                    counterText: "",
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    hintText: "05xx xxx xx xx"),
                                maxLength: 11,
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
                          verifyPhone(context);
                        },
                      ),
                    )
                  ],
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
                    "Kod Gönderiliyor...",
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

  verifyPhone(context) async {
    if (StringHelper.isValidPhoneNumber(phoneController.text)) {
      setState(() {
        isLoading = true;
      });
      await AuthenticationService()
          .verifyPhone('+9' + phoneController.text, context, (status) {
        if (status.authenticationEnum == AuthenticationEnum.smsSent) {
          setState(() {
            isLoading = false;
          });
          pushToValidationPage(context, status.verificationId);
        }
      });
    } else {
      showWarning('Lütfen geçerli bir telefon giriniz');
    }
  }

  showWarning(String text) {
    _scaffOldState.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  pushToValidationPage(BuildContext context, String verificationId) {
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

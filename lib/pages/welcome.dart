import 'package:flutter/material.dart';
import 'package:pinemoji/pages/phone.dart';
import 'package:pinemoji/widgets/outcome-button.dart';

class WelcomePage extends StatelessWidget {
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
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 50, 0, 0),
                        child: Container(
                          child: Text(
                            "Türk Tabipleri\nBirliği İletişim\nPlatformuna\nHoşgeldiniz",
                            style: TextStyle(
                              fontSize: height * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0, top: 24.0),
                        child: Image.asset(
                          "assets/ttb.png",
                          width: height * 0.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: Image.asset(
                "assets/welcome.png",
                width:
                    height - 370 > (width / (373 / 296)) ? width : height - 370,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
              child: OutcomeButton(
                text: "İlerle",
                action: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PhoneValidationPage();
                    },
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

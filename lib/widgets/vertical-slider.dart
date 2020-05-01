import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/widget-controllers/health-widget-controller.dart';

import 'health-widget.dart';

class VerticalSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: CarouselSlider(
        carouselController: CarouselController()
        ,
        options: CarouselOptions(height: size.height),
        items: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 3,
                    color: Colors.white,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Şu ana kadar COVID-19 tanısı aldınız mı?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: HealthWidgetController(
                        healthStatusModelList: [
                          HealthStatusModel(
                            emoji: "😊",
                            text: "Hayır",
                          ),
                          HealthStatusModel(
                            emoji: "😒",
                            text: "Evet, test sonucum pozitif çıktı",
                          ),
                          HealthStatusModel(
                            emoji: "😐",
                            text: "Evet test negatifti ama BT sonucuma göre",
                          ),
                          HealthStatusModel(
                            emoji: "😶",
                            text: "Diğer",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 3,
                    color: Colors.white,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "COVID-19 nedeniyle uygulanan tedavi",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: HealthWidgetController(
                        healthStatusModelList: [
                          HealthStatusModel(
                            emoji: "😊",
                            text: "Tanı almadım",
                          ),
                          HealthStatusModel(
                            emoji: "😷",
                            text: "Hastalığı evde ilaç alarak geçirdim",
                          ),
                          HealthStatusModel(
                            emoji: "🤒",
                            text: "Serviste yatarak tedavi gördüm",
                          ),
                          HealthStatusModel(
                            emoji: "😶",
                            text: "Yoğun bakımda yatarak tedavi gördüm",
                          ),
                          HealthStatusModel(
                            emoji: "🤢",
                            text: "Entübe edildim",
                          ),
                          HealthStatusModel(
                            emoji: "😶",
                            text: "Diğer",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 3,
                    color: Colors.white,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Riskli COVID 19 temasınız oldu mu? ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: HealthWidgetController(
                        healthStatusModelList: [
                          HealthStatusModel(
                            emoji: "😊",
                            text: "Hayır",
                          ),
                          HealthStatusModel(
                            emoji: "😐",
                            text: "Evet düşük riskli",
                          ),
                          HealthStatusModel(
                            emoji: "🙁",
                            text: "Evet orta riskli",
                          ),
                          HealthStatusModel(
                            emoji: "😰",
                            text: "Evet yüksek riskli",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 3,
                    color: Colors.white,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Temas sonrası SB riskli temas algoritması uygun bir şekilde uygulandı mı?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: HealthWidgetController(
                        healthStatusModelList: [
                          HealthStatusModel(
                            emoji: "😊",
                            text:
                                "Hayır, protokol uygulanmadı ve çalışmaya zorlandım",
                          ),
                          HealthStatusModel(
                            emoji: "😷",
                            text:
                                "Evet, yüksek riskliydim hidroksiklorin tedavisiyle beş gün istirahat sonrasında testim negatif çıktı işe başladım",
                          ),
                          HealthStatusModel(
                            emoji: "🤒",
                            text:
                                "Evet orta riskliydim maskeyle çalıştım ve beş gün sonra test yapıldı",
                          ),
                          HealthStatusModel(
                            emoji: "😶",
                            text:
                                "Evet düşük riskliydim, maske ile çalıştım, semptom takibim yapıldı ve yedinci günde test yapıldı",
                          ),
                          HealthStatusModel(
                            emoji: "😶",
                            text: "Diğer",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

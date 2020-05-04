import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinemoji/models/company.dart';
import 'package:pinemoji/models/emoji.dart';
import 'package:pinemoji/models/emoji_option.dart';
import 'package:pinemoji/models/question.dart';
import 'package:pinemoji/models/request.dart';
import 'package:pinemoji/models/survey.dart';

class CompanyRepository {
  Company getCompany() {
    return Company(
        id: "2df77a23-1534-4736-825c-d180566250a3",
        name: "İstanbul Tabipler Odası",
        title: "İsatnbul Tabipler Odası",
        taxNo: "");
  }

  List<Emoji> getEmojiList() {
    List<Emoji> emojiList = [
      Emoji(
          companyId: "2df77a23-1534-4736-825c-d180566250a3",
          description: " Tıbbi\nMaske",
          info: "😷",
          optionList: [
            EmojiOption(name: "Acil Destek", color: "D71773"),
            EmojiOption(name: "Azalıyor", color: "EBEE51"),
            EmojiOption(name: "Yeterli", color: "1CABCB"),
          ],
          stateList: []),
      Emoji(
          companyId: "2df77a23-1534-4736-825c-d180566250a3",
          description: "  N95\nMaske",
          info: "😷",
          optionList: [
            EmojiOption(name: "Acil Destek", color: "D71773"),
            EmojiOption(name: "Azalıyor", color: "EBEE51"),
            EmojiOption(name: "Yeterli", color: "1CABCB"),
          ],
          stateList: []),
      Emoji(
          companyId: "2df77a23-1534-4736-825c-d180566250a3",
          description: "Siperlik /\n Gözlük",
          info: "🥽",
          optionList: [
            EmojiOption(name: "Acil Destek", color: "D71773"),
            EmojiOption(name: "Azalıyor", color: "EBEE51"),
            EmojiOption(name: "Yeterli", color: "1CABCB"),
          ],
          stateList: []),
      Emoji(
          companyId: "2df77a23-1534-4736-825c-d180566250a3",
          description: "Eldiven",
          info: "🧤",
          optionList: [
            EmojiOption(name: "Acil Destek", color: "D71773"),
            EmojiOption(name: "Azalıyor", color: "EBEE51"),
            EmojiOption(name: "Yeterli", color: "1CABCB"),
          ],
          stateList: []),
      Emoji(
          companyId: "2df77a23-1534-4736-825c-d180566250a3",
          description: "Önlük",
          info: "🥼",
          optionList: [
            EmojiOption(name: "Acil Destek", color: "D71773"),
            EmojiOption(name: "Azalıyor", color: "EBEE51"),
            EmojiOption(name: "Yeterli", color: "1CABCB"),
          ],
          stateList: []),
      Emoji(
          companyId: "2df77a23-1534-4736-825c-d180566250a3",
          description: "Solunum\n  Cihazı",
          info: "⚗",
          optionList: [
            EmojiOption(name: "Acil Destek", color: "D71773"),
            EmojiOption(name: "Azalıyor", color: "EBEE51"),
            EmojiOption(name: "Yeterli", color: "1CABCB"),
          ],
          stateList: []),
    ];
    return emojiList;
  }

  Survey getSurvey() {
    return Survey(
        id: "1268aa3c-5675-486a-9fc6-7903b8e554c5",
        active: true,
        companyId: "2df77a23-1534-4736-825c-d180566250a3",
        answerType: "updateable",
        sendType: "incomplete",
        info: "Sağlık Durumu",
        questionList: [
          Question(
              id: "d92abe85-fa24-4a04-b29d-3b8245640491",
              description: "Şu ana kadar COVID-19 tanısı aldınız mı?",
              type: "TEXT",
              answerList: [
                "Hayır",
                "Evet, test sonucum pozitif çıktı",
                "Evet test negatifti ama BT sonucuma göre",
              ],
              emojiList: [
                "😊",
                "😒",
                "😐",
              ]),
          Question(
              id: "22d61d18-da9a-48ac-a88f-b24af8dcba73",
              description: "COVID-19 nedeniyle uygulanan tedavi",
              type: "TEXT",
              answerList: [
                "Tanı almadım",
                "Hastalığı evde ilaç alarak geçirdim",
                "Serviste yatarak tedavi gördüm",
                "Yoğun bakımda yatarak tedavi gördüm",
                "Entübe edildim",
              ],
              emojiList: [
                "😊",
                "😷",
                "🤒",
                "😶",
                "🤢",
              ]),
          Question(
              id: "c7706328-7dc4-488b-9ab4-f5ad18466b4d",
              description: "Riskli COVID 19 temasınız oldu mu?",
              type: "SELECT",
              answerList: [
                "Hayır",
                "Evet düşük riskli",
                "Evet orta riskli",
                "Evet yüksek riskli",
              ],
              emojiList: [
                "😊",
                "😐",
                "🙁",
                "😰",
              ]),
          Question(
              id: "268feb88-38ee-4abd-8a04-57a9fe5ff805",
              description:
                  "Temas sonrası SB riskli temas algoritması uygun bir şekilde uygulandı mı?",
              type: "TEXT",
              answerList: [
                "Hayır, protokol uygulanmadı ve çalışmaya zorlandım",
                "Evet, yüksek riskliydim hidroksiklorin tedavisiyle beş gün istirahat sonrasında testim negatif çıktı işe başladım",
                "Evet orta riskliydim maskeyle çalıştım ve beş gün sonra test yapıldı",
                "Evet düşük riskliydim, maske ile çalıştım, semptom takibim yapıldı ve yedinci günde test yapıldı",
              ],
              emojiList: [
                "😓",
                "🤢",
                "😷",
                "😷",
              ])
        ]);
  }
}

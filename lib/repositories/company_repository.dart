import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinemoji/models/answer.dart';
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
          id: "1",
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
          id: "2",
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
          id: "3",
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
          id: "4",
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
          id: "5",
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
          id: "6",
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
                Answer(answerText: "Hayır" ,emojiText: "😊",),
                Answer(answerText: "Evet, test sonucum pozitif çıktı" ,emojiText: "😒",),
                Answer(answerText: "Evet test negatifti ama BT sonucuma göre" , emojiText: "😐",),
                Answer(answerText: "Diğer" ,emojiText: "😶",),
              ]),
          Question(
              id: "22d61d18-da9a-48ac-a88f-b24af8dcba73",
              description: "COVID-19 nedeniyle uygulanan tedavi",
              type: "TEXT",
              answerList: [
                Answer(answerText: "Tanı almadım", emojiText: "😊",),
                Answer(answerText: "Hastalığı evde ilaç alarak geçirdim", emojiText: "😷",),
                Answer(answerText: "Serviste yatarak tedavi gördüm", emojiText: "🤒",),
                Answer(answerText: "Yoğun bakımda yatarak tedavi gördüm", emojiText: "😶",),
                Answer(answerText: "Entübe edildim", emojiText: "🤢",),
                Answer(answerText: "Diğer", emojiText: "😶",),    
              ]),
          Question(
              id: "c7706328-7dc4-488b-9ab4-f5ad18466b4d",
              description: "Riskli COVID 19 temasınız oldu mu?",
              type: "SELECT",
              answerList: [
                Answer(answerText: "Hayır", emojiText: "😊",),
                Answer(answerText: "Evet düşük riskli", emojiText: "😐",),
                Answer(answerText: "Evet orta riskli", emojiText:"🙁",),
                Answer(answerText: "Evet yüksek riskli", emojiText: "😰",),
              ]),
          Question(
              id: "268feb88-38ee-4abd-8a04-57a9fe5ff805",
              description:
                  "Temas sonrası SB riskli temas algoritması uygun bir şekilde uygulandı mı?",
              type: "TEXT",
              answerList: [
                Answer(answerText: "Hayır, protokol uygulanmadı ve çalışmaya zorlandım", emojiText: "😓",),
                Answer(answerText: "Evet, yüksek riskliydim hidroksiklorin tedavisiyle beş gün istirahat sonrasında testim negatif çıktı işe başladım", emojiText: "🤢",),
                Answer(answerText: "Evet orta riskliydim maskeyle çalıştım ve beş gün sonra test yapıldı", emojiText: "😷",),
                Answer(answerText: "Evet düşük riskliydim, maske ile çalıştım, semptom takibim yapıldı ve yedinci günde test yapıldı", emojiText: "😷",),
                Answer(answerText: "Diğer", emojiText: "😶",),
              ])
        ]);
  }
}

import 'package:pinemoji/models/company.dart';
import 'package:pinemoji/models/emoji.dart';
import 'package:pinemoji/models/emoji_option.dart';
import 'package:pinemoji/models/question.dart';
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
          description: "Tek Kullanımlık Önlük",
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
              description: "Şu ana kadar son salgında tanı aldınız mı?",
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
              description: "Son salgın nedeniyle uygulanan tedavi",
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
              description: "Son salgın hastası ile riskli bir temasınız oldu mu?",
              type: "SELECT",
              answerList: [
                "Hayır",
                "Evet düşük riskli (Tıbbi maske takılmış, gözlük, eldiven ve önlük kullanılmamış)",
                "Evet orta riskli (Tıbbi maske veya N95 kullanmamış/N95 endikasyonu olan durumda tıbbi maske kullanmış / göz koruyucu kullanılmamış)",
                "Evet yüksek riskli (Tıbbi maske veya N95 kullanmamış)",
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
                  "Temas sonrası SB riskli temas algoritması uygulandı mı?",
              type: "TEXT",
              answerList: [
                "Hayır, herhangi bir protokol uygulanmadı ve çalışmaya devam ettim",
                "Evet, yüksek riskliydim ve algoritmaya göre izlendim",
                "Evet orta riskliydim maskeyle çalıştım ve yedi gün sonra test yapıldı",
                "Evet düşük riskliydim, maske ile çalıştım, semptom takibim yapıldı",
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

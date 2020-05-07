import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

import 'constants.dart';

void main(List<String> args) {
  var teleDart = TeleDart(Telegram(Constants.botKey), Event());
  teleDart.start().then((User me) => print('${me.username} is initialised'));

  teleDart.onCommand('start').listen((Message message) {
    ReplyMarkup replyMarkup = InlineKeyboardMarkup(inline_keyboard: [
      [
        InlineKeyboardButton(
            text: 'Github Repo',
            url: 'https://github.com/FlutterKerala/WeeklyChallenges')
      ]
    ]);
    return teleDart.replyMessage(message,
        'Hi, <b>${message.from.first_name}</b> [@${message.from.username}] \nUse <code>/week weeknumber</code> to get leaderboard results of specified week',
        parse_mode: 'html', reply_markup: replyMarkup);
  });
}

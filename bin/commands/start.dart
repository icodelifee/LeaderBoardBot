import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

Future<Message> start(Message message, TeleDart teleDart) {
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
}

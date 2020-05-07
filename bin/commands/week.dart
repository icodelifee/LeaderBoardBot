import 'dart:io';

import 'package:grizzly_io/io_loader.dart';
import 'package:path/path.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

Future<Message> week(Message message, TeleDart teleDart) async {
  var week;
  // get week from reponse
  var exp = RegExp(r'^\/week (.+)$');
  try {
    week = exp.firstMatch(message.text).group(1);
  } catch (e) {
    return teleDart.replyMessage(message, 'Oops! Something Went Wrong');
  }

  List<List<String>> csv;
  // check if provided week is a number or not
  if (!isNumeric(week)) {
    return teleDart.replyMessage(message, 'Sorry! Invalid Week.');
  }

  final filePath =
      join(dirname(Platform.script.toFilePath()), 'data', 'week$week.csv');

  try {
    //Read CSV From File And Parse
    csv = await readCsv(filePath);
  } catch (e) {
    // If file not found return not found error
    return teleDart.replyMessage(
        message, 'Oops! Cannot Find The Data For The Requested Week');
  }

  // Remove the headers
  csv.removeAt(0);

  // Sort by points
  csv.sort((a, b) => int.parse(a[2]).compareTo(int.parse(b[2])));

  var res = "Week 1's Leaderboard : \nTeam\t| Members\t| Points\n";
  for (var team in csv) {
    res += '${team[0]}\t|${team[1]}\t|${team[2]}\n';
  }
  return teleDart.replyMessage(message, res,
      parse_mode: 'html', disable_web_page_preview: true);
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

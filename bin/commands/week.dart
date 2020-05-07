import 'dart:io';
import "dart:math";

import 'package:grizzly_io/io_loader.dart';
import 'package:path/path.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';


int getMaxLength(Iterable names) {
  
 return names.map<int>((n) => (n is num ? n.toString().length : n.length)).reduce(max);
  
}
  
String lpad(str, len) {
  
    int diff = max(0, len - str.length);
  
    return (" " * diff) + str;
  
}
  
String rpad(str, len) {
  
    int diff = max(0, len - str.length);
  
    return str + (" " * diff);
  
}
  
String col ( List items ) => "| " + items.join(" | ") + " |";

String leaderboard(List data) {
  
  int col1Max = max("ID".length, getMaxLength(data.map((list) => list[0])));
  
  int col2Max = max("Teams".length, getMaxLength(data.map((list) => list[1])));
  
  int col3Max = max("Points".length, getMaxLength(data.map((list) => list[2])));
  
  String topHeader = "** Leaderboard **\n";
  
  String header = col([rpad("ID", col1Max),rpad("Team", col2Max), rpad("Points", col3Max)]);
 
  String div = "-" * header.length;
  
  String rows = (data.fold<List<String>>([], (init, v) => [...init,
                                                           col([lpad(v[0].toString(), col1Max),                              rpad(v[1].toString(), col2Max),
     lpad(v[2].toString(), col3Max)])]).join("\n"));
  
  return [topHeader, header, div, rows].join("\n");
  
}

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

  res += leaderboard(csv)

  return teleDart.replyMessage(message, res,
      parse_mode: 'html', disable_web_page_preview: true);
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

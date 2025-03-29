import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Utils{

  //Source: https://stackoverflow.com/questions/63010255/get-first-few-words-of-a-string-in-dart
  String firstFewWords(String bigSentence, int numberOfWords){

    int startIndex = 0;
    int indexOfSpace = 0;

    for(int i = 0; i < numberOfWords; i++){
      indexOfSpace = bigSentence.indexOf(' ', startIndex);
      if(indexOfSpace == -1){
        return bigSentence;
      }
      startIndex = indexOfSpace + 1;
    }

    return '${bigSentence.substring(0, indexOfSpace)}...';
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if(dateTime.isAfter(today.subtract(Duration(days: 1))) && dateTime.isBefore(today.add(Duration(days: 1)))){
      return 'Today, ${DateFormat('hh:mma').format(dateTime)}';
    }

    return DateFormat('EEEE, hh:mma').format(dateTime);
  }
}
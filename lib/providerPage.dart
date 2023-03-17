import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:remider_app/sample.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class ProviderPage extends ChangeNotifier {

 CalendarFormat calendarFormat = CalendarFormat.week;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDate = DateTime.now();
   late SharedPreferences prefs;



  Map<String, List<Map<String, String>>> mySelectedEvents = {};



   provi(title, descri, time) {
    mySelectedEvents[DateFormat('yyyy-MM-dd').format(selectedDate!)]?.add({
      "eventTitle": title,
      "eventDescp": descri,
      "time": time,
    });

    notifyListeners();
  }



  // CalendarFormat _calendarFormat = CalendarFormat.week;
  // DateTime _focusedDay = DateTime.now();


    // CalendarFormat get calendarFormat => _calendarFormat;
  // DateTime get focusedDay => _focusedDay;



  
  // set calendarFormat(CalendarFormat value) {
  //   _calendarFormat = value;
  //   notifyListeners();
  // }

  // set focusedDay(DateTime value) {
  //   _focusedDay = value;
  //   notifyListeners();
  // }

  // set selectedDate(DateTime? value) {
  //   _selectedDate = value;
  //   notifyListeners();
  // }

  // set mySelectedEvents(Map<String, List> value) {
  //   _mySelectedEvents = value;
  //   notifyListeners();
  // }
}

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remider_app/providerPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  //---Text editing controller

  final titleController = TextEditingController();
  final descpController = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  late SharedPreferences prefs;

  String? get title => null;

  String? get descri => null;

  String? get time => null;

  @override
  void initState() {
    //---TODO: implement initState

    super.initState();
    _selectedDate = _focusedDay;
    timeinput.text = "";
    initPrefs();
  }

  Map<String, List> mySelectedEvents = {};

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  ///---Shared Preference---------------------------------------------------------

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      mySelectedEvents = Map<String, List<dynamic>>.from(
          (json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderPage>(builder: (context, value, _) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 6),

                //---TableCalendar------------------------------------------------

                TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime(2030),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,

                  //---Header Style-----------------------------------------------

                  headerStyle: const HeaderStyle(
                    headerMargin: EdgeInsets.all(8.0),
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    formatButtonVisible: false,
                    formatButtonShowsNext: false,
                    titleTextStyle:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),

                  //---CalendarStyle----------------------------------------------

                  calendarStyle: const CalendarStyle(
                    defaultTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                    weekendTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDate, selectedDay)) {
                      // Call `setState()` when updating the selected day
                      setState(() {
                        _selectedDate = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDate, day);
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      // Call `setState()` when updating calendar format
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    // No need to call `setState()` here
                    _focusedDay = focusedDay;
                  },
                  eventLoader: _listOfDayEvents,
                ),

                //---EventCalendarScreen------------------------------------------

                SizedBox(
                  height: 10,
                ),
                ..._listOfDayEvents(_selectedDate!).map(
                  (myEvents) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 95,
                      decoration: BoxDecoration(
                        color: Colors.primaries[
                            Random().nextInt(Colors.primaries.length)],
                        border: Border.all(width: .01),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(' ${myEvents['eventTitle']}'),
                        ),
                        subtitle: Text('   ${myEvents['eventDescp']}'),
                        trailing: Text('  ${myEvents['time']}'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                elevation: 0,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      style: TextStyle(height: 0.40, fontSize: 14),
                      controller: titleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 254, 254, 254),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Title',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    //---pick your time

                    Text("pick your time"),
                    SizedBox(height: 4),
                    SizedBox(
                      width: 5,
                      child: TextField(
                        controller: timeinput,
                        style: TextStyle(height: 0.40, fontSize: 14),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if (pickedTime != null) {
                            print(pickedTime.format(context)); //output 10:51 PM
                            DateTime parsedTime = DateFormat.jm()
                                .parse(pickedTime.format(context).toString());

                            String formattedTime =
                                DateFormat("h:mma").format(parsedTime);

                            setState(() {
                              timeinput.text =
                                  formattedTime; //set the value of text field.
                            });
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.timer_sharp,
                            color: Color.fromARGB(255, 72, 59, 59),
                          ),
                          hintText: "",
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    //---Descrption

                    TextField(
                      controller: descpController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Descrption',
                      ),
                    ),
                  ],
                ),

                //---Cancel

                actions: [
                  MaterialButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                    textColor: Colors.white,
                  ),

                  //---Add

                  MaterialButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: const Text('Add '),
                    textColor: Colors.white,
                    onPressed: () {
                      if (titleController.text.isEmpty &&
                          descpController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Required title and description'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        //---Navigator.pop(context);

                        return;
                      } else {
                        if (mySelectedEvents[DateFormat('yyyy-MM-dd')
                                .format(_selectedDate!)] !=
                            null) {
                          mySelectedEvents[DateFormat('yyyy-MM-dd')
                                  .format(_selectedDate!)]
                              ?.add({
                            "eventTitle": titleController.text,
                            "eventDescp": descpController.text,
                            "time": timeinput.text,
                          });
                        } else {
                          mySelectedEvents[DateFormat('yyyy-MM-dd')
                              .format(_selectedDate!)] = [
                            {
                              "eventTitle": titleController.text,
                              "eventDescp": descpController.text,
                              "time": timeinput.text,
                            }
                          ];
                        }

                        prefs.setString(
                            "events", json.encode((mySelectedEvents)));
                        titleController.clear();
                        descpController.clear();
                        timeinput.clear();
                        Navigator.pop(context);

                        value.provi(title, descri, time);

                        return;
                      }
                    },
                  ),
                ],
              ),
            );
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
      );
    });
  }
  //--- _showAddEventDialog

}

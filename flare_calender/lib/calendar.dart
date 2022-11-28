import 'dart:ffi';

import 'package:flare_calender/eventData.dart';
import 'package:flare_calender/eventsProvider.dart';
import 'package:flare_calender/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key, required this.current_day});
  final DateTime current_day;
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<DateTime> date_list = [];
  List<DateTime> first_week = [];
  List<DateTime> last_week = [];
  //DateTime selected_date_time = current_day;
  final event_name_controller = TextEditingController();
  //DateTime chosen_date = day;
  bool check_today(DateTime date_1) {
    //debugPrint("Checking date");
    for (int i = 0;
        i <
            Provider.of<EventsProvider>(context, listen: false)
                .events_list
                .length;
        i++) {
      if (date_1.day ==
              Provider.of<EventsProvider>(context, listen: false)
                  .events_list[i]
                  .date
                  .day &&
          date_1.month ==
              Provider.of<EventsProvider>(context, listen: false)
                  .events_list[i]
                  .date
                  .month &&
          date_1.year ==
              Provider.of<EventsProvider>(context, listen: false)
                  .events_list[i]
                  .date
                  .year) {
        //debugPrint('----: SAME DAY:-----');
        return true;
      } else {
        //debugPrint('----: DIFF DAYS:-----');
        //return false;
      }
    }
    return false;
  }

  void first_week_gen(DateTime day) {
    first_week = [];
    DateTime first_day = DateTime(day.year, day.month, 1); //tuesday 1st nov 22
    int day_num = first_day.weekday;
    first_day = first_day.subtract(Duration(days: day_num));
    //debugPrint("${first_day}");
    for (var i = 0; i < 7; i++) {
      first_week.add(first_day.add(Duration(days: i)));
    }

    debugPrint("${first_week},${first_week.length}");

    /*for(int i = 0; i<8; i++){}
    for(var day in first_week)*/
  }

  void last_week_gen(DateTime day) {
    last_week = [];
    DateTime last_day = DateTime(day.year, day.month + 1, 0);
    //debugPrint('${last_day}');
    int day_num = last_day.weekday;
    last_day = last_day.subtract(Duration(days: day_num));
    //debugPrint("${last_day}");
    for (var i = 0; i < 7; i++) {
      last_week.add(last_day.add(Duration(days: i)));
    }
    debugPrint('last week: ${last_week}');
  }

  void mid_week_gen(DateTime day) {
    date_list = [];
    DateTime explore_day = day.add(Duration(days: 1, hours: 12));
    debugPrint('Explore day ----: ${explore_day}');

    while (explore_day.isBefore(last_week.first)) {
      date_list.add(explore_day);
      explore_day = explore_day.add(Duration(days: 1));
    }
    debugPrint('mid week: ${date_list}');
    date_list.insertAll(0, first_week);
    date_list.addAll(last_week);
    debugPrint('Full List----: ${date_list} ');
  }

  @override
  void initState() {
    // TODO: implement initState
    first_week_gen(widget.current_day);
    last_week_gen(widget.current_day);
    mid_week_gen(first_week.last);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    first_week_gen(widget.current_day);
    last_week_gen(widget.current_day);
    mid_week_gen(first_week.last);
    debugPrint(
        'Events list ---: ${Provider.of<EventsProvider>(context, listen: false).events_list}');
    List<String> days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Container(
      height: 400,
      width: 400,
      child: Column(children: [
        Text(
            '${DateFormat(
              'MMMM y',
            ).format(widget.current_day)}',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)
            //style: Theme.of(context).textTheme.bodyText2)

            ),
        GridView.builder(
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            itemCount: date_list.length +
                7, //This is what defines x in [for index in range(0,x)]
            itemBuilder: ((context, index) {
              if (index > 6) {
                return GestureDetector(
                  onTap: () async {
                    DateTime day_chosen = date_list[index - 7];
                    await showDialog<void>(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                              title: Text(
                                "New Event",
                                style: TextStyle(fontSize: 24),
                              ),
                              content: Material(
                                child: TextField(
                                  controller: event_name_controller,
                                ),
                              ),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text(
                                    "Save",
                                    textAlign: TextAlign.center,

                                    //when you press the save button, save the couple [DateTime, Event_name]
                                  ),
                                  onPressed: () {
                                    Provider.of<EventsProvider>(context,
                                            listen: false)
                                        .event_create(
                                      event_name_controller.text,
                                      day_chosen,
                                    );
                                    debugPrint(
                                        'Events list ---: ${Provider.of<EventsProvider>(context, listen: false).events_list}');

                                    Navigator.of(context).pop();
                                    event_name_controller.clear();
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    event_name_controller.clear();
                                    Provider.of<EventsProvider>(context,
                                            listen: false)
                                        .events_list_clear();
                                  },
                                ),
                              ],
                            ));
                    setState(() {});
                    event_name_controller.clear();
                  },
                  child: Container(
                    // = (current_day == date_list[index])
                    //?
                    //:
                    //
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (check_today(date_list[index - 7]))
                            ? Colors.pink
                            : null),
                    child: Center(
                      child: Text(

                          //Numbers on the calendar
                          '${date_list[index - 7].day}',
                          style: TextStyle(
                              color: ((date_list[index - 7].day ==
                                          DateTime.now().day &&
                                      date_list[index - 7].month ==
                                          DateTime.now().month &&
                                      date_list[index - 7].year ==
                                          DateTime.now().year)
                                  //
                                  ? Colors.pink
                                  : (date_list[index - 7].month !=
                                          widget.current_day.month)
                                      ? Colors.grey
                                      : null))),
                    ),
                  ),
                );
              } else {
                return Container(
                    //Letters at the top
                    child: Center(
                        child: Text(
                  "${days[index]}",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                )));
              }
            })),
      ]),
    );
  }
}

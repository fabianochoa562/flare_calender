import 'package:flare_calender/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import 'editDay.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  DateTime current_day = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        /*floatingActionButton: FloatingActionButton(
              onPressed: () {
                Provider.of<EventsProvider>(context, listen: false).increment();
              },
            ), */
        appBar: AppBar(
          title: Text(
            "Calendar",
          ),
        ),
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                height: 600,
                width: 400,
                child: ScrollSnapList(
                    key: Key("test"),
                    shrinkWrap: true,
                    listController: ScrollController(
                        initialScrollOffset: 12 *
                            400), //sets the first month shown to current_day.month
                    itemCount: 24,
                    itemSize: 400, //MediaQuery.of(context).size.width,
                    onItemFocus: (p0) {},
                    itemBuilder: (context, index) {
                      return Calendar(
                        current_day: current_day
                            .subtract(Duration(days: 12 * 30))
                            .add(Duration(days: index * 30)),
                      );
                    }),
              ),
              FloatingActionButton(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                mini: true,
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ModalBottomSheet();
                      });
                },
                child: Icon(Icons.add),
              )
            ],
          ),
        ));
  }
}

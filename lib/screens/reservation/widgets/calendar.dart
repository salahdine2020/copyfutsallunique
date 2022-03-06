import 'package:flutter/material.dart';
import 'package:futsal_unique/models/booking_model.dart';
import 'package:futsal_unique/screens/reservation/reservation.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  final ValueChanged<String?> update;
  const Calendar({Key? key, required this.update}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDate = DateTime.now(); // TO tracking date
  int? currentDateSelectedIndex;//= 0; //For Horizontal Date
  ScrollController scrollController = ScrollController(); //To Track Scroll of ListView

  List<String> listOfMonths = [
    "Janv",
    "Févr",
    "Mars",
    "Avr",
    "Mai",
    "Juin",
    "Juill",
    "Août",
    "Sept",
    "Oct",
    "Nov",
    "Déc"
  ];

  List<String> listOfDays = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 30,
            //margin: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              listOfMonths[selectedDate.month - 1] +
                  ', ' +
                  selectedDate.year.toString(),
              style: kFontSize18FontWeight600TextStyle,
            )),
        Container(
            height: 70,
            child: Container(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 20);
                  },
                  itemCount: 60,
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          currentDateSelectedIndex = index;
                          selectedDate =
                              DateTime.now().add(Duration(days: index));
                          String selectedDateFormat = DateFormat('dd-MM-yyyy').format(selectedDate);
                          print('selected date is $selectedDateFormat');
                          print('---------------------------------------------------------------------');
                          print('selected date is $selectedDate');
                          Booking.date = selectedDateFormat;
                          print('date in booking app is === ${Booking.date}');
                          widget.update(selectedDateFormat);
                        });
                      },
                      child: Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width/5,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: currentDateSelectedIndex == index
                                ? colorButton
                                : Colors.white70),//Color(0xffEEEEEE)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              listOfMonths[DateTime.now()
                                  .add(Duration(days: index))
                                  .month -
                                  1]
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: currentDateSelectedIndex == index
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            Text(
                              DateTime.now()
                                  .add(Duration(days: index))
                                  .day
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: currentDateSelectedIndex == index
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            Text(
                              listOfDays[DateTime.now()
                                  .add(Duration(days: index))
                                  .weekday -
                                  1]
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: currentDateSelectedIndex == index
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
            )
        )
      ],
    );
  }
}

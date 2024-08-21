import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Set<DateTime> _selectedDays = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: 3, // number of months to show
        itemBuilder: (context, index) {
          final dateNow = DateTime.now();
          final firstDay = DateTime(dateNow.year, dateNow.month + index, 1);
          final lastDay = DateTime(dateNow.year, dateNow.month + index + 1, 0);

          return TableCalendar(
            headerStyle: const HeaderStyle(
              headerPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              formatButtonVisible: false,
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextFormatter: (date, locale) => date.narrowDayOfWeek,
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableGestures: AvailableGestures.none,
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: firstDay,
            enabledDayPredicate: (day) {
              // Disable weekend days (Saturday & Sunday)
              if (day.weekday == DateTime.saturday ||
                  day.weekday == DateTime.sunday) {
                return false;
              }
              return true;
            },
            calendarBuilders: CalendarBuilders(
              // Customize style and appearance for disabled days
              disabledBuilder: (context, day, focusedDay) {
                if (day.weekday == DateTime.saturday) {
                  return Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                if (day.weekday == DateTime.sunday) {
                  return Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return null;
              },
              defaultBuilder: (context, day, focusedDay) {
                // Customize style and appearance for default days
                return Center(
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            selectedDayPredicate: (day) => _selectedDays.contains(day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                if (_selectedDays.contains(selectedDay)) {
                  _selectedDays.remove(selectedDay);
                } else {
                  _selectedDays.add(selectedDay);
                }
              });
            },
          );
        },
      ),
    );
  }
}

extension NarrowDayOfWeek on DateTime {
  String get narrowDayOfWeek {
    List<String> narrowWeekdays = DateFormat.EEEE().dateSymbols.NARROWWEEKDAYS;
    int dayOfWeekIndex =
        weekday % 7; // Modulo 7 to get the index (0 = Sunday, 6 = Saturday)
    return narrowWeekdays[dayOfWeekIndex];
  }
}

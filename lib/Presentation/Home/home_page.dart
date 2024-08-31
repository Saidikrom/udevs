import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:udevstech/core/constants/color_const.dart';
import 'package:udevstech/core/constants/font_const.dart';
import 'package:udevstech/core/constants/p_m_const.dart';
import 'package:udevstech/core/constants/radius_const.dart';
import 'package:udevstech/widgets/custom_calendar.dart';
import 'package:udevstech/widgets/event_element.dart';

import '../../bloc/data_bloc.dart';
import '../../bloc/data_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  List<DateTime> todoDates = [
    DateTime.now().subtract(const Duration(days: 2)),
    DateTime.now().add(const Duration(days: 1)),
    DateTime.now().add(const Duration(days: 3)),
  ];

  void _onYearChanged(int? newYear) {
    setState(() {
      selectedDate = DateTime(newYear!, selectedDate.month, selectedDate.day);
    });
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  DateTime _parseDate(String dateString) {
    dateString = dateString.trim();

    try {
      return DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString);
    } catch (e) {
      print(
          'Failed to parse date with alternative format yyyy-MM-dd HH:mm:ss. Error: $e');
    }

    print('Date parsing error: $dateString');
    throw FormatException('Invalid date format: $dateString');
  }

  Color _parseColor(String colorName) {
    switch (colorName) {
      case "Blue":
        return ColorConst.primaryColorBlue;
      case "Red":
        return ColorConst.redColor;
      case "Orange":
        return ColorConst.orangeColor;
      default:
        return ColorConst.primaryColorBlue; // Default color for unknown names
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primaryBGColor,
      body: BlocBuilder<DataBloc, DataState>(builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DataError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is DataLoaded) {
          final events = state.data;
          final eventColors = <DateTime, List<Color>>{};
          for (var event in events) {
            DateTime eventDate;
            try {
              eventDate = _parseDate(event.time);
            } catch (e) {
              print('Error parsing date: $e');
              continue;
            }
            if (eventColors.containsKey(eventDate)) {
              eventColors[eventDate]!.add(_parseColor(event.color));
            } else {
              eventColors[eventDate] = [_parseColor(event.color)];
            }
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: PMConst.small15All,
                child: Column(
                  children: [
                    customAppBar(),
                    CalendarHeader(
                      selectedDate: selectedDate,
                      onPreviousMonth: () {
                        setState(() {
                          selectedDate = DateTime(
                              selectedDate.year, selectedDate.month - 1);
                        });
                      },
                      onNextMonth: () {
                        setState(() {
                          selectedDate = DateTime(
                              selectedDate.year, selectedDate.month + 1);
                        });
                      },
                      onYearChanged: _onYearChanged,
                    ),
                    buildWeekDays(),
                    CustomCalendarWidget(
                      selectedDate: selectedDate,
                      eventColors: eventColors,
                      onDateSelected: _onDateChanged,
                    ),
                    addEvent(),
                    listOfEvents(),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('No data available'),
          );
        }
      }),
    );
  }

  Widget listOfEvents() {
    return Container(
      width: 319,
      margin: PMConst.smallToponly,
      child: BlocBuilder<DataBloc, DataState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is DataLoaded) {
            final dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");

            final filteredEvents = state.data.where(
              (event) {
                try {
                  final eventDate = dateFormat.parse(event.time);
                  return eventDate.year == selectedDate.year &&
                      eventDate.month == selectedDate.month &&
                      eventDate.day == selectedDate.day;
                } catch (e) {
                  print('Date parsing error: $e');
                  return false;
                }
              },
            ).toList();

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final item = filteredEvents[index];
                return EventElement(
                  id: item.id!,
                  name: item.name,
                  subname: item.subname,
                  time: item.time,
                  hour: item.hour,
                  location: item.location,
                  color: item.color,
                );
              },
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }

  Widget addEvent() {
    return Padding(
      padding: PMConst.regularToponly,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Schedule",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: FontConst.regular14Font),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/AddEvent");
            },
            child: Container(
              height: 30.h,
              width: 102.w,
              decoration: BoxDecoration(
                borderRadius: RadiusConst.regularRadius,
                color: ColorConst.primaryColorBlue,
              ),
              child: Center(
                  child: Text(
                "+ Add Event",
                style: TextStyle(
                    color: ColorConst.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: FontConst.small10Font),
              )),
            ),
          )
        ],
      ),
    );
  }

  Widget customAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          color: ColorConst.primaryBGColor,
          width: MediaQuery.of(context).size.width / 2 + 25,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 110.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: PMConst.extraSmallRightonly,
                        child: Text(
                          "Sunday",
                          style: TextStyle(
                              fontSize: FontConst.regular14Font,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${monthName(selectedDate.month)} ",
                            style: TextStyle(fontSize: FontConst.small10Font),
                          ),
                          YearChooser(
                            selectedYear: selectedDate.year,
                            onYearChanged: _onYearChanged,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SvgPicture.asset(
          "assets/icons/notification_icon.svg",
          height: 20.h,
          width: 20.w,
        ),
      ],
    );
  }

  Widget buildWeekDays() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][index],
            style: TextStyle(fontSize: FontConst.regular12Font),
          ),
        );
      },
    );
  }

  String monthName(int month) {
    List<String> monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return monthNames[month - 1];
  }
}

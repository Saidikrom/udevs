import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:udevstech/core/constants/color_const.dart';
import 'package:udevstech/core/constants/font_const.dart';


class CustomCalendarWidget extends StatelessWidget {
  final DateTime selectedDate;

  final ValueChanged<DateTime> onDateSelected;
   final Map<DateTime, List<Color>> eventColors;

  const CustomCalendarWidget({super.key, 
   required this.selectedDate,
    required this.eventColors,
    required this.onDateSelected,
  });

  @override
   Widget build(BuildContext context) {
    int daysInMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    int firstDayOfWeek =
        DateTime(selectedDate.year, selectedDate.month, 1).weekday;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: daysInMonth + firstDayOfWeek - 1,
      itemBuilder: (context, index) {
        if (index < firstDayOfWeek - 1) {
          return Container();
        } else {
          int day = index - firstDayOfWeek + 2;
          DateTime currentDay =
              DateTime(selectedDate.year, selectedDate.month, day);
          List<Color> colors = eventColors[currentDay] ?? [];

          return _buildDayCell(context, currentDay, day, colors);
        }
      },
    );
  }

 Widget _buildDayCell(
      BuildContext context, DateTime currentDay, int day, List<Color> colors) {
    bool isSelected = currentDay.year == selectedDate.year &&
        currentDay.month == selectedDate.month &&
        currentDay.day == selectedDate.day;

    return GestureDetector(
      onTap: () => onDateSelected(currentDay),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? ColorConst.primaryColorBlue : Colors.transparent,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "$day",
              style: TextStyle(
                fontSize: FontConst.medium16Font,
                color: isSelected
                    ? ColorConst.primaryColor
                    : ColorConst.primaryDarckColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (colors.isNotEmpty)
              Positioned(
                bottom: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(colors.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1.0),
                      width: 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: colors[index],
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class YearChooser extends StatelessWidget {
  final int selectedYear;
  final ValueChanged<int?> onYearChanged;

  const YearChooser({super.key, required this.selectedYear, required this.onYearChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      value: selectedYear,
      items: List.generate(3001, (index) {
        int year = 1950 + index;
        return DropdownMenuItem(
          value: year,
          child: Text(
            "$year",
            style: TextStyle(
              fontSize: FontConst.regular14Font,
            ),
          ),
        );
      }),
      onChanged: onYearChanged,
    );
  }
}

class CalendarHeader extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<int?> onYearChanged;

  const CalendarHeader({super.key, 
    required this.selectedDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${_monthName(selectedDate.month)} ",
          style: TextStyle(
              fontSize: FontConst.medium20Font, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: onPreviousMonth,
              child: Container(
                height: 23.h,
                width: 23.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConst.extralightGrayColor),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 15,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            GestureDetector(
              onTap: onNextMonth,
              child: Container(
                height: 23.h,
                width: 23.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConst.extralightGrayColor,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _monthName(int month) {
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:udevstech/core/constants/color_const.dart';
import 'package:udevstech/core/constants/font_const.dart';
import 'package:udevstech/core/constants/p_m_const.dart';
import 'package:udevstech/core/constants/radius_const.dart';

class EventElement extends StatelessWidget {
  final int id;
  final String name;
  final String subname;
  final String time;
  final String hour;
  final String location;
  final String color;
  const EventElement(
      {super.key,
      required this.id,
      required this.name,
      required this.color,
      required this.subname,
      required this.time,
      required this.hour,
      required this.location});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    dateFormat.parse(time);
    Color mainParseColor(String colorName) {
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

    Color secondaryParseColor(String color) {
      switch (color) {
        case "Blue":
          return const Color(0xff056EA1);
        case "Red":
          return const Color(0xffBF2200);
        case "Orange":
          return const Color(0xffB86E00);
        default:
          return const Color(0xff056EA1); 
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/EventInfo", arguments: id);
        },
        child: Container(
          height: 95.h,
          width: 319.w,
          decoration: BoxDecoration(
            borderRadius: RadiusConst.regularRadius,
            color: mainParseColor(color),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 319.h,
                height: 85.w,
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: RadiusConst.regularOlnyBottomRadius),
                child: Padding(
                  padding: PMConst.small12All,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: FontConst.regular14Font,
                            color: secondaryParseColor(color)),
                      ),
                      Text(
                        subname,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: FontConst.small8Font,
                            color: secondaryParseColor(color)),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/time_icon.svg",
                                color: secondaryParseColor(color),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                hour,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: FontConst.small10Font,
                                  color: secondaryParseColor(color),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/location_icon.svg",
                                color: secondaryParseColor(color),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                location,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: FontConst.small10Font,
                                  color: secondaryParseColor(color),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:udevstech/core/constants/color_const.dart';
import 'package:udevstech/core/constants/font_const.dart';
import 'package:udevstech/core/constants/p_m_const.dart';
import 'package:udevstech/core/constants/radius_const.dart';
import 'package:udevstech/bloc/data_bloc.dart';
import 'package:udevstech/bloc/data_event.dart';
import 'package:udevstech/bloc/data_state.dart';
import 'package:udevstech/data/models/data_model.dart';

import '../Add_event/add_event.dart';

class EventInfo extends StatelessWidget {
  int? eventId;

  EventInfo({super.key, this.eventId});

  @override
  Widget build(BuildContext context) {

    context.read<DataBloc>().add(GetEventById(eventId!));

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DataBloc, DataState>(
          builder: (context, state) {
            if (state is DataLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DataLoaded) {
              DataModel? event;

              try {
                event = state.data.firstWhere(
                  (e) => e.id == eventId,
                );
              } catch (e) {
                return const Center(child: Text("Event not found"));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(event: event),
                  EventDetails(event: event),
                  Deletebutton(eventId: eventId!),
                ],
              );
            } else if (state is DataError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("No data"));
            }
          },
        ),
      ),
    );
  }
}

class Deletebutton extends StatelessWidget {
  final int eventId;

  const Deletebutton({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: PMConst.regular30All,
          child: GestureDetector(
            onTap: () {
              context.read<DataBloc>().add(DeleteDataEvent(eventId));
              Navigator.of(context).pop();
            },
            child: Container(
              height: 46.h,
              decoration: BoxDecoration(
                  color: const Color(0xffFEE8E9),
                  borderRadius: RadiusConst.smallRadius),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.delete,
                      color: Colors.red,
                      size: 16,
                    ),
                    Text(
                      "Delete Event",
                      style: TextStyle(
                        fontSize: FontConst.regular14Font,
                        color: const Color(0xff292929),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EventDetails extends StatelessWidget {
  final DataModel event;

  const EventDetails({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PMConst.regular30All,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reminder",
            style: TextStyle(
                fontSize: FontConst.medium16Font, fontWeight: FontWeight.bold),
          ),
          Text(
            "15 minutes before",
            style: TextStyle(
                color: ColorConst.grayColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description",
                style: TextStyle(
                    fontSize: FontConst.medium16Font,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                event
                    .name, // Assuming the description is the event's name for simplicity
                style: TextStyle(
                  color: ColorConst.grayColor,
                  fontSize: FontConst.small10Font,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  final DataModel event;

  const AppBar({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    Color mainParseColor(String colorName) {
      switch (colorName) {
        case "Blue":
          return ColorConst.primaryColorBlue;
        case "Red":
          return ColorConst.redColor;
        case "Orange":
          return ColorConst.orangeColor;
        default:
          return ColorConst.primaryColorBlue;
      }
    }

    return Container(
      height: 248.h,
      decoration: BoxDecoration(
        color: mainParseColor(event.color),
        borderRadius: RadiusConst.largeOlnyBottomRadius,
      ),
      child: Padding(
        padding: PMConst.h30v20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: ColorConst.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/arrow_back_icon.svg",
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddEvent(
                              event: event,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/edit_icon.svg",
                          ),
                          Text(
                            "Edit",
                            style: TextStyle(
                                color: ColorConst.primaryColor,
                                fontSize: FontConst.regular14Font,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Text(
              event.name,
              style: TextStyle(
                  color: ColorConst.primaryColor,
                  fontSize: FontConst.extraLargeFont,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              event.subname,
              style: TextStyle(
                color: ColorConst.primaryColor,
                fontSize: FontConst.small10Font,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/time_icon.svg",
                      height: 20.h,
                      width: 20.w,
                      color: ColorConst.primaryColor,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      event.hour,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: FontConst.small10Font,
                        color: ColorConst.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/location_icon.svg",
                      height: 20.h,
                      width: 20.w,
                      color: ColorConst.primaryColor,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      event.location,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: FontConst.regular12Font,
                        color: ColorConst.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

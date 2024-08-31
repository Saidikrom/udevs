import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:udevstech/core/constants/color_const.dart';
import 'package:udevstech/core/constants/font_const.dart';
import 'package:udevstech/core/constants/p_m_const.dart';
import 'package:udevstech/core/constants/radius_const.dart';

import '../../bloc/data_bloc.dart';
import '../../bloc/data_event.dart';
import '../../data/models/data_model.dart';
import '../../widgets/custom_input.dart';

class AddEvent extends StatefulWidget {
  final DataModel? event;

  const AddEvent({super.key, this.event});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  late TextEditingController nameController;
  late TextEditingController subnameController;
  late TextEditingController timeController;
  late TextEditingController locationController;
  String selectedColorName = "Red";
  Color selectedColor = Colors.blue;
  String times = "";
  String hours = "";

  @override
  void initState() {
    super.initState();

    if (widget.event != null) {
      final event = widget.event!;
      nameController = TextEditingController(text: event.name);
      subnameController = TextEditingController(text: event.subname);
      timeController = TextEditingController(text: event.hour);
      locationController = TextEditingController(text: event.location);
      selectedColorName = event.color;
      selectedColor = ColorChooser.getColorByName(event.color);
      times = event.time;
      hours = event.hour;
    } else {
      nameController = TextEditingController();
      subnameController = TextEditingController();
      timeController = TextEditingController();
      locationController = TextEditingController();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    subnameController.dispose();
    timeController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void _onColorChanged(String? newColorName) {
    setState(() {
      selectedColorName = newColorName!;
      selectedColor = ColorChooser.getColorByName(newColorName);
    });
  }

  void _selectDateTime(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2950),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final formattedDate =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
        final formattedTime = selectedTime.format(context);
        final formattedDateTime = "$formattedTime $formattedDate";
        setState(() {
          timeController.text = formattedDateTime;
          hours = formattedTime;
          times = selectedDate.toString();
        });
      }
    }
  }

  void saveData() {
    final name = nameController.text;
    final subname = subnameController.text;
    final time = times;
    final hour = hours;
    final location = locationController.text;

    if (name.isNotEmpty &&
        subname.isNotEmpty &&
        time.isNotEmpty &&
        location.isNotEmpty) {
      final data = DataModel(
        id: widget.event?.id ?? 0, 
        name: name,
        subname: subname,
        time: time,
        hour: hour,
        location: location,
        color: selectedColorName,
      );

      if (widget.event == null) {
        context.read<DataBloc>().add(AddDataEvent(data));
      } else {
        context.read<DataBloc>().add(UpdateEvent(data));
      }

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: PMConst.small15All,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Color(0xff6B7280),
                ),
              ),
              CustomInput(
                controller: nameController,
                height: 42.h,
                formName: "Event name",
              ),
              CustomInput(
                controller: subnameController,
                height: 110.h,
                formName: "Event description",
              ),
              CustomInput(
                controller: locationController,
                height: 42.h,
                formName: "Event location",
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Priority color",
                      style: TextStyle(fontSize: 14),
                    ),
                    ColorChooser(
                      selectedColorName: selectedColorName,
                      onColorChanged: _onColorChanged,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _selectDateTime(context),
                child: AbsorbPointer(
                  child: CustomInput(
                    controller: timeController,
                    height: 42.h,
                    formName: "Event date & time",
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: saveData,
                    child: Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        color: ColorConst.primaryColorBlue,
                        borderRadius: RadiusConst.smallRadius,
                      ),
                      child: Center(
                        child: Text(
                          widget.event == null ? "Add" : "Update",
                          style: TextStyle(
                            fontSize: FontConst.medium16Font,
                            color: ColorConst.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ColorChooser extends StatelessWidget {
  final String selectedColorName;
  final ValueChanged<String?> onColorChanged;

  const ColorChooser({
    super.key,
    required this.selectedColorName,
    required this.onColorChanged,
  });

  static Color getColorByName(String colorName) {
    switch (colorName) {
      case "Red":
        return ColorConst.redColor;
      case "Blue":
        return ColorConst.primaryColorBlue;
      case "Orange":
        return ColorConst.orangeColor;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: ColorConst.primaryColorBlue,
      ),
      value: selectedColorName,
      items: <String>["Red", "Blue", "Orange"].map((String colorName) {
        return DropdownMenuItem<String>(
          value: colorName,
          child: Row(
            children: [
              Container(
                width: 20.w,
                height: 20.h,
                color: getColorByName(colorName),
              ),
              SizedBox(width: 8.w),
              Text(colorName),
            ],
          ),
        );
      }).toList(),
      onChanged: onColorChanged,
    );
  }
}

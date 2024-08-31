import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:udevstech/core/constants/color_const.dart';
import 'package:udevstech/core/constants/font_const.dart';
import 'package:udevstech/core/constants/p_m_const.dart';
import 'package:udevstech/core/constants/radius_const.dart';

class CustomInput extends StatelessWidget {
  const CustomInput(
      {super.key,
      required this.controller,
      required this.height,
      required this.formName, IconData? suffixIcon});
  final TextEditingController controller;
  final double height;
  final String formName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PMConst.smallToponly,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formName,
            style: TextStyle(fontSize: FontConst.regular14Font),
          ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: height + 10,
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: controller,
              decoration: InputDecoration(
                fillColor: ColorConst.lightGrayColor,
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: OutlineInputBorder(
                  borderRadius: RadiusConst.smallRadius,
                  borderSide: BorderSide(
                    color: ColorConst.lightGrayColor,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: RadiusConst.smallRadius,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: RadiusConst.smallRadius,
                  borderSide: BorderSide(
                    color: ColorConst.lightGrayColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

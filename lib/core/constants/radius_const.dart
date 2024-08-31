import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadiusConst {
  static BorderRadius smallRadius = BorderRadius.circular(8.r);
  static BorderRadius regularRadius = BorderRadius.circular(10.r);
  static BorderRadius largeRadius = BorderRadius.circular(20.r);
  static BorderRadius largeOlnyBottomRadius = BorderRadius.only(
    bottomLeft: Radius.circular(20.r),
    bottomRight: Radius.circular(20.r),
  );
  static BorderRadius regularOlnyBottomRadius = BorderRadius.only(
    bottomLeft: Radius.circular(10.r),
    bottomRight: Radius.circular(10.r),
  );
}

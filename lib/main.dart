import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:udevstech/routes/routes.dart';

import 'bloc/data_bloc.dart';
import 'bloc/data_event.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => DataBloc()
        ..add(LoadDataEvent()), 
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final queryData = MediaQueryData.fromView(WidgetsBinding.instance.window);
    final height = queryData.size.height;
    final width = queryData.size.width;
    final Routes routes = Routes();
    return ScreenUtilInit(
        designSize: Size(width, height),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext, context) {
          return BlocProvider(
            create: (_) => DataBloc()..add(LoadDataEvent()),
            child: MaterialApp(
              onGenerateRoute: routes.onGenerateRoute,
              initialRoute: '/',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
              ),
            ),
          );
        });
  }
}

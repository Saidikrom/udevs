import 'package:flutter/material.dart';
import 'package:udevstech/Presentation/Add_event/add_event.dart';
import 'package:udevstech/Presentation/Event_info/event_info.dart';

import '../Presentation/Home/home_page.dart';

class Routes {
  Route? onGenerateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/AddEvent':
        return MaterialPageRoute(builder: (_) => const AddEvent());
      case '/EventInfo':
        return MaterialPageRoute(builder: (_) => EventInfo(eventId: args as int,));
      default:
        return null;
    }
  }
}

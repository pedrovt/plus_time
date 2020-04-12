import 'package:flutter/material.dart';
import 'package:plus_time/afterInstallPanel.dart';
import 'package:plus_time/data/moor_database.dart';
import 'package:plus_time/home.dart';
import 'package:provider/provider.dart';
import 'generate.dart';
import 'services/load_calendars.dart';
import 'services/locationService.dart';
import 'add_event.dart';
import 'qrcode.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (_) => AppDatabase()),
          Provider(create: (_) => ProjectsInfo()),
          Provider(create: (_) => LocationService()),
          StreamProvider(create: (_) => LocationService().locationStream)
        ],
        child: MaterialApp(
          title: '+Time',
          theme: ThemeData(
            primarySwatch: Colors.lime,
            primaryColor: const Color(0xFFcddc39),
            accentColor: const Color(0xFFcddc39),
            canvasColor: const Color(0xFFfafafa),
            fontFamily: 'Merriweather',
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              title: TextStyle(
                  fontSize: 27.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w200),
              subtitle: TextStyle(
                  fontSize: 16.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w200),
              body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
          ),
          initialRoute: '/', //'/login',
          routes: {
            '/': (context) =>
                InstalationPanel(), //Home(Provider.of<ProjectsInfo>(context)),
            '/add_event': (context) => AddEvent(),
            '/login': (context) => GenerateScreen(eventData: "eventData"),
            '/qrModule': (context) => QRCode(),
          },
        ));
  }
}

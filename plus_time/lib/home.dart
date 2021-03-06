import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:device_calendar/device_calendar.dart';
import 'dart:async';
import 'services/load_calendars.dart';

class Home extends StatelessWidget {
  final ProjectsInfo projectInfo;

  Home(this.projectInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(projectsInfo: projectInfo),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.projectsInfo}) : super(key: key);

  final ProjectsInfo projectsInfo;

  @override
  _HomePageState createState() => _HomePageState(projectsInfo);
}

class _HomePageState extends State<HomePage> {
  final ProjectsInfo projectsInfo;
  List<Card> projectCards;
  int _selectedIndex = 0;

  List<String> litems = [
    "What should I do next?",
  ];
  List<String> litems2 = [
    "Statistics",
  ];
  bool calendarChanged = false;

  CalendarItem selectedCalendar;
  _HomePageState(this.projectsInfo);

  bool _isLoading = true;
  void _onLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedCalendar = new CalendarItem(0, "");
    _onLoading();
  }

  /* Create the layout */
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      getProjects();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_small_white.png',
              fit: BoxFit.scaleDown,
              height: 32,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              if (!_isLoading && projectCards != null) ...[
                if (projectCards.isNotEmpty) ...[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          child: new Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: Text(
                                litems[index],
                                style: Theme.of(context).textTheme.title,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: litems.length,
                    ),
                  ),
                ]
              ],
              if (!_isLoading && projectCards != null) ...[
                if (projectCards.isEmpty) ...[
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                    return Center(
                      child: Column(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: Image.asset('assets/nodata.jpg'),
                                  ),
                                  Expanded(
                                    child: Image.asset('assets/hashtag.jpg'),
                                  )
                                ])),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "No projects found in this calendar.",
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Just create an event starting with your project name to see statistics about your project.",
                            style: Theme.of(context).textTheme.title,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Eg. An event named #Personal Gym with duration of 2 hours, will add 2 hours to the project #Personal",
                            style: Theme.of(context).textTheme.subtitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                    );
                  }, childCount: 1)),
                ] else ...[
                  SliverList(
                    delegate: SliverChildListDelegate(projectCards),
                  )
                ]
              ],
              if (!_isLoading && projectCards != null) ...[
                if (projectCards.isNotEmpty) ...[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          child: new Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: Text(
                                litems2[index],
                                style: Theme.of(context).textTheme.title,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: litems2.length,
                    ),
                  ),
                ]
              ],
              if (!_isLoading &&
                  projectCards != null &&
                  projectCards.length != 0)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        child: new Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: PieChart(
                              dataMap: widget.projectsInfo.projects,
                              animationDuration: Duration(milliseconds: 800),
                              chartLegendSpacing: 32.0,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 2.7,
                              showChartValuesInPercentage: true,
                              showChartValues: true,
                              showChartValuesOutside: false,
                              chartValueBackgroundColor: Colors.grey[200],
                              showLegends: true,
                              legendPosition: LegendPosition.right,
                              decimalPlaces: 1,
                              showChartValueLabel: true,
                              initialAngle: 0,
                              chartValueStyle: defaultChartValueStyle.copyWith(
                                color: Colors.blueGrey[900].withOpacity(0.9),
                              ),
                              chartType: ChartType.ring,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: litems2.length,
                  ),
                ),
            ],
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Add Event'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_export),
            title: Text('Import'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).disabledColor,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            print("Selected index is $_selectedIndex");
            switch (_selectedIndex) {
              case 0: // Home
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Home(Provider.of<ProjectsInfo>(context))));
                break;
              case 1: // Add Event
                Navigator.pushNamed(context, '/add_event');
                break;
              case 2: // Import
                Navigator.pushNamed(context, '/qrModule');
                break;
              case 3: // Logout
                Navigator.pushNamed(context, '/login');
                break;
            }
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: Text(
                'You are using calendar ' + projectsInfo.selectedCalendar.name),
            action: SnackBarAction(
              label: 'Change',
              onPressed: () {
                // CHANGE Calendar
                showDialog(
                    context: context,
                    builder: (_) => new SimpleDialog(
                          title: Text(
                            "Change Calendar",
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.0,
                          ),
                          children: <Widget>[
                            Text(
                              "You are using calendar " +
                                  projectsInfo.selectedCalendar.name,
                              textAlign: TextAlign.center,
                              textScaleFactor: 0.9,
                            ),
                            new SimpleDialogOption(
                                onPressed: () {
                                  // Navigator.of(context).pop();
                                },
                                child: new Center(
                                  child: DropdownButton<CalendarItem>(
                                    hint: Text("Select calendar"),
                                    onChanged: (CalendarItem value) {
                                      setState(() {
                                        print(
                                            "Selected calendar $value.calendarName on index $value.index ");
                                        projectsInfo.setSelectedCalendarIndex(
                                            value.index);
                                        _isLoading = true;
                                        SnackBar(
                                            content: Text(
                                                'Changed calendar to ' +
                                                    value.calendarName));

                                        Navigator.of(context).pop();
                                      });
                                    },
                                    items: projectsInfo.obtainDropDownItems(),
                                  ),
                                ))
                          ],
                        ));
              },
            ),
          );

          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
        },
        tooltip: 'Calendar',
        child: Icon(Icons.event_note),
      ),
    );
  }

  Future getProjects() async {
    Calendar _selectedCalendar = await projectsInfo.retriveCalendars();
    print("Selected calendar: " + _selectedCalendar.name);
    projectCards = await projectsInfo.obtainProjectCards(context);
    setState(() {
      _isLoading = false;
    });
  }
}

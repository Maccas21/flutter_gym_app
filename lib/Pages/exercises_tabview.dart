import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Pages/add_exercise_page.dart';
import 'package:flutter_gym_app/Pages/exercise_graph_tab.dart';
import 'package:flutter_gym_app/Pages/exercise_history_tab.dart';
import 'package:intl/intl.dart';

class ExercisesTabView extends StatefulWidget {
  final DateTime currentDate;
  final String exerciseName;
  final bool hasAdd;

  const ExercisesTabView({
    super.key,
    required this.currentDate,
    required this.exerciseName,
    this.hasAdd = true,
  });

  @override
  State<ExercisesTabView> createState() => _ExercisesTabViewState();
}

class _ExercisesTabViewState extends State<ExercisesTabView> {
  late List<Widget> tabs;
  late List<Tab> tabBar;

  @override
  void initState() {
    super.initState();

    // init tabs
    tabs = [];
    tabBar = [];

    // if hasAdd is true then include AddExercisePage
    widget.hasAdd
        ? tabs.add(AddExercisePage(
            exerciseName: widget.exerciseName, currentDate: widget.currentDate))
        : false; // do nothing

    tabs.addAll([
      const ExerciseGraphTab(),
      const ExerciseHistoryTab(),
    ]);

    // if hasAdd is true then include tab for AddExercisePage
    widget.hasAdd
        ? tabBar.add(Tab(
            text: DateUtils.isSameDay(widget.currentDate, DateTime.now())
                ? 'Today'
                : DateFormat('EEE, MMM d').format(widget.currentDate),
          ))
        : false; // do nothing

    tabBar.addAll([
      const Tab(text: 'Graph'),
      const Tab(text: 'History'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.exerciseName),
          bottom: TabBar(tabs: tabBar),
        ),
        body: TabBarView(children: tabs),
      ),
    );
  }
}

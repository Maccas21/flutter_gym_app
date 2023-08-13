import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/database.dart';
//import 'package:flutter_gym_app/Pages/exercises_tabview.dart';
import 'package:flutter_gym_app/Util/exercise_day_tile.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({Key? key}) : super(key: key);
  //const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => HistoryTabState();
}

class HistoryTabState extends State<HistoryTab> {
  final Box box = Hive.box('hivebox');
  late List<dynamic> datesHistory; //List<DateTime>
  late List<DayDatabase> db = [];

  @override
  void initState() {
    super.initState();

    datesHistory = box.get('datesHistory') ?? [];
    for (DateTime date in datesHistory) {
      db.add(DayDatabase(date));
    }
  }

  // Open ExercisesTabView page when day tile is clicked
  // Redraw state when poping back to history page
  void dayTileOnTap(String name, DateTime currentDate) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return ExercisesTabView(
    //         exerciseName: name,
    //         currentDate: currentDate,
    //       );
    //     },
    //   ),
    // ).then((value) => redraw());
  }

  // Update database and redraw widgets
  void redraw() {
    setState(() {
      for (DayDatabase data in db) {
        data.updateDatabase();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: datesHistory.length,
                itemBuilder: (context, datesIndex) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade600,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                DateFormat('EEEE, MMMM d, y')
                                    .format(datesHistory[datesIndex]),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        DayTile(
                          db: db[datesIndex],
                          dayTileOnTap: dayTileOnTap,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

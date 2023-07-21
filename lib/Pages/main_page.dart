import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Pages/graph_tab.dart';
import 'package:flutter_gym_app/Pages/history_tab.dart';
import 'package:flutter_gym_app/Pages/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.grey.shade900,
        iconSize: 25,
        height: 60,
        activeColor: Colors.grey.shade100,
        inactiveColor: Colors.grey.shade800,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: "Exercises"),
          BottomNavigationBarItem(
              icon: Icon(Icons.stacked_line_chart), label: "Graph"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 2:
            {
              return CupertinoTabView(
                builder: (context) {
                  return const CupertinoPageScaffold(
                    child: HistoryTab(),
                  );
                },
              );
            }
          case 1:
            {
              return CupertinoTabView(
                builder: (context) {
                  return const CupertinoPageScaffold(
                    child: GraphTab(),
                  );
                },
              );
            }
          default:
            {
              return CupertinoTabView(
                builder: (context) {
                  return const CupertinoPageScaffold(
                    child: HomePage(),
                  );
                },
              );
            }
        }
      },
    );
  }
}

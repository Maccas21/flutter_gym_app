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
  int currentPage = 0;

  final List<GlobalKey<NavigatorState>> keys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  List<Widget> pages = const [
    HomePage(),
    GraphTab(),
    HistoryTab(),
  ];

  // Create an offstage toggle and build seperate navigator routes for each tab
  Widget offStageNavigatorBuilder(int index) {
    return Offstage(
      offstage: currentPage != index,
      child: Navigator(
        key: keys[index],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => pages[index]);
        },
      ),
    );
  }

  // Switch tab to index. If already at index then pop all pages to first
  void selectTab(int index) {
    if (index == currentPage) {
      keys[index].currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        currentPage = index;
      });
    }
  }

  // return true if should pop scope or false otherwise
  Future<bool> onWillPop() async {
    final bool isFirstRouteInCurrentTab =
        !await keys[currentPage].currentState!.maybePop();

    // check if current tab is at the root navigation route page
    if (isFirstRouteInCurrentTab) {
      // move to first tab if not already
      if (currentPage != 0) {
        selectTab(0);
        return false;
      }
    }

    // pop once from the current navigation route
    return isFirstRouteInCurrentTab;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            offStageNavigatorBuilder(0),
            offStageNavigatorBuilder(1),
            offStageNavigatorBuilder(2),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            selectTab(index);
          },
          currentIndex: currentPage,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center), label: "Exercises"),
            BottomNavigationBarItem(
                icon: Icon(Icons.stacked_line_chart), label: "Graph"),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: "History"),
          ],
        ),
      ),
    );
  }
}

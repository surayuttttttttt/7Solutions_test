// ignore_for_file: avoid_print

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:solution/services.dart';

class SevenSolutionTest extends StatefulWidget {
  const SevenSolutionTest({super.key});

  @override
  State<SevenSolutionTest> createState() => _SevenSolutionTestState();
}

class _SevenSolutionTestState extends State<SevenSolutionTest> {
  FiboController2? fiboController2 = FiboController2();
  ScrollController outsidescrollController = ScrollController();
  ScrollController insideScrollController = ScrollController();

  @override
  void initState() {
    fiboController2?.generatedFibonacci();
    outsidescrollController.addListener(() {});
    insideScrollController.addListener(() {});
    super.initState();
  }

  Map<int, Map<int, bool>> circle = {};
  Map<int, Map<int, bool>> square = {};
  Map<int, Map<int, bool>> cross = {};

  // Map<int, int> fiboMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("SevenSolutionTest")),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: outsidescrollController,
              children: fiboController2!.fiboMap.entries.map((entry) {
                int index = entry.key;
                Map<int, bool> value = entry.value;

                return Column(
                    children: value.entries.map((e) {
                  int fiboValue = e.key;
                  bool isActive = e.value;
                  return ListTile(
                    onTap: () async {
                      if (fiboValue % 3 == 0) {
                        onListTileTap(fiboValue, index, circle);
                      } else if (fiboValue % 3 == 1) {
                        onListTileTap(fiboValue, index, square);
                      } else if (fiboValue % 3 == 2) {
                        onListTileTap(fiboValue, index, cross);
                      }
                    },
                    tileColor: isActive ? Colors.red : Colors.white,
                    leading: Text('Index: $index, Number: $fiboValue'),
                    trailing: Icon(fiboController2!.getFiboIcon(fiboValue)),
                  );
                }).toList());
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget buildListTile({
    required int fiboValue,
    required bool isActive,
    required int index,
    required Map<int, Map<int, bool>> specificTypeMap,
  }) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (insideScrollController.hasClients) {
        handleModalScroll(insideScrollController, index, specificTypeMap);
      }
    });

    return ListTile(
      onTap: () async {
        onRemove(specificTypeMap, fiboController2!.fiboMap, index, fiboValue);
        handleFiboListScroll(outsidescrollController, index);
      },
      tileColor: isActive ? Colors.green : Colors.white,
      title: Text('Number: $fiboValue'),
      subtitle: Text('Index: $index'),
      trailing: Icon(fiboController2!.getFiboIcon(fiboValue)),
    );
  }

  List<Column> buildListTileForSpecificType(
      Map<int, Map<int, bool>> specificMap) {
    return specificMap.entries.map((entry) {
      int index = entry.key;
      Map<int, bool> innerMap = entry.value;

      return Column(
        children: innerMap.entries.map((e) {
          int fiboValue = e.key;
          bool isActive = e.value;
          return buildListTile(
            fiboValue: fiboValue,
            isActive: isActive,
            index: index,
            specificTypeMap: specificMap,
          );
        }).toList(),
      );
    }).toList();
  }

  showSpecifiType(int type, int index) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.75,
          child: ListView(
            controller: insideScrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: type == 1
                ? buildListTileForSpecificType(
                    circle,
                  )
                : type == 2
                    ? buildListTileForSpecificType(
                        square,
                      )
                    : buildListTileForSpecificType(
                        cross,
                      ),
          ),
        );
      },
    );
  }

  void onListTileTap(int fiboValue, int index,
      Map<int, Map<int, bool>> specificMapType) async {
    specificMapType.forEach((index, map) {
      map.forEach((fiboValue, isActive) {
        specificMapType[index]![fiboValue] = false;
      });
    });
    specificMapType.addAll({
      index: {fiboValue: true}
    });
    sortBottomSheetOrder();
    fiboController2!.fiboMap.remove(index);
    setState(() {});

    await showSpecifiType(fiboController2!.getFiboType(fiboValue), index);
  }

  void onRemove(Map<int, Map<int, bool>> specificTypeMap,
      Map<int, Map<int, bool>> fiboMap, int index, int fiboValue) {
    //REMOVE KEY FROM SPECIFIC TYPE MAP
    specificTypeMap.remove(index);

    //SET ALL MAP VALUE FOR RESETTING TILE COLOUR DISPLAY
    fiboMap.forEach((index, value) {
      value.forEach((fiboValue, isActive) {
        fiboController2!.fiboMap[index]![fiboValue] = false;
      });
    });

    //SET BOOLEAN FOR DISPLAYING RED TILE
    fiboController2!.fiboMap.addAll({
      index: {fiboValue: true}
    });

    //SORT FIBO LIST
    sortMap();

    setState(() {});
    Navigator.of(context).pop();
  }

  void resetTileColour() {
    fiboController2!.fiboMap.forEach((index, value) {
      value.forEach((fiboValue, isActive) {
        fiboController2!.fiboMap[index]![fiboValue] = false;
      });
    });
  }

  void sortMap() {
    LinkedHashMap<int, Map<int, bool>> sortedMap2 = LinkedHashMap.fromEntries(
      fiboController2!.fiboMap.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)),
    );
    fiboController2!.fiboMap = sortedMap2;
  }

  void sortBottomSheetOrder() {
    LinkedHashMap<int, Map<int, bool>> sortedMapCircle =
        LinkedHashMap.fromEntries(
            circle.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

    LinkedHashMap<int, Map<int, bool>> sortedMapSquare =
        LinkedHashMap.fromEntries(
            square.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    LinkedHashMap<int, Map<int, bool>> sortedMapCross =
        LinkedHashMap.fromEntries(
            cross.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    //  setState(() {});
    circle = sortedMapCircle;
    square = sortedMapSquare;
    cross = sortedMapCross;
  }

  void handleFiboListScroll(ScrollController scrollController, int index) {
    double avgPos =
        scrollController.position.maxScrollExtent / fiboController2!.count;
    scrollController.animateTo(
      index >= 35 ? (avgPos * index) + 150 : (avgPos * index),
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 200),
    );
  }

  void handleModalScroll(ScrollController scrollController, int index,
      Map<int, Map<int, bool>> specificTypeMap) {
    double avgPos =
        scrollController.position.maxScrollExtent / specificTypeMap.length;

    int? outerKeyWithTrue;
    specificTypeMap.forEach((index, map) {
      if (map.values.contains(true)) {
        outerKeyWithTrue = index;
      }
    });

    scrollController.animateTo(
      specificTypeMap.entries.first.key == outerKeyWithTrue
          ? scrollController.position.minScrollExtent
          : (avgPos * outerKeyWithTrue!),
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 200),
    );
  }
}

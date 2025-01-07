// ignore_for_file: avoid_print

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:solution/controller2.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
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
        title: Center(child: Text("Example")),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: outsidescrollController,
              children: fiboController2!.fiboMap2.entries.map((entry) {
                int index = entry.key;
                Map<int, bool> value = entry.value;

                return Column(
                    children: value.entries.map((e) {
                  int fiboValue = e.key;
                  bool isActive = e.value;
                  return ListTile(
                    onTap: () async {
                      if (fiboValue % 3 == 0) {
                        circle.forEach((index, map) {
                          map.forEach((fiboValue, isActive) {
                            circle[index]![fiboValue] = false;
                          });
                        });
                        circle.addAll({
                          index: {fiboValue: true}
                        });
                        sortBottomSheetOrder();
                      } else if (fiboValue % 3 == 1) {
                        square.forEach((index, map) {
                          map.forEach((fiboValue, isActive) {
                            square[index]![fiboValue] = false;
                          });
                        });
                        square.addAll({
                          index: {fiboValue: true}
                        });
                        sortBottomSheetOrder();
                      } else if (fiboValue % 3 == 2) {
                        cross.forEach((index, map) {
                          map.forEach((fiboValue, isActive) {
                            cross[index]![fiboValue] = false;
                          });
                        });
                        cross.addAll({
                          index: {fiboValue: true}
                        });
                        sortBottomSheetOrder();
                      }
                      fiboController2!.fiboMap2.remove(index);
                      setState(() {});

                      await showSpecifiType(
                          fiboController2!.getFiboType(fiboValue), index);
                      print(fiboController2!.fiboMap2.toString());
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
                  ? circle.entries.map((entry) {
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
                            specificTypeMap: circle,
                          );
                        }).toList(),
                      );
                    }).toList()
                  : type == 2
                      ? square.entries.map((entry) {
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
                                specificTypeMap: square,
                              );
                            }).toList(),
                          );
                        }).toList()
                      : cross.entries.map((entry) {
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
                                specificTypeMap: cross,
                              );
                            }).toList(),
                          );
                        }).toList()),
        );
      },
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
        onRemove(specificTypeMap, fiboController2!.fiboMap2, index, fiboValue);
        handleFiboListScroll(outsidescrollController, index);
      },
      tileColor: isActive ? Colors.green : Colors.white,
      title: Text('Number: $fiboValue'),
      subtitle: Text('Index: $index'),
      trailing: Icon(fiboController2!.getFiboIcon(fiboValue)),
    );
  }

  void onRemove(Map<int, Map<int, bool>> specificTypeMap,
      Map<int, Map<int, bool>> fiboMap, int index, int fiboValue) {
    //REMOVE KEY FROM SPECIFIC TYPE MAP
    specificTypeMap.remove(index);

    //SET ALL MAP VALUE FOR RESETTING TILE COLOUR DISPLAY
    fiboMap.forEach((index, value) {
      value.forEach((fiboValue, isActive) {
        fiboController2!.fiboMap2[index]![fiboValue] = false;
      });
    });

    //SET BOOLEAN FOR DISPLAYING RED TILE
    fiboController2!.fiboMap2.addAll({
      index: {fiboValue: true}
    });

    //SORT FIBO LIST
    sortMap();

    setState(() {});
    Navigator.of(context).pop();
  }

  void resetTileColour() {
    fiboController2!.fiboMap2.forEach((index, value) {
      value.forEach((fiboValue, isActive) {
        fiboController2!.fiboMap2[index]![fiboValue] = false;
      });
    });
  }

  void sortMap() {
    LinkedHashMap<int, Map<int, bool>> sortedMap2 = LinkedHashMap.fromEntries(
      fiboController2!.fiboMap2.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)),
    );
    fiboController2!.fiboMap2 = sortedMap2;
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

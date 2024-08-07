//  Created by Muhammad Faiq Haidar on 22/07/2024.
//  Copyright © 2024 Muhammad Faiq Haidar. All rights reserved.

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:radeena/styles/style.dart';
import 'package:radeena/views/history/saved_calculation_page.dart';
import 'package:radeena/controllers/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, dynamic>>> _futureHistory;
  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    super.initState();
    _futureHistory = _historyController.getHistory();
  }

  // Refresh Data
  void _refreshHistory() {
    setState(() {
      _futureHistory = _historyController.getHistory();
    });
  }

  // Delete Confirmation
  void _showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this calculation?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                await _historyController.deleteHistory(id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Calculation successfully deleted!")),
                );
                _refreshHistory();
              },
            ),
          ],
        );
      },
    );
  }

  // Display Heirs
  Map<String, int> parseSelectedHeirs(String selectedHeirsString) {
    return Map.fromEntries(
      selectedHeirsString
          .substring(1, selectedHeirsString.length - 1)
          .split(', ')
          .map((entry) {
        final parts = entry.split(': ');
        return MapEntry(parts[0], int.parse(parts[1]));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: green01Color,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "History",
          style: titleDetermineHeirsStyle(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * .06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Subtitle
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 25),
              child: Text(
                "Calculation List",
                style: textUnderTitleStyle(),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futureHistory,
                builder: (context, snapshot) {
                  // Loading State
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      // If No Records, Display Illustration
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: -10,
                            child: Lottie.asset(
                              'assets/lottie/no_calculation.json',
                              width: 430,
                              height: 430,
                            ),
                          ),
                          Positioned(
                            bottom: 250,
                            left: 30,
                            right: 30,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'No calculation history found. You can save the calculation first in \"Determine Heirs\" feature ya! 👌',
                                  textStyle: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade800,
                                  ),
                                  speed: const Duration(milliseconds: 50),
                                ),
                              ],
                              totalRepeatCount: 3,
                              pause: const Duration(milliseconds: 1000),
                              displayFullTextOnTap: true,
                              stopPauseOnTap: true,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // If Records Exist, Display Data
                  else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final calculation = snapshot.data![index];
                        final selectedHeirs =
                            parseSelectedHeirs(calculation['selectedHeirs']);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        primaryColor.withOpacity(0.7),
                                        secondaryColor.withOpacity(0.7),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(13.0),
                                  ),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          calculation['calculationName'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 5.0,
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                offset: Offset(3.0, 3.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 20,
                                          child: Marquee(
                                            child: Text(
                                              'Family Members ➜ ' +
                                                  selectedHeirs.entries
                                                      .map((e) =>
                                                          '${e.value}-${e.key}')
                                                      .join(' ┆ '),
                                              style: TextStyle(
                                                  color: Colors.yellow.shade100,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            autoRepeat: true,
                                            directionMarguee:
                                                DirectionMarguee.TwoDirection,
                                            animationDuration:
                                                Duration(milliseconds: 8000),
                                            pauseDuration:
                                                Duration(milliseconds: 0),
                                            backDuration:
                                                Duration(milliseconds: 8000),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SavedCalculationPage(
                                            calculation: calculation,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Trash Icon
                              Container(
                                width: 58.0,
                                height: 58.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor.withOpacity(0.7),
                                      secondaryColor.withOpacity(0.7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.white, size: 35),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(
                                        context, calculation['id']);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

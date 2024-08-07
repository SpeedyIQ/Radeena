//  Created by Muhammad Faiq Haidar on 22/07/2024.
//  Copyright © 2024 Muhammad Faiq Haidar. All rights reserved.

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restart_app/restart_app.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:radeena/styles/style.dart';
import 'package:radeena/views/calculation/inheritance_page.dart';
import 'package:radeena/views/calculation/heir_page.dart';
import 'package:radeena/controllers/identification_controller.dart';
import 'package:radeena/controllers/impediment_controller.dart';
import 'package:radeena/controllers/calculation_controller.dart';

class CalculationPage extends StatelessWidget {
  final double totalProperty;
  final double propertyAmount;
  final double debtAmount;
  final double testamentAmount;
  final double funeralAmount;
  final Map<String, int> selectedHeirs;

  final IdentificationController identificationController;
  final ImpedimentController impedimentController;

  const CalculationPage({
    Key? key,
    required this.totalProperty,
    required this.propertyAmount,
    required this.selectedHeirs,
    required this.debtAmount,
    required this.testamentAmount,
    required this.funeralAmount,
    required this.identificationController,
    required this.impedimentController,
  }) : super(key: key);

  // Number Formatting
  String formatNumber(double number) {
    return number.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.");
  }

  // Reset Confirmation Dialog
  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Reset"),
          content: Text(
              "Are you sure you want to reset the calculation and go to the home page?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Restart.restartApp();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    CalculationController calculationController = CalculationController();

    Map<String, int> filteredHeirs =
        impedimentController.getFilteredHeirs(selectedHeirs);

    var result = calculationController.calculateInheritance(
        totalProperty, filteredHeirs);
    Map<String, double> distribution = result['distribution'];
    String divisionStatus = result['divisionStatus'];
    int finalShare = result['finalShare'];

    // See Heir Details
    List<DataRow> heirRows = filteredHeirs.entries
        .where((entry) => entry.value > 0)
        .map((entry) => DataRow(
              cells: [
                DataCell(
                  Tooltip(
                    message: "Click to see details",
                    child: GestureDetector(
                      child: Text(
                        entry.key,
                        style: TextStyle(color: Colors.teal.shade800),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HeirPage(
                              heir: entry.key,
                              quantity: entry.value,
                              totalInheritance: distribution[entry.key] ?? 0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                DataCell(Center(
                    child: Text(
                  entry.value.toString(),
                  style: TextStyle(color: Colors.teal.shade800),
                ))),
                DataCell(Text(
                  "IDR ${formatNumber(distribution[entry.key] ?? 0)}",
                  style: TextStyle(color: Colors.teal.shade800),
                )),
              ],
            ))
        .toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: green01Color,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Calculation",
          style: titleDetermineHeirsStyle(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * .06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Subtitle
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Text(
                      "Inheritance Distribution",
                      style: textUnderTitleStyle(),
                    ),
                  ),
                  SizedBox(height: 25),
                  // If Heirs Exist, Display Result
                  if (filteredHeirs.isNotEmpty) ...[
                    StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      children: [
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: buildContainer(
                            "Net Property",
                            backgroundColor,
                            Colors.white,
                            Colors.teal.shade800,
                          ),
                        ),
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: buildContainer(
                            "IDR ${formatNumber(totalProperty)}",
                            primaryColor,
                            secondaryColor,
                            Colors.white,
                          ),
                        ),
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: buildContainer(
                            "Final Share",
                            backgroundColor,
                            Colors.white,
                            Colors.teal.shade800,
                          ),
                        ),
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: buildContainer(
                            "$finalShare",
                            primaryColor,
                            secondaryColor,
                            Colors.white,
                          ),
                        ),
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: buildContainer(
                            "Division Status",
                            backgroundColor,
                            Colors.white,
                            Colors.teal.shade800,
                          ),
                        ),
                        StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: buildContainer(
                            "$divisionStatus",
                            primaryColor,
                            secondaryColor,
                            Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.grey.shade700, size: 12),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Click on the heir's row to see individual inheritance details.",
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.7),
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                              Colors.grey.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        // Table Result
                        child: DataTable(
                          columns: const [
                            DataColumn(
                                label: Text(
                              'Heir',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Qty',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Inheritance',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                          ],
                          rows: heirRows,
                        ),
                      ),
                    ),
                    SizedBox(height: 500),
                  ]
                  // If No Heirs Selected, Display Illustration
                  else ...[
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 360,
                            left: 20,
                            right: 20,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'No heir has been selected. All assets (IDR ${formatNumber(totalProperty)}) will be distributed to the kinsfolk (Dzawil Arham) or to the treasury (Baitul Maal).',
                                  textAlign: TextAlign.left,
                                  textStyle: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade800,
                                  ),
                                  speed: const Duration(milliseconds: 50),
                                ),
                              ],
                              totalRepeatCount: 1,
                              pause: const Duration(milliseconds: 1000),
                              displayFullTextOnTap: true,
                              stopPauseOnTap: true,
                            ),
                          ),
                          SizedBox(height: 450),
                          Lottie.asset(
                            'assets/lottie/treasury.json',
                            width: 340,
                            height: 410,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 500),
                  ],
                ],
              ),
            ),
          ),

          // Button for Distribution Details
          Positioned(
            top: 640,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (filteredHeirs.isNotEmpty) ...[
                  _buildGradientButton(
                    text: "Distribution Detail",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InheritancePage(
                            identificationController: identificationController,
                            impedimentController: impedimentController,
                            totalProperty:
                                identificationController.property.getTotal(),
                            propertyAmount:
                                identificationController.property.getAmount(),
                            debtAmount:
                                identificationController.property.getDebt(),
                            testamentAmount: identificationController.property
                                .getTestament(),
                            funeralAmount:
                                identificationController.property.getFuneral(),
                            selectedHeirs: selectedHeirs,
                          ),
                        ),
                      );
                    },
                  ),

                  // Button for Save Result
                  _buildGradientButton(
                    text: "Save Result",
                    onPressed: () async {
                      TextEditingController nameController =
                          TextEditingController();
                      bool isNameEmpty = false;

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text("Save Calculation"),
                                content: TextField(
                                  controller: nameController,
                                  maxLength: 30,
                                  decoration: InputDecoration(
                                    hintText: "Enter calculation name",
                                    errorText:
                                        isNameEmpty ? 'Name is required' : null,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Save"),
                                    onPressed: () async {
                                      if (nameController.text.isEmpty) {
                                        setState(() {
                                          isNameEmpty = true;
                                        });
                                        return;
                                      }
                                      String calculationName =
                                          nameController.text;
                                      await calculationController
                                          .saveCalculation(
                                        calculationName,
                                        totalProperty,
                                        propertyAmount,
                                        debtAmount,
                                        testamentAmount,
                                        funeralAmount,
                                        selectedHeirs,
                                        distribution,
                                        divisionStatus,
                                        finalShare,
                                      );
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Calculation successfully saved!")),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],

                // Button for Resetting
                _buildGradientButton(
                  icon: Icons.home,
                  onPressed: () {
                    _showResetConfirmationDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Button Styles
  Widget _buildGradientButton(
      {String? text, IconData? icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade300, Colors.teal.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(17),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: text != null
            ? Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              )
            : Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }

  // Masonry Layout Styles
  Widget buildContainer(String text, Color color1, Color color2, Color color3) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color1.withOpacity(0.7),
            color2.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color3,
        ),
      ),
    );
  }
}

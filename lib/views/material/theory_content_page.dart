import 'package:flutter/material.dart';
import 'package:radeena/styles/style.dart';
import 'package:radeena/controllers/library_controller.dart';

class TheoryContentPage extends StatelessWidget {
  final String title;
  final LibraryController libraryController;

  const TheoryContentPage(
      {required this.title, required this.libraryController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final theories = libraryController.getTheoriesByTitle(title);

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
          "Library",
          style: titleDetermineHeirsStyle(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * .06),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text(
                  title,
                  style: textUnderTitleStyle(),
                ),
              ),
              SizedBox(height: 25),
              for (var theory in theories) ...[
                Text(
                  theory['content'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: green02Color,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  theory['subContent'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 25),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

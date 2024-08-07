//  Created by Muhammad Faiq Haidar on 22/07/2024.
//  Copyright © 2024 Muhammad Faiq Haidar. All rights reserved.

import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:lottie/lottie.dart';
import 'package:radeena/styles/style.dart';
import 'package:radeena/views/division/impediment_page.dart';
import 'package:radeena/controllers/identification_controller.dart';
import 'package:radeena/controllers/impediment_controller.dart';

class IdentificationPage extends StatefulWidget {
  final IdentificationController controller;
  final ImpedimentController impedimentController;

  const IdentificationPage({
    Key? key,
    required this.controller,
    required this.impedimentController,
  }) : super(key: key);

  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> {
  int currentStep = 1;

  final _propertyAmountController = TextEditingController();
  final _debtAmountController = TextEditingController();
  final _testamentAmountController = TextEditingController();
  final _funeralAmountController = TextEditingController();

  String? _propertyError;
  String? _debtError;
  String? _testamentError;
  String? _funeralError;

  @override
  void initState() {
    super.initState();
    _propertyAmountController.addListener(_validateTestamentAmount);
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
            if (currentStep == 1) {
              Navigator.of(context).pop();
            } else {
              setState(() {
                currentStep = 1;
              });
            }
          },
        ),
        title: Text("Determine Heirs", style: titleDetermineHeirsStyle()),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06),
            child: _buildInputStep(currentStep),
          ),
          // Button for Steps
          Positioned(
            right: 40,
            top: 640,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade300, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(17),
              ),
              child: FloatingActionButton(
                onPressed: () {
                  if (currentStep == 1) {
                    _submitPropertyDetails();
                  } else if (currentStep == 2) {
                    _submitGenderDetails();
                  } else if (currentStep == 3) {
                    _navigateToImpedimentPage();
                  }
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Testament Validation
  void _validateTestamentAmount() {
    setState(() {
      double? propertyAmount = double.tryParse(_propertyAmountController.text);
      if (propertyAmount != null) {
        double maxTestamentAmount = propertyAmount / 3;
        double? testamentAmount =
            double.tryParse(_testamentAmountController.text);
        if (testamentAmount != null && testamentAmount > maxTestamentAmount) {
          _testamentError =
              'Testament amount cannot exceed 1/3 of the property amount.';
        } else {
          _testamentError = null;
        }
      }
    });
  }

  Widget _buildInputStep(int step) {
    switch (step) {
      case 1:
        return _buildPropertyInputStep();
      case 2:
        return _buildGenderInputStep();
      case 3:
        return _buildFamilyInputStep();
      default:
        return Container();
    }
  }

  // Property Step
  Widget _buildPropertyInputStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Input the Deceased's Property", style: textUnderTitleStyle()),
        SizedBox(height: 25.0),
        _buildInputExplanation(
            "The total assets left by the deceased without any deductions. This field is mandatory to proceed to the next step."),
        _buildGradientCard(
          child: _buildTextInputField(
            controller: _propertyAmountController,
            label: "Property's Amount",
            hint: "Enter amount",
            errorText: _propertyError,
          ),
        ),
        _buildInputExplanation(
            "Unpaid debts of the deceased, to be deducted from the Property Amount for inheritance distribution. Enter \"0\" if none."),
        _buildGradientCard(
          child: _buildTextInputField(
            controller: _debtAmountController,
            label: "Debt Amount",
            hint: "Enter amount",
            errorText: _debtError,
          ),
        ),
        _buildInputExplanation(
            "Bequest amount left by the deceased, must not exceeding 1/3 of total assets. Enter \"0\" if none."),
        // Real-Time Testament Validation
        if (_propertyAmountController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              "Max Allowed = IDR ${(double.tryParse(_propertyAmountController.text) ?? 0) / 3}",
              style: TextStyle(
                  color: Colors.green.shade700, fontWeight: FontWeight.w500),
            ),
          ),
        _buildGradientCard(
          child: Column(
            children: [
              _buildTextInputField(
                controller: _testamentAmountController,
                label: "Testament Amount",
                hint: "Enter amount",
                errorText: _testamentError,
              ),
            ],
          ),
        ),
        _buildInputExplanation(
            "Funeral expenses for the deceased, to be deducted from the Property Amount for inheritance distribution. Enter \"0\" if none."),
        _buildGradientCard(
          child: _buildTextInputField(
            controller: _funeralAmountController,
            label: "Funeral Amount",
            hint: "Enter amount",
            errorText: _funeralError,
          ),
        ),
        SizedBox(height: 100),
      ],
    );
  }

  // Text Input
  Widget _buildTextInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          style: TextStyle(
              fontSize: 24, color: Colors.teal, fontWeight: FontWeight.w700),
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            errorText: errorText,
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildGradientCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  // Explanation for Each Input
  Widget _buildInputExplanation(String explanation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        explanation,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
      ),
    );
  }

  // Property Submission
  void _submitPropertyDetails() {
    setState(() {
      _propertyError = widget.controller
          .updatePropertyAmount(_propertyAmountController.text);
      _debtError =
          widget.controller.updateDebtAmount(_debtAmountController.text);
      _testamentError = widget.controller
          .updateTestamentAmount(_testamentAmountController.text);
      _funeralError =
          widget.controller.updateFuneralAmount(_funeralAmountController.text);

      if (_propertyError == null &&
          _debtError == null &&
          _testamentError == null &&
          _funeralError == null &&
          widget.controller.property.total >= 0 &&
          (widget.controller.property.debt +
                  widget.controller.property.testament +
                  widget.controller.property.funeral) >
              widget.controller.property.amount) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Asset Notice'),
            content: Text(
                'The amount of debt, testament, and funeral arrangements, or the total of the debt, testament, and funeral arrangements, must not exceed the property amount; inheritance cannot be calculated.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Understand'),
              ),
            ],
          ),
        );
      } else if (_propertyError == null &&
          _debtError == null &&
          _testamentError == null &&
          _funeralError == null &&
          widget.controller.property.total >= 0 &&
          widget.controller.property.total == 0) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Asset Notice'),
            content: Text(
                'The total inheritance is 0; inheritance cannot be calculated.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Understand'),
              ),
            ],
          ),
        );
      } else if (_propertyError == null &&
          _debtError == null &&
          _testamentError == null &&
          _funeralError == null &&
          widget.controller.property.total >= 0) {
        currentStep = 2;
      } else {
        String errorMessage = _propertyError ??
            _debtError ??
            _funeralError ??
            'Something is not right.';

        if (_testamentError != null) {
          errorMessage = _testamentError!;
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Asset Notice'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Understand'),
              ),
            ],
          ),
        );
      }
    });
  }

  // Gender Step
  Widget _buildGenderInputStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Deceased's Gender", style: textUnderTitleStyle()),
        SizedBox(height: 25.0),
        _buildInputExplanation(
            "To determine the deceased's spouse, either wife or husband."),
        Center(
          child: Lottie.asset(
            'assets/lottie/spouse.json',
            width: 400,
            height: 350,
          ),
        ),
        _buildGenderSelection(),
        SizedBox(height: 100),
      ],
    );
  }

  // Select Gender
  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGenderIcon(
          icon: Icons.person,
          label: "Male",
          gender: 'Male',
          selected: widget.controller.deceased.gender == 'Male',
        ),
        SizedBox(width: 30),
        _buildGenderIcon(
          icon: Icons.person_2,
          label: "Female",
          gender: 'Female',
          selected: widget.controller.deceased.gender == 'Female',
        ),
      ],
    );
  }

  Widget _buildGenderIcon({
    required IconData icon,
    required String label,
    required String gender,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.controller.setDeceasedGender(gender);
        });
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? Colors.pink.shade100 : Colors.transparent,
                width: 3,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                icon,
                size: 100,
                color: selected ? Colors.pink : Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            label,
            style: TextStyle(
              fontSize: 23,
              color: selected ? Colors.brown.shade400 : Colors.grey,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Gender Submission
  void _submitGenderDetails() {
    setState(() {
      String? genderError = widget.controller.validateGender();
      if (genderError == null) {
        currentStep = 3;
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Gender Notice'),
            content: Text(genderError),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Understand'),
              ),
            ],
          ),
        );
      }
    });
  }

  // Family Step
  Widget _buildFamilyInputStep() {
    String? gender = widget.controller.deceased.gender;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Input Family Members", style: textUnderTitleStyle()),
          SizedBox(height: 25.0),
          _buildInputExplanation(
              "If the deceased left any family members, input the form below. Note that some may not qualify as heirs due to Faraid rules."),
          _buildFamilyMemberSection("Descendants", [
            {'title': "Son", 'max': 10},
            {'title': "Daughter", 'max': 10},
            {'title': "Grandson", 'max': 10},
            {'title': "Granddaughter", 'max': 10},
          ]),
          _buildFamilyMemberSection("Spouse", [
            {
              'title': gender == 'Male' ? "Wife" : "Husband",
              'max': gender == 'Male' ? 4 : 1
            },
          ]),
          _buildFamilyMemberSection("Ancestors", [
            {'title': "Father", 'max': 1},
            {'title': "Mother", 'max': 4},
            {'title': "Paternal Grandfather", 'max': 1},
            {'title': "Paternal Grandmother", 'max': 1},
            {'title': "Maternal Grandmother", 'max': 1},
          ]),
          _buildFamilyMemberSection("Siblings", [
            {'title': "Brother", 'max': 8},
            {'title': "Sister", 'max': 8},
            {'title': "Paternal Half-Brother", 'max': 8},
            {'title': "Paternal Half-Sister", 'max': 8},
            {'title': "Maternal Half-Brother", 'max': 8},
            {'title': "Maternal Half-Sister", 'max': 8},
          ]),
          _buildFamilyMemberSection("Sibling Descendants", [
            {'title': "Son of Brother", 'max': 10},
            {'title': "Son of Paternal Half-Brother", 'max': 10},
          ]),
          _buildFamilyMemberSection("Father's Siblings", [
            {'title': "Uncle", 'max': 5},
            {'title': "Paternal Uncle", 'max': 5},
            {'title': "Son of Uncle", 'max': 10},
            {'title': "Son of Paternal Uncle", 'max': 10},
          ]),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberSection(
      String title, List<Map<String, dynamic>> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15, bottom: 5),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.7),
                secondaryColor.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 5), // Adjust spacing between title and cards
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: members.map((member) {
            return _buildFamilyMemberInput(member['title'], max: member['max']);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFamilyMemberInput(String title, {required int max}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5), // Adjust margins as needed
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.teal.shade700,
            ),
          ),
          InputQty(
            initVal: 0,
            minVal: 0,
            maxVal: max,
            steps: 1,
            qtyFormProps: QtyFormProps(enableTyping: true),
            decoration: QtyDecorationProps(
              isBordered: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              minusBtn: Icon(Icons.person_remove_alt_1_rounded,
                  color: Colors.red.shade700),
              plusBtn: Icon(Icons.person_add_alt_1_rounded,
                  color: Colors.blue.shade600),
            ),
            onQtyChanged: (val) {
              int quantity = val is double ? val.toInt() : val;
              widget.impedimentController.updateHeirQuantity(title, quantity);
            },
          ),
        ],
      ),
    );
  }

  // Navigate to Impediment Page
  void _navigateToImpedimentPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImpedimentPage(
          identificationController: widget.controller,
          impedimentController: widget.impedimentController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _propertyAmountController.dispose();
    _debtAmountController.dispose();
    _testamentAmountController.dispose();
    _funeralAmountController.dispose();
    super.dispose();
  }
}

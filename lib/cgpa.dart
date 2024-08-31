import 'package:flutter/material.dart';

class Cgpa extends StatefulWidget {
  const Cgpa({super.key});
  @override
  _CgpaState createState() => _CgpaState();
}

class _CgpaState extends State<Cgpa> {
  int _numberOfSubjects = 0;
  final List<TextEditingController> _subjectControllers = [];
  final List<TextEditingController> _gradeControllers = [];
  final List<TextEditingController> _creditHourControllers = [];
  double _gpa = 0.0;
  double _cgpa = 0.0;
  final TextEditingController _previousGpaController = TextEditingController();
  final TextEditingController _previousCreditHoursController = TextEditingController();

  final Map<String, double> _gradeMap = {
    'A': 4.0,
    'B+': 3.5,
    'B': 3.0,
    'C+': 2.5,
    'C': 2.0,
    'F': 0.0,
  };

  void _createTextFields() {
    _subjectControllers.clear();
    _gradeControllers.clear();
    _creditHourControllers.clear();
    for (int i = 0; i < _numberOfSubjects; i++) {
      _subjectControllers.add(TextEditingController());
      _gradeControllers.add(TextEditingController());
      _creditHourControllers.add(TextEditingController());
    }
  }

  void _calculateGPA() {
    double totalPoints = 0.0;
    int totalCreditHours = 0;

    for (int i = 0; i < _numberOfSubjects; i++) {
      String grade = _gradeControllers[i].text.trim().toUpperCase();
      int creditHours = int.tryParse(_creditHourControllers[i].text.trim()) ?? 0;

      if (_gradeMap.containsKey(grade) && creditHours > 0) {
        totalPoints += _gradeMap[grade]! * creditHours;
        totalCreditHours += creditHours;
      }
    }

    setState(() {
      _gpa = totalCreditHours > 0 ? totalPoints / totalCreditHours : 0.0;
    });
  }
  void _calculateCGPA() {
    double previousGpa = double.tryParse(_previousGpaController.text) ?? 0.0;
    int previousCreditHours = int.tryParse(_previousCreditHoursController.text) ?? 0;
    _calculateGPA();
    int currentCreditHours = 0;
    for (var controller in _creditHourControllers) {
      currentCreditHours += int.tryParse(controller.text.trim()) ?? 0;
    }

    double totalQualityPoints = (previousGpa * previousCreditHours) + (_gpa * currentCreditHours);
    int totalCreditHours = previousCreditHours + currentCreditHours;

    setState(() {
      _cgpa = totalCreditHours > 0 ? totalQualityPoints / totalCreditHours : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculate your CGPA'),
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: screenHeight * 0.07,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _previousGpaController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Enter previous GPA/CGPA',
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Container(
              width: double.infinity,
              height: screenHeight * 0.07,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _previousCreditHoursController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Enter previous credit hours',
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Container(
              width: double.infinity,
              height: screenHeight * 0.07,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Enter number of subjects ',
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                ),
                onChanged: (value) {
                  setState(() {
                    _numberOfSubjects = int.tryParse(value) ?? 0;
                    _createTextFields();
                  });
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _numberOfSubjects,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _subjectControllers[index],
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Subject ${index + 1} Name',
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _gradeControllers[index],
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Grade',
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _creditHourControllers[index],
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Cr Hours',
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: screenHeight * 0.03),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _calculateCGPA();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey[400],
                      title: Text('CGPA Calculated', style: TextStyle(color: Colors.black)),
                      content: Text('Your CGPA is: ${_cgpa.toStringAsFixed(2)}', style: TextStyle(color: Colors.black)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.15,
                    vertical: screenHeight * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text('Submit and Calculate CGPA', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _subjectControllers) {
      controller.dispose();
    }
    for (var controller in _gradeControllers) {
      controller.dispose();
    }
    for (var controller in _creditHourControllers) {
      controller.dispose();
    }
    _previousGpaController.dispose();
    _previousCreditHoursController.dispose();
    super.dispose();
  }
}

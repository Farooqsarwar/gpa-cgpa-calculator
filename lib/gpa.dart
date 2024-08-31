import 'package:flutter/material.dart';

class SubjectInputScreen extends StatefulWidget {
  const SubjectInputScreen({super.key});

  @override
  _SubjectInputScreenState createState() => _SubjectInputScreenState();
}

class _SubjectInputScreenState extends State<SubjectInputScreen> {
  int _numberOfSubjects = 0;
  final List<TextEditingController> _subjectControllers = [];
  final List<TextEditingController> _gradeControllers = [];
  final List<TextEditingController> _creditHourControllers = [];
  double _gpa = 0.0;

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Calculate your GPA'),
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
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Enter number of subjects',
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
                  _calculateGPA();
                  for (int i = 0; i < _numberOfSubjects; i++) {
                    print('Subject: ${_subjectControllers[i].text}, Grade: ${_gradeControllers[i].text}, Credit Hours: ${_creditHourControllers[i].text}');
                  }
                  print('GPA: $_gpa');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey[400],
                      title: Text('GPA Calculated', style: TextStyle(color: Colors.black)),
                      content: Text('Your GPA is: ${_gpa.toStringAsFixed(2)}', style: TextStyle(color: Colors.black)),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                          ),
                          child: Text('OK', style: TextStyle(color: Colors.white)),
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
                child: Text('Calculate GPA', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cgpa extends StatefulWidget {
  const cgpa({super.key});
  @override
  _cgpaState createState() => _cgpaState();
}
class _cgpaState extends State<cgpa> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculate your CGPA'),
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _previousGpaController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Enter previous GPA/CGPA',
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _previousCreditHoursController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Enter previous credit hours',
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Enter number of subjects',
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    _numberOfSubjects = int.tryParse(value) ?? 0;
                    _createTextFields();
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _numberOfSubjects,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Subject ${index + 1} Name',
                                hintStyle: const TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _gradeControllers[index],
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Grade',
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _creditHourControllers[index],
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Cr Hours',
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
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
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _calculateCGPA();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey[400],
                      title: const Text('CGPA Calculated', style: TextStyle(color: Colors.black)),
                      content: Text('Your CGPA is: ${_cgpa.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Submit and Calculate CGPA'),
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

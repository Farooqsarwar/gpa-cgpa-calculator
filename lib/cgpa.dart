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

  bool _isDialogOpen = false; // Flag to track if a dialog is open

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

  bool _isValidGrade(String grade) {
    return _gradeMap.containsKey(grade);
  }

  void _calculateGPA() {
    double totalPoints = 0.0;
    int totalCreditHours = 0;
    String invalidGrades = '';

    for (int i = 0; i < _numberOfSubjects; i++) {
      String grade = _gradeControllers[i].text.trim().toUpperCase();
      int creditHours = int.tryParse(_creditHourControllers[i].text.trim()) ?? 0;

      if (_isValidGrade(grade) && creditHours > 0) {
        totalPoints += _gradeMap[grade]! * creditHours;
        totalCreditHours += creditHours;
      } else if (creditHours > 0) {
        invalidGrades += 'Subject ${i + 1}: ${_subjectControllers[i].text} - Invalid Grade: $grade\n';
      }
    }

    if (invalidGrades.isNotEmpty) {
      _showInvalidGradesDialog(invalidGrades);
    } else {
      setState(() {
        _gpa = totalCreditHours > 0 ? totalPoints / totalCreditHours : 0.0;
      });
    }
  }

  void _calculateCGPA() {
    double previousGpa = double.tryParse(_previousGpaController.text) ?? 0.0;
    int previousCreditHours = int.tryParse(_previousCreditHoursController.text) ?? 0;

    // Calculate GPA first
    _calculateGPA();

    // Check if GPA calculation was successful before proceeding
    if (_gpa > 0.0) {
      int currentCreditHours = 0;

      for (var controller in _creditHourControllers) {
        currentCreditHours += int.tryParse(controller.text.trim()) ?? 0;
      }

      double totalQualityPoints = (previousGpa * previousCreditHours) + (_gpa * currentCreditHours);
      int totalCreditHours = previousCreditHours + currentCreditHours;

      setState(() {
        _cgpa = totalCreditHours > 0 ? totalQualityPoints / totalCreditHours : 0.0;
      });

      // Show CGPA dialog after successful calculation
      _showCGPADialog();
    }
  }

  void _showInvalidGradesDialog(String invalidGrades) {
    if (!_isDialogOpen) { // Check if a dialog is already open
      _isDialogOpen = true; // Set the flag to true
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[400],
          title: Text('Invalid Grades', style: TextStyle(color: Colors.black)),
          content: Text(invalidGrades, style: TextStyle(color: Colors.black)),
          actions: [
            ElevatedButton(
              onPressed: () {
                _isDialogOpen = false; // Reset the flag when the dialog is closed
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
    }
  }

  void _showCGPADialog() {
    if (!_isDialogOpen) { // Check if a dialog is already open
      _isDialogOpen = true; // Set the flag to true
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[400],
          title: Text('CGPA Calculated', style: TextStyle(color: Colors.black)),
          content: Text('Your CGPA is: ${_cgpa.toStringAsFixed(3)}', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                _isDialogOpen = false; // Reset the flag when the dialog is closed
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }
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
            // Previous GPA and Credit Hours Input Fields
            _buildTextField(_previousGpaController, 'Enter previous GPA/CGPA', screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),
            _buildTextField(_previousCreditHoursController, 'Enter previous credit hours', screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),

            // Number of Subjects Input Field
            _buildTextField(null, 'Enter number of subjects', screenWidth, screenHeight, onChanged: (value) {
              setState(() {
                _numberOfSubjects = int.tryParse(value) ?? 0;
                _createTextFields();
              });
            }),

            SizedBox(height: screenHeight * 0.03),

            // Dynamic Subject, Grade, and Credit Hours Input Fields
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _numberOfSubjects,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: Row(
                    children: [
                      Expanded(child: _buildSubjectField(_subjectControllers[index], 'Subject ${index + 1} Name', screenWidth)),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(child: _buildGradeField(_gradeControllers[index], 'Grade', screenWidth)),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(child: _buildCreditHourField(_creditHourControllers[index], 'Cr Hours', screenWidth)),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: screenHeight * 0.03),

            // Calculate Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _calculateCGPA();
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

  Container _buildTextField(TextEditingController? controller, String hintText, double screenWidth, double screenHeight, {Function(String)? onChanged}) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.07,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: controller == null ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Container _buildSubjectField(TextEditingController controller, String hintText, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        ),
      ),
    );
  }

  Container _buildGradeField(TextEditingController controller, String hintText, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        ),
      ),
    );
  }
  Container _buildCreditHourField(TextEditingController controller, String hintText, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        ),
      ),
    );
  }
}

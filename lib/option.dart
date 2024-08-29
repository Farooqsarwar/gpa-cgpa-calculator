import 'package:flutter/material.dart';
import 'package:gpacalculator/gpa.dart';
import 'package:gpacalculator/cgpa.dart';

class Option extends StatelessWidget {
  const Option({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: EdgeInsets.all(screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.1),
            const CircleAvatar(
              backgroundImage: AssetImage("assets/iqra.jpg"),
              radius: 120,
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              'Select Calculation',
              style: TextStyle(
                color: Colors.black,
                fontSize: screenHeight * 0.030,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SubjectInputScreen()),
                      );
                    },
                    child: const Text(
                      'Calculate GPA',
                      style: TextStyle(color: Colors.black,fontSize: 17),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Cgpa()),
                      );
                    },
                    child: const Text(
                      'Calculate CGPA',
                      style: TextStyle(color: Colors.black,fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

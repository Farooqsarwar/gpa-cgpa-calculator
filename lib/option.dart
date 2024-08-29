import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpacalculator/gpa.dart';
import 'cgpa.dart';
class option extends StatelessWidget {
  const option({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Text('Select Calculation',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SubjectInputScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white54,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Calculate GPA',style: TextStyle(color: Colors.black),),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const cgpa()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white54,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Calculate CGPA',style: TextStyle(color: Colors.black),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
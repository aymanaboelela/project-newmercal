import 'package:flutter/material.dart';

class CramerSolverPage extends StatefulWidget {
  const CramerSolverPage({Key? key}) : super(key: key);

  @override
  _CramerSolverPageState createState() => _CramerSolverPageState();
}

class _CramerSolverPageState extends State<CramerSolverPage> {
  List<TextEditingController> controllers = List.generate(
    12,
    (index) => TextEditingController(),
  );

  double? x1;
  double? x2;
  double? x3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cramer Solver'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          for (int i = 0; i < 3; i++)
            Row(
              children: [
                for (int j = 0; j < 4; j++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller:
                            controllers[i * 4 + j], // تحديد التحكم المناسب
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Element [$i][$j]',
                        ),
                        onChanged: (value) {
                          setState(() {
                            controllers[i * 4 + j].text = value;
                          });
                        },
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 25),
          Center(
            child: ElevatedButton(
              onPressed: _solveEquations,
              child: const Text('Solve Equations'),
            ),
          ),
          if (x1 != null && x2 != null && x3 != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Results:', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('x1 = $x1'),
                  Text('x2 = $x2'),
                  Text('x3 = $x3'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _solveEquations() {
    try {
      List<double> coefficients = controllers
          .map((controller) => double.parse(controller.text))
          .toList();

      double a11 = coefficients[0];
      double a12 = coefficients[1];
      double a13 = coefficients[2];
      double a21 = coefficients[3];
      double a22 = coefficients[4];
      double a23 = coefficients[5];
      double a31 = coefficients[6];
      double a32 = coefficients[7];
      double a33 = coefficients[8];
      double b1 = coefficients[9];
      double b2 = coefficients[10];
      double b3 = coefficients[11];

      double determinantA = a11 * a22 * a33 +
          a12 * a23 * a31 +
          a13 * a21 * a32 -
          a13 * a22 * a31 -
          a11 * a23 * a32 -
          a12 * a21 * a33;

      double determinantX = b1 * a22 * a33 +
          a12 * a23 * b3 +
          a13 * b2 * a32 -
          a13 * a22 * b3 -
          b1 * a23 * a32 -
          a12 * b2 * a33;

      double determinantY = a11 * b2 * a33 +
          b1 * a23 * a31 +
          a13 * a21 * b3 -
          a13 * b2 * a31 -
          a11 * a23 * b3 -
          b1 * a21 * a33;

      double determinantZ = a11 * a22 * b3 +
          a12 * b2 * a31 +
          b1 * a21 * a32 -
          b1 * a22 * a31 -
          a11 * b2 * a32 -
          a12 * a21 * b3;

      x1 = determinantX / determinantA;
      x2 = determinantY / determinantA;
      x3 = determinantZ / determinantA;

      setState(() {});
    } catch (FormatException) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter valid numeric coefficients.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

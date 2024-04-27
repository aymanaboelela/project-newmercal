import 'package:flutter/material.dart';

class GaussianEliminationScreen extends StatefulWidget {
  @override
  _GaussianEliminationScreenState createState() =>
      _GaussianEliminationScreenState();
}

class _GaussianEliminationScreenState extends State<GaussianEliminationScreen> {
  final List<List<double>> matrix = List.generate(3, (_) => List.filled(4, 0));
  double x1 = 0, x2 = 0, x3 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gaussian Elimination'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const   Text('Enter matrix:', style: TextStyle(fontSize: 18)),
         const    SizedBox(height: 8),
            for (int i = 0; i < 3; i++)
              Row(
                children: [
                  for (int j = 0; j < 4; j++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration:
                              InputDecoration(labelText: 'Element [$i][$j]'),
                          onChanged: (value) {
                            setState(() {
                              matrix[i][j] = double.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
       const      SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  solveEquations();
                },
                child:const  Text('Solve Equations'),
              ),
            ),
      const      SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text('x1 = $x1', style: TextStyle(fontSize: 18)),
                  Text('x2 = $x2', style: TextStyle(fontSize: 18)),
                  Text('x3 = $x3', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void solveEquations() {
    double m21 = 0, m31 = 0, m32 = 0;
    m21 = matrix[1][0] / matrix[0][0];
    m31 = matrix[2][0] / matrix[0][0];
    for (int j = 0; j < 4; j++) {
      double e2 = matrix[1][j];
      double e1 = m21 * matrix[0][j];
      matrix[1][j] = e2 - e1;
    }
    for (int j = 0; j < 4; j++) {
      double e3 = matrix[2][j];
      double e1 = m31 * matrix[0][j];
      matrix[2][j] = e3 - e1;
    }
    m32 = matrix[2][1] / matrix[1][1];
    for (int j = 0; j < 4; j++) {
      double e3 = matrix[2][j];
      double e1 = m32 * matrix[1][j];
      matrix[2][j] = e3 - e1;
    }
    x3 = matrix[2][3] / matrix[2][2];
    x2 = (matrix[1][3] - (matrix[1][2] * x3)) / matrix[1][1];
    x1 = (matrix[0][3] - ((matrix[0][1] * x2) + (matrix[0][2] * x3))) /
        matrix[0][0];
    setState(() {});
  }
}

import 'package:flutter/material.dart';

class LUPage extends StatefulWidget {
  @override
  LUPageState createState() => LUPageState();
}

class LUPageState extends State<LUPage> {
  List<List<double>> matrix = List.generate(3, (_) => List.filled(4, 0.0));
  double x1 = 0, x2 = 0, x3 = 0;

  void performLU() {
    List<List<double>> a = List.generate(
        3, (i) => List.generate(4, (j) => matrix[i][j].toDouble()));
    List<double> result = LUDecomposition(a);
    setState(() {
      x1 = result[0];
      x2 = result[1];
      x3 = result[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('LU Decomposition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
       const      SizedBox(height: 20),
            for (int i = 0; i < 3; i++)
              Row(
                children: [
                  for (int j = 0; j < 4; j++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Element [$i][$j]',
                          ),
                          onChanged: (value) {
                            matrix[i][j] = double.tryParse(value) ?? 0.0;
                          },
                        ),
                      ),
                    ),
                ],
              ),
        const     SizedBox(height: 20),
            ElevatedButton(
              onPressed: performLU,
              child: Text('Calculate'),
            ),
      const       SizedBox(height: 20),
         const    Text('Results:', style: TextStyle(fontSize: 18)),
        const     SizedBox(height: 10),
            Text('x1 = $x1'),
            Text('x2 = $x2'),
            Text('x3 = $x3'),
          ],
        ),
      ),
    );
  }
}

List<double> LUDecomposition(List<List<double>> a) {
  List<List<double>> u = List.generate(3, (i) => List.filled(4, 0.0));
  double m21 = 0, m31 = 0, m32 = 0;
  CopyMatrix(a, u);
  m21 = u[1][0] / u[0][0];
  m31 = u[2][0] / u[0][0];
  for (int j = 0; j < 4; j++) {
    u[1][j] -= m21 * u[0][j];
  }
  for (int j = 0; j < 4; j++) {
    u[2][j] -= m31 * u[0][j];
  }
  m32 = u[2][1] / u[1][1];
  for (int j = 0; j < 4; j++) {
    u[2][j] -= m32 * u[1][j];
  }
  double x3 = u[2][3] / u[2][2];
  double x2 = (u[1][3] - u[1][2] * x3) / u[1][1];
  double x1 = (u[0][3] - u[0][1] * x2 - u[0][2] * x3) / u[0][0];
  return [x1, x2, x3];
}

void CopyMatrix(List<List<double>> x, List<List<double>> y) {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 4; j++) {
      y[i][j] = x[i][j];
    }
  }
}

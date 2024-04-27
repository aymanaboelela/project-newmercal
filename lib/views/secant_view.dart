import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class SecantMethodPage extends StatefulWidget {
  const SecantMethodPage({Key? key}) : super(key: key);

  @override
  _SecantMethodPageState createState() => _SecantMethodPageState();
}

class _SecantMethodPageState extends State<SecantMethodPage> {
  final TextEditingController functionController = TextEditingController();
  final TextEditingController initialGuess1Controller = TextEditingController();
  final TextEditingController initialGuess2Controller = TextEditingController();
  final TextEditingController epsilonController = TextEditingController();

  List<Map<String, dynamic>> steps = [];

  late Expression expression;
  late Parser parser;
  late ContextModel contextModel;
  late Variable x;

  @override
  void initState() {
    super.initState();
    parser = Parser();
    contextModel = ContextModel();
    x = Variable('x');
  }

  double f(double xValue) {
    contextModel.bindVariable(x, Number(xValue));
    return expression.evaluate(EvaluationType.REAL, contextModel);
  }

  double secant(double xiMinus1, double xi, double eps) {
    double error = double.infinity;
    int iter = 0;

    while (error > eps) {
      double fXiMinus1 = f(xiMinus1);
      double fXi = f(xi);
      error = (xi - xiMinus1).abs() / xi * 100;

      steps.add({
        'iteration': iter.toStringAsFixed(3),
        'xiMinus1': xiMinus1.toStringAsFixed(3),
        'f(xi-1)': fXiMinus1.toStringAsFixed(3),
        'xi': xi.toStringAsFixed(3),
        'f(xi)': fXi.toStringAsFixed(3),
        'Error': iter == 0 ? "-----" : error
      });

      double temp = xi;
      xi = xi - (fXi * (xiMinus1 - xi)) / (fXiMinus1 - fXi);
      xiMinus1 = temp;

      iter++;
    }

    // Add final step
    double fXiMinus1 = f(xiMinus1);
    double fXi = f(xi);
    error = (xi - xiMinus1).abs() / xi * 100;
    steps.add({
      'iteration': iter.toStringAsFixed(3),
      'xiMinus1': xiMinus1.toStringAsFixed(3),
      'f(xi-1)': fXiMinus1.toStringAsFixed(3),
      'xi': xi.toStringAsFixed(3),
      'f(xi)': fXi.toStringAsFixed(3),
      'Error': error.toStringAsFixed(3),
    });

    return xi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secant Method'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: functionController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: 'Enter the function (ex: x^2 - 4)'),
            ),
            TextFormField(
              controller: initialGuess1Controller,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: 'Enter initial guess (xi-1)'),
            ),
            TextFormField(
              controller: initialGuess2Controller,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: 'Enter initial guess (xi)'),
            ),
            TextFormField(
              controller: epsilonController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter epsilon (eps)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                try {
                  String function = functionController.text;
                  expression = parser.parse(function);

                  double initialGuess1 =
                      double.parse(initialGuess1Controller.text);
                  double initialGuess2 =
                      double.parse(initialGuess2Controller.text);
                  double eps = double.parse(epsilonController.text);

                  steps.clear();
                  // ignore: unused_local_variable
                  double root = secant(initialGuess1, initialGuess2, eps);

                  setState(() {}); // Trigger rebuild to update the table
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Invalid input: ${e.toString()}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Iteration')),
                    DataColumn(label: Text('xi-1')),
                    DataColumn(label: Text('f(xi-1)')),
                    DataColumn(label: Text('xi')),
                    DataColumn(label: Text('f(xi)')),
                    DataColumn(label: Text('Error')),
                  ],
                  rows: steps.map((step) {
                    return DataRow(cells: [
                      DataCell(Text('${step['iteration']}')),
                      DataCell(Text('${step['xiMinus1']}')),
                      DataCell(Text('${step['f(xi-1)']}')),
                      DataCell(Text('${step['xi']}')),
                      DataCell(Text('${step['f(xi)']}')),
                      DataCell(Text('${step['Error']}')),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//  0.95*x^3 - 5.9*x^2 + 10.9*x - 6
// Using The Secant Method Use an initial guess of 𝑥−1 = 2.5 𝑎𝑛𝑑
// 𝑥0 = 3.5 and iterate until εa ≤ 0.5

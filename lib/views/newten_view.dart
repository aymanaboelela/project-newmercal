import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class NewtonMethodPage extends StatefulWidget {
  const NewtonMethodPage({Key? key}) : super(key: key);

  @override
  NewtonMethodPageState createState() => NewtonMethodPageState();
}

class NewtonMethodPageState extends State {
  final TextEditingController initialGuessController = TextEditingController();
  final TextEditingController epsilonController = TextEditingController();
  final TextEditingController functionController = TextEditingController();

  List<Map<String, dynamic>> steps = [];

  late Parser parser;
  late Expression expression;
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

  double fDash(double xValue) {
    Expression derivative = expression.derive('x');
    contextModel.bindVariable(x, Number(xValue));
    return derivative.evaluate(EvaluationType.REAL, contextModel);
  }

  double newton(double xo, double eps) {
    double error = double.infinity;
    int iter = 0;
    double xiPlus1 = 0;
    double xi = xo;

    while (error > eps && iter < 1000) {
      double fXi = f(xi);
      double fDashXi = fDash(xi);
      xiPlus1 = xi - (fXi / fDashXi);

      steps.add({
        'iteration': iter.round(),
        'xi': xi.toStringAsFixed(3),
        'f(xi)': fXi.toStringAsFixed(3),
        'f\'(xi)': fDashXi.toStringAsFixed(3),
        'Error': iter == 0 ? "----" : error.toStringAsFixed(3),
      });
      error = (xiPlus1 - xi).abs();

      xi = xiPlus1;
      iter++;
    }

    return xi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newton Method'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: functionController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Enter the function'),
            ),
            TextFormField(
              controller: initialGuessController,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: 'Enter initial guess (x0)'),
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

                  double initialGuess =
                      double.parse(initialGuessController.text);
                  double eps = double.parse(epsilonController.text);

                  steps.clear();
                  // ignore: unused_local_variable
                  double root = newton(initialGuess, eps);

                  setState(() {}); // Trigger rebuild to update the table
                } on FormatException catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Invalid input: ${e.message}'),
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
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('An unexpected error occurred.'),
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
                child: Column(
                  children: [
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('Iteration')),
                        DataColumn(label: Text('xi')),
                        DataColumn(label: Text('f(xi)')),
                        DataColumn(label: Text('f\'(xi)')),
                        DataColumn(label: Text('Error')),
                      ],
                      rows: steps.map((step) {
                        return DataRow(cells: [
                          DataCell(Text('${step['iteration']}')),
                          DataCell(Text('${step['xi']}')),
                          DataCell(Text('${step['f(xi)']}')),
                          DataCell(Text('${step['f\'(xi)']}')),
                          DataCell(Text('${step['Error']}')),
                        ]);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//-0.9*x^2 + 1.7*x + 2.5
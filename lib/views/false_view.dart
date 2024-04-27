import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class FalsePositionPage extends StatefulWidget {
  const FalsePositionPage({Key? key});

  @override
  FalsePositionPageState createState() => FalsePositionPageState();
}

class FalsePositionPageState extends State<FalsePositionPage> {
  TextEditingController xlController = TextEditingController();
  TextEditingController xuController = TextEditingController();
  TextEditingController epsController = TextEditingController();
  TextEditingController functionController = TextEditingController();
  List<Map<String, dynamic>> iterations = [];
  final _formKey = GlobalKey<FormState>();

  double f(double x, String function) {
    Parser p = Parser();
    Expression exp = p.parse(function);
    ContextModel cm = ContextModel();
    cm.bindVariable(Variable('x'), Number(x));
    return exp.evaluate(EvaluationType.REAL, cm);
  }

  void falsePosition(double xl, double xu, double eps, String function) {
    int iter = 0;
    double xr = 0;
    double xrOld = 0;
    double error = 0;
    bool isFirstIteration = true;
    do {
      xrOld = xr;
      xr = xu -
          (f(xu, function) * (xl - xu)) / (f(xl, function) - f(xu, function));
      error = ((xr - xrOld).abs() / xr) * 100;
      if (isFirstIteration) {
        iterations.add({
          'iteration': iter.toStringAsFixed(3),
          'xl': xl.toStringAsFixed(3),
          'f(xl)': f(xl, function).toStringAsFixed(3),
          'xu': xu.toStringAsFixed(3),
          'f(xu)': f(xu, function).toStringAsFixed(3),
          'xr': xr.toStringAsFixed(3),
          'f(xr)': f(xr, function).toStringAsFixed(3),
          'Error%': '----', // empty for first iteration
        });
        isFirstIteration = false;
      } else {
        iterations.add({
          'iteration': iter.toStringAsFixed(3),
          'xl': xl.toStringAsFixed(3),
          'f(xl)': f(xl, function).toStringAsFixed(3),
          'xu': xu.toStringAsFixed(3),
          'f(xu)': f(xu, function).toStringAsFixed(3),
          'xr': xr.toStringAsFixed(3),
          'f(xr)': f(xr, function).toStringAsFixed(3),
          'Error%': error.toStringAsFixed(3),
        });
      }
      if (f(xl, function) * f(xr, function) > 0) {
        xl = xr;
      } else {
        xu = xr;
      }
      iter++;
    } while (error > eps);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('False Position Method'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: functionController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a function';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Enter function (ex: -2 + 7*x - 5*x^2 + 6*x^3)',
                ),
              ),
              TextFormField(
                controller: xlController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                decoration:
                    const InputDecoration(labelText: 'Enter lower bound (xl)'),
              ),
              TextFormField(
                controller: xuController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                decoration:
                    const InputDecoration(labelText: 'Enter upper bound (xu)'),
              ),
              TextFormField(
                controller: epsController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                decoration:
                    const InputDecoration(labelText: 'Enter epsilon (eps)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    double xl = double.parse(xlController.text);
                    double xu = double.parse(xuController.text);
                    double eps = double.parse(epsController.text);
                    String function = functionController.text;
                    iterations.clear();
                    try {
                      if (f(xl, function) * f(xu, function) < 0) {
                        falsePosition(xl, xu, eps, function);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Incorrect xl and xu values'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: Text(e.toString()),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                child: const Text('Calculate'),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Iteration')),
                      DataColumn(label: Text('xl')),
                      DataColumn(label: Text('f(xl)')),
                      DataColumn(label: Text('xu')),
                      DataColumn(label: Text('f(xu)')),
                      DataColumn(label: Text('xr')),
                      DataColumn(label: Text('f(xr)')),
                      DataColumn(label: Text('Error%')),
                    ],
                    rows: iterations.map((iteration) {
                      return DataRow(cells: [
                        DataCell(Text('${iteration['iteration']}')),
                        DataCell(Text('${iteration['xl']}')),
                        DataCell(Text('${iteration['f(xl)']}')),
                        DataCell(Text('${iteration['xu']}')),
                        DataCell(Text('${iteration['f(xu)']}')),
                        DataCell(Text('${iteration['xr']}')),
                        DataCell(Text('${iteration['f(xr)']}')),
                        DataCell(Text('${iteration['Error%']}')),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// -26 + 82.3*x - 88*x^2 + 45.4*x^3 - 9*x^4 + 0.65*x^5

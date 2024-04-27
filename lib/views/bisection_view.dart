import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class BisectionPage extends StatefulWidget {
  const BisectionPage({super.key});

  @override
  BisectionPageState createState() => BisectionPageState();
}

class BisectionPageState extends State<BisectionPage> {
  TextEditingController xlController = TextEditingController();
  TextEditingController xuController = TextEditingController();
  TextEditingController epsController = TextEditingController();
  TextEditingController functionController = TextEditingController();
  List<Map<String, dynamic>> iterations = [];
  final _formKey = GlobalKey<FormState>();
  double f(double x, String function) {
    Parser p = Parser();
    Expression exp;
    exp = p.parse(function);
    ContextModel cm = ContextModel();
    cm.bindVariable(Variable('x'), Number(x));
    return exp.evaluate(EvaluationType.REAL, cm);
  }

  void bisect(double xl, double xu, double eps, String function) {
    int iter = 0;
    double xr = 0;
    double xrOld = 0;
    double error = 0;
    do {
      xrOld = xr;
      xr = (xl + xu) / 2;
      error = ((xr - xrOld).abs() / xr) * 100;
      if (iterations.isEmpty) {
        iterations.add({
          'iteration': iter,
          'xl': xl,
          'f(xl)': f(xl, function),
          'xu': xu,
          'f(xu)': f(xu, function),
          'xr': xr,
          'f(xr)': f(xr, function),
          'Error%': '----', // error on first itration in emptu
        });
      } else {
        iterations.add({
          'iteration': iter,
          'xl': xl,
          'f(xl)': f(xl, function),
          'xu': xu,
          'f(xu)': f(xu, function),
          'xr': xr,
          'f(xr)': f(xr, function),
          'Error%': error,
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
          title: const Text('Bisection Method'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                  controller: functionController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      labelText:
                          'Enter function(ex: -2 + 7*x - 5*x^2 + 6*x^3)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Function';
                    }
                    return null;
                  }),
              TextFormField(
                controller: xlController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Xl';
                  }
                  return null;
                },
                decoration:
                    const InputDecoration(labelText: 'Enter lower value'),
              ),
              TextFormField(
                controller: xuController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Enter upper value'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Xu';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: epsController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Enter epsilon value'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Epsilon';
                  }
                  return null;
                },
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
                    setState(() {});
                    try {
                      if (f(xl, function) * f(xu, function) < 0) {
                        bisect(
                            xl,
                            xu,
                            eps,
                            functionController
                                .text); // Passing the function here
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

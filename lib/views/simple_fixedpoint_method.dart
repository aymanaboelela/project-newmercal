import 'package:flutter/material.dart';
import 'dart:math' as math;

class FixedPointMethodPage extends StatefulWidget {
  const FixedPointMethodPage({Key? key});

  @override
  _FixedPointMethodPageState createState() => _FixedPointMethodPageState();
}

class _FixedPointMethodPageState extends State {
  TextEditingController x0Controller = TextEditingController();
  TextEditingController epsController = TextEditingController();
  TextEditingController functionController = TextEditingController();
  List<Map<String, dynamic>> iterations = [];

  final _formKey = GlobalKey<FormState>();

  double f(double x) {
    return math.sqrt((1.8 * x) + 2.5);
  }

  void fixedPoint(double x, double eps) {
    iterations.clear();
    int maxIterations = 100;
    int iter = 0;
    double xiPlus1 = 0;
    double xi = x;
    double error = 0;

    do {
      xiPlus1 = f(xi);
      error = ((xiPlus1 - xi).abs() / xiPlus1) * 100;

      iterations.add({
        'iteration': iter.toStringAsFixed(3),
        'Xi': xi.toStringAsFixed(3),
        'Xi+1': xiPlus1.toStringAsFixed(3),
        'Error%': error.toStringAsFixed(3),
      });

      xi = xiPlus1;
      iter++;
    } while (error > eps && iter < maxIterations);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Point Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: functionController,
                    keyboardType: TextInputType.text,
                    decoration:
                        const InputDecoration(labelText: 'Function (Optional)'),
                  ),
                  TextFormField(
                    controller: x0Controller,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Enter x0'),
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
                        const InputDecoration(labelText: 'Enter epsilon'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        double x0 = double.parse(x0Controller.text);
                        double eps = double.parse(epsController.text);
                        fixedPoint(x0, eps);
                      }
                    },
                    child: const Text('Calculate'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Iteration')),
                    DataColumn(label: Text('Xi')),
                    DataColumn(label: Text('Xi+1')),
                    DataColumn(label: Text('Error%')),
                  ],
                  rows: iterations.map((iteration) {
                    return DataRow(cells: [
                      DataCell(Text('${iteration['iteration']}')),
                      DataCell(Text('${iteration['Xi']}')),
                      DataCell(Text('${iteration['Xi+1']}')),
                      DataCell(Text('${iteration['Error%']}')),
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

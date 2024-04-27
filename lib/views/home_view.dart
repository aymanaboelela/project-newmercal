import 'package:flutter/material.dart';
import 'package:newmercal/views/bisection_view.dart';
import 'package:newmercal/views/cramer_solver_view.dart';
import 'package:newmercal/views/false_view.dart';
import 'package:newmercal/views/gauss_elimination_view.dart';
import 'package:newmercal/views/lu_view.dart';
import 'package:newmercal/views/newten_view.dart';
import 'package:newmercal/views/secant_view.dart';
import 'package:newmercal/views/simple_fixedpoint_method.dart';
import 'package:newmercal/widgets/custom_funcation_name.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image.asset(
          //   "assets/3.jpg",
          //   height: double.infinity,
          //   width: double.infinity,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Choose A Method :",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                  ),
                  children: [
                    CustomFunctionName(
                      image: "assets/2.jpg",
                      title: "Bisection Method",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const BisectionPage();
                            },
                          ),
                        );
                      },
                    ),
                    CustomFunctionName(
                      image: "assets/3.jpg",
                      title: "The False Position Method",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const FalsePositionPage();
                            },
                          ),
                        );
                      },
                    ),
                    CustomFunctionName(
                      image: "assets/4.jpg",
                      title: "Simple Fixed Point Method",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const FixedPointMethodPage();
                            },
                          ),
                        );
                      },
                    ),
                    CustomFunctionName(
                      image: "assets/5.jpg",
                      title: "Newton Method",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const NewtonMethodPage();
                            },
                          ),
                        );
                      },
                    ),
                    CustomFunctionName(
                      image: "assets/6.jpg",
                      title: "Secant Method",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SecantMethodPage();
                            },
                          ),
                        );
                      },
                    ),
                    CustomFunctionName(
                      image: "assets/7.jpg",
                      title: "Gauss Elimination",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return GaussianEliminationScreen();
                            },
                          ),
                        );
                      },
                    ),
                    CustomFunctionName(
                      image: "assets/aa.jpg",
                      title: "LU Decomposition ",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LUPage();
                            },
                          ),
                        );
                      },
                    ),
                    CustomFunctionName(
                      image: "assets/i.jpg",
                      title: "Cramer’s Rule ",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CramerSolverPage();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

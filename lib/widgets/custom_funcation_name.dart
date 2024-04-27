import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFunctionName extends StatelessWidget {
  const CustomFunctionName({
    Key? key,
    required this.title,
    required this.onTap,
    required this.image,
  }) : super(key: key);

  final String title;
  final String image;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white),
        ),
        child: ListTile(
          splashColor: Colors.deepPurpleAccent,
          selectedColor: Colors.blue,
          hoverColor: Colors.grey[500],
          onTap: onTap,
          title: Center(
            child: Text(
              style: GoogleFonts.kanit(
                fontSize: 20,
              ),
              title,
            ),
          ),
        ),
      ),
    );
  }
}

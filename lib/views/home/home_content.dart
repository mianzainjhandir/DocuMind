import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Home Content Screen",
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

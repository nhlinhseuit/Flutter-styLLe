import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatefulWidget {
  final String firstLine;
  final String? secondLine;
  const Header({required this.firstLine, this.secondLine,super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.firstLine.toUpperCase(),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 32
            ),
          ),
          if (widget.secondLine != null)
          Text(
            widget.secondLine!.toUpperCase(),
            style: GoogleFonts.inter(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 32
            ),
          ),
          const Divider(
              height: 32,
              thickness: 2,
              indent: 0,
              endIndent: 200,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}
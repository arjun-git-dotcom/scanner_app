import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final String name;
  final String dateofbirth;
  final String nationality;
  final String gender;
  final String personalNumber;
  final String issueDate;

  const DetailsPage({
    super.key,
    required this.name,
    required this.dateofbirth,
    required this.nationality,
    required this.gender,
    required this.personalNumber,
    required this.issueDate
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.name),
            Text(widget.dateofbirth),
            Text(widget.nationality),
            Text(widget.gender),
            Text(widget.personalNumber),
            Text(widget.issueDate)
          ],
        ),
      ),
    );
  }
}

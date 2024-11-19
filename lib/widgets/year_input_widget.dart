import 'package:flutter/material.dart';

class YearInputWidget extends StatelessWidget {
  final TextEditingController yearController;
  final Function(String) onYearChanged;

  const YearInputWidget({
    required this.yearController,
    required this.onYearChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: yearController,
      decoration: InputDecoration(
        hintText: 'Введите год',
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: onYearChanged,
    );
  }
}

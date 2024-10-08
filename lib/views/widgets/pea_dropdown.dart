import 'package:flutter/material.dart';

class PeaDropdown extends StatelessWidget {
  final String hintText;
  final String? helperText;
  final List<String> items;
  final void Function(String?)? onChanged;

  const PeaDropdown({
    super.key,
    required this.hintText,
    this.helperText,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hintText,
          helperText: helperText,
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

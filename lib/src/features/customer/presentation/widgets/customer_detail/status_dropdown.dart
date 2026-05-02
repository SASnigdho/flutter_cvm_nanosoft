import 'package:flutter/material.dart';

class StatusDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  const StatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: 'Visit Status',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'Pending', child: Text('Pending')),
        DropdownMenuItem(value: 'Visited', child: Text('Visited')),
        DropdownMenuItem(value: 'Not Available', child: Text('Not Available')),
      ],
      onChanged: onChanged,
    );
  }
}

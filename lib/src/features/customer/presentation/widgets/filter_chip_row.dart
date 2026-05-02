import 'package:flutter/material.dart';

class FilterChipRow extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusSelected;

  const FilterChipRow({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  final List<String> statuses = const [
    'All',
    'Pending',
    'Visited',
    'Not Available',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statuses.map((status) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(status),
              selected: selectedStatus == status,
              onSelected: (selected) {
                if (selected) {
                  onStatusSelected(status);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

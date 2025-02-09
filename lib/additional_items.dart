import 'package:flutter/material.dart';

class AdditionalItems extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalItems(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Icon(
            icon,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            label,
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

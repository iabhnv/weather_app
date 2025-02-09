
import 'package:flutter/material.dart';

class ForecastItem extends StatelessWidget {
  final IconData icon;
  final String time;
  final String value;
  const ForecastItem(
      {super.key, required this.icon, required this.time, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
            ),
          ],
        ),
      ),
    );
  }
}

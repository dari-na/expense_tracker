import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 149,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: const Color(0xFF4F518D)),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 78,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFC8CAF8),
                ),
                alignment: Alignment.center,
                child: Text(
                  value ? 'Custom' : 'Current',
                  style: const TextStyle(color: Color(0xFF4F518D), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: value ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 78,
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  value ? 'Current' : 'Custom',
                  style: const TextStyle(color: Color(0xFF4F518D)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
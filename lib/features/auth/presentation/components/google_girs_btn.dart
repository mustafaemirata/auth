import 'package:flutter/material.dart';

class GoogleGiris extends StatelessWidget {
  final VoidCallback onTap; // butona basıldığında çalışacak fonksiyon

  const GoogleGiris({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          'lib/assets/google.png',
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}

import 'package:examcheck_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class EchecPage extends StatelessWidget {
  final double moyenne;

  const EchecPage({super.key, required this.moyenne});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Échec'),
        leading: const BackButton(),
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.text,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/Failure.png', 
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Désolé 😞',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '  failure is not the end ,buta step towards victory! vous avec eu ${moyenne.toStringAsFixed(2)} de moyenne',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

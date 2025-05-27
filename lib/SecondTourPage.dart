import 'package:examcheck_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SecondTourPage extends StatelessWidget {
  final double moyenne;

  const SecondTourPage({super.key, required this.moyenne});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
       backgroundColor: AppColors.background,
        title: const Text('Second Tour'),
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
                'assets/images/Courage.png', 
                width: 100,
                height: 100,
              
              ),
              const SizedBox(height: 20),
              const Text(
                'Courage ! ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Don t give up! You are stronger than you think.\n Stay focused and give it your all to succeed!you have  ${moyenne.toStringAsFixed(2)} de moyenne',
                style: const TextStyle(
                  color: AppColors.text2,
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

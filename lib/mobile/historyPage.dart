import 'package:flutter/material.dart';
import 'package:examcheck_app/utils/app_colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  // ⚠️ Données simulées, plus tard à remplacer par des données dynamiques
  final List<Map<String, dynamic>> historique = const [
    {
      'exam': 'BAC',
      'numPv': '12345',
      'moyenne': 14.5,
      'result': 'Validé',
      'date': '2025-05-01'
    },
    {
      'exam': 'BEPC',
      'numPv': '67890',
      'moyenne': 9.0,
      'result': 'Second tour',
      'date': '2025-05-01'
    },
    {
      'exam': 'BAC',
      'numPv': '54321',
      'moyenne': 6.75,
      'result': 'Échec',
      'date': '2025-04-30'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Historique des recherches'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: const BackButton(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historique.length,
        itemBuilder: (context, index) {
          final item = historique[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.primary),
            ),
            child: ListTile(
              leading: const Icon(Icons.history, color: AppColors.primary),
              title: Text(
                '${item['exam']} - PV: ${item['numPv']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Moyenne: ${item['moyenne']} - ${item['result']}\nDate: ${item['date']}',
                style: const TextStyle(height: 1.4),
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}

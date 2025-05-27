import 'package:flutter/material.dart';
// contient allResults
import 'package:examcheck_app/utils/app_colors.dart';

class ViewAllResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> allResults;

  const ViewAllResultsPage({super.key, required this.allResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Tous les résultats"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: allResults.isEmpty
          ? const Center(
              child: Text(
                "Aucun résultat disponible.",
                style: TextStyle(color: AppColors.text),
              ),
            )
          : ListView.builder(
              itemCount: allResults.length,
              itemBuilder: (context, index) {
                final result = allResults[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.person, color: AppColors.primary),
                    title: Text("${result['nom']} ${result['prenom']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("PV: ${result['numeroPV']}"),
                        Text("Ville: ${result['ville']} | Série: ${result['serie']}"),
                        Text("Moyenne: ${result['moyenne']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

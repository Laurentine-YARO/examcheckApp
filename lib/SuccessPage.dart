import 'package:examcheck_app/RelevePage.dart';
import 'package:examcheck_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  final String nom;
  final String prenom;
  final String type;
  final String numeroPV;
  final String jury; // utilisé comme "ville"
  final String serie;
  final double moyenne;
  final Map<String, double> notes;

  const SuccessPage({
    super.key,
    required this.nom,
    required this.prenom,
    required this.type,
    required this.numeroPV,
    required this.jury,
    required this.serie,
    required this.moyenne,
    required this.notes,
  });

  String getMention(double moyenne) {
    if (moyenne >= 18) {
      return "Excellent";
    } else if (moyenne >= 16) {
      return "Très bien";
    } else if (moyenne >= 14) {
      return "Bien";
    } else if (moyenne >= 12) {
      return "Assez bien";
    } else {
      return "Passable";
    }
  }

  @override
  Widget build(BuildContext context) {
    final mention = getMention(moyenne);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/Success.jpeg',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'CONGRATULATIONS!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '$nom $prenom \nvous avez validez avec une moyenne de\n $moyenne',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Mention: $mention',
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Préparation des données pour le relevé
                  final result = StudentResult(
                    nom: nom,
                    prenom: prenom,
                    numeroPV: numeroPV,
                    serie: serie,
                    ville: jury, // Utilisé ici comme "ville"
                    notes: notes.entries.map((entry) => Note(
                      matiere: entry.key,
                      coef: 1, // tu peux adapter selon les données réelles
                      note: entry.value,
                    )).toList(),
                    total: notes.values.reduce((a, b) => a + b).toInt(),
                    moyenne: moyenne,
                    mention: mention,
                    decision: "Admis",
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RelevePage(student: result),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Voir mon relevé"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:examcheck_app/utils/app_colors.dart';
import 'package:examcheck_app/mobile/SuccessPage.dart';
import 'package:examcheck_app/mobile/SecondTourPage.dart';
import 'package:examcheck_app/mobile/EchecPage.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  final TextEditingController pvController = TextEditingController();

  String selectedExam = 'BAC';
  String? selectedSerie;
  String? selectedAnnee;

  final List<String> examTypes = ['BAC', 'BEPC'];
  final List<String> bacSeries = ['A', 'C', 'D', 'E', 'F', 'Pro', 'F3'];
  final List<String> annees = ['2025', '2024', '2023'];

  final List<Map<String, dynamic>> resultats = [
    {
      'type': 'BAC',
      'serie': 'D',
      'numPv': '12345',
      'ville': 'Ouagadougou',
      'nom': 'Sawadogo',
      'prenom': 'Ali',
      'annee': '2025',
      'notes': {
        'Mathématiques': 15.0,
        'Physique chimie': 14.0,
        'EPS': 16.0,
        'SVT': 12.0,
        'Français': 16.0,
        'Anglais': 13.0,
        'Philosophie': 11.0,
        'Histoire et géographie': 10.0,
      },
      'coefs': {
        'Mathématiques': 5,
        'Physique chimie': 5,
        'EPS': 2,
        'SVT': 5,
        'Français': 3,
        'Anglais': 2,
        'Philosophie': 2,
        'Histoire et géographie': 2,
      },
    },
    {
      'type': 'BEPC',
      'numPv': '67890',
      'ville': 'Bobo',
      'nom': 'Ouedraogo',
      'prenom': 'Awa',
      'annee': '2024',
      'notes': {
        'SVT': 12.0,
        'EPS': 14.0,
        'Anglais': 15.0,
        'Physique chimie': 11.0,
        'Français': 10.0,
        'Histoire et géographie': 8.0,
        'Mathématiques': 9.0,
      },
      'coefs': {
        'Français': 3,
        'Histoire et géographie': 3,
        'Mathématiques': 5,
        'SVT': 3,
        'EPS': 2,
        'Anglais': 3,
        'Physique chimie': 4,
      },
    },
    {
      'type': 'BAC',
      'serie': 'C',
      'numPv': '54321',
      'ville': 'Koudougou',
      'nom': 'Lougué',
      'prenom': 'Awa',
      'annee': '2023',
      'notes': {
        'Mathématiques': 8.0,
        'Physique chimie': 9.0,
        'EPS': 10.0,
        'SVT': 7.0,
        'Anglais': 6.0,
        'Philosophie': 5.0,
        'Histoire et géographie': 9.0,
        'Français': 7.0,
      },
      'coefs': {
        'Mathématiques': 5,
        'Physique chimie': 5,
        'EPS': 2,
        'SVT': 5,
        'Français': 3,
        'Anglais': 2,
        'Philosophie': 2,
        'Histoire et géographie': 2,
      },
    },
  ];

  @override
  void dispose() {
    pvController.dispose();
    super.dispose();
  }

  double calculerMoyennePonderee(
    Map<String, double> notes,
    Map<String, int> coefs,
  ) {
    double totalPoints = 0;
    int totalCoef = 0;

    notes.forEach((matiere, note) {
      final coef = coefs[matiere] ?? 1;
      totalPoints += note * coef;
      totalCoef += coef;
    });
    final moyenne = totalCoef > 0 ? totalPoints / totalCoef : 0.0;
    print("Total: $totalPoints | Coef: $totalCoef | Moyenne: $moyenne");
    return moyenne;
    //return totalCoef > 0 ? totalPoints / totalCoef : 0.0;
  }

  void verifierResultat() {
    final pv = pvController.text.trim();

    if (selectedAnnee == null) {
      _showError("Veuillez sélectionner l'année.");
      return;
    }

    if (selectedExam == 'BAC' && selectedSerie == null) {
      _showError("Veuillez sélectionner une série.");
      return;
    }

    if (pv.isEmpty) {
      _showError("Veuillez saisir le numéro PV.");
      return;
    }

    final result = resultats.firstWhere(
      (item) =>
          item['type'] == selectedExam &&
          item['numPv'] == pv &&
          item['annee'] == selectedAnnee &&
          (selectedExam == 'BEPC' || item['serie'] == selectedSerie),
      orElse: () => {},
    );

    if (result.isEmpty) {
      _showError("Aucun résultat trouvé. Vérifiez les informations saisies.");
      return;
    }

    final String nom = result['nom'];
    final String prenom = result['prenom'];
    final String type = result['type'];
    final String numeroPV = result['numPv'];
    final String jury = result['ville'];
    final String serie = result['serie'] ?? '';
    final Map<String, double> notes = Map<String, double>.from(
      result['notes'] ?? {},
    );
    final Map<String, int> coefs = Map<String, int>.from(result['coefs'] ?? {});

    if (notes.isEmpty || coefs.isEmpty) {
      _showError("Données de notes ou coefficients manquantes.");
      return;
    }

    final double moyenne = calculerMoyennePonderee(notes, coefs);
    print("MOYENNE CALCULÉE : $moyenne");

    if (moyenne >= 10) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => SuccessPage(
                nom: nom,
                prenom: prenom,
                numeroPV: numeroPV,
                jury: jury,
                type: type,
                serie: serie,
                notes: notes,
                moyenne: moyenne,
              ),
        ),
      );
    } else if (moyenne >= 8) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SecondTourPage(moyenne: moyenne)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EchecPage(moyenne: moyenne)),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Vérification des résultats",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: "Année *",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              value: selectedAnnee,
              items:
                  annees.map((year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAnnee = value;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedExam,
              decoration: const InputDecoration(
                hintText: "Type d'examen *",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              items:
                  examTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedExam = value!;
                  selectedSerie = null;
                });
              },
            ),
            if (selectedExam == 'BAC') ...[
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedSerie,
                decoration: const InputDecoration(
                  hintText: "Série *",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items:
                    bacSeries.map((serie) {
                      return DropdownMenuItem(value: serie, child: Text(serie));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSerie = value!;
                  });
                },
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              controller: pvController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: "Numéro PV *",
                prefixIcon: Icon(Icons.confirmation_number),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.search, color: AppColors.text2),
                label: const Text(
                  "Rechercher",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.text2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: verifierResultat,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

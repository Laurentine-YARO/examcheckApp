import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examcheck_app/utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';

class JuryPage extends StatefulWidget {
  const JuryPage({super.key});

  @override
  State<JuryPage> createState() => _JuryPageState();
}

class _JuryPageState extends State<JuryPage> {
  bool isUploading = false;
  String status = '';
  String selectedLanguage = 'Français';
  bool isSettingsVisible = false;

  Future<void> importExcelResults() async {
    setState(() {
      isUploading = true;
      status = 'Importation en cours...';
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null && result.files.single.bytes != null) {
        Uint8List bytes = result.files.single.bytes!;
        final excel = Excel.decodeBytes(bytes);

        for (var table in excel.tables.keys) {
          final sheet = excel.tables[table]!;
          for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
            final row = sheet.row(rowIndex);

            String numPV = row[0]?.value.toString() ?? '';
            String nom = row[1]?.value.toString() ?? '';
            String prenom = row[2]?.value.toString() ?? '';
            String ville = row[3]?.value.toString() ?? '';
            String type = row[4]?.value.toString() ?? ''; // BAC / BEPC
            String annee = row[5]?.value.toString() ?? '';
            String serie = row[6]?.value.toString() ?? '';
            double moyenne =
                double.tryParse(row[7]?.value.toString() ?? '0') ?? 0;

            // Notes
            Map<String, double> notes = {
              'Français': double.tryParse(row[8]?.value.toString() ?? '0') ?? 0,
              'Maths': double.tryParse(row[9]?.value.toString() ?? '0') ?? 0,
              'Physique':
                  double.tryParse(row[10]?.value.toString() ?? '0') ?? 0,
              // Ajoute plus de matières si besoin
            };

            // Coefficients
            Map<String, int> coefs = {
              'Français': int.tryParse(row[11]?.value.toString() ?? '2') ?? 2,
              'Maths': int.tryParse(row[12]?.value.toString() ?? '3') ?? 3,
              'Physique': int.tryParse(row[13]?.value.toString() ?? '3') ?? 3,
            };

            await FirebaseFirestore.instance
                .collection('resultats')
                .doc(numPV)
                .set({
                  'numPv': numPV,
                  'nom': nom,
                  'prenom': prenom,
                  'ville': ville,
                  'type': type,
                  'annee': annee,
                  'serie': serie,
                  'moyenne': moyenne,
                  'secondTour': moyenne >= 8 && moyenne < 10,
                  'notes': notes,
                  'coefs': coefs,
                });
          }
        }

        setState(() {
          status = "Importation terminée avec succès ✅";
        });
      } else {
        setState(() {
          status = "Aucun fichier sélectionné.";
        });
      }
    } catch (e) {
      setState(() {
        status = "Erreur d'importation : $e";
      });
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Espace Jury"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.upload_file, color: AppColors.text),
                label: const Text(
                  'Importer Résultats (Excel)',
                  style: TextStyle(color: AppColors.text),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: isUploading ? null : importExcelResults,
              ),
            ),

            const SizedBox(height: 30),
            if (status.isNotEmpty)
              Text(
                status,
                style: TextStyle(
                  color: status.contains("Erreur") ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 40),
            if (isSettingsVisible)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Paramètres',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.language, color: AppColors.primary),
                          SizedBox(width: 10),
                          Text(
                            'Langue',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                      DropdownButton<String>(
                        value: selectedLanguage,
                        items:
                            ['Français', 'English']
                                .map(
                                  (lang) => DropdownMenuItem(
                                    value: lang,
                                    child: Text(lang),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLanguage = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isSettingsVisible = !isSettingsVisible;
          });
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}

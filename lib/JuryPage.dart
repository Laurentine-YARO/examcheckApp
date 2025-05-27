import 'package:examcheck_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
// bien importé

class JuryPage extends StatefulWidget {
  const JuryPage({super.key});

  @override
  State<JuryPage> createState() => _JuryPageState();
}

class _JuryPageState extends State<JuryPage> {
  bool notificationsEnabled = false;
  String selectedLanguage = 'Français';
  bool isSettingsVisible = false;
  List<Map<String, dynamic>> allResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      setState(() {
                        isSettingsVisible = !isSettingsVisible;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              const Center(
                child: Text(
                  'Admin Panel',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Importer fichier Excel
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
                  onPressed: () async {
                    //Navigator.push(
                    //context,
                    //MaterialPageRoute(builder: (_) => ViewAllResultsPage(allResults: allResults)),
                    //);

                    try {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['xlsx'],
                          );

                      if (result != null && result.files.single.bytes != null) {
                        final bytes = result.files.single.bytes!;
                        final excel = Excel.decodeBytes(bytes);

                        for (var table in excel.tables.keys) {
                          final sheet = excel.tables[table]!;
                          for (
                            int rowIndex = 1;
                            rowIndex < sheet.maxRows;
                            rowIndex++
                          ) {
                            final row = sheet.row(rowIndex);
                            final nom = row[0]?.value.toString() ?? '';
                            final prenom = row[1]?.value.toString() ?? '';
                            final numeroPV = row[2]?.value.toString() ?? '';
                            final ville = row[3]?.value.toString() ?? '';
                            final serie = row[4]?.value.toString() ?? '';
                            final moyenne =
                                double.tryParse(
                                  row[5]?.value.toString() ?? '0',
                                ) ??
                                0;

                            allResults.add({
                              'nom': nom,
                              'prenom': prenom,
                              'numeroPV': numeroPV,
                              'ville': ville,
                              'serie': serie,
                              'moyenne': moyenne,
                              'secondTour': moyenne >= 8 && moyenne < 10,
                              'notes': {
                                'Français':
                                    double.tryParse(
                                      row[7]?.value.toString() ?? '0',
                                    ) ??
                                    0,
                                'Maths':
                                    double.tryParse(
                                      row[8]?.value.toString() ?? '0',
                                    ) ??
                                    0,
                                'Physique':
                                    double.tryParse(
                                      row[9]?.value.toString() ?? '0',
                                    ) ??
                                    0,
                                // Ajoute plus de matières si tu veux...
                              },
                              'coefs': {
                                'Français':
                                    int.tryParse(
                                      row[10]?.value.toString() ?? '2',
                                    ) ??
                                    2,
                                'Maths':
                                    int.tryParse(
                                      row[11]?.value.toString() ?? '3',
                                    ) ??
                                    3,
                                'Physique':
                                    int.tryParse(
                                      row[12]?.value.toString() ?? '3',
                                    ) ??
                                    3,
                              },
                            });
                          }
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Importation réussie")),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Erreur d'importation: $e")),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Paramètres
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

                    //Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // children: [
                    // const Row(
                    //children: [
                    //Icon(Icons.notifications, color: AppColors.primary),
                    // SizedBox(width: 10),
                    // Text(
                    //  'Notifications',
                    // style: TextStyle(fontSize: 18, color: AppColors.text),
                    // ),
                    //],
                    // ),
                    //Switch(
                    //value: notificationsEnabled,
                    //onChanged: (bool value) {
                    // setState(() {
                    //  notificationsEnabled = value;
                    // });
                    // },
                    //// activeColor: AppColors.primary,
                    //  inactiveThumbColor: AppColors.text,
                    //  ),
                    //  ],
                    //),
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
                                    (value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (String? value) {
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
      ),
    );
  }
}

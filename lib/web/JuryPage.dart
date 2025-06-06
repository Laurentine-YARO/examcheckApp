import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examcheck_app/utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';

class JuryPage extends StatefulWidget {
  final Uint8List? excelFileBytes;
  final String? fileName;

  const JuryPage({super.key, this.excelFileBytes, this.fileName});

  @override
  State<JuryPage> createState() => _JuryPageState();
}

class _JuryPageState extends State<JuryPage> {
  bool isUploading = false;
  String status = '';
  String selectedLanguage = 'Français';
  bool isSettingsVisible = false;
  Excel? excel;

  Future<void> pickAndUploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final fileBytes = result.files.single.bytes!;
      final fileName = result.files.single.name;

      setState(() {
        excel = Excel.decodeBytes(fileBytes);
      });

      // Enregistrement sur Firebase Storage
      final storageRef = FirebaseStorage.instance.ref('resultats/$fileName');
      await storageRef.putData(fileBytes);

      // Lecture et enregistrement dans Firestore
      await saveExcelDataToFirestore(fileBytes);

      setState(() {
        status = "Fichier importé avec succès ✅";
      });
    } else {
      setState(() {
        status = "Aucun fichier sélectionné";
      });
    }
  }

  Future<void> saveExcelDataToFirestore(Uint8List fileBytes) async {
    final excel = Excel.decodeBytes(fileBytes);

    for (var table in excel.tables.keys) {
      final sheet = excel.tables[table];
      if (sheet == null || sheet.maxRows <= 1) return;

      final headers = sheet.rows[0].map((cell) => cell?.value?.toString() ?? '').toList();

      for (int i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        Map<String, dynamic> rowData = {};

        for (int j = 0; j < headers.length; j++) {
          final key = headers[j];
          final value = row.length > j ? row[j]?.value : null;
          rowData[key] = value;
        }

        final docId = rowData['numPv']?.toString() ?? FirebaseFirestore.instance.collection('resultats').doc().id;

        try {
          await FirebaseFirestore.instance.collection("resultats").doc(docId).set(rowData);
        } catch (e) {
          print("Erreur Firestore : $e");
        }
      }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (excel != null)
              ...excel!.tables.entries.map((table) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Feuille : ${table.key}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: table.value.rows.first.map((e) => DataColumn(label: Text(e?.value.toString() ?? ""))).toList(),
                        rows: table.value.rows.skip(1).map((row) {
                          return DataRow(
                            cells: row.map((cell) => DataCell(Text(cell?.value.toString() ?? ""))).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isUploading ? null : () async {
                  setState(() {
                    isUploading = true;
                    status = 'Importation en cours...';
                  });
                  await pickAndUploadFile();
                  setState(() => isUploading = false);
                },
                icon: const Icon(Icons.upload_file, color: AppColors.text),
                label: const Text('Importer Résultats (Excel)', style: TextStyle(color: AppColors.text)),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
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
                  const Text('Paramètres', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.text)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.language, color: AppColors.primary),
                          SizedBox(width: 10),
                          Text('Langue', style: TextStyle(fontSize: 18, color: AppColors.text)),
                        ],
                      ),
                      DropdownButton<String>(
                        value: selectedLanguage,
                        items: ['Français', 'English']
                            .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                            .toList(),
                        onChanged: (value) => setState(() => selectedLanguage = value!),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => isSettingsVisible = !isSettingsVisible),
        child: const Icon(Icons.settings),
      ),
    );
  }
}

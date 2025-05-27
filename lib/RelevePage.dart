import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

class RelevePage extends StatelessWidget {
  final StudentResult student;
  const RelevePage({super.key, required this.student});

  Future<void> generatePdf(StudentResult result) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("RELEVE DE NOTES DU BACCALAUREAT", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Nom : ${result.nom}"),
              pw.Text("Prénom : ${result.prenom}"),
              pw.Text("Numéro PV : ${result.numeroPV}"),
              pw.Text("Série : ${result.serie}"),
              pw.Text("Centre : ${result.ville}"),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Matière', 'Coef', 'Note'],
                data: result.notes.map((note) => [note.matiere, note.coef.toString(), note.note.toString()]).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Total : ${result.total}"),
              pw.Text("Moyenne : ${result.moyenne}/20"),
              pw.Text("Mention : ${result.mention}"),
              pw.Text("Décision : ${result.decision}"),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/releve_${result.numeroPV}.pdf");
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Télécharger Relevé")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Ajouté au cas où le contenu dépasse
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nom: ${student.nom}', style: const TextStyle(fontSize: 18)),
              Text('Prénom: ${student.prenom}', style: const TextStyle(fontSize: 18)),
              Text('Type d\'examen: BAC', style: const TextStyle(fontSize: 18)), // Remplacer si nécessaire
              Text('Série: ${student.serie}', style: const TextStyle(fontSize: 18)),
              Text('Numéro PV: ${student.numeroPV}', style: const TextStyle(fontSize: 18)),
              Text('Ville: ${student.ville}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              const Text('Notes :', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ...student.notes.map((note) => Text('${note.matiere} (Coef: ${note.coef}): ${note.note}')),
              const SizedBox(height: 20),
              Text('Moyenne: ${student.moyenne}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => generatePdf(student),
                  child: const Text("Télécharger mon relevé"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentResult {
  final String nom;
  final String prenom;
  final String numeroPV;
  final String serie;
  final String ville;
  final List<Note> notes;
  final int total;
  final double moyenne;
  final String mention;
  final String decision;

  StudentResult({
    required this.nom,
    required this.prenom,
    required this.numeroPV,
    required this.serie,
    required this.ville,
    required this.notes,
    required this.total,
    required this.moyenne,
    required this.mention,
    required this.decision,
  });
}

class Note {
  final String matiere;
  final int coef;
  final double note;

  Note({required this.matiere, required this.coef, required this.note});
}



class StudentResult {
  final String nom;
  final String prenom;
  final String numeroPV;
  final String ville;
  final String serie;
  final double moyenne;

  StudentResult({
    required this.nom,
    required this.prenom,
    required this.numeroPV,
    required this.ville,
    required this.serie,
    required this.moyenne,
  });

  // Méthode pour convertir en Map (utile plus tard pour stockage Firebase ou JSON)
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'numeroPV': numeroPV,
      'ville': ville,
      'serie': serie,
      'moyenne': moyenne,
    };
  }

  // Méthode pour créer un StudentResult à partir d'une Map
  factory StudentResult.fromMap(Map<String, dynamic> map) {
    return StudentResult(
      nom: map['nom'],
      prenom: map['prenom'],
      numeroPV: map['numeroPV'],
      ville: map['ville'],
      serie: map['serie'],
      moyenne: (map['moyenne'] as num).toDouble(),
    );
  }
}

class DatabaseService {
  // Singleton : une seule instance partagée
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Liste simulant la base de données
  final List<StudentResult> _results = [];

  // Ajouter un résultat
  void addResult(StudentResult result) {
    _results.add(result);
  }

  // Récupérer tous les résultats
  List<StudentResult> getAllResults() {
    return List.unmodifiable(_results); // lecture seule
  }

  // Supprimer tous les résultats
  void clearResults() {
    _results.clear();
  }

  // Rechercher un résultat par numéro PV
  StudentResult? findByNumeroPV(String numeroPV) {
    try {
      return _results.firstWhere((r) => r.numeroPV == numeroPV);
    } catch (e) {
      return null;
    }
  }
}

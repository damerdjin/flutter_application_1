class Transaction {
  final String titre;
  final double montant;
  final DateTime date;
  final bool estRevenu;
  final String description; // Ajout du champ description

  Transaction({
    required this.titre,
    required this.montant,
    required this.date,
    required this.estRevenu,
    required this.description,
  });
}
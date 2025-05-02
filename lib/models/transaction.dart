class Transaction {
  final String titre;
  final double montant;
  final DateTime date;
  final bool estRevenu;

  Transaction({
    required this.titre,
    required this.montant,
    required this.date,
    required this.estRevenu,
  });
}
class Mission {
  final String id;
  final String titre;
  final DateTime dateDebut;
  final DateTime dateFin;
  final String description;
  final double tjm;

  const Mission({
    required this.id,
    required this.titre,
    required this.dateDebut,
    required this.dateFin,
    required this.description,
    required this.tjm,
  });
}
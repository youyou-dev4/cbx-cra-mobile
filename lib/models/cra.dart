// Les états possibles d'un CRA selon les specs
enum CraStatus { draft, submitted, approved, rejected, invalidated }

// Les types possibles pour un jour
enum DayType { mission, absence, intercontrat, vide }

enum AbsenceType { conge, rtt, maladie }

class CraDay {
  final DateTime date;
  DayType type;
  AbsenceType? absenceType;

  CraDay({
    required this.date,
    this.type = DayType.vide,
    this.absenceType,
  });
}

class Cra {
  final String id;
  final String userId;
  final int mois;   // 1 = janvier
  final int annee;
  CraStatus status;
  final List<CraDay> jours;

  Cra({
    required this.id,
    required this.userId,
    required this.mois,
    required this.annee,
    this.status = CraStatus.draft,
    required this.jours,
  });

  // Règle métier : est-ce qu'on peut modifier ce CRA ?
  bool get estModifiable {
    if (status == CraStatus.approved) return false;
    if (status == CraStatus.rejected) return true;
    return true;
  }

  // Règle métier : peut-on soumettre ?
  bool get peutSoumettre {
    return status == CraStatus.draft || status == CraStatus.rejected;
  }
}
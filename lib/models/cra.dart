enum CraStatus { draft, submitted, approved, rejected, invalidated }

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
  final int mois;   
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

  bool get estModifiable {
    if (status == CraStatus.approved) return false;
    if (status == CraStatus.rejected) return true;
    return true;
  }

  bool get peutSoumettre {
    return status == CraStatus.draft || status == CraStatus.rejected;
  }
}
import 'package:flutter/material.dart';
import '../models/cra.dart';
import '../models/user.dart';
import '../models/mission.dart';
import '../data/mock_data.dart';

class CraProvider extends ChangeNotifier {
  // Données de l'utilisateur connecté
  User get user => mockUser;
  Mission get mission => mockMission;

  // CRA courant
  Cra _cra = mockCra;
  Cra get cra => _cra;

  // Changer le type d'un jour (ex: mission → absence)
  void setDayType(DateTime date, DayType type, {AbsenceType? absenceType}) {
    if (!_cra.estModifiable) return;

    final index = _cra.jours.indexWhere(
      (j) => j.date.year == date.year &&
             j.date.month == date.month &&
             j.date.day == date.day,
    );

    if (index != -1) {
      _cra.jours[index].type = type;
      _cra.jours[index].absenceType = absenceType;
      notifyListeners(); // Notifie les widgets pour rebuild
    }
  }

  // Remplir tout le mois en mission (bouton "Remplir le mois")
  void remplirToutLeMois() {
    if (!_cra.estModifiable) return;
    for (final jour in _cra.jours) {
      jour.type = DayType.mission;
      jour.absenceType = null;
    }
    notifyListeners();
  }

  // Soumettre le CRA
  void soumettreCra() {
    if (!_cra.peutSoumettre) return;
    _cra.status = CraStatus.submitted;
    notifyListeners();
  }

  // Couleur d'un jour selon son type
  Color couleurJour(DayType type) {
    switch (type) {
      case DayType.mission:
        return const Color(0xFFD4EDDA); // vert clair
      case DayType.absence:
        return const Color(0xFFFFF3CD); // jaune
      case DayType.intercontrat:
        return const Color(0xFFCCE5FF); // bleu clair
      case DayType.vide:
        return const Color(0xFFF0F0F0); // gris
    }
  }
}
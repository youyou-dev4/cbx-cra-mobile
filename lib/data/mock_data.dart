import '../models/user.dart';
import '../models/mission.dart';
import '../models/cra.dart';

// Utilisateur connecté (mock)
final mockUser = User(
  id: 'user_1',
  nom: 'Matoub',
  prenom: 'Prénom',
  email: 'matoub@cbx.com',
);

// Mission active (mock)
final mockMission = Mission(
  id: 'mission_1',
  titre: 'DevOps API',
  dateDebut: DateTime(2026, 1, 1),
  dateFin: DateTime(2026, 3, 31),
  description: 'Mission DevOps sur APIs internes',
  tjm: 450,
);

// Génère les jours ouvrés de janvier 2026
// Janvier 2026 : 21 jours de mission, 0 absence
List<CraDay> _genererJoursJanvier() {
  final jours = <CraDay>[];

  for (int i = 1; i <= 31; i++) {
    final date = DateTime(2026, 1, i);
    // On saute les weekends (samedi=6, dimanche=7)
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      continue;
    }
    jours.add(CraDay(date: date, type: DayType.mission));
  }

  return jours; // 21 jours ouvrés en janvier 2026
}

// CRA de janvier 2026
final mockCra = Cra(
  id: 'cra_jan_2026',
  userId: 'user_1',
  mois: 1,
  annee: 2026,
  status: CraStatus.draft,
  jours: _genererJoursJanvier(),
);
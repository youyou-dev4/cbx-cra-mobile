import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cra_provider.dart';
import '../models/cra.dart';

class AbsencesScreen extends StatelessWidget {
  const AbsencesScreen({super.key});

  String _labelAbsence(AbsenceType? type) {
    switch (type) {
      case AbsenceType.conge:   return 'Congé payé';
      case AbsenceType.rtt:     return 'RTT';
      case AbsenceType.maladie: return 'Maladie';
      case null:                return 'Absence';
    }
  }

  IconData _iconeAbsence(AbsenceType? type) {
    switch (type) {
      case AbsenceType.conge:   return Icons.beach_access;
      case AbsenceType.rtt:     return Icons.event_available;
      case AbsenceType.maladie: return Icons.local_hospital;
      case null:                return Icons.event_busy;
    }
  }

  Color _couleurAbsence(AbsenceType? type) {
    switch (type) {
      case AbsenceType.conge:   return Colors.blue;
      case AbsenceType.rtt:     return Colors.green;
      case AbsenceType.maladie: return Colors.red;
      case null:                return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CraProvider>();
    final cra = provider.cra;

    // Récupère uniquement les jours d'absence
    final absences = cra.jours
        .where((j) => j.type == DayType.absence)
        .toList();

    // Compte par type
    final nbConge = absences
        .where((j) => j.absenceType == AbsenceType.conge)
        .length;
    final nbRtt = absences
        .where((j) => j.absenceType == AbsenceType.rtt)
        .length;
    final nbMaladie = absences
        .where((j) => j.absenceType == AbsenceType.maladie)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absences — Janvier 2026'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Résumé compteurs
              Row(
                children: [
                  _carteCompteur(
                    context: context,
                    icone: Icons.beach_access,
                    label: 'Congés',
                    count: nbConge,
                    couleur: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _carteCompteur(
                    context: context,
                    icone: Icons.event_available,
                    label: 'RTT',
                    count: nbRtt,
                    couleur: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _carteCompteur(
                    context: context,
                    icone: Icons.local_hospital,
                    label: 'Maladie',
                    count: nbMaladie,
                    couleur: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Titre liste
              Text(
                absences.isEmpty
                    ? 'Aucune absence ce mois-ci'
                    : '${absences.length} absence(s) déclarée(s)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Liste des absences
              Expanded(
                child: absences.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 64,
                              color: Colors.green.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Aucune absence en janvier 2026',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: absences.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final jour = absences[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _couleurAbsence(jour.absenceType)
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Icon(
                                  _iconeAbsence(jour.absenceType),
                                  color: _couleurAbsence(jour.absenceType),
                                ),
                              ),
                              title: Text(
                                _labelAbsence(jour.absenceType),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${jour.date.day} janvier 2026',
                              ),
                              // Bouton supprimer l'absence
                              trailing: cra.estModifiable
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        provider.setDayType(
                                          jour.date,
                                          DayType.mission,
                                        );
                                      },
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
              ),

              // Bouton ajouter une absence
              if (cra.estModifiable)
                ElevatedButton.icon(
                  onPressed: () => context.go('/cra'),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter une absence'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Carte compteur en haut
  Widget _carteCompteur({
    required BuildContext context,
    required IconData icone,
    required String label,
    required int count,
    required Color couleur,
  }) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icone, color: couleur, size: 24),
              const SizedBox(height: 6),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: couleur,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
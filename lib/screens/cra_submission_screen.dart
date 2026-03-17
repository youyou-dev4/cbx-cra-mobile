import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cra_provider.dart';
import '../models/cra.dart';

class CraSubmissionScreen extends StatelessWidget {
  const CraSubmissionScreen({super.key});

  String _labelStatut(CraStatus status) {
    switch (status) {
      case CraStatus.draft:       return 'Brouillon';
      case CraStatus.submitted:   return 'Soumis';
      case CraStatus.approved:    return 'Validé';
      case CraStatus.rejected:    return 'Rejeté';
      case CraStatus.invalidated: return 'Invalidé';
    }
  }

  Color _couleurStatut(CraStatus status) {
    switch (status) {
      case CraStatus.draft:       return Colors.grey;
      case CraStatus.submitted:   return Colors.orange;
      case CraStatus.approved:    return Colors.green;
      case CraStatus.rejected:    return Colors.red;
      case CraStatus.invalidated: return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CraProvider>();
    final cra = provider.cra;

    // Compte les jours par type
    final nbMission = cra.jours
        .where((j) => j.type == DayType.mission)
        .length;
    final nbAbsence = cra.jours
        .where((j) => j.type == DayType.absence)
        .length;
    final nbVide = cra.jours
        .where((j) => j.type == DayType.vide)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Soumettre CRA'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              const Text(
                'Récapitulatif — Janvier 2026',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Badge statut actuel
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _couleurStatut(cra.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _labelStatut(cra.status),
                  style: TextStyle(
                    color: _couleurStatut(cra.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Résumé jours
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _ligneResume(
                        couleur: const Color(0xFFD4EDDA),
                        label: 'Jours mission',
                        valeur: '$nbMission jours',
                      ),
                      const Divider(height: 24),
                      _ligneResume(
                        couleur: const Color(0xFFFFF3CD),
                        label: 'Absences',
                        valeur: '$nbAbsence jours',
                      ),
                      const Divider(height: 24),
                      _ligneResume(
                        couleur: const Color(0xFFF0F0F0),
                        label: 'Jours non renseignés',
                        valeur: '$nbVide jours',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Alerte si jours vides
              if (nbVide > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning,
                          color: Colors.orange, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '$nbVide jour(s) non renseigné(s)',
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              // Bouton soumettre
              if (cra.peutSoumettre)
                ElevatedButton.icon(
                  onPressed: () => _confirmerSoumission(context, provider),
                  icon: const Icon(Icons.send),
                  label: const Text('Soumettre le CRA'),
                ),

              // Message si déjà soumis / validé
              if (!cra.peutSoumettre)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'CRA déjà soumis',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Ligne du résumé avec couleur + label + valeur
  Widget _ligneResume({
    required Color couleur,
    required String label,
    required String valeur,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: couleur,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 15)),
        ),
        Text(
          valeur,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  // Dialog de confirmation avant soumission
  void _confirmerSoumission(
    BuildContext context,
    CraProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmer la soumission'),
        content: const Text(
          'Une fois soumis, le CRA ne pourra plus être modifié '
          'jusqu\'à un éventuel rejet. Confirmer ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.soumettreCra();
              Navigator.pop(context);
              // Retour dashboard avec message de succès
              context.go('/dashboard');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('CRA soumis avec succès ✅'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cra_provider.dart';
import '../models/cra.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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

  IconData _iconeStatut(CraStatus status) {
    switch (status) {
      case CraStatus.draft:       return Icons.edit;
      case CraStatus.submitted:   return Icons.schedule;
      case CraStatus.approved:    return Icons.check_circle;
      case CraStatus.rejected:    return Icons.cancel;
      case CraStatus.invalidated: return Icons.block;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CraProvider>();
    final cra = provider.cra;

    // Historique mocké : on affiche plusieurs mois pour la démo
    final historique = [
      _HistoriqueItem(mois: 'Janvier 2026',  cra: cra),
      _HistoriqueItem(mois: 'Décembre 2025', statut: CraStatus.approved,  jours: 22),
      _HistoriqueItem(mois: 'Novembre 2025', statut: CraStatus.approved,  jours: 20),
      _HistoriqueItem(mois: 'Octobre 2025',  statut: CraStatus.rejected,  jours: 23),
      _HistoriqueItem(mois: 'Septembre 2025',statut: CraStatus.approved,  jours: 21),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique CRA'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: historique.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = historique[index];
            final statut = item.cra?.status ?? item.statut!;
            final nbJours = item.cra != null
                ? item.cra!.jours
                    .where((j) => j.type == DayType.mission)
                    .length
                : item.jours!;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                // Icône statut
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _couleurStatut(statut).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    _iconeStatut(statut),
                    color: _couleurStatut(statut),
                  ),
                ),
                // Mois + jours
                title: Text(
                  item.mois,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('$nbJours jours travaillés'),
                // Badge statut
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _couleurStatut(statut).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _labelStatut(statut),
                    style: TextStyle(
                      color: _couleurStatut(statut),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Classe helper pour l'historique mocké
class _HistoriqueItem {
  final String mois;
  final Cra? cra;
  final CraStatus? statut;
  final int? jours;

  _HistoriqueItem({
    required this.mois,
    this.cra,
    this.statut,
    this.jours,
  });
}
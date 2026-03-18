import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cra_provider.dart';
import '../models/cra.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Texte lisible pour le statut CRA
  String _labelStatut(CraStatus status) {
    switch (status) {
      case CraStatus.draft:       return 'Brouillon';
      case CraStatus.submitted:   return 'Soumis';
      case CraStatus.approved:    return 'Validé';
      case CraStatus.rejected:    return 'Rejeté';
      case CraStatus.invalidated: return 'Invalidé';
    }
  }

  // Couleur du badge statut
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
    final user = provider.user;
    final mission = provider.mission;
    final cra = provider.cra;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historique',
            onPressed: () => context.go('/history'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bonjour utilisateur
              Text(
                'Bonjour, ${user.prenom} 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Carte mission active
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mission active',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        mission.titre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mission.description,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Carte statut CRA
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CRA Janvier 2026',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
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
                        ],
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Bouton principal 
              ElevatedButton.icon(
                onPressed: () => context.go('/cra'),
                icon: const Icon(Icons.calendar_month),
                label: const Text('Saisir mon CRA'),
              ),
              const SizedBox(height: 12),

              // Bouton soumission
              OutlinedButton.icon(
                onPressed: () => context.go('/submission'),
                icon: const Icon(Icons.send),
                label: const Text('Soumettre mon CRA'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
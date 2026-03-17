import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cra_provider.dart';
import '../models/cra.dart';
import '../widgets/day_cell.dart';

class CraCalendarScreen extends StatelessWidget {
  const CraCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CraProvider>();
    final cra = provider.cra;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRA Janvier 2026'),
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
              // Mission active
              Text(
                'Mission active',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const Text(
                'DevOps API',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Légende couleurs
              Row(
                children: [
                  _legendeItem(const Color(0xFFD4EDDA), 'Mission'),
                  const SizedBox(width: 16),
                  _legendeItem(const Color(0xFFFFF3CD), 'Absence'),
                  const SizedBox(width: 16),
                  _legendeItem(const Color(0xFFF0F0F0), 'Vide'),
                ],
              ),
              const SizedBox(height: 20),

              // En-têtes jours de la semaine
              Row(
                children: ['L', 'M', 'M', 'J', 'V']
                    .map(
                      (j) => Expanded(
                        child: Center(
                          child: Text(
                            j,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),

              // Grille calendrier
              Expanded(
                child: _buildGrille(context, provider, cra),
              ),

              const SizedBox(height: 16),

              // Bouton remplir tout le mois
              if (cra.estModifiable)
                ElevatedButton.icon(
                  onPressed: () {
                    provider.remplirToutLeMois();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tous les jours remplis en mission ✅'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.flash_on),
                  label: const Text('Remplir le mois'),
                ),

              // Message si CRA non modifiable
              if (!cra.estModifiable)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock, color: Colors.orange, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'CRA non modifiable',
                        style: TextStyle(color: Colors.orange),
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

  // Construit la grille 5 colonnes (lundi → vendredi)
  Widget _buildGrille(
    BuildContext context,
    CraProvider provider,
    Cra cra,
  ) {
    // Janvier 2026 commence un jeudi (weekday = 4)
    // On calcule le décalage pour aligner sur lundi
    final premierJour = DateTime(2026, 1, 1);
    final decalage = premierJour.weekday - 1; // lundi=0, mardi=1...

    // On crée une liste de cellules avec des cases vides au début
    final cellules = <Widget>[];

    // Cases vides pour aligner le premier jour
    for (int i = 0; i < decalage; i++) {
      cellules.add(const SizedBox.shrink());
    }

    // Cases pour chaque jour ouvré
    for (final jour in cra.jours) {
      cellules.add(
        DayCell(
          jour: jour,
          estModifiable: cra.estModifiable,
          onTap: cra.estModifiable
              ? () => _showDayOptions(context, provider, jour)
              : null,
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 5,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      children: cellules,
    );
  }

  // Popup quand on appuie sur un jour
  void _showDayOptions(
    BuildContext context,
    CraProvider provider,
    CraDay jour,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jour du ${jour.date.day} janvier',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Option Mission
            ListTile(
              leading: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4EDDA),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              title: const Text('Mission'),
              onTap: () {
                provider.setDayType(jour.date, DayType.mission);
                Navigator.pop(context);
              },
            ),

            // Option Congé
            ListTile(
              leading: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              title: const Text('Congé'),
              onTap: () {
                provider.setDayType(
                  jour.date,
                  DayType.absence,
                  absenceType: AbsenceType.conge,
                );
                Navigator.pop(context);
              },
            ),

            // Option RTT
            ListTile(
              leading: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              title: const Text('RTT'),
              onTap: () {
                provider.setDayType(
                  jour.date,
                  DayType.absence,
                  absenceType: AbsenceType.rtt,
                );
                Navigator.pop(context);
              },
            ),

            // Option Maladie
            ListTile(
              leading: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              title: const Text('Maladie'),
              onTap: () {
                provider.setDayType(
                  jour.date,
                  DayType.absence,
                  absenceType: AbsenceType.maladie,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget légende en bas du calendrier
  Widget _legendeItem(Color couleur, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: couleur,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
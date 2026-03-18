import 'package:flutter/material.dart';
import '../models/cra.dart';

class DayCell extends StatelessWidget {
  final CraDay jour;
  final bool estModifiable;
  final VoidCallback? onTap;

  const DayCell({
    super.key,
    required this.jour,
    required this.estModifiable,
    this.onTap,
  });

  Color _couleur(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  switch (jour.type) {
    case DayType.mission:
      return isDark
          ? const Color(0xFF1B4332)  // vert foncé
          : const Color(0xFFD4EDDA); // vert clair
    case DayType.absence:
      return isDark
          ? const Color(0xFF3D2B00)  // jaune foncé
          : const Color(0xFFFFF3CD); // jaune clair
    case DayType.intercontrat:
      return isDark
          ? const Color(0xFF0D2A4A)  // bleu foncé
          : const Color(0xFFCCE5FF); // bleu clair
    case DayType.vide:
      return isDark
          ? const Color(0xFF2A2A2A)  // gris foncé
          : const Color(0xFFF0F0F0); // gris clair
  }
}

  String get _label {
    switch (jour.type) {
      case DayType.mission:     return 'M';
      case DayType.intercontrat: return 'IC';
      case DayType.vide:        return '';
      case DayType.absence:
        switch (jour.absenceType) {
          case AbsenceType.conge:   return 'CP';
          case AbsenceType.rtt:     return 'RTT';
          case AbsenceType.maladie: return 'MAL';
          case null:                return 'A';
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _couleur(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${jour.date.day}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            if (_label.isNotEmpty)
              Text(
                _label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[700],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
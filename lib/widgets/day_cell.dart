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

  Color get _couleur {
    switch (jour.type) {
      case DayType.mission:
        return const Color(0xFFD4EDDA);
      case DayType.absence:
        return const Color(0xFFFFF3CD);
      case DayType.intercontrat:
        return const Color(0xFFCCE5FF);
      case DayType.vide:
        return const Color(0xFFF0F0F0);
    }
  }

  // Initiales du type affiché dans la case
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
          color: _couleur,
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
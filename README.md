# CBX CRA Mobile

Application mobile de gestion des Comptes Rendus d'Activité (CRA) pour les consultants CBX.
Développée avec Flutter dans le cadre du test technique CBX Group.

---

## Aperçu

Application mobile permettant à un consultant de saisir, gérer et soumettre ses CRA mensuels.
Backend entièrement mocké, données de démonstration sur janvier 2026.

---

## Lancer le projet

### Prérequis
- Flutter SDK >= 3.0.0
- Android Studio ou VS Code
- Un émulateur Android/iOS ou un téléphone physique

### Installation
```bash
git clone https://github.com/youyou-dev4/cbx-cra-mobile.git
cd cbx-cra-mobile
flutter pub get
flutter run
```

### Compte de démonstration
Email : n'importe lequel
Mot de passe : n'importe lequel

---

## Architecture
```
lib/
├── main.dart              # Point d'entrée + thème (light/dark)
├── router.dart            # Navigation avec go_router
├── data/
│   └── mock_data.dart     # Données simulées (janvier 2026)
├── models/
│   ├── user.dart          # Modèle utilisateur
│   ├── mission.dart       # Modèle mission
│   └── cra.dart           # Modèle CRA + états + règles métier
├── providers/
│   └── cra_provider.dart  # Gestion d'état (Provider)
├── screens/
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   ├── cra_calendar_screen.dart
│   ├── absences_screen.dart
│   ├── cra_submission_screen.dart
│   └── history_screen.dart
└── widgets/
    └── day_cell.dart      # Cellule jour du calendrier
```

---

## Ecrans

| Ecran | Description |
|-------|-------------|
| Login | Authentification mock |
| Dashboard | Mission active + statut CRA du mois |
| CRA Calendrier | Vue mensuelle avec couleurs par type de jour |
| Absences | Liste et compteurs des absences du mois |
| Soumission | Recapitulatif + confirmation de soumission |
| Historique | Liste des CRA des mois precedents |

---

## Couleurs calendrier

| Couleur | Signification |
|---------|---------------|
| Vert | Jour de mission |
| Jaune | Absence (Conge / RTT / Maladie) |
| Gris | Jour non renseigne |

---

## Regles metier implementees

- Fenetre CRA : du 22 au 28 du mois (Europe/Paris)
- Etats CRA : DRAFT -> SUBMITTED -> APPROVED / REJECTED / INVALIDATED
- CRA valide : non modifiable
- CRA rejete : redevient modifiable
- Hors fenetre : non modifiable si statut DRAFT
- Remplissage rapide : bouton "Remplir le mois" en 1 clic
- Saisie jour par jour : tap sur chaque case
- Absences : Conge / RTT / Maladie

---

## Donnees de demonstration

- Mois : Janvier 2026
- Mission active : DevOps API
- Jours travailles : 21 jours
- Absences : 0

---

## Stack technique

| Technologie | Usage |
|-------------|-------|
| Flutter 3 | Framework mobile |
| Provider | Gestion d'etat |
| go_router | Navigation |
| Material 3 | Design system |

---

## Bonus implementes

- Dark mode : suit automatiquement le theme du telephone



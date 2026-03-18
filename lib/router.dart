import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/cra_calendar_screen.dart';
import 'screens/cra_submission_screen.dart';
import 'screens/history_screen.dart';
import 'screens/absences_screen.dart'; 

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login',      builder: (ctx, state) => const LoginScreen()),
    GoRoute(path: '/dashboard',  builder: (ctx, state) => const DashboardScreen()),
    GoRoute(path: '/cra',        builder: (ctx, state) => const CraCalendarScreen()),
    GoRoute(path: '/submission', builder: (ctx, state) => const CraSubmissionScreen()),
    GoRoute(path: '/history',    builder: (ctx, state) => const HistoryScreen()),
    GoRoute(path: '/absences',   builder: (ctx, state) => const AbsencesScreen()), 
  ],
);
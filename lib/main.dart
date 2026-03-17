import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cra_provider.dart';
import 'router.dart';

void main() {
  runApp(const CbxApp());
}

class CbxApp extends StatelessWidget {
  const CbxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CraProvider(),
      child: MaterialApp.router(
        title: 'CBX CRA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A56DB), // bleu CBX
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A56DB),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A56DB),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
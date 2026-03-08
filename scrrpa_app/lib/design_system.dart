import 'package:flutter/material.dart';

class SCRRAColors {
  static const Color primary = Color(0xFFEC5B13);
  static const Color navy = Color(0xFF1E3A5F);
  static const Color background = Color(0xFFF8F6F6);
  static const Color darkBg = Color(0xFF0F172A);
  static const Color slate400 = Color(0xFF94A3B8);
}

class SCRRATheme {
  static ThemeData get light => ThemeData(
    primaryColor: SCRRAColors.primary,
    scaffoldBackgroundColor: SCRRAColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: SCRRAColors.navy,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: SCRRAColors.navy, fontWeight: FontWeight.bold, fontSize: 18),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: elevatedButtonFromStyle(),
    ),
  );

  static ButtonStyle elevatedButtonFromStyle() => ElevatedButton.styleFrom(
    backgroundColor: SCRRAColors.primary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    padding: const EdgeInsets.symmetric(vertical: 16),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
}

class SCRRAScreenWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final bool showAppBar;

  const SCRRAScreenWrapper({
    super.key, 
    required this.title, 
    required this.child, 
    this.actions, 
    this.bottomNavigationBar,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar(
        title: Text(title),
        actions: actions,
      ) : null,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

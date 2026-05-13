import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF00d4aa);
  static const Color primaryLight = Color(0xFF00f0c0);
  static const Color primaryDark = Color(0xFF00a886);
  
  // Background
  static const Color bgPrimary = Color(0xFF0a0f1c);
  static const Color bgSecondary = Color(0xFF111827);
  static const Color bgCard = Color(0xFF1a2236);
  static const Color bgInput = Color(0xFF1e2a45);
  
  // Text
  static const Color textPrimary = Color(0xFFf1f5f9);
  static const Color textSecondary = Color(0xFF94a3b8);
  static const Color textMuted = Color(0xFF64748b);
  
  // Accent
  static const Color accent = Color(0xFF00d4aa);
  static const Color purple = Color(0xFFa78bfa);
  static const Color purpleLight = Color(0xFFc4b5fd);
  static const Color orange = Color(0xFFfb923c);
  static const Color blue = Color(0xFF60a5fa);
  static const Color pink = Color(0xFFf472b6);
  static const Color yellow = Color(0xFFfbbf24);
  
  // Status
  static const Color success = Color(0xFF22c55e);
  static const Color warning = Color(0xFFf59e0b);
  static const Color error = Color(0xFFef4444);
  static const Color info = Color(0xFF3b82f6);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [purple, purpleLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [orange, pink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient oceanGradient = LinearGradient(
    colors: [blue, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light theme colors
  static const Color lightBgPrimary = Color(0xFFf8fafc);
  static const Color lightBgSecondary = Color(0xFFf1f5f9);
  static const Color lightBgCard = Color(0xFFffffff);
  static const Color lightTextPrimary = Color(0xFF0f172a);
  static const Color lightTextSecondary = Color(0xFF475569);
}

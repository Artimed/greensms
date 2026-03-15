import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Цвета бренда приложения — в тон QR-баннеру.
class AppColors {
  AppColors._();

  /// Основной зелёный (светлый, баннер-правый конец)
  static const green = Color(0xFF2BBF69);

  /// Тёмный зелёный (баннер-левый конец)
  static const greenDark = Color(0xFF1F8C4C);

  /// Градиент кнопок и баннеров
  static const gradient = LinearGradient(
    colors: [greenDark, green],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Градиент диагональный (для карточек)
  static const gradientDiag = LinearGradient(
    colors: [greenDark, green],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  AppTheme._();

  static const double actionButtonHeight = 44;
  static const double actionButtonRadius = 14;

  // Seed = яркий зелёный баннера, чтобы primary совпадал с кнопками
  static const _seed = AppColors.green;

  static ThemeData get light {
    final cs = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ).copyWith(primary: AppColors.green, onPrimary: Colors.white);
    return _base(cs).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: cs.surface,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final cs = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ).copyWith(primary: AppColors.green, onPrimary: Colors.white);
    return _base(cs).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: cs.surface,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
    );
  }

  static ThemeData _base(ColorScheme cs) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      // Карточки без жёсткой тени
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        color: cs.surfaceContainerLow,
      ),
      // Outline-поля ввода
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(actionButtonRadius),
        ),
        filled: true,
        fillColor: cs.surfaceContainerLow,
      ),
      // FilledButton — заполненный основным цветом (диалоги, вторичные действия)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, actionButtonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(actionButtonRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, actionButtonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(actionButtonRadius),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.green;
          }
          return null;
        }),
      ),
    );
  }
}

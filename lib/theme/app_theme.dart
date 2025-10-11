import 'package:flutter/material.dart';

class AppTheme {
  // Cores românticas
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color lightPink = Color(0xFFF8BBD9);
  static const Color softPink = Color(0xFFFCE4EC);
  static const Color lavender = Color(0xFFE1BEE7);
  static const Color lightLavender = Color(0xFFF3E5F5);
  static const Color lightBlue = Color(0xFFB3E5FC);
  static const Color softBlue = Color(0xFFE3F2FD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);

  // Gradientes românticos
  static const LinearGradient romanticGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightPink, lavender, lightBlue],
  );

  static const LinearGradient heartGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryPink, lightPink],
  );

  // Tema claro romântico
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPink,
        brightness: Brightness.light,
        primary: primaryPink,
        secondary: lavender,
        surface: white,
        background: softPink,
        error: Colors.red.shade400,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: textDark,
          fontFamily: 'Roboto',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w300,
          color: textDark,
          fontFamily: 'Roboto',
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: textDark,
          fontFamily: 'Roboto',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: textDark,
          fontFamily: 'Roboto',
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textDark,
          fontFamily: 'Roboto',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textDark,
          fontFamily: 'Roboto',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textLight,
          fontFamily: 'Roboto',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: white,
          elevation: 4,
          shadowColor: primaryPink.withAlpha(3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
      cardTheme: CardTheme(
        color: white,
        elevation: 8,
        shadowColor: primaryPink.withAlpha(2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
        iconTheme: IconThemeData(color: primaryPink),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: lightPink, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: lightPink, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primaryPink, width: 2),
        ),
        labelStyle: const TextStyle(color: textLight),
        hintStyle: const TextStyle(color: textLight),
      ),
    );
  }

  // Frases carinhosas
  static const List<String> romanticPhrases = [
    "Cuidar de você é meu maior gesto de amor 💖",
    "Sua hidratação é minha prioridade 💧❤️",
    "Cada gota de água é um ato de amor próprio 🌸",
    "Você merece todo cuidado do mundo 💕",
    "Beber água é cuidar do seu coração 💗",
    "Sua saúde é meu maior tesouro 💎",
    "Cada gole é um passo para o seu bem-estar ✨",
    "Você é especial e merece todo cuidado 🌹",
    "Hidratar-se é um ato de amor 💝",
    "Seu bem-estar é minha felicidade 💖",
  ];

  // Mensagens de notificação
  static const List<String> notificationMessages = [
    "Amor, hora de se hidratar 💧❤️",
    "Que tal uma pausa para beber água? 💕",
    "Seu corpo precisa de hidratação, meu amor 💖",
    "Hora de cuidar de você mesmo 💧✨",
    "Uma pausa romântica para beber água 💕",
    "Seu bem-estar é importante para mim 💗",
    "Vamos nos hidratar juntos? 💧❤️",
    "Cada gota é um gesto de amor próprio 💝",
    "Hora de nutrir seu corpo com amor 💖",
    "Sua saúde é minha prioridade 💕",
  ];
}


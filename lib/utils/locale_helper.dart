import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class LocaleHelper {
  static Future<void> initialize() async {
    // Inicializar localização para português brasileiro
    await initializeDateFormatting('pt_BR', null);
  }
  
  static Locale getDefaultLocale() {
    return const Locale('pt', 'BR');
  }
}



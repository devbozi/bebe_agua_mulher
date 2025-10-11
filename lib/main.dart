import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'utils/locale_helper.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar localização
  await LocaleHelper.initialize();
  
  // Inicializar serviços
  await NotificationService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bebe Água Mulher 💕',
      theme: AppTheme.lightTheme,
      locale: LocaleHelper.getDefaultLocale(),
      home: const AppInitializer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Verificar se é a primeira vez
      final isFirstTime = await StorageService.isFirstTime();
      
      // Carregar configurações e agendar notificações
      final settings = await StorageService.getSettings();
      await NotificationService.scheduleReminders(settings);
      
      setState(() {
        _isFirstTime = isFirstTime;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.romanticGradient,
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppTheme.primaryPink,
                ),
                SizedBox(height: 24),
                Text(
                  'Preparando tudo com amor... 💕',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _isFirstTime ? const WelcomeScreen() : const HomeScreen();
  }
}
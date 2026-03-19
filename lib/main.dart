// ═══════════════════════════════════════════════════════════════════════════
// Clean Truck App - Главный файл приложения
// Описание: Это образовательная игра для детей о сортировке отходов
// Автор: Студент
// Дата: 2024
// ═══════════════════════════════════════════════════════════════════════════

// Стандартные импорты Flutter
import 'package:flutter/material.dart';

// Импорт локальных моделей и сервисов
import 'models/game_data.dart';
import 'services/storage_service.dart';

// Импорт экранов приложения
import 'screens/intro_screen.dart';
import 'screens/hub_screen.dart';
import 'screens/gameplay_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/truck_customizer_screen.dart';
import 'screens/eco_quiz_screen.dart';
import 'screens/speed_challenge_screen.dart';
import 'screens/memory_match_screen.dart';

/// Точка входа в приложение
/// Используется async/await для инициализации хранилища перед запуском приложения
void main() async {
  //.ensureInitialized() гарантирует, что Flutter инициализирован
  // перед выполнением любого асинхронного кода
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация сервиса хранения данных (Hive)
  await StorageService.init();
  
  // Запуск приложения
  runApp(const CleanTruckApp());
}

/// Основной виджет приложения
/// Использует Material Design 3 с зеленой экологической темой
class CleanTruckApp extends StatelessWidget {
  const CleanTruckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Truck', // Название приложения
      debugShowCheckedModeBanner: false, // Скрыть баннер режима отладки
      theme: ThemeData(
        // Создание цветовой схемы на основе зеленого цвета (экология)
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10b981)),
        useMaterial3: true, // Использовать Material Design 3
        fontFamily: 'sans-serif', // Шрифт по умолчанию
      ),
      home: const AppRoot(), // Корневой виджет управления состоянием
    );
  }
}

/// Перечисление всех возможных экранов приложения
/// Используется для навигации между экранами
enum GameScreen {
  intro,          // Экран введения/заставка
  hub,            // Главное меню/хаб
  playing,        // Игра по сортировке отходов
  speedChallenge, // Мини-игра на скорость
  memoryMatch,    // Мини-игра на память
  quiz,           // Экович-викторина
  customize,      // Настройка грузовика
  stats,          // Статистика и достижения
}

/// Главный виджет управления состоянием приложения
/// Отвечает за навигацию между экранами и хранение глобального состояния
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  // Текущий активный экран (по умолчанию - экран введения)
  GameScreen _screen = GameScreen.intro;
  
  // Текущая локация в игре (park, city, forest)
  String _location = 'park';
  
  // Цвет грузовика (по умолчанию зеленый)
  String _truckColor = 'green';
  
  // Список выбранных стикеров для грузовика
  List<String> _truckStickers = [];
  
  // Статистика игрока
  PlayerStats _stats = PlayerStats();

  @override
  void initState() {
    super.initState();
    // Загрузка сохраненных данных при инициализации
    _loadData();
  }

  /// Загрузка сохраненных данных из локального хранилища
  /// Вызывается при запуске приложения
  Future<void> _loadData() async {
    final stats = StorageService.loadStats();
    final color = StorageService.loadTruckColor();
    final stickers = StorageService.loadTruckStickers();
    
    setState(() {
      _stats = stats;
      _truckColor = color;
      _truckStickers = stickers;
    });
  }

  /// Сохранение статистики игрока
  Future<void> _saveStats() async {
    await StorageService.saveStats(_stats);
  }

  /// Сохранение настроек грузовика (цвет и стикеры)
  Future<void> _saveTruckSettings() async {
    await StorageService.saveTruckColor(_truckColor);
    await StorageService.saveTruckStickers(_truckStickers);
  }

  /// Переход на указанный экран
  void _goTo(GameScreen s) => setState(() => _screen = s);

  /// Обработка завершения игры по сортировке отходов
  /// Обновляет статистику игрока
  void _handleGameComplete(int score, int sorted, int accuracy) {
    setState(() {
      final prev = _stats;
      
      // Проверка, завершена ли уже эта локация
      final locations = prev.locationsCompleted.contains(_location)
          ? prev.locationsCompleted
          : [...prev.locationsCompleted, _location];
      
      // Обновление статистики с новыми значениями
      _stats = prev.copyWith(
        totalScore: prev.totalScore + score,
        totalItemsSorted: prev.totalItemsSorted + sorted,
        accuracy: ((prev.accuracy + accuracy) / 2).round(),
        locationsCompleted: locations,
        gamesPlayed: prev.gamesPlayed + 1,
        // Начисление бонуса за идеальную игру (100% точность)
        perfectRounds: accuracy == 100 ? prev.perfectRounds + 1 : prev.perfectRounds,
      );
      
      // Возврат в главное меню
      _screen = GameScreen.hub;
    });
    _saveStats();
  }

  /// Обработка завершения игры "Скоростной вызов"
  void _handleSpeedComplete(int score) {
    setState(() {
      final prev = _stats;
      _stats = prev.copyWith(
        totalScore: prev.totalScore + score,
        gamesPlayed: prev.gamesPlayed + 1,
        // Обновление рекорда, если текущий счет выше
        bestSpeedScore: score > prev.bestSpeedScore ? score : prev.bestSpeedScore,
      );
      _screen = GameScreen.hub;
    });
    _saveStats();
  }

  /// Обработка завершения игры "Найди пару"
  void _handleMemoryComplete(int score) {
    setState(() {
      final prev = _stats;
      _stats = prev.copyWith(
        totalScore: prev.totalScore + score,
        gamesPlayed: prev.gamesPlayed + 1,
      );
      _screen = GameScreen.hub;
    });
    _saveStats();
  }

  /// Обработка завершения викторины
  void _handleQuizComplete(int score) {
    setState(() {
      final prev = _stats;
      _stats = prev.copyWith(
        totalScore: prev.totalScore + score,
        gamesPlayed: prev.gamesPlayed + 1,
        // Обновление рекорда по викторине
        bestQuizScore: score > prev.bestQuizScore ? score : prev.bestQuizScore,
      );
      _screen = GameScreen.hub;
    });
    _saveStats();
  }

  /// Переключение стикера на грузовике
  /// Добавляет или удаляет стикер из списка
  void _toggleSticker(String sid) {
    setState(() {
      if (_truckStickers.contains(sid)) {
        _truckStickers = _truckStickers.where((s) => s != sid).toList();
      } else {
        _truckStickers = [..._truckStickers, sid];
      }
    });
    _saveTruckSettings();
  }

  @override
  Widget build(BuildContext context) {
    // Маршрутизация на основе текущего экрана
    switch (_screen) {
      case GameScreen.intro:
        return IntroScreen(onDone: () => _goTo(GameScreen.hub));

      case GameScreen.hub:
        return HubScreen(
          stats: _stats,
          truckColor: _truckColor,
          truckStickers: _truckStickers,
          onLocation: (loc) {
            setState(() {
              _location = loc;
              _screen = GameScreen.playing;
            });
          },
          onScreen: (s) => _goTo(s),
        );

      case GameScreen.playing:
        return GamePlayScreen(
          location: _location,
          onBack: () => _goTo(GameScreen.hub),
          onComplete: _handleGameComplete,
        );

      case GameScreen.speedChallenge:
        return SpeedChallengeScreen(
          onBack: () => _goTo(GameScreen.hub),
          onComplete: _handleSpeedComplete,
        );

      case GameScreen.memoryMatch:
        return MemoryMatchScreen(
          onBack: () => _goTo(GameScreen.hub),
          onComplete: _handleMemoryComplete,
        );

      case GameScreen.quiz:
        return EcoQuizScreen(
          onBack: () => _goTo(GameScreen.hub),
          onComplete: _handleQuizComplete,
        );

      case GameScreen.customize:
        return TruckCustomizerScreen(
          truckColor: _truckColor,
          truckStickers: _truckStickers,
          onColor: (c) {
            setState(() => _truckColor = c);
            _saveTruckSettings();
          },
          onSticker: _toggleSticker,
          onBack: () => _goTo(GameScreen.hub),
        );

      case GameScreen.stats:
        return StatsScreen(
          stats: _stats,
          onBack: () => _goTo(GameScreen.hub),
        );
    }
  }
}

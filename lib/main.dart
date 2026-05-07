// ═══════════════════════════════════════════════════════════════════════════
// Clean Truck App - Главный файл приложения
// Описание: Это образовательная игра для детей о сортировке отходов
// Автор: Студент
// Дата: 2024
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'models/game_data.dart';
import 'services/storage_service.dart';
import 'core/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const CleanTruckApp());
}

class CleanTruckApp extends StatelessWidget {
  const CleanTruckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Truck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10b981)),
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  GameScreen _screen = GameScreen.intro;
  String _location = 'park';
  String _truckColor = 'green';
  List<String> _truckStickers = [];
  PlayerStats _stats = PlayerStats();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

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

  Future<void> _saveStats() async {
    await StorageService.saveStats(_stats);
  }

  Future<void> _saveTruckSettings() async {
    await StorageService.saveTruckColor(_truckColor);
    await StorageService.saveTruckStickers(_truckStickers);
  }

  void _goTo(GameScreen s) => setState(() => _screen = s);

  void _handleGameComplete(int score, int sorted, int accuracy) {
    setState(() {
      final prev = _stats;
      final locations = prev.locationsCompleted.contains(_location)
          ? prev.locationsCompleted
          : [...prev.locationsCompleted, _location];
      _stats = prev.copyWith(
        totalScore: prev.totalScore + score,
        totalItemsSorted: prev.totalItemsSorted + sorted,
        accuracy: ((prev.accuracy + accuracy) / 2).round(),
        locationsCompleted: locations,
        gamesPlayed: prev.gamesPlayed + 1,
        perfectRounds: accuracy == 100 ? prev.perfectRounds + 1 : prev.perfectRounds,
      );
      _screen = GameScreen.hub;
    });
    _saveStats();
  }

  void _handleSpeedComplete(int score) {
    setState(() {
      final prev = _stats;
      _stats = prev.copyWith(
        totalScore: prev.totalScore + score,
        gamesPlayed: prev.gamesPlayed + 1,
        bestSpeedScore: score > prev.bestSpeedScore ? score : prev.bestSpeedScore,
      );
      _screen = GameScreen.hub;
    });
    _saveStats();
  }

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

  void _handleQuizComplete(int score) {
    setState(() {
      final prev = _stats;
      _stats = prev.copyWith(
        totalScore: prev.totalScore + score,
        gamesPlayed: prev.gamesPlayed + 1,
        bestQuizScore: score > prev.bestQuizScore ? score : prev.bestQuizScore,
      );
      _screen = GameScreen.hub;
    });
    _saveStats();
  }

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
    return AppRouter(
      screen: _screen,
      location: _location,
      truckColor: _truckColor,
      truckStickers: _truckStickers,
      stats: _stats,
      onNavigate: _goTo,
      onLocationSelect: (loc) {
        setState(() {
          _location = loc;
          _screen = GameScreen.playing;
        });
      },
      onColorSelect: (c) {
        setState(() => _truckColor = c);
        _saveTruckSettings();
      },
      onStickerToggle: _toggleSticker,
      onGameComplete: _handleGameComplete,
      onSpeedComplete: _handleSpeedComplete,
      onMemoryComplete: _handleMemoryComplete,
      onQuizComplete: _handleQuizComplete,
    ).buildScreen();
  }
}
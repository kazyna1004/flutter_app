// ═══════════════════════════════════════════════════════════════════════════
// App Router - Маршрутизация приложения
// Описание: Содержит логику навигации и управления состоянием приложения
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/game_data.dart';
import '../screens/intro_screen.dart';
import '../screens/hub_screen.dart';
import '../screens/gameplay_screen.dart';
import '../screens/speed_challenge_screen.dart';
import '../screens/memory_match_screen.dart';
import '../screens/eco_quiz_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/truck_customizer_screen.dart';

/// Перечисление всех возможных экранов приложения
enum GameScreen {
  intro,
  hub,
  playing,
  speedChallenge,
  memoryMatch,
  quiz,
  customize,
  stats,
}

/// Маршрутизатор приложения
class AppRouter {
  final GameScreen screen;
  final String location;
  final String truckColor;
  final List<String> truckStickers;
  final PlayerStats stats;
  final void Function(GameScreen) onNavigate;
  final void Function(String) onLocationSelect;
  final void Function(String) onColorSelect;
  final void Function(String) onStickerToggle;
  final void Function(int, int, int) onGameComplete;
  final void Function(int) onSpeedComplete;
  final void Function(int) onMemoryComplete;
  final void Function(int) onQuizComplete;

  const AppRouter({
    required this.screen,
    required this.location,
    required this.truckColor,
    required this.truckStickers,
    required this.stats,
    required this.onNavigate,
    required this.onLocationSelect,
    required this.onColorSelect,
    required this.onStickerToggle,
    required this.onGameComplete,
    required this.onSpeedComplete,
    required this.onMemoryComplete,
    required this.onQuizComplete,
  });

  /// Построение виджета экрана
  Widget buildScreen() {
    switch (screen) {
      case GameScreen.intro:
        return IntroScreen(onDone: () => onNavigate(GameScreen.hub));

      case GameScreen.hub:
        return HubScreen(
          stats: stats,
          truckColor: truckColor,
          truckStickers: truckStickers,
          onLocation: onLocationSelect,
          onScreen: onNavigate,
        );

      case GameScreen.playing:
        return GamePlayScreen(
          location: location,
          onBack: () => onNavigate(GameScreen.hub),
          onComplete: onGameComplete,
        );

      case GameScreen.speedChallenge:
        return SpeedChallengeScreen(
          onBack: () => onNavigate(GameScreen.hub),
          onComplete: onSpeedComplete,
        );

      case GameScreen.memoryMatch:
        return MemoryMatchScreen(
          onBack: () => onNavigate(GameScreen.hub),
          onComplete: onMemoryComplete,
        );

      case GameScreen.quiz:
        return EcoQuizScreen(
          onBack: () => onNavigate(GameScreen.hub),
          onComplete: onQuizComplete,
        );

      case GameScreen.customize:
        return TruckCustomizerScreen(
          truckColor: truckColor,
          truckStickers: truckStickers,
          onColor: onColorSelect,
          onSticker: onStickerToggle,
          onBack: () => onNavigate(GameScreen.hub),
        );

      case GameScreen.stats:
        return StatsScreen(
          stats: stats,
          onBack: () => onNavigate(GameScreen.hub),
        );
    }
  }
}
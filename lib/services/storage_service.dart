// ═══════════════════════════════════════════════════════════════════════════
// Storage Service - Сервис локального хранилища
// Описание: Управляет сохранением и загрузкой данных игрока с помощью Hive
// Примечание: Hive - это легкая и быстрая база данных NoSQL для Flutter
// ═══════════════════════════════════════════════════════════════════════════

// Импорт пакета Hive для локального хранения данных
import 'package:hive_flutter/hive_flutter.dart';
import '../models/game_data.dart';

/// Сервис для работы с локальным хранилищем данных
/// Статические методы для простоты использования
class StorageService {
  // Имена боксов (контейнеров данных) в Hive
  static const String _statsBoxName = 'player_stats';
  static const String _truckBoxName = 'truck_settings';
  
  // Ключи для хранения данных
  static const String _statsKey = 'stats';
  static const String _truckColorKey = 'color';
  static const String _truckStickersKey = 'stickers';

  /// Инициализация Hive и открытие боксов
  /// Вызывается один раз при запуске приложения
  static Future<void> init() async {
    // Инициализация Flutter плагина Hive
    await Hive.initFlutter();
    // Открытие боксов для хранения данных
    await Hive.openBox(_statsBoxName);
    await Hive.openBox(_truckBoxName);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Методы для работы со статистикой игрока
  // ═══════════════════════════════════════════════════════════════════════════

  /// Загрузка статистики игрока из хранилища
  /// Возвращает объект PlayerStats с данными или новый объект по умолчанию
  static PlayerStats loadStats() {
    final box = Hive.box(_statsBoxName);
    final data = box.get(_statsKey);
    if (data != null) {
      return _statsFromMap(Map<String, dynamic>.from(data));
    }
    // Возврат статистики по умолчанию, если данных нет
    return PlayerStats();
  }

  /// Сохранение статистики игрока в хранилище
  static Future<void> saveStats(PlayerStats stats) async {
    final box = Hive.box(_statsBoxName);
    await box.put(_statsKey, _statsToMap(stats));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Методы для работы с настройками грузовика
  // ═══════════════════════════════════════════════════════════════════════════

  /// Загрузка цвета грузовика из хранилища
  /// По умолчанию возвращает 'green'
  static String loadTruckColor() {
    final box = Hive.box(_truckBoxName);
    return box.get(_truckColorKey, defaultValue: 'green');
  }

  /// Сохранение цвета грузовика
  static Future<void> saveTruckColor(String color) async {
    final box = Hive.box(_truckBoxName);
    await box.put(_truckColorKey, color);
  }

  /// Загрузка списка стикеров грузовика
  /// По умолчанию возвращает пустой список
  static List<String> loadTruckStickers() {
    final box = Hive.box(_truckBoxName);
    final List<dynamic> stickers = box.get(_truckStickersKey, defaultValue: []);
    return stickers.cast<String>();
  }

  /// Сохранение списка стикеров грузовика
  static Future<void> saveTruckStickers(List<String> stickers) async {
    final box = Hive.box(_truckBoxName);
    await box.put(_truckStickersKey, stickers);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Вспомогательные методы для сериализации данных
  // ═══════════════════════════════════════════════════════════════════════════

  /// Преобразование объекта PlayerStats в Map для сохранения
  /// Используется для сериализации данных перед записью в Hive
  static Map<String, dynamic> _statsToMap(PlayerStats stats) {
    return {
      'totalScore': stats.totalScore,
      'totalItemsSorted': stats.totalItemsSorted,
      'accuracy': stats.accuracy,
      'locationsCompleted': stats.locationsCompleted,
      'gamesPlayed': stats.gamesPlayed,
      'bestSpeedScore': stats.bestSpeedScore,
      'bestQuizScore': stats.bestQuizScore,
      'perfectRounds': stats.perfectRounds,
    };
  }

  /// Восстановление объекта PlayerStats из Map
  /// Используется для десериализации данных после загрузки из Hive
  /// Примечание: Используются значения по умолчанию для обратной совместимости
  static PlayerStats _statsFromMap(Map<String, dynamic> map) {
    return PlayerStats(
      totalScore: map['totalScore'] ?? 0,
      totalItemsSorted: map['totalItemsSorted'] ?? 0,
      accuracy: map['accuracy'] ?? 100,
      locationsCompleted: List<String>.from(map['locationsCompleted'] ?? []),
      gamesPlayed: map['gamesPlayed'] ?? 0,
      bestSpeedScore: map['bestSpeedScore'] ?? 0,
      bestQuizScore: map['bestQuizScore'] ?? 0,
      perfectRounds: map['perfectRounds'] ?? 0,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Truck Widget - Виджет грузовика
// Описание: Визуальный компонент грузовика с возможностью кастомизации
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/game_data.dart';

/// Виджет для отображения грузовика
/// Показывает цветной грузовик с выбранными стикерами
/// Используется на экране кастомизации и в главном меню
class TruckWidget extends StatelessWidget {
  final String colorId;         // ID выбранного цвета
  final List<String> stickerIds; // Список ID выбранных стикеров
  final double scale;          // Масштаб отображения

  const TruckWidget({
    super.key,
    required this.colorId,
    required this.stickerIds,
    this.scale = 1.0, // Масштаб 1.0 по умолчанию
  });

  @override
  Widget build(BuildContext context) {
    // Поиск цвета грузовика по ID
    // Если цвет не найден, используется первый цвет (зеленый)
    final c = truckColors.firstWhere(
      (t) => t.id == colorId,
      orElse: () => truckColors.first,
    );
    
    // Преобразование цветов из int в Color
    final fromColor = Color(c.from);
    final toColor = Color(c.to);

    return Transform.scale(
      scale: scale, // Применение масштаба
      child: SizedBox(
        width: 200,
        height: 120,
        child: Stack(
          children: [
            // ═══════════════════════════════════════════════════════════════
            // Кузов грузовика (задняя часть)
            // ═══════════════════════════════════════════════════════════════
            Positioned(
              bottom: 20,
              left: 60,
              child: Container(
                width: 140,
                height: 90,
                decoration: BoxDecoration(
                  // Градиент от светлого к темному оттенку
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [fromColor, toColor],
                  ),
                  // Скругленные углы (как у настоящего грузовика)
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                  // Обводка для объема
                  border: Border.all(color: toColor.withValues(alpha: 0.8), width: 3),
                ),
                child: Stack(
                  children: [
                    // Логотип переработки в центре
                    const Center(
                      child: Text('♻️', style: TextStyle(fontSize: 36)),
                    ),
                    // Отображение стикеров (до 3 штук)
                    ...stickerIds.take(3).toList().asMap().entries.map((e) {
                      // Поиск стикера по ID
                      final s = stickers.firstWhere(
                        (x) => x.id == e.value,
                        orElse: () => stickers.first,
                      );
                      return Positioned(
                        top: 4.0 + e.key * 22, // Вертикальное расположение
                        right: 6,
                        child: Text(s.emoji, style: const TextStyle(fontSize: 18)),
                      );
                    }),
                  ],
                ),
              ),
            ),
            
            // ═══════════════════════════════════════════════════════════════
            // Кабина грузовика (передняя часть)
            // ═══════════════════════════════════════════════════════════════
            Positioned(
              bottom: 20,
              left: 0,
              child: Container(
                width: 78,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [fromColor, toColor],
                  ),
                  // Скругленные углы спереди
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                  border: Border.all(color: toColor.withValues(alpha: 0.8), width: 3),
                ),
                // Окно кабины с водителем
                child: Center(
                  child: Container(
                    width: 44,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFbae6fd), // Светло-голубое стекло
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF38bdf8), width: 2),
                    ),
                    child: const Center(
                      // Смайлик водителя
                      child: Text('😊', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ),
            ),
            
            // ═══════════════════════════════════════════════════════════════
            // Колеса грузовика (2 колеса)
            // ═══════════════════════════════════════════════════════════════
            for (final left in [16.0, 128.0])
              Positioned(
                bottom: 0,
                left: left,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1f2937), // Темная резина
                    border: Border.all(color: const Color(0xFF111827), width: 3),
                  ),
                  // Центр колеса (диск)
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF6b7280), // Серый металл
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

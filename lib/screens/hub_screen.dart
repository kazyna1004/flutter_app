// ═══════════════════════════════════════════════════════════════════════════
// Hub Screen - Главное меню
// Описание: Центральный экран приложения с выбором локаций и мини-игр
//           Показывает питомца, грузовик и статистику игрока
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../main.dart';
import '../models/game_data.dart';
import '../widgets/eco_pet_widget.dart';
import '../widgets/truck_widget.dart';

/// Главный экран (хаб)
/// Здесь игрок выбирает локацию для игры или мини-игры
class HubScreen extends StatelessWidget {
  final PlayerStats stats;              // Статистика игрока
  final String truckColor;            // Цвет грузовика
  final List<String> truckStickers;   // Стикеры грузовика
  final void Function(String location) onLocation; // Выбор локации
  final void Function(GameScreen screen) onScreen; // Выбор экрана

  const HubScreen({
    super.key,
    required this.stats,
    required this.truckColor,
    required this.truckStickers,
    required this.onLocation,
    required this.onScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Градиентный фон (небо)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBAE6FD), // Светло-голубой
              Color(0xFFFED7AA), // Светло-оранжевый
              Color(0xFFFEF08A), // Светло-желтый
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                // ═══════════════════════════════════════════════════════════════
                // Заголовок приложения
                // ═══════════════════════════════════════════════════════════════
                Column(
                  children: [
                    const Text(
                      'Clean Truck 🚛',
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Choose Your Adventure!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF047857),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // ═══════════════════════════════════════════════════════════════
                // Карточка с питомцем, грузовиком и статистикой
                // ═══════════════════════════════════════════════════════════════
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Питомец игрока
                      EcoPetWidget(score: stats.totalScore),
                      const Spacer(),
                      // Грузовик игрока
                      TruckWidget(
                        colorId: truckColor,
                        stickerIds: truckStickers,
                        scale: 0.55,
                      ),
                      const Spacer(),
                      // Статистика
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${stats.totalScore}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF059669),
                            ),
                          ),
                          const Text(
                            'Total Score',
                            style: TextStyle(fontSize: 12, color: Color(0xFF6b7280)),
                          ),
                          Text(
                            '${stats.totalItemsSorted} items sorted',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6b7280)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // ═══════════════════════════════════════════════════════════════
                // Кнопки выбора локации
                // ═══════════════════════════════════════════════════════════════
                ...locations.map(
                  (loc) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _LocationButton(
                      location: loc,
                      isCompleted: stats.locationsCompleted.contains(loc.id),
                      onTap: () => onLocation(loc.id),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // ═══════════════════════════════════════════════════════════════
                // Заголовок мини-игр
                // ═══════════════════════════════════════════════════════════════
                const Text(
                  '🎮 Mini Games & More!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF047857),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // ═══════════════════════════════════════════════════════════════
                // Сетка мини-игр
                // ═══════════════════════════════════════════════════════════════
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _MiniGameButton(
                      icon: '⚡',
                      label: 'Speed\nChallenge',
                      gradientColors: const [Color(0xFFfb923c), Color(0xFFef4444)],
                      onTap: () => onScreen(GameScreen.speedChallenge),
                    ),
                    _MiniGameButton(
                      icon: '🧠',
                      label: 'Memory\nMatch',
                      gradientColors: const [Color(0xFFc084fc), Color(0xFFec4899)],
                      onTap: () => onScreen(GameScreen.memoryMatch),
                    ),
                    _MiniGameButton(
                      icon: '❓',
                      label: 'Eco\nQuiz',
                      gradientColors: const [Color(0xFF60a5fa), Color(0xFF06b6d4)],
                      onTap: () => onScreen(GameScreen.quiz),
                    ),
                    _MiniGameButton(
                      icon: '🎨',
                      label: 'Customize\nTruck',
                      gradientColors: const [Color(0xFF818cf8), Color(0xFFa855f7)],
                      onTap: () => onScreen(GameScreen.customize),
                    ),
                    _MiniGameButton(
                      icon: '🏆',
                      label: 'Stats &\nAwards',
                      gradientColors: const [Color(0xFFfbbf24), Color(0xFFf97316)],
                      onTap: () => onScreen(GameScreen.stats),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Мотивирующее сообщение
                const Text(
                  '✨ Sort waste correctly and help save our planet! ✨',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4b5563),
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Кнопка выбора локации
/// Показывает название, описание и статус завершения
class _LocationButton extends StatefulWidget {
  final LocationInfo location;
  final bool isCompleted;
  final VoidCallback onTap;

  const _LocationButton({
    required this.location,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  State<_LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<_LocationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    // Анимация нажатия
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = widget.location;
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: loc.gradientColors.map((c) => Color(c)).toList(),
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Color(loc.gradientColors.first).withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Эмодзи локации
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(loc.emoji, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              // Название и описание
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      loc.description,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Индикатор завершения
              if (widget.isCompleted)
                const Text('✅', style: TextStyle(fontSize: 24))
              else
                const Text(
                  '→',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Кнопка мини-игры
/// Квадратная кнопка с иконкой и названием
class _MiniGameButton extends StatefulWidget {
  final String icon;
  final String label;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _MiniGameButton({
    required this.icon,
    required this.label,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  State<_MiniGameButton> createState() => _MiniGameButtonState();
}

class _MiniGameButtonState extends State<_MiniGameButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.92,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.first.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

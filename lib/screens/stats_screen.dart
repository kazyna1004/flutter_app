// ═══════════════════════════════════════════════════════════════════════════
// Stats Screen - Экран статистики и достижений
// Описание: Показывает статистику игрока и все разблокированные достижения
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/game_data.dart';
import '../widgets/eco_pet_widget.dart';

/// Экран статистики и достижений
/// Отображает прогресс игрока и все доступные достижения
class StatsScreen extends StatelessWidget {
  final PlayerStats stats;
  final VoidCallback onBack;

  const StatsScreen({
    super.key,
    required this.stats,
    required this.onBack,
  });

  /// Генерация списка достижений на основе статистики
  List<_Achievement> get _achievements => [
        _Achievement(
          id: 'first', 
          label: 'First Sort!', 
          emoji: '🌱', 
          unlocked: stats.totalItemsSorted >= 1
        ),
        _Achievement(
          id: 'ten', 
          label: '10 Items Sorted', 
          emoji: '♻️', 
          unlocked: stats.totalItemsSorted >= 10
        ),
        _Achievement(
          id: 'fifty', 
          label: '50 Items Sorted', 
          emoji: '🌿', 
          unlocked: stats.totalItemsSorted >= 50
        ),
        _Achievement(
          id: 'hundred', 
          label: '100 Items Sorted', 
          emoji: '🏆', 
          unlocked: stats.totalItemsSorted >= 100
        ),
        _Achievement(
          id: 'perfect', 
          label: 'Perfect Round', 
          emoji: '⭐', 
          unlocked: stats.perfectRounds >= 1
        ),
        _Achievement(
          id: 'speed', 
          label: 'Speed Demon', 
          emoji: '⚡', 
          unlocked: stats.bestSpeedScore >= 100
        ),
        _Achievement(
          id: 'quiz', 
          label: 'Eco Expert', 
          emoji: '🎓', 
          unlocked: stats.bestQuizScore >= 400
        ),
        _Achievement(
          id: 'locations', 
          label: 'Explorer', 
          emoji: '🗺️', 
          unlocked: stats.locationsCompleted.length >= 3
        ),
        _Achievement(
          id: 'games', 
          label: 'Dedicated Player', 
          emoji: '🎮', 
          unlocked: stats.gamesPlayed >= 10
        ),
        _Achievement(
          id: 'champion', 
          label: 'Eco Champion', 
          emoji: '👑', 
          unlocked: stats.totalScore >= 5000
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFEF9C3), Color(0xFFFFEDD5)], // Желто-оранжевый
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ═══════════════════════════════════════════════════════════════
              // Верхняя панель навигации
              // ═══════════════════════════════════════════════════════════════
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white.withOpacity(0.6),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: onBack,
                      child: const Text('←', style: TextStyle(fontSize: 24)),
                    ),
                    const Expanded(
                      child: Text(
                        'Stats & Awards 🏆',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Color(0xFFb45309),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
              
              // ═══════════════════════════════════════════════════════════════
              // Основное содержимое
              // ═══════════════════════════════════════════════════════════════
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // ═══════════════════════════════════════════════════════
                      // Карточка с питомцем и общим счетом
                      // ═══════════════════════════════════════════════════════
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                            EcoPetWidget(score: stats.totalScore),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${stats.totalScore} pts',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                                const Text(
                                  'Total Score',
                                  style: TextStyle(fontSize: 13, color: Color(0xFF6b7280)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // ═══════════════════════════════════════════════════════
                      // Сетка статистики
                      // ═══════════════════════════════════════════════════════
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _StatCard(
                            emoji: '♻️', 
                            value: '${stats.totalItemsSorted}', 
                            label: 'Items Sorted', 
                            color: const Color(0xFF059669)
                          ),
                          _StatCard(
                            emoji: '🎯', 
                            value: '${stats.accuracy}%', 
                            label: 'Accuracy', 
                            color: const Color(0xFF2563eb)
                          ),
                          _StatCard(
                            emoji: '🎮', 
                            value: '${stats.gamesPlayed}', 
                            label: 'Games Played', 
                            color: const Color(0xFF9333ea)
                          ),
                          _StatCard(
                            emoji: '⭐', 
                            value: '${stats.perfectRounds}', 
                            label: 'Perfect Rounds', 
                            color: const Color(0xFFd97706)
                          ),
                          _StatCard(
                            emoji: '⚡', 
                            value: '${stats.bestSpeedScore}', 
                            label: 'Best Speed', 
                            color: const Color(0xFFea580c)
                          ),
                          _StatCard(
                            emoji: '🎓', 
                            value: '${stats.bestQuizScore}', 
                            label: 'Best Quiz', 
                            color: const Color(0xFF0891b2)
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // ═══════════════════════════════════════════════════════
                      // Заголовок достижений
                      // ═══════════════════════════════════════════════════════
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '🏅 Achievements',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // ═══════════════════════════════════════════════════════
                      // Список достижений
                      // ═══════════════════════════════════════════════════════
                      ..._achievements.map(
                        (a) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _AchievementTile(achievement: a),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Карточка отображения статистики
class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6b7280)),
          ),
        ],
      ),
    );
  }
}

/// Модель достижения
class _Achievement {
  final String id;
  final String label;
  final String emoji;
  final bool unlocked;

  const _Achievement({
    required this.id,
    required this.label,
    required this.emoji,
    required this.unlocked,
  });
}

/// Элемент списка достижений
class _AchievementTile extends StatelessWidget {
  final _Achievement achievement;

  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: unlocked ? const Color(0xFFFEF9C3) : const Color(0xFFf9fafb),
        border: Border.all(
          color: unlocked ? const Color(0xFFFDE68A) : const Color(0xFFe5e7eb),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            achievement.emoji,
            style: TextStyle(
              fontSize: 24,
              color: unlocked ? null : Colors.black.withOpacity(0.3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              achievement.label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: unlocked ? const Color(0xFF92400e) : const Color(0xFF9ca3af),
              ),
            ),
          ),
          if (unlocked)
            const Text(
              '✓',
              style: TextStyle(
                color: Color(0xFFf59e0b),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          else
            const Text('🔒', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

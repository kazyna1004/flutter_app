// ═══════════════════════════════════════════════════════════════════════════
// Speed Challenge Screen - Экран скоростного испытания
// Описание: Мини-игра на скорость - сортировать как можно больше предметов
//           за 30 секунд, комбо-система дает больше очков
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_data.dart';

/// Экран скоростного испытания
/// Мини-игра на время - нужно отсортировать максимум за 30 секунд
class SpeedChallengeScreen extends StatefulWidget {
  final VoidCallback onBack;
  final void Function(int score) onComplete;

  const SpeedChallengeScreen({
    super.key,
    required this.onBack,
    required this.onComplete,
  });

  @override
  State<SpeedChallengeScreen> createState() => _SpeedChallengeScreenState();
}

/// Состояния игры
enum _Phase { ready, playing, done }

class _SpeedChallengeScreenState extends State<SpeedChallengeScreen> {
  _Phase _phase = _Phase.ready;
  int _timeLeft = 30;
  int _score = 0;
  int _combo = 0;
  late WasteItem _current;
  String? _feedbackText;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Инициализация первого предмета
    _current = allWaste.first;
  }

  @override
  void dispose() {
    // Обязательная очистка таймера при удалении виджета
    _timer?.cancel();
    super.dispose();
  }

  /// Переход к следующему предмету
  void _nextItem() {
    final shuffledList = shuffled(allWaste);
    setState(() => _current = shuffledList.first);
  }

  /// Запуск игры
  void _start() {
    setState(() {
      _phase = _Phase.playing;
      _score = 0;
      _combo = 0;
      _timeLeft = 30;
    });
    _nextItem();

    // Таймер обратного отсчета
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          t.cancel();
          _phase = _Phase.done;
        }
      });
    });
  }

  /// Обработка выбора корзины
  void _handleBin(WasteType binType) {
    if (_phase != _Phase.playing) return;
    final isCorrect = _current.type == binType;

    if (isCorrect) {
      // Правильный ответ - расчет очков с комбо
      final pts = 10 + _combo * 5;
      setState(() {
        _score += pts;
        _combo++;
        _feedbackText = '+$pts${_combo > 1 ? ' 🔥x$_combo' : ''}';
      });
    } else {
      // Неправильный - сброс комбо
      setState(() {
        _combo = 0;
        _feedbackText = '❌';
      });
    }

    // Скрытие обратной связи через 600мс
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _feedbackText = null);
    });

    _nextItem();
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case _Phase.ready:
        return _buildReadyScreen();
      case _Phase.playing:
        return _buildPlayingScreen();
      case _Phase.done:
        return _buildDoneScreen();
    }
  }

  /// Экран готовности к игре
  Widget _buildReadyScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFffedd5), Color(0xFFfee2e2)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: widget.onBack,
                  child: const Text('←', style: TextStyle(fontSize: 24)),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 16),
                    const Text(
                      'Speed Challenge',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFea580c),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Sort as many items as you\ncan in 30 seconds!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Color(0xFF4b5563)),
                    ),
                    const SizedBox(height: 40),
                    _GradButton(
                      label: 'Start! ⚡',
                      colors: const [Color(0xFFfb923c), Color(0xFFef4444)],
                      onTap: _start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Экран игры
  Widget _buildPlayingScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFffedd5), Color(0xFFfee2e2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ═══════════════════════════════════════════════════════════════
              // Верхняя панель (таймер, счет, комбо)
              // ═══════════════════════════════════════════════════════════════
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white.withValues(alpha: 0.6),
                child: Row(
                  children: [
                    // Таймер - красный когда мало времени
                    Text(
                      '⏱ ${_timeLeft}s',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: _timeLeft <= 10
                            ? const Color(0xFFef4444)
                            : const Color(0xFFea580c),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$_score pts',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFea580c),
                      ),
                    ),
                    if (_combo > 1) ...[
                      const SizedBox(width: 12),
                      Text(
                        '🔥 x$_combo',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFf97316),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Прогресс-бар времени
              LinearProgressIndicator(
                value: _timeLeft / 30,
                backgroundColor: const Color(0xFFe5e7eb),
                valueColor: AlwaysStoppedAnimation(
                  _timeLeft <= 10
                      ? const Color(0xFFef4444)
                      : const Color(0xFFfb923c),
                ),
                minHeight: 6,
              ),
              
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ═══════════════════════════════════════════════
                            // Карточка предмета
                            // ═══════════════════════════════════════════════
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _current.emoji,
                                    style: const TextStyle(fontSize: 56),
                                  ),
                                  Text(
                                    _current.name,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4b5563),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 28),
                            
                            // ═══════════════════════════════════════════════
                            // Сетка корзин
                            // ═══════════════════════════════════════════════
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: bins
                                  .map(
                                    (bin) => _BinTapButton(
                                      bin: bin,
                                      onTap: () => _handleBin(bin.type),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // ═══════════════════════════════════════════════════════
                    // Обратная связь
                    // ═══════════════════════════════════════════════════════
                    if (_feedbackText != null)
                      Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFf97316),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Text(
                              _feedbackText!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Экран завершения
  Widget _buildDoneScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFffedd5), Color(0xFFfee2e2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 8),
                    const Text(
                      "Time's Up!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFea580c),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFf97316),
                      ),
                    ),
                    const Text(
                      'Speed Challenge Score',
                      style: TextStyle(color: Color(0xFF6b7280), fontSize: 14),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: _GradButton(
                        label: 'Back to Hub 🏠',
                        colors: const [Color(0xFFfb923c), Color(0xFFef4444)],
                        onTap: () => widget.onComplete(_score),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Кнопка корзины
class _BinTapButton extends StatefulWidget {
  final BinInfo bin;
  final VoidCallback onTap;

  const _BinTapButton({required this.bin, required this.onTap});

  @override
  State<_BinTapButton> createState() => _BinTapButtonState();
}

class _BinTapButtonState extends State<_BinTapButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      lowerBound: 0.90,
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
    final bin = widget.bin;
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
              colors: bin.gradientColors.map((c) => Color(c)).toList(),
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Color(bin.gradientColors.first).withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(bin.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                bin.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Кнопка с градиентом
class _GradButton extends StatelessWidget {
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  const _GradButton({
    required this.label,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

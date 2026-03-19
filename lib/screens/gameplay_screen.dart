// ═══════════════════════════════════════════════════════════════════════════
// Gameplay Screen - Экран сортировки отходов
// Описание: Основная игровая механика - сортировка отходов по корзинам
//           Игроку нужно перетаскивать или нажимать на правильную корзину
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/game_data.dart';

/// Экран игрового процесса (сортировка отходов)
/// Основная механика игры
class GamePlayScreen extends StatefulWidget {
  final String location; // ID выбранной локации
  final VoidCallback onBack; // Возврат в меню
  // Колбэк завершения игры (счет, количество, точность)
  final void Function(int score, int sorted, int accuracy) onComplete;

  const GamePlayScreen({
    super.key,
    required this.location,
    required this.onBack,
    required this.onComplete,
  });

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  late LocationInfo _loc; // Информация о локации
  late List<WasteItem> _items; // Список предметов для сортировки
  int _currentIdx = 0; // Индекс текущего предмета
  int _score = 0; // Текущий счет
  int _correct = 0; // Количество правильных ответов
  bool _done = false; // Игра завершена
  _FeedbackData? _feedback; // Данные для отображения обратной связи
  bool _dragging = false; // Состояние перетаскивания

  @override
  void initState() {
    super.initState();
    // Поиск локации по ID или использование первой
    _loc = locations.firstWhere(
      (l) => l.id == widget.location,
      orElse: () => locations.first,
    );
    // Перемешивание и выбор 8 предметов для игры
    _items = shuffled(allWaste).take(8).toList();
  }

  /// Получение текущего предмета
  WasteItem get _current => _items[_currentIdx];

  /// Обработка выбора корзины
  void _handleDrop(WasteType binType) {
    // Игнорирование повторных нажатий во время анимации
    if (_done || _feedback != null) return;
    
    final isCorrect = _current.type == binType;

    setState(() {
      if (isCorrect) {
        // Правильный ответ - начисление очков
        _score += 100;
        _correct++;
        _feedback = _FeedbackData('✅ Correct! +100', true);
      } else {
        // Неправильный ответ - показ подсказки
        _feedback = _FeedbackData(
          '❌ Wrong! Goes in ${wasteTypeLabel(_current.type)}',
          false,
        );
      }
    });

    // Задержка перед переходом к следующему предмету
    Future.delayed(const Duration(milliseconds: 1200), () {
      // Проверка, что виджет все еще в дереве
      if (!mounted) return;
      setState(() {
        _feedback = null;
        if (_currentIdx + 1 >= _items.length) {
          // Все предметы отсортированы
          _done = true;
        } else {
          _currentIdx++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Преобразование цветов из int в Color
    final bgColors = _loc.bgGradientColors.map((c) => Color(c)).toList();

    // Если игра завершена - показать экран результатов
    if (_done) {
      return _buildDoneScreen(bgColors);
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: bgColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ═══════════════════════════════════════════════════════════════
              // Верхняя панель (навигация, название, счет)
              // ═══════════════════════════════════════════════════════════════
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white.withOpacity(0.6),
                child: Row(
                  children: [
                    // Кнопка назад
                    GestureDetector(
                      onTap: widget.onBack,
                      child: const Text('←', style: TextStyle(fontSize: 24)),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            _loc.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF047857),
                            ),
                          ),
                          Text(
                            '${_currentIdx + 1} / ${_items.length}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6b7280)),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '$_score pts',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Прогресс-бар
              LinearProgressIndicator(
                value: _currentIdx / _items.length,
                backgroundColor: const Color(0xFFe5e7eb),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF34d399)),
                minHeight: 6,
              ),
              
              // ═══════════════════════════════════════════════════════════════
              // Игровая область
              // ═══════════════════════════════════════════════════════════════
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Where does this go?',
                            style: TextStyle(
                              color: Color(0xFF4b5563),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // ═══════════════════════════════════════════════
                          // Карточка предмета для сортировки
                          // ═══════════════════════════════════════════════
                          GestureDetector(
                            onTapDown: (_) => setState(() => _dragging = true),
                            onTapUp: (_) => setState(() => _dragging = false),
                            onTapCancel: () => setState(() => _dragging = false),
                            child: AnimatedScale(
                              scale: _dragging ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _current.emoji,
                                      style: const TextStyle(fontSize: 64),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _current.name,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF4b5563),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // ═══════════════════════════════════════════════
                          // Сетка корзин для сортировки
                          // ═══════════════════════════════════════════════
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: bins
                                .map((bin) => _BinButton(
                                      bin: bin,
                                      onTap: () => _handleDrop(bin.type),
                                    ))
                                .toList(),
                          ),
                          
                          const SizedBox(height: 12),
                          const Text(
                            'Tap a bin to sort',
                            style: TextStyle(fontSize: 12, color: Color(0xFF9ca3af)),
                          ),
                        ],
                      ),
                    ),
                    
                    // ═══════════════════════════════════════════════════════
                    // Обратная связь (правильно/неправильно)
                    // ═══════════════════════════════════════════════════════
                    if (_feedback != null)
                      Positioned(
                        top: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: _feedback!.isCorrect
                                  ? const Color(0xFF10b981) // Зеленый для правильно
                                  : const Color(0xFFef4444), // Красный для неправильно
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              _feedback!.message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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

  /// Построение экрана завершения игры
  Widget _buildDoneScreen(List<Color> bgColors) {
    final acc = (_correct / _items.length * 100).round();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: bgColors,
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
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🎉', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 8),
                    const Text(
                      'Level Complete!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _loc.name,
                      style: const TextStyle(color: Color(0xFF6b7280), fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    
                    // Статистика игры
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatBox(
                          value: '$_score',
                          label: 'Score',
                          color: const Color(0xFF059669),
                          bg: const Color(0xFFd1fae5),
                        ),
                        _StatBox(
                          value: '$_correct/${_items.length}',
                          label: 'Correct',
                          color: const Color(0xFF2563eb),
                          bg: const Color(0xFFdbeafe),
                        ),
                        _StatBox(
                          value: '$acc%',
                          label: 'Accuracy',
                          color: const Color(0xFF9333ea),
                          bg: const Color(0xFFf3e8ff),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Кнопка возврата в меню
                    SizedBox(
                      width: double.infinity,
                      child: _GradientButton(
                        label: 'Back to Hub 🏠',
                        colors: const [Color(0xFF34d399), Color(0xFF059669)],
                        onTap: () => widget.onComplete(_score, _items.length, acc),
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

/// Вспомогательный класс для обратной связи
class _FeedbackData {
  final String message;
  final bool isCorrect;

  _FeedbackData(this.message, this.isCorrect);
}

/// Кнопка корзины
class _BinButton extends StatefulWidget {
  final BinInfo bin;
  final VoidCallback onTap;

  const _BinButton({required this.bin, required this.onTap});

  @override
  State<_BinButton> createState() => _BinButtonState();
}

class _BinButtonState extends State<_BinButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.93,
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
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(bin.gradientColors.first).withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(bin.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 6),
              Text(
                bin.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Блок отображения статистики
class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color bg;

  const _StatBox({
    required this.value,
    required this.label,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6b7280)),
          ),
        ],
      ),
    );
  }
}

/// Кнопка с градиентом
class _GradientButton extends StatefulWidget {
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.colors,
    required this.onTap,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.97,
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: widget.colors),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.colors.first.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Eco Quiz Screen - Экран эко-викторины
// Описание: Викторина с вопросами об окружающей среде и переработке
//           5 случайных вопросов с объяснениями
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/game_data.dart';

/// Экран эко-викторины
/// Игрок отвечает на вопросы об окружающей среде
class EcoQuizScreen extends StatefulWidget {
  final VoidCallback onBack;
  final void Function(int score) onComplete;

  const EcoQuizScreen({
    super.key,
    required this.onBack,
    required this.onComplete,
  });

  @override
  State<EcoQuizScreen> createState() => _EcoQuizScreenState();
}

class _EcoQuizScreenState extends State<EcoQuizScreen> {
  late List<QuizQuestion> _questions;
  int _idx = 0;
  int? _selected;
  int _score = 0;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    // Перемешивание и выбор 5 вопросов из пула
    _questions = shuffled(quizQuestions).take(5).toList();
  }

  QuizQuestion get _current => _questions[_idx];

  /// Обработка выбора ответа
  void _answer(int i) {
    // Игнорирование повторных нажатий
    if (_selected != null) return;
    
    setState(() => _selected = i);
    if (i == _current.correctAnswer) {
      // Правильный ответ - +100 очков
      setState(() => _score += 100);
    }
    
    // Переход к следующему вопросу через 1.5 секунды
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (_idx + 1 >= _questions.length) {
        setState(() => _done = true);
      } else {
        setState(() {
          _idx++;
          _selected = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return _buildDoneScreen();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFdbeafe), Color(0xFFcffafe)],
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
                      onTap: widget.onBack,
                      child: const Text('←', style: TextStyle(fontSize: 24)),
                    ),
                    const Expanded(
                      child: Text(
                        'Eco Quiz ❓',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Color(0xFF1d4ed8),
                        ),
                      ),
                    ),
                    Text(
                      '${_idx + 1}/${_questions.length}',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF6b7280)),
                    ),
                  ],
                ),
              ),
              
              // Прогресс-бар
              LinearProgressIndicator(
                value: _idx / _questions.length,
                backgroundColor: const Color(0xFFe5e7eb),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF60a5fa)),
                minHeight: 6,
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // ═══════════════════════════════════════════════════════
                      // Эмодзи вопроса
                      // ═══════════════════════════════════════════════════════
                      Text(_current.emoji, style: const TextStyle(fontSize: 60)),
                      const SizedBox(height: 16),
                      
                      // ═══════════════════════════════════════════════════════
                      // Текст вопроса
                      // ═══════════════════════════════════════════════════════
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          _current.question,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1f2937),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // ═══════════════════════════════════════════════════════
                      // Варианты ответов
                      // ═══════════════════════════════════════════════════════
                      ..._current.options.asMap().entries.map((entry) {
                        final i = entry.key;
                        final opt = entry.value;
                        Color bg = Colors.white;
                        Color border = const Color(0xFFe5e7eb);
                        Color text = const Color(0xFF1f2937);

                        // Окрашивание вариантов после выбора
                        if (_selected != null) {
                          if (i == _current.correctAnswer) {
                            // Правильный ответ - зеленый
                            bg = const Color(0xFF10b981);
                            border = const Color(0xFF10b981);
                            text = Colors.white;
                          } else if (i == _selected) {
                            // Выбранный неправильный - красный
                            bg = const Color(0xFFf87171);
                            border = const Color(0xFFf87171);
                            text = Colors.white;
                          } else {
                            // Не выбранные - серый
                            bg = const Color(0xFFf3f4f6);
                            text = const Color(0xFF9ca3af);
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () => _answer(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: bg,
                                border: Border.all(color: border, width: 2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                opt,
                                style: TextStyle(
                                  color: text,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      
                      // ═══════════════════════════════════════════════════════
                      // Объяснение ответа
                      // ═══════════════════════════════════════════════════════
                      if (_selected != null) ...[
                        const SizedBox(height: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _selected == _current.correctAnswer
                                ? const Color(0xFFd1fae5)
                                : const Color(0xFFfee2e2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _current.explanation,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _selected == _current.correctAnswer
                                  ? const Color(0xFF065f46)
                                  : const Color(0xFF991b1b),
                            ),
                          ),
                        ),
                      ],
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

  /// Экран завершения викторины
  Widget _buildDoneScreen() {
    final correct = _score ~/ 100;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFdbeafe), Color(0xFFcffafe)],
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
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🎓', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 8),
                    const Text(
                      'Quiz Complete!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1d4ed8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF3b82f6),
                      ),
                    ),
                    Text(
                      '$correct / ${_questions.length} correct',
                      style: const TextStyle(color: Color(0xFF6b7280), fontSize: 14),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: _GradBtn(
                        label: 'Back to Hub 🏠',
                        colors: const [Color(0xFF60a5fa), Color(0xFF06b6d4)],
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

/// Кнопка с градиентом
class _GradBtn extends StatelessWidget {
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  const _GradBtn({
    required this.label,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(18),
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

// ═══════════════════════════════════════════════════════════════════════════
// Eco Pet Widget - Виджет питомца
// Описание: Анимированный питомец, который растет вместе со счетом игрока
//           Уровень питомца повышается каждые 1000 очков
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/game_data.dart';

/// Виджет питомца-эколога
/// Отображает питомца с анимацией прыжка и прогрессом до следующего уровня
class EcoPetWidget extends StatefulWidget {
  final int score; // Текущий счет игрока

  const EcoPetWidget({super.key, required this.score});

  @override
  State<EcoPetWidget> createState() => _EcoPetWidgetState();
}

class _EcoPetWidgetState extends State<EcoPetWidget>
    with SingleTickerProviderStateMixin {
  // Контроллер анимации для прыжков
  late AnimationController _controller;
  // Анимация вертикального смещения
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    
    // Инициализация контроллера анимации
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700), // Длительность одного цикла
      vsync: this, // Синхронизация с кадрами экрана
    )..repeat(reverse: true); // Повторять с реверсом (вверх-вниз)
    
    // Создание анимации прыжка
    // От -8 до 0 пикселей с плавной кривой
    _bounceAnim = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    // Обязательно освобождаем ресурсы анимации при удалении виджета
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Получение уровня и эмодзи питомца на основе счета
    final level = getPetLevel(widget.score);
    final petEmoji = getPetEmoji(widget.score);
    
    // Прогресс до следующего уровня (0.0 - 1.0)
    // Рассчитывается как остаток от деления на 1000, деленный на 1000
    final progress = (widget.score % 1000) / 1000.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ═══════════════════════════════════════════════════════════════════
        // Анимированный питомец
        // ═══════════════════════════════════════════════════════════════════
        AnimatedBuilder(
          animation: _bounceAnim,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _bounceAnim.value), // Вертикальное смещение
            child: child,
          ),
          child: Text(petEmoji, style: const TextStyle(fontSize: 44)),
        ),
        
        const SizedBox(height: 4),
        
        // ═══════════════════════════════════════════════════════════════════
        // Бейдж уровня питомца
        // ═══════════════════════════════════════════════════════════════════
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFd1fae5), // Светло-зеленый фон
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Lv.$level Eco Pet', // Отображение уровня
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF065f46), // Темно-зеленый текст
            ),
          ),
        ),
        
        const SizedBox(height: 4),
        
        // ═══════════════════════════════════════════════════════════════════
        // Прогресс-бар до следующего уровня
        // ═══════════════════════════════════════════════════════════════════
        SizedBox(
          width: 80,
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFe5e7eb), // Серый фон
              valueColor: const AlwaysStoppedAnimation(Color(0xFF34d399)), // Зеленый прогресс
            ),
          ),
        ),
      ],
    );
  }
}

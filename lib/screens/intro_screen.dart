// ═══════════════════════════════════════════════════════════════════════════
// Intro Screen - Экран введения/заставка
// Описание: Анимированный экран загрузки при первом запуске приложения
//           Показывает движущийся грузовик с названием приложения
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/truck_widget.dart';

/// Экран введения/заставки
/// Анимированный грузовик, который "едет" по экрану
class IntroScreen extends StatefulWidget {
  final VoidCallback onDone; // Колбэк по завершении анимации

  const IntroScreen({super.key, required this.onDone});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  // Контроллер анимации
  late AnimationController _controller;
  
  // Позиция грузовика (0.0 - 1.0)
  double _truckPercent = 0.0;
  
  // Вертикальное смещение для эффекта тряски
  double _bounce = 0.0;

  @override
  void initState() {
    super.initState();
    
    // Инициализация контроллера анимации (5.5 секунд)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    );

    // Обновление состояния на каждом кадре анимации
    _controller.addListener(() {
      final t = _controller.value;
      // Использование функции плавности (ease-in-out)
      final eased = t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
      setState(() {
        _truckPercent = eased;
        // Эффект тряски колес при движении
        _bounce = sin(t * 5500 / 200) * 4;
      });
    });

    // Обработка завершения анимации
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Небольшая задержка перед переходом
        Future.delayed(const Duration(milliseconds: 500), widget.onDone);
      }
    });

    // Запуск анимации
    _controller.forward();
  }

  @override
  void dispose() {
    // Освобождение ресурсов контроллера
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Получение размера экрана
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        // Красивый градиентный фон (небо и трава)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Голубое небо
              Color(0xFFB0E0E6), // Светло-голубой
              Color(0xFF90EE90),  // Светло-зеленая трава
            ],
          ),
        ),
        child: Stack(
          children: [
            // ═══════════════════════════════════════════════════════════════
            // Декоративные элементы (солнце и облака)
            // ═══════════════════════════════════════════════════════════════
            const Positioned(
              top: 48,
              right: 80,
              child: Text('☀️', style: TextStyle(fontSize: 64)),
            ),
            const Positioned(
              top: 64,
              left: 64,
              child: Text('☁️', style: TextStyle(fontSize: 48)),
            ),
            const Positioned(
              top: 96,
              left: 192,
              child: Text('☁️', style: TextStyle(fontSize: 32)),
            ),
            
            // ═══════════════════════════════════════════════════════════════
            // Заголовок приложения
            // ═══════════════════════════════════════════════════════════════
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Clean Truck',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF059669),
                      shadows: [
                        Shadow(
                          offset: const Offset(3, 3),
                          blurRadius: 0,
                          color: Colors.black.withValues(alpha: 0.15),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Let's Make the World Clean! 🌍",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF047857),
                    ),
                  ),
                ],
              ),
            ),
            
            // ═══════════════════════════════════════════════════════════════
            // Дорога внизу экрана
            // ═══════════════════════════════════════════════════════════════
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 128,
                color: const Color(0xFF4b5563), // Темно-серая дорога
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Row(
                    // Разметка дороги (штрихи)
                    children: List.generate(
                      12,
                      (_) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 60),
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBBF24), // Желтая разметка
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // ═══════════════════════════════════════════════════════════════
            // Анимированный грузовик
            // ═══════════════════════════════════════════════════════════════
            Positioned(
              bottom: 128,
              // Движение грузовика слева направо
              left: size.width * (-0.25 + _truckPercent * 1.35),
              child: Transform.translate(
                offset: Offset(0, _bounce), // Эффект тряски
                child: const TruckWidget(
                  colorId: 'green',
                  stickerIds: [],
                ),
              ),
            ),
            
            // ═══════════════════════════════════════════════════════════════
            // Индикатор загрузки (точки)
            // ═══════════════════════════════════════════════════════════════
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF10b981),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

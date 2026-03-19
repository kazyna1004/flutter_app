// ═══════════════════════════════════════════════════════════════════════════
// Truck Customizer Screen - Экран кастомизации грузовика
// Описание: Экран для изменения цвета грузовика и добавления стикеров
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/game_data.dart';
import '../widgets/truck_widget.dart';

/// Экран кастомизации грузовика
/// Позволяет игроку выбрать цвет и стикеры для своего грузовика
class TruckCustomizerScreen extends StatelessWidget {
  final String truckColor;           // Текущий цвет грузовика
  final List<String> truckStickers;  // Текущие стикеры
  final void Function(String color) onColor; // Изменение цвета
  final void Function(String stickerId) onSticker; // Изменение стикеров
  final VoidCallback onBack; // Возврат в меню

  const TruckCustomizerScreen({
    super.key,
    required this.truckColor,
    required this.truckStickers,
    required this.onColor,
    required this.onSticker,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFe0e7ff), Color(0xFFf3e8ff)], // Сиреневый градиент
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
                color: Colors.white.withValues(alpha: 0.6),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: onBack,
                      child: const Text('←', style: TextStyle(fontSize: 24)),
                    ),
                    const Expanded(
                      child: Text(
                        'Customize Truck 🎨',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Color(0xFF4338ca),
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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ═══════════════════════════════════════════════════════
                      // Предпросмотр грузовика
                      // ═══════════════════════════════════════════════════════
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _BouncingTruck(
                            colorId: truckColor,
                            stickerIds: truckStickers,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // ═══════════════════════════════════════════════════════
                      // Выбор цвета грузовика
                      // ═══════════════════════════════════════════════════════
                      const Text(
                        '🎨 Truck Color',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF374151),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: truckColors
                            .map(
                              (c) => _ColorButton(
                                truckColor: c,
                                isSelected: truckColor == c.id,
                                onTap: () => onColor(c.id),
                              ),
                            )
                            .toList(),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // ═══════════════════════════════════════════════════════
                      // Выбор стикеров
                      // ═══════════════════════════════════════════════════════
                      const Text(
                        '⭐ Stickers',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF374151),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      GridView.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: stickers
                            .map(
                              (s) => _StickerButton(
                                sticker: s,
                                isSelected: truckStickers.contains(s.id),
                                onTap: () => onSticker(s.id),
                              ),
                            )
                            .toList(),
                      ),
                      
                      const SizedBox(height: 16),
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

/// Анимированный грузовик с эффектом подпрыгивания
class _BouncingTruck extends StatefulWidget {
  final String colorId;
  final List<String> stickerIds;

  const _BouncingTruck({required this.colorId, required this.stickerIds});

  @override
  State<_BouncingTruck> createState() => _BouncingTruckState();
}

class _BouncingTruckState extends State<_BouncingTruck>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnim,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _bounceAnim.value),
        child: child,
      ),
      child: TruckWidget(
        colorId: widget.colorId,
        stickerIds: widget.stickerIds,
      ),
    );
  }
}

/// Кнопка выбора цвета
class _ColorButton extends StatelessWidget {
  final TruckColor truckColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorButton({
    required this.truckColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.diagonal3Values(
          isSelected ? 1.05 : 1.0,
          isSelected ? 1.05 : 1.0,
          1.0,
        ),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(truckColor.from), Color(truckColor.to)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(truckColor.from).withValues(alpha: 0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            truckColor.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

/// Кнопка выбора стикера
class _StickerButton extends StatelessWidget {
  final StickerInfo sticker;
  final bool isSelected;
  final VoidCallback onTap;

  const _StickerButton({
    required this.sticker,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.diagonal3Values(
          isSelected ? 1.1 : 1.0,
          isSelected ? 1.1 : 1.0,
          1.0,
        ),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFe0e7ff) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: const Color(0xFF6366f1), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(sticker.emoji, style: const TextStyle(fontSize: 28)),
        ),
      ),
    );
  }
}

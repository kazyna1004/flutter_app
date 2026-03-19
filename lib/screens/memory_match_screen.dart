// ═══════════════════════════════════════════════════════════════════════════
// Memory Match Screen - Экран игры на память
// Описание: Классическая игра "Найди пару" - нужно найти все пары карточек
//           12 карточек (6 пар), счет зависит от количества ходов
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../models/game_data.dart';

class MemoryMatchScreen extends StatefulWidget {
  final VoidCallback onBack;
  final void Function(int score) onComplete;

  const MemoryMatchScreen({
    super.key,
    required this.onBack,
    required this.onComplete,
  });

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _CardData {
  final int id;
  final String emoji;
  final bool matched;
  final bool flipped;

  const _CardData({
    required this.id,
    required this.emoji,
    this.matched = false,
    this.flipped = false,
  });

  _CardData copyWith({bool? matched, bool? flipped}) {
    return _CardData(
      id: id,
      emoji: emoji,
      matched: matched ?? this.matched,
      flipped: flipped ?? this.flipped,
    );
  }
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  late List<_CardData> _cards;
  final List<int> _selected = [];
  int _moves = 0;
  bool _done = false;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _initCards();
  }

  void _initCards() {
    final emojis = allWaste.take(6).map((w) => w.emoji).toList();
    final doubled = [...emojis, ...emojis];
    doubled.shuffle();

    _cards = doubled
        .asMap()
        .entries
        .map((e) => _CardData(id: e.key, emoji: e.value))
        .toList();
  }

  void _flip(int id) {
    if (_checking || _selected.length >= 2) return;

    final card = _cards[id];
    if (card.flipped || card.matched) return;

    setState(() {
      _cards[id] = card.copyWith(flipped: true);
      _selected.add(id);
    });

    if (_selected.length == 2) {
      _moves++;
      _checking = true;

      final a = _selected[0];
      final b = _selected[1];

      if (_cards[a].emoji == _cards[b].emoji) {
        setState(() {
          _cards[a] = _cards[a].copyWith(matched: true);
          _cards[b] = _cards[b].copyWith(matched: true);
          _selected.clear();
          _checking = false;

          if (_cards.every((c) => c.matched)) {
            _done = true;
          }
        });
      } else {
        Future.delayed(const Duration(milliseconds: 700), () {
          if (!mounted) return;

          setState(() {
            _cards[a] = _cards[a].copyWith(flipped: false);
            _cards[b] = _cards[b].copyWith(flipped: false);
            _selected.clear();
            _checking = false;
          });
        });
      }
    }
  }

  int get _score => (600 - _moves * 20).clamp(0, 600);

  @override
  Widget build(BuildContext context) {
    if (_done) return _buildDoneScreen();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: const Text('←', style: TextStyle(fontSize: 24)),
                  ),
                  const Expanded(
                    child: Text(
                      'Memory Match 🧠',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text('$_moves moves'),
                ],
              ),
            ),

            Text('Score: $_score'),

            const SizedBox(height: 12),

            // GRID
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _cards.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, i) {
                  return _MemoryCard(
                    card: _cards[i],
                    onTap: () => _flip(i),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            const Text(
              'You matched them all!',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text('Score: $_score'),
            Text('Moves: $_moves'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => widget.onComplete(_score),
              child: const Text('Back to Hub'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryCard extends StatefulWidget {
  final _CardData card;
  final VoidCallback onTap;

  const _MemoryCard({
    required this.card,
    required this.onTap,
  });

  @override
  State<_MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<_MemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    if (widget.card.flipped || widget.card.matched) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant _MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final show = widget.card.flipped || widget.card.matched;
    final oldShow = oldWidget.card.flipped || oldWidget.card.matched;

    if (show && !oldShow) {
      _controller.forward();
    } else if (!show && oldShow) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * 3.14159;
          final isFront = _animation.value >= 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? Transform(
                    alignment: Alignment.center,
                    transform:
                        Matrix4.identity()..rotateY(3.14159),
                    child: _buildFront(),
                  )
                : _buildBack(),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    final card = widget.card;

    return Container(
      decoration: BoxDecoration(
        color: card.matched ? Colors.grey.shade300 : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          card.emoji,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.pink],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          '❓',
          style: TextStyle(fontSize: 26),
        ),
      ),
    );
  }
}
// ═══════════════════════════════════════════════════════════════════════════
// Models & Data - Модели данных и статические данные приложения
// Описание: Содержит все модели данных, используемые в игре
// ═══════════════════════════════════════════════════════════════════════════

/// Перечисление типов отходов для сортировки
/// Используется для категоризации отходов и определения правильных корзин
enum WasteType {
  organic,  // Органические отходы (еда, растения)
  plastic,  // Пластик
  paper,    // Бумага
  glass,    // Стекло
}

/// Модель элемента отходов
/// Представляет один предмет, который нужно отсортировать
class WasteItem {
  final String id;       // Уникальный идентификатор
  final String name;     // Название предмета
  final WasteType type;  // Тип отходов
  final String emoji;    // Эмодзи для отображения

  const WasteItem({
    required this.id,
    required this.name,
    required this.type,
    required this.emoji,
  });
}

/// Модель информации о корзине
/// Представляет корзину для сбора определенного типа отходов
class BinInfo {
  final WasteType type;           // Тип отходов для корзины
  final String label;             // Название корзины
  final String emoji;            // Эмодзи корзины
  final List<int> gradientColors; // Цвета градиента для UI
  final int bgColor;             // Фоновый цвет

  const BinInfo({
    required this.type,
    required this.label,
    required this.emoji,
    required this.gradientColors,
    required this.bgColor,
  });
}

/// Модель информации о локации
/// Представляет игровую локацию (парк, город, лес)
class LocationInfo {
  final String id;                    // Уникальный ID локации
  final String name;                 // Название
  final String description;          // Описание
  final List<int> gradientColors;   // Цвета градиента кнопки
  final List<int> bgGradientColors; // Цвета фона
  final String emoji;               // Эмодзи

  const LocationInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.gradientColors,
    required this.bgGradientColors,
    required this.emoji,
  });
}

/// Модель цвета грузовика
/// Представляет доступный цвет для кастомизации грузовика
class TruckColor {
  final String id;    // Уникальный ID цвета
  final String label; // Отображаемое название
  final int from;     // Начальный цвет градиента
  final int to;       // Конечный цвет градиента

  const TruckColor({
    required this.id,
    required this.label,
    required this.from,
    required this.to,
  });
}

/// Модель информации о стикере
/// Представляет стикер для украшения грузовика
class StickerInfo {
  final String id;    // Уникальный ID стикера
  final String emoji; // Эмодзи стикера

  const StickerInfo({required this.id, required this.emoji});
}

/// Модель вопроса викторины
/// Представляет один вопрос с вариантами ответов
class QuizQuestion {
  final int id;              // ID вопроса
  final String question;     // Текст вопроса
  final List<String> options; // Варианты ответов
  final int correctAnswer;   // Индекс правильного ответа
  final String explanation; // Объяснение ответа
  final String emoji;       // Эмодзи для вопроса

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.emoji,
  });
}

/// Модель статистики игрока
/// Хранит все игровые достижения и прогресс
class PlayerStats {
  int totalScore;              // Общий счет
  int totalItemsSorted;        // Всего отсортировано предметов
  int accuracy;                // Точность (в процентах)
  List<String> locationsCompleted; // Завершенные локации
  int gamesPlayed;            // Всего сыграно игр
  int bestSpeedScore;         // Лучший счет в скоростной игре
  int bestQuizScore;          // Лучший счет в викторине
  int perfectRounds;          // Количество идеальных раундов

  PlayerStats({
    this.totalScore = 0,
    this.totalItemsSorted = 0,
    this.accuracy = 100,
    List<String>? locationsCompleted,
    this.gamesPlayed = 0,
    this.bestSpeedScore = 0,
    this.bestQuizScore = 0,
    this.perfectRounds = 0,
  }) : locationsCompleted = locationsCompleted ?? [];

  /// Метод для создания копии объекта с измененными полями
  /// Используется для обновления состояния без мутации
  PlayerStats copyWith({
    int? totalScore,
    int? totalItemsSorted,
    int? accuracy,
    List<String>? locationsCompleted,
    int? gamesPlayed,
    int? bestSpeedScore,
    int? bestQuizScore,
    int? perfectRounds,
  }) {
    return PlayerStats(
      totalScore: totalScore ?? this.totalScore,
      totalItemsSorted: totalItemsSorted ?? this.totalItemsSorted,
      accuracy: accuracy ?? this.accuracy,
      locationsCompleted: locationsCompleted ?? this.locationsCompleted,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      bestSpeedScore: bestSpeedScore ?? this.bestSpeedScore,
      bestQuizScore: bestQuizScore ?? this.bestQuizScore,
      perfectRounds: perfectRounds ?? this.perfectRounds,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Static Data - Статические данные (константы)
// ═══════════════════════════════════════════════════════════════════════════

/// Список всех предметов отходов в игре
/// 12 предметов, по 3 на каждый тип
const List<WasteItem> allWaste = [
  WasteItem(id: '1', name: 'Apple Core', type: WasteType.organic, emoji: '🍎'),
  WasteItem(id: '2', name: 'Plastic Bottle', type: WasteType.plastic, emoji: '🍾'),
  WasteItem(id: '3', name: 'Newspaper', type: WasteType.paper, emoji: '📰'),
  WasteItem(id: '4', name: 'Glass Jar', type: WasteType.glass, emoji: '🫙'),
  WasteItem(id: '5', name: 'Banana Peel', type: WasteType.organic, emoji: '🍌'),
  WasteItem(id: '6', name: 'Plastic Bag', type: WasteType.plastic, emoji: '🛍️'),
  WasteItem(id: '7', name: 'Cardboard Box', type: WasteType.paper, emoji: '📦'),
  WasteItem(id: '8', name: 'Glass Bottle', type: WasteType.glass, emoji: '🍶'),
  WasteItem(id: '9', name: 'Orange Peel', type: WasteType.organic, emoji: '🍊'),
  WasteItem(id: '10', name: 'Plastic Cup', type: WasteType.plastic, emoji: '🥤'),
  WasteItem(id: '11', name: 'Magazine', type: WasteType.paper, emoji: '📕'),
  WasteItem(id: '12', name: 'Leaves', type: WasteType.organic, emoji: '🍂'),
];

/// Список корзин для сбора отходов
/// 4 корзины - по одной на каждый тип
const List<BinInfo> bins = [
  BinInfo(
    type: WasteType.organic,
    label: 'Organic',
    emoji: '🌱',
    gradientColors: [0xFF34d399, 0xFF059669],
    bgColor: 0xFF10b981,
  ),
  BinInfo(
    type: WasteType.plastic,
    label: 'Plastic',
    emoji: '♻️',
    gradientColors: [0xFFfbbf24, 0xFFd97706],
    bgColor: 0xFFf59e0b,
  ),
  BinInfo(
    type: WasteType.paper,
    label: 'Paper',
    emoji: '📄',
    gradientColors: [0xFF60a5fa, 0xFF2563eb],
    bgColor: 0xFF3b82f6,
  ),
  BinInfo(
    type: WasteType.glass,
    label: 'Glass',
    emoji: '🫙',
    gradientColors: [0xFFc084fc, 0xFF9333ea],
    bgColor: 0xFFa855f7,
  ),
];

/// Список игровых локаций
/// 3 локации с разными темами
const List<LocationInfo> locations = [
  LocationInfo(
    id: 'park',
    name: 'Sunny Park 🌳',
    description: 'Help clean the beautiful park!',
    gradientColors: [0xFF34d399, 0xFF059669],
    bgGradientColors: [0xFFbbf7d0, 0xFFd1fae5, 0xFFbae6fd],
    emoji: '🌳',
  ),
  LocationInfo(
    id: 'city',
    name: 'Busy City 🏙️',
    description: 'Keep the city streets clean!',
    gradientColors: [0xFF60a5fa, 0xFF2563eb],
    bgGradientColors: [0xFFbfdbfe, 0xFFf1f5f9, 0xFFe2e8f0],
    emoji: '🏙️',
  ),
  LocationInfo(
    id: 'forest',
    name: 'Magic Forest 🌲',
    description: 'Protect the forest wildlife!',
    gradientColors: [0xFF2dd4bf, 0xFF16a34a],
    bgGradientColors: [0xFF86efac, 0xFFccfbf1, 0xFFd1fae5],
    emoji: '🌲',
  ),
];

/// Список доступных цветов для грузовика
const List<TruckColor> truckColors = [
  TruckColor(id: 'green', label: 'Eco Green', from: 0xFF10b981, to: 0xFF059669),
  TruckColor(id: 'blue', label: 'Ocean Blue', from: 0xFF3b82f6, to: 0xFF2563eb),
  TruckColor(id: 'orange', label: 'Sunset Orange', from: 0xFFf97316, to: 0xFFea580c),
  TruckColor(id: 'purple', label: 'Galaxy Purple', from: 0xFFa855f7, to: 0xFF9333ea),
  TruckColor(id: 'red', label: 'Fire Red', from: 0xFFef4444, to: 0xFFdc2626),
  TruckColor(id: 'yellow', label: 'Sunny Yellow', from: 0xFFeab308, to: 0xFFca8a04),
];

/// Список доступных стикеров для грузовика
const List<StickerInfo> stickers = [
  StickerInfo(id: 'star', emoji: '⭐'),
  StickerInfo(id: 'heart', emoji: '❤️'),
  StickerInfo(id: 'leaf', emoji: '🌿'),
  StickerInfo(id: 'recycle', emoji: '♻️'),
  StickerInfo(id: 'earth', emoji: '🌍'),
  StickerInfo(id: 'sun', emoji: '☀️'),
  StickerInfo(id: 'rainbow', emoji: '🌈'),
  StickerInfo(id: 'flower', emoji: '🌸'),
];

/// Список вопросов для эко-викторины
/// 8 вопросов об окружающей среде и переработке
const List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    id: 1,
    question: 'How long does a plastic bottle take to decompose?',
    options: ['1 year', '10 years', '100 years', '450 years'],
    correctAnswer: 3,
    explanation: 'Plastic bottles can take up to 450 years to decompose! That\'s why recycling is so important.',
    emoji: '🧃',
  ),
  QuizQuestion(
    id: 2,
    question: 'Which of these can be composted?',
    options: ['Plastic bags', 'Banana peels', 'Glass jars', 'Metal cans'],
    correctAnswer: 1,
    explanation: 'Banana peels and other organic waste can be composted to make nutrient-rich soil!',
    emoji: '🍌',
  ),
  QuizQuestion(
    id: 3,
    question: 'What color bin is typically used for recycling paper?',
    options: ['Green', 'Blue', 'Yellow', 'Red'],
    correctAnswer: 1,
    explanation: 'Blue bins are commonly used for paper recycling in many places!',
    emoji: '📄',
  ),
  QuizQuestion(
    id: 4,
    question: 'Which uses less energy?',
    options: ['Making new paper', 'Recycling old paper', 'Both the same', 'Neither uses energy'],
    correctAnswer: 1,
    explanation: 'Recycling paper uses 60% less energy than making new paper from trees!',
    emoji: '⚡',
  ),
  QuizQuestion(
    id: 5,
    question: 'What happens to glass when we recycle it?',
    options: ['It goes to landfill', 'It can be melted and reused forever', 'It becomes plastic', 'It disappears'],
    correctAnswer: 1,
    explanation: 'Glass can be recycled infinitely without losing quality! It\'s a super material.',
    emoji: '🫙',
  ),
  QuizQuestion(
    id: 6,
    question: 'Which animal is most affected by ocean plastic?',
    options: ['Dogs', 'Sea turtles', 'Cats', 'Birds'],
    correctAnswer: 1,
    explanation: 'Sea turtles often mistake plastic bags for jellyfish. We can help by reducing plastic use!',
    emoji: '🐢',
  ),
  QuizQuestion(
    id: 7,
    question: 'What does the ♻️ symbol mean?',
    options: ['Throw away', 'Can be recycled', 'Dangerous', 'Keep forever'],
    correctAnswer: 1,
    explanation: 'The recycling symbol means the item can be recycled into new products!',
    emoji: '♻️',
  ),
  QuizQuestion(
    id: 8,
    question: 'Which saves more water?',
    options: ['Taking a bath', 'Taking a short shower', 'Both the same', 'Neither saves water'],
    correctAnswer: 1,
    explanation: 'A short shower uses much less water than filling a bathtub!',
    emoji: '🚿',
  ),
];

// ═══════════════════════════════════════════════════════════════════════════
// Helper Functions - Вспомогательные функции
// ═══════════════════════════════════════════════════════════════════════════

/// Получение уровня питомца на основе счета
/// Уровень от 1 до 5, рассчитывается каждые 1000 очков
int getPetLevel(int score) => (score ~/ 1000 + 1).clamp(1, 5);

/// Получение эмодзи питомца на основе счета
/// Птенцы прогрессируют по мере роста счета
String getPetEmoji(int score) {
  const pets = ['🐣', '🐥', '🐤', '🦜', '🦅'];
  return pets[getPetLevel(score) - 1];
}

/// Перемешивание списка (возвращает копию)
/// Используется для случайного порядка вопросов и предметов
List<T> shuffled<T>(List<T> list) {
  final copy = List<T>.from(list);
  copy.shuffle();
  return copy;
}

/// Получение названия типа отходов
/// Возвращает строку для отображения
String wasteTypeLabel(WasteType t) {
  switch (t) {
    case WasteType.organic:
      return 'Organic';
    case WasteType.plastic:
      return 'Plastic';
    case WasteType.paper:
      return 'Paper';
    case WasteType.glass:
      return 'Glass';
  }
}

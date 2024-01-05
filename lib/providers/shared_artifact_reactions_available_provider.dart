import 'package:flutter_riverpod/flutter_riverpod.dart';

final sharedArtifactsReactionsAvailableProvider =
StateProvider<List<String>>((ref) => [
  "🔖",
  "⭐",
  "🌉",
  "❓"
]);
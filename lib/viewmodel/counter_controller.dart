import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider =
    StateNotifierProvider<CounterController, int>((ref) => CounterController());

class CounterController extends StateNotifier<int> {
  CounterController() : super(0);

  void increment() {
    state = state + 1;
  }
}

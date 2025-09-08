import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}

class DebouncedTextEditingController {
  final Duration debounceDelay;
  final void Function(String value) onChanged;
  final Debouncer _debouncer;

  DebouncedTextEditingController({
    this.debounceDelay = const Duration(milliseconds: 300),
    required this.onChanged,
  }) : _debouncer = Debouncer(delay: debounceDelay);

  void updateValue(String value) {
    _debouncer.call(() => onChanged(value));
  }

  void dispose() {
    _debouncer.dispose();
  }
}

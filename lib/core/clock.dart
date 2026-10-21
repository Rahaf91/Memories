/// Source of "now". Injected so time-driven UI (e.g. letters unlocking) is
/// testable: tests swap in a clock they can move forward.
class Clock {
  const Clock();

  DateTime now() => DateTime.now();
}

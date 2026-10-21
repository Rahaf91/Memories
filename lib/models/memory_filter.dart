/// Filters available on the Memories screen.
enum MemoryFilter {
  all('All'),

  /// Memories friends shared with the user.
  friends('Friends'),

  /// Memories involving other people (any owner).
  shared('Shared'),

  /// Memories that belong to a shared capsule.
  capsules('Capsules');

  const MemoryFilter(this.label);

  final String label;
}

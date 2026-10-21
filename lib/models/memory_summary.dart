/// Aggregate numbers for one month of memories.
class MemorySummary {
  const MemorySummary({
    required this.month,
    required this.memoryCount,
    required this.peopleCount,
    required this.previewImageUrls,
  });

  /// First day of the summarized month.
  final DateTime month;
  final int memoryCount;

  /// Distinct people the user shared memories with that month.
  final int peopleCount;
  final List<String> previewImageUrls;

  factory MemorySummary.fromMap(Map<String, dynamic> map) => MemorySummary(
    month: DateTime.parse(map['month'] as String),
    memoryCount: map['memory_count'] as int,
    peopleCount: map['people_count'] as int,
    previewImageUrls: List<String>.from(map['preview_image_urls'] as List),
  );

  Map<String, dynamic> toMap() => {
    'month': month.toIso8601String(),
    'memory_count': memoryCount,
    'people_count': peopleCount,
    'preview_image_urls': previewImageUrls,
  };
}

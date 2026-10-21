/// The five moods a user can choose from.
///
/// [value] is the stable identifier stored in the database; never rename it.
enum Mood {
  amazing('amazing', 'Happy'), // shown as "Happy"; id kept for stored data
  good('good', 'Good'),
  okay('okay', 'Okay'),
  sad('sad', 'Sad'),
  veryBad('very_bad', 'Very Bad');

  const Mood(this.value, this.label);

  final String value;
  final String label;

  static Mood fromValue(String value) =>
      Mood.values.firstWhere((m) => m.value == value);
}

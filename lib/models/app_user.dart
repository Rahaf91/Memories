/// A person in the app: the signed-in user or one of their friends.
class AppUser {
  const AppUser({required this.id, required this.displayName, this.avatarUrl});

  final String id;
  final String displayName;
  final String? avatarUrl;

  String get firstName => displayName.split(' ').first;

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
    id: map['id'] as String,
    displayName: map['display_name'] as String,
    avatarUrl: map['avatar_url'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'display_name': displayName,
    'avatar_url': avatarUrl,
  };
}

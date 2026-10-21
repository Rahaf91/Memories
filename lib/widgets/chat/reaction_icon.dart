import 'package:flutter/material.dart';

import '../../models/message_reaction.dart';
import '../../models/mood.dart';
import '../common/mood_face.dart';

/// Quiet line icon for a reaction. Faces reuse the app's mood faces, so
/// there are no emoji anywhere.
class ReactionIcon extends StatelessWidget {
  const ReactionIcon({
    super.key,
    required this.type,
    required this.color,
    this.size = 16,
  });

  final ReactionType type;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ReactionType.love => Icon(
        Icons.favorite_rounded,
        size: size,
        color: color,
      ),
      ReactionType.agree => Icon(
        Icons.thumb_up_outlined,
        size: size,
        color: color,
      ),
      ReactionType.haha => MoodFace(
        mood: Mood.amazing,
        color: color,
        size: size,
        showOutline: true,
      ),
      ReactionType.sad => MoodFace(
        mood: Mood.sad,
        color: color,
        size: size,
        showOutline: true,
      ),
    };
  }
}

/// Thrown when a photo couldn't be uploaded.
class MediaUploadException implements Exception {
  const MediaUploadException([this.debugMessage]);

  /// Provider message, for logs only.
  final String? debugMessage;

  @override
  String toString() => 'MediaUploadException($debugMessage)';
}

/// Stores user photos (memories, waiting messages).
///
/// Flow: pick a photo (local file path) → show it immediately via
/// `MediaImage(source: localPath)` → [uploadImage] returns a stored
/// reference (e.g. a private Storage path) that is saved with the record →
/// [displayUrls] turns references back into displayable URLs (signed URLs
/// for private storage) when records are read.
abstract interface class MediaRepository {
  /// Uploads the file at [localPath] into [userId]'s [folder] (e.g.
  /// `memories`) and returns the stored reference. Throws
  /// [MediaUploadException].
  Future<String> uploadImage(
    String localPath, {
    required String userId,
    required String folder,
  });

  /// Displayable URLs for stored references, in the same order. A
  /// reference that can't be resolved maps to null.
  Future<List<String?>> displayUrls(List<String> references);

  /// Removes previously uploaded media (best effort).
  Future<void> deleteImage(String reference);
}

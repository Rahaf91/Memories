import '../repositories/media_repository.dart';

/// Keeps photos on the device: the "stored reference" is the local file
/// path itself. Used in tests and when Supabase isn't configured.
class LocalMediaRepository implements MediaRepository {
  @override
  Future<String> uploadImage(
    String localPath, {
    required String userId,
    required String folder,
  }) async => localPath;

  @override
  Future<List<String?>> displayUrls(List<String> references) async =>
      references;

  @override
  Future<void> deleteImage(String reference) async {}
}

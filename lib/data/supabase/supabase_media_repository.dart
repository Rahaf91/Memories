import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/media_repository.dart';

/// Photos in the private Supabase Storage bucket `memory-photos`.
///
/// Files are stored at `<user id>/<folder>/<file>`; the bucket's policies
/// only let each user read and write inside their own `<user id>/` folder.
/// Records store the path; it's turned into a short-lived signed URL when
/// displayed.
class SupabaseMediaRepository implements MediaRepository {
  SupabaseMediaRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const bucket = 'memory-photos';

  /// How long a signed URL stays valid (records are re-read on refresh).
  static const signedUrlLifetime = Duration(days: 1);

  StorageFileApi get _storage => _client.storage.from(bucket);

  /// `<user id>/<folder>/<timestamp>-<random>.<ext>`
  @visibleForTesting
  static String pathFor({
    required String userId,
    required String folder,
    required String localPath,
    DateTime? now,
    Random? random,
  }) {
    final dot = localPath.lastIndexOf('.');
    final ext = dot >= 0 && dot > localPath.lastIndexOf('/')
        ? localPath.substring(dot + 1).toLowerCase()
        : 'jpg';
    final stamp = (now ?? DateTime.now()).toUtc().millisecondsSinceEpoch;
    final suffix = (random ?? Random.secure())
        .nextInt(1 << 32)
        .toRadixString(36);
    return '$userId/$folder/$stamp-$suffix.$ext';
  }

  static String _contentType(String path) {
    final ext = path.substring(path.lastIndexOf('.') + 1).toLowerCase();
    return switch (ext) {
      'png' => 'image/png',
      'heic' => 'image/heic',
      'heif' => 'image/heif',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/jpeg',
    };
  }

  @override
  Future<String> uploadImage(
    String localPath, {
    required String userId,
    required String folder,
  }) async {
    final path = pathFor(userId: userId, folder: folder, localPath: localPath);
    try {
      await _storage.upload(
        path,
        File(localPath),
        fileOptions: FileOptions(
          contentType: _contentType(path),
          upsert: false,
        ),
      );
      return path;
    } catch (e) {
      throw MediaUploadException('$e');
    }
  }

  @override
  Future<List<String?>> displayUrls(List<String> references) async {
    if (references.isEmpty) return const [];
    // Already a URL (e.g. legacy data): use as is.
    final paths = [
      for (final r in references)
        if (!r.startsWith('http')) r,
    ];
    final signed = <String, String>{};
    if (paths.isNotEmpty) {
      try {
        final results = await _storage.createSignedUrlsResult(
          paths,
          signedUrlLifetime.inSeconds,
        );
        for (final r in results) {
          switch (r) {
            case SignedUrlSuccess(:final path, :final signedUrl):
              signed[path] = signedUrl;
            case SignedUrlFailure(:final path, :final error):
              // Missing/inaccessible file: shown as a neutral placeholder.
              debugPrint('Photo $path unavailable: $error');
          }
        }
      } catch (e) {
        debugPrint('Signing photo URLs failed: $e');
      }
    }
    return [for (final r in references) r.startsWith('http') ? r : signed[r]];
  }

  @override
  Future<void> deleteImage(String reference) async {
    if (reference.startsWith('http')) return;
    try {
      await _storage.remove([reference]);
    } catch (e) {
      debugPrint('Deleting photo failed: $e');
    }
  }
}

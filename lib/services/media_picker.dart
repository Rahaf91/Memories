import 'package:image_picker/image_picker.dart';

/// Picks media from the device. Abstracted so tests (and a future
/// camera/upload flow) can swap the implementation.
abstract interface class MediaPicker {
  /// Lets the user choose a photo. Returns its local file path, or null
  /// if they cancelled.
  Future<String?> pickImage();
}

/// Photo library picker backed by the `image_picker` plugin.
class DeviceMediaPicker implements MediaPicker {
  DeviceMediaPicker([ImagePicker? picker]) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<String?> pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2400,
      imageQuality: 88,
    );
    return file?.path;
  }
}

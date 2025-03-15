import "dart:convert";

import "package:camera/camera.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:image_picker/image_picker.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:dicoding_story_fl/interfaces/libs/widgets.dart";
import "package:dicoding_story_fl/libs/constants.dart";
import "package:dicoding_story_fl/libs/extensions.dart";
import "package:dicoding_story_fl/service_locator.dart";

part "picked_image_provider.g.dart";

@riverpod
class PickedImage extends _$PickedImage {
  final _cacheKey = "providers.picked_image_provider";

  SharedPreferences get _cacheService => ServiceLocator.find();

  @override
  FutureOr<XFile?> build() async {
    return _cachedImage ?? await _imagePickerRecovery();
  }

  XFile? get _cachedImage {
    final cachedImageBytes = _cacheService.getString(_cacheKey);

    if (cachedImageBytes == null) return null;

    final imageBytes = jsonDecode(cachedImageBytes) as List;

    return XFile.fromData(
      Uint8List.fromList(
        imageBytes.map((e) => e is int ? e : int.parse(e)).toList(),
      ),
    );
  }

  set _cachedImage(XFile? value) {
    if (value == null) {
      _cacheService.remove(_cacheKey);

      return;
    }

    Future.microtask(() async {
      _cacheService.setString(
        _cacheKey,
        jsonEncode((await value.readAsBytes()).toList()),
      );
    });
  }

  Future<XFile?> _imagePickerRecovery() async {
    if (defaultTargetPlatform != TargetPlatform.android) return null;

    final response = await ImagePicker().retrieveLostData();

    return response.file;
  }

  Future<XFile?> pickImage(
    // ignore: avoid_build_context_in_providers
    BuildContext context, {
    ImageSource source = ImageSource.gallery,
  }) async {
    state = const AsyncLoading();

    final isRequireCustomCamera = !kIsMobile && source == ImageSource.camera;

    try {
      final image = await (isRequireCustomCamera
          ? showDialog<XFile?>(
              context: context,
              builder: (_) => const _CustomCameraDialog(),
            )
          : ImagePicker().pickImage(source: source, imageQuality: 50));

      if (image == null) return null;

      _cachedImage = image;
      state = AsyncData(image);

      return image;
    } catch (err, trace) {
      final exception = err.toAppException(
        trace: trace,
        message: switch (source) {
          ImageSource.camera => "Camera is not available",
          ImageSource.gallery => "Can't access gallery",
        },
      );

      state = AsyncError(exception, exception.trace ?? trace);

      return null;
    }
  }

  Future<bool> removeCache() => _cacheService.remove(_cacheKey);
}

@riverpod
FutureOr<List<CameraDescription>> _cameras(_CamerasRef ref) {
  return availableCameras();
}

class _CustomCameraDialog extends ConsumerWidget {
  const _CustomCameraDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camerasAsync = ref.watch(_camerasProvider);

    return Dialog.fullscreen(
      child: Column(children: [
        AppBar(leading: const CloseButton()),
        Expanded(
          child: switch (camerasAsync) {
            AsyncData(:final value) => CustomCamera(
                value,
                delegate: const CustomCameraDelegate(enableAudio: false),
                onAcceptResult: (result) => Navigator.maybePop(context, result),
              ),
            AsyncError(:final error) => SizedErrorWidget(
                error: error,
                action: ElevatedButton.icon(
                  onPressed: () => ref.invalidate(_camerasProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh"),
                ),
              ),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ]),
    );
  }
}

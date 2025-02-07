import "dart:convert";

import "package:camera/camera.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:dicoding_story_fl/interfaces/libs/widgets.dart";
import "package:dicoding_story_fl/libs/constants.dart";
import "package:dicoding_story_fl/libs/extensions.dart";
import "package:dicoding_story_fl/service_locator.dart";

import "../libs/types.dart";

/// {@template dicoding_story_fl.interfaces.ux.providers.PickedImageProvider}
/// Picked image from gallery or camera and store it in [value].
/// {@endtemplate}
final class PickedImageProvider extends AsyncValueNotifier<XFile?> {
  /// {@macro dicoding_story_fl.interfaces.ux.providers.PickedImageProvider}
  PickedImageProvider() : super(null) {
    cacheService = ServiceLocator.find<SharedPreferences>();

    final cachedImageBytes = cacheService.getString(cacheKey);

    if (cachedImageBytes != null) {
      final imageBytes = jsonDecode(cachedImageBytes) as List;

      value = XFile.fromData(
        Uint8List.fromList(
          imageBytes.map((e) => e is int ? e : int.parse(e)).toList(),
        ),
      );
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      Future.microtask(() => _retrieveLostData()).then((_) => null);
    }
  }

  @override
  void dispose() {
    cacheService.remove(cacheKey);

    super.dispose();
  }

  late final SharedPreferences cacheService;
  final cacheKey = "providers.picked_image_provider";

  /// Reset [value] to `null`.
  ///
  /// Incase you need it.
  void resetValue() {
    cacheService.remove(cacheKey);
    value = null;
  }

  /// Pick image from gallery or camera.
  ///
  /// For non mobile platform on [ImageSource.camera], this method will show
  /// fullscreen dialog with custom camera support and do the async process
  /// there.
  ///
  /// NOTE: This method will maintain the previous [value] even when you cancel
  /// to re-pick an image. Refer to [resetValue] to set `null` into [value].
  Future<XFile?> pickImage(
    BuildContext context, {
    ImageSource source = ImageSource.gallery,
  }) async {
    isLoading = true;

    if (!kIsMobile && source == ImageSource.camera) {
      final dialogResult = await showDialog<XFile?>(
        context: context,
        builder: (_) => const _CustomCamDialog(),
      );

      if (dialogResult == null) return null;

      cacheService.setString(
        cacheKey,
        jsonEncode((await dialogResult.readAsBytes()).toList()),
      );
      value = dialogResult;

      return dialogResult;
    }

    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 50,
      );

      if (image == null) return null;

      cacheService.setString(
        cacheKey,
        jsonEncode((await image.readAsBytes()).toList()),
      );
      value = image;

      return image;
    } catch (err, trace) {
      final exception = err.toAppException(
        message: switch (source) {
          ImageSource.camera => "Camera is not available",
          ImageSource.gallery => "Can't access gallery",
        },
        trace: trace,
      );

      kLogger.e(
        "PickedImageProvider.pickImage",
        error: exception,
        stackTrace: exception.trace,
      );

      setError(exception, exception.trace);

      return null;
    }
  }

  /// `Android` data recovery.
  Future<void> _retrieveLostData() async {
    isLoading = true;

    final LostDataResponse response = await ImagePicker().retrieveLostData();

    if (response.isEmpty) return;

    final file = response.file;

    if (file != null) {
      value = file;
      return;
    }

    final rawException = response.exception;

    if (rawException != null) {
      final exception = rawException.toAppException(trace: StackTrace.current);

      kLogger.w(
        "PickedImageProvider._retrieveLostData",
        error: exception,
        stackTrace: exception.trace,
      );

      setError(exception, exception.trace);
      return;
    }

    isLoading = false;
  }
}

class _CustomCamDialog extends StatefulWidget {
  const _CustomCamDialog();

  @override
  State<_CustomCamDialog> createState() => _CustomCamDialogState();
}

class _CustomCamDialogState extends State<_CustomCamDialog> {
  final Future<List<CameraDescription>> _cameras = availableCameras();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cameras,
      initialData: const <CameraDescription>[],
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final hasError = snapshot.hasError;
        final error = snapshot.error;

        return Dialog.fullscreen(
          child: Column(
            children: [
              AppBar(leading: const CloseButton()),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : hasError
                        ? SizedErrorWidget(
                            error: error.toAppException(
                              message: error is CameraException
                                  ? error.description
                                  : "Camera is not available",
                            ),
                          )
                        : CustomCamera(
                            snapshot.data ?? [],
                            delegate: const CustomCameraDelegate(
                              enableAudio: false,
                            ),
                            onAcceptResult: (result) {
                              Navigator.maybePop(context, result);
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}

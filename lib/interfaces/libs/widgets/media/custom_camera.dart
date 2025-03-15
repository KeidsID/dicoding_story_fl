import "package:camera/camera.dart";
import "package:equatable/equatable.dart";
import "package:fl_utilities/fl_utilities.dart";
import "package:flex_color_scheme/flex_color_scheme.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "package:dicoding_story_fl/interfaces/libs/widgets.dart";
import "package:dicoding_story_fl/libs/constants.dart";
import "package:dicoding_story_fl/libs/extensions.dart";

typedef CustomCameraResultCallback = void Function(XFile result);

/// {@template ds.interfaces.libs.widgets.CustomCamera}
/// Custom camera widget.
///
/// Note that this widget will expand to fill available space. So make sure
/// adjust it's constraints accordingly.
///
/// Video record not supported yet.
/// {@endtemplate}
class CustomCamera extends StatefulWidget {
  /// {@macro ds.interfaces.libs.widgets.CustomCamera}
  CustomCamera(
    this.cameras, {
    super.key,
    this.delegate = const CustomCameraDelegate(),
    this.onAcceptResult,
  }) : assert(cameras.isNotEmpty, "Camera Not Found");

  /// List of available cameras.
  ///
  /// Try fetch it from [availableCameras].
  final List<CameraDescription> cameras;

  /// Camera configuration.
  final CustomCameraDelegate delegate;

  /// Callback when user accept the taken picture.
  final CustomCameraResultCallback? onAcceptResult;

  @override
  State<CustomCamera> createState() => CustomCameraState();
}

class CustomCameraState extends State<CustomCamera>
    with WidgetsBindingObserver {
  // ---------------------------------------------------------------------------
  // WIDGET GETTERS
  // ---------------------------------------------------------------------------

  /// Shorthand for `widget.cameras`.
  List<CameraDescription> get cameras => widget.cameras;

  /// Shorthand for `widget.delegate`.
  CustomCameraDelegate get delegate => widget.delegate;

  /// Shorthand for `widget.onAcceptResult`.
  CustomCameraResultCallback? get onAcceptResult => widget.onAcceptResult;

  // ---------------------------------------------------------------------------
  // STATES AND METHODS
  // ---------------------------------------------------------------------------

  /// The actual [controller].
  ///
  /// Use [setController] to initialize it.
  CameraController? _controller;

  /// Controller for camera widget.
  ///
  /// Initialize it with [setController] method.
  CameraController? get controller => _controller;

  /// [CameraDescription] from [controller].
  CameraDescription? get selectedCamera => controller?.description;

  /// Indicates [controller] is initialized and ready to use.
  bool get isCameraInitialized => controller?.value.isInitialized ?? false;

  /// Indicates [controller] is switching camera. Don't misinterpret this as
  /// a condition that the camera has been switched.
  ///
  /// Triggered by [setController] method.
  bool isSwitchingCam = false;

  Object? _error;
  StackTrace? _trace;

  /// Error that may occur when initializing camera.
  Object? get error => _error;

  /// [error] trace.
  StackTrace? get trace => _trace;

  /// Set [controller]. Will [setState] if [mounted].
  ///
  /// If [camera] already used, then won't do anything.
  Future<void> setController(CameraDescription camera) async {
    if (selectedCamera == camera && error == null) return;

    final newController = CameraController(
      camera,
      delegate.resolutionPreset,
      enableAudio: delegate.enableAudio,
      imageFormatGroup: delegate.imageFormatGroup,
    );

    void preProcess() {
      isSwitchingCam = true;
      _error = null;
      _trace = null;
    }

    (mounted) ? setState(preProcess) : preProcess();

    try {
      // for debugging camera switching
      if (kDebugMode) await Future.delayed(const Duration(seconds: 1));

      await newController.initialize();
      await controller?.dispose();

      void postProcess() {
        _controller = newController;
        isSwitchingCam = false;
      }

      (mounted) ? setState(postProcess) : postProcess();
    } catch (err, trace) {
      // dispose [newController] on error.
      newController.dispose();

      String? msg;

      if (err is CameraException) {
        msg = err.description ?? "Failed to initialize camera";
      }

      final exception = err.toAppException(message: msg, trace: trace);

      kLogger.e(
        "CustomCameraState.setController",
        error: exception,
        stackTrace: exception.trace,
      );

      void errorPostProcess() {
        isSwitchingCam = false;
        _error = exception;
        _trace = exception.trace;
      }

      (mounted) ? setState(errorPostProcess) : errorPostProcess();
    }
  }

  /// File result from camera capture/recording.
  ///
  /// Video are not supported yet.
  XFile? cameraResult;

  /// Take picture from camera.
  ///
  /// Success take will stored in [cameraResult].
  Future<XFile?> takePicture() async {
    try {
      final image = await controller?.takePicture();

      if (image == null) return null;

      setState(() => cameraResult = image);
      return image;
    } on CameraException catch (err, trace) {
      final exception = err.toAppException(
        message: err.description ?? "Failed to take picture",
        trace: trace,
      );

      kLogger.e(
        "CustomCameraState.takePicture",
        error: exception,
        stackTrace: exception.trace,
      );

      return null;
    }
  }

  /// Switch camera. Suitable when there are two [cameras]
  /// (Commonly on mobile to switch between front and back camera).
  ///
  /// For more switching methods, try use [DropdownButton] with
  /// [setController].
  Future<void> switchCamera() async {
    if (cameras.length != 2) return;

    if (controller?.description == cameras.first) {
      setController(cameras[1]);
    } else {
      setController(cameras.first);
    }
  }

  // ---------------------------------------------------------------------------
  // DESCRIBE
  // ---------------------------------------------------------------------------

  Widget _buildCameraWidget(BuildContext context) {
    final theme = context.theme;
    final textTheme = theme.textTheme;

    final isSwitchCamDisable = cameras.length < 2 && isCameraInitialized;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: double.infinity,
            color: theme.scaffoldBackgroundColor,
            child: isCameraInitialized && !isSwitchingCam
                ? controller?.buildPreview()
                : error != null
                    ? SizedErrorWidget.expand(error: error, trace: trace)
                    : Center(
                        child: cameras.isEmpty
                            ? Text(
                                "Camera Not Found",
                                style: textTheme.headlineMedium,
                              )
                            : const CircularProgressIndicator(),
                      ),
          ),
        ),
        //
        Container(
          height: double.infinity,
          padding: const EdgeInsets.all(16.0),
          color: theme.cardColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MenuAnchor(
                menuChildren: cameras.map((e) {
                  return MenuItemButton(
                    onPressed: () => setController(e),
                    child: Text(
                      '${e.lensDirection.name.capitalize} Camera - ${e.name.split('<').first}',
                    ),
                  );
                }).toList(),
                builder: (context, menu, _) => IconButton(
                  tooltip: "Switch Camera",
                  onPressed: isSwitchCamDisable
                      ? null
                      : () => menu.isOpen ? menu.close() : menu.open(),
                  icon: const Icon(Icons.cameraswitch_outlined),
                ),
              ),
              //
              IconButton.filledTonal(
                iconSize: 48.0,
                tooltip: "Take Picture",
                onPressed: () => takePicture(),
                icon: const Icon(Icons.camera_alt_outlined),
              ),
              //
              const IconButton(
                onPressed: null,
                icon: Icon(Icons.settings_outlined),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!isCameraInitialized) return;

    switch (state) {
      case AppLifecycleState.inactive:
        controller?.dispose();
        break;
      case AppLifecycleState.resumed:
        if (selectedCamera != null) setController(selectedCamera!);
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    if (cameras.isNotEmpty) setController(cameras.first);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    if (cameraResult == null) return _buildCameraWidget(context);

    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: ImageFromXFile(cameraResult!, fit: BoxFit.cover),
          ),
        ),
        Container(
          width: 600.0,
          height: kToolbarHeight,
          color: theme.cardColor,
          child: Row(
            children: <Widget>[
              TextButton(
                onPressed: () => setState(() => cameraResult = null),
                child: const Text("Retry"),
              ),
              TextButton(
                onPressed: () => onAcceptResult?.call(cameraResult!),
                child: const Text("Ok"),
              ),
            ].map((e) => Expanded(child: e)).toList(),
          ),
        ),
      ],
    );
  }
}

/// {@template ds.interfaces.libs.widgets.CustomCameraDelegate}
/// Camera configuration.
/// {@endtemplate}
class CustomCameraDelegate extends Equatable {
  /// {@macro ds.interfaces.libs.widgets.CustomCameraDelegate}
  const CustomCameraDelegate({
    this.resolutionPreset = ResolutionPreset.medium,
    this.enableAudio = true,
    this.imageFormatGroup,
  });

  /// Affect the quality of video recording and image capture:
  ///
  /// A preset is treated as a target resolution, and exact values are not
  /// guaranteed. Platform implementations may fall back to a higher or lower
  /// resolution if a specific preset is not available.
  final ResolutionPreset resolutionPreset;

  /// Whether to include audio when recording a video.
  final bool enableAudio;

  /// The [ImageFormatGroup] describes the output of the raw image format.
  ///
  /// When null the imageFormat will fallback to the platforms default.
  final ImageFormatGroup? imageFormatGroup;

  @override
  List<Object?> get props => [resolutionPreset, enableAudio, imageFormatGroup];
}

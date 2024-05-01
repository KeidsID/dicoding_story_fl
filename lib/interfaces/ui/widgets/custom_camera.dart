import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_utilities/fl_utilities.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dicoding_story_fl/common/constants.dart';
import 'package:dicoding_story_fl/common/utils.dart';
import 'package:dicoding_story_fl/interfaces/ui.dart';

typedef CustomCameraResultCallback = void Function(XFile result);

/// {@template dicoding_story_fl.interfaces.ui.CustomCameraDelegate}
/// Camera configuration.
/// {@endtemplate}
class CustomCameraDelegate extends Equatable {
  /// {@macro dicoding_story_fl.interfaces.ui.CustomCameraDelegate}
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

/// {@template dicoding_story_fl.interfaces.ui.CustomCamera}
/// Custom camera widget.
///
/// Note that this widget will expand to fill available space. So make sure
/// adjust it's constraints accordingly.
///
/// Video record not supported yet.
/// {@endtemplate}
class CustomCamera extends StatefulWidget {
  /// {@macro dicoding_story_fl.interfaces.ui.CustomCamera}
  CustomCamera(
    this.cameras, {
    super.key,
    this.delegate = const CustomCameraDelegate(),
    this.onAcceptResult,
  }) : assert(cameras.isNotEmpty, 'Camera Not Found');

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

  CameraController? _camController;

  /// Controller for camera widget.
  ///
  /// Initialize it with [setCamController] method.
  CameraController? get camController => _camController;

  /// [CameraDescription] from [camController].
  CameraDescription? get selectedCam => camController?.description;

  /// Indicates [camController] is initialized and ready to use.
  bool get isCamInitialized => camController?.value.isInitialized ?? false;

  /// Indicates [camController] is switching camera. Don't misinterpret this as
  /// a condition that the camera has been switched.
  ///
  /// Triggered by [setCamController] method.
  bool isSwitchingCam = false;

  Object? _error;
  StackTrace? _trace;

  /// Error that may occur when initializing camera.
  Object? get error => _error;

  /// [error] trace.
  StackTrace? get trace => _trace;

  /// Set [camController]. Will [setState] if [mounted].
  ///
  /// If [camera] already used, then won't do anything.
  Future<void> setCamController(CameraDescription camera) async {
    if (selectedCam == camera && error == null) return;

    final newController = CameraController(
      camera,
      delegate.resolutionPreset,
      enableAudio: delegate.enableAudio,
      imageFormatGroup: delegate.imageFormatGroup,
    );

    void initProcess() {
      isSwitchingCam = true;
      _error = null;
      _trace = null;
    }

    (mounted) ? setState(initProcess) : initProcess();

    try {
      // for debugging camera switching
      if (kDebugMode) await Future.delayed(const Duration(seconds: 1));

      await newController.initialize();
      await camController?.dispose();

      void postProcess() {
        _camController = newController;
        isSwitchingCam = false;
      }

      (mounted) ? setState(postProcess) : postProcess();
    } catch (err, trace) {
      // dispose [newController] on error.
      newController.dispose();

      late final String? msg;

      if (err is CameraException) {
        msg = err.description ?? 'Failed to initialize camera';
      }

      final exception = err.toSimpleException(message: msg, trace: trace);

      kLogger.e(
        'CustomCameraWidgetState.setCamController',
        error: exception,
        stackTrace: exception.trace,
      );

      void postProcess() {
        isSwitchingCam = false;
        _error = exception;
        _trace = exception.trace;
      }

      (mounted) ? setState(postProcess) : postProcess();
    }
  }

  /// File result from camera capture/recording.
  ///
  /// Video are not supported yet.
  XFile? camResult;

  /// Take picture from camera.
  ///
  /// Success take will stored in [camResult].
  Future<XFile?> takePicture() async {
    try {
      final image = await camController?.takePicture();

      if (image == null) return null;

      setState(() => camResult = image);
      return image;
    } on CameraException catch (err, trace) {
      final exception = err.toSimpleException(
        message: err.description ?? 'Failed to take picture',
        trace: trace,
      );

      kLogger.e(
        'CustomCameraWidgetState.takePicture',
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
  /// [setCamController].
  Future<void> switchCam() async {
    if (cameras.length != 2) return;

    if (camController?.description == cameras.first) {
      setCamController(cameras[1]);
    } else {
      setCamController(cameras.first);
    }
  }

  // ---------------------------------------------------------------------------
  // DESCRIBE
  // ---------------------------------------------------------------------------

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!isCamInitialized) return;

    switch (state) {
      case AppLifecycleState.inactive:
        camController?.dispose();
        break;
      case AppLifecycleState.resumed:
        if (selectedCam != null) setCamController(selectedCam!);
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    if (cameras.isNotEmpty) setCamController(cameras.first);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    camController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textTheme = theme.textTheme;

    final isSwitchCamDisable = cameras.length < 2 && isCamInitialized;

    return camResult != null
        ? Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ImageFromXFile(camResult!, fit: BoxFit.cover),
                ),
              ),
              Container(
                width: 600.0,
                height: kToolbarHeight,
                color: theme.cardColor,
                child: Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () => setState(() => camResult = null),
                      child: const Text('Retry'),
                    ),
                    TextButton(
                      onPressed: () => onAcceptResult?.call(camResult!),
                      child: const Text('Ok'),
                    ),
                  ].map((e) => Expanded(child: e)).toList(),
                ),
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  color: theme.scaffoldBackgroundColor,
                  child: isCamInitialized && !isSwitchingCam
                      ? camController?.buildPreview()
                      : error != null
                          ? SizedErrorWidget.expand(error: error, trace: trace)
                          : Center(
                              child: cameras.isEmpty
                                  ? Text(
                                      'Camera Not Found',
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
                          onPressed: () => setCamController(e),
                          child: Text(
                            '${e.lensDirection.name.capitalize} Camera - ${e.name.split('<').first}',
                          ),
                        );
                      }).toList(),
                      builder: (context, menu, _) => IconButton(
                        tooltip: 'Switch Camera',
                        onPressed: isSwitchCamDisable
                            ? null
                            : () => menu.isOpen ? menu.close() : menu.open(),
                        icon: const Icon(Icons.cameraswitch_outlined),
                      ),
                    ),
                    //
                    IconButton.filledTonal(
                      iconSize: 48.0,
                      tooltip: 'Take Picture',
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
}

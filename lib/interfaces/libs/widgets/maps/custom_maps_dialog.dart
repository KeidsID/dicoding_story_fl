import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/interfaces/libs/constants.dart";
import "package:dicoding_story_fl/interfaces/libs/l10n.dart";
import "package:dicoding_story_fl/interfaces/libs/widgets.dart";
import "package:dicoding_story_fl/libs/constants.dart";
import "package:dicoding_story_fl/service_locator.dart";
import "package:dicoding_story_fl/use_cases.dart";

/// A fullscreen custom Google Maps dialog that return [LocationData] on
/// location confirmation.
class CustomMapsDialog extends StatefulWidget {
  const CustomMapsDialog({
    super.key,
    this.initialLocation,
    this.title,
    this.readonly = false,
  });

  final LocationData? initialLocation;

  /// Dialog title.
  ///
  /// Only used when [readonly] is `false`.
  final String? title;

  /// Dialog is readonly and won't return any value on [Navigator.pop].
  ///
  /// Useful for displaying [initialLocation].
  final bool readonly;

  @override
  State<CustomMapsDialog> createState() => _CustomMapsDialogState();
}

class _CustomMapsDialogState extends State<CustomMapsDialog> {
  LocationData? get initialLocation => widget.initialLocation;
  String? get title => widget.title;
  bool get readonly => widget.readonly;

  /// Value to return on location confirmation.
  LocationData? location;

  /// Act as value store for [FutureBuilder].
  ///
  /// For the actual fetch, refer to [_fetchInitLocation].
  late Future<LocationData> _fetchInitLocationValue;
  Future<LocationData> _fetchInitLocation() async {
    if (initialLocation != null) return initialLocation!;

    return ServiceLocator.find<GetLocationUseCase>().execute(null);
  }

  GoogleMapController? _mapController;
  late CameraPosition _mapCam;

  bool _isFetchingMapLocation = true;

  /// Current map location.
  ///
  /// Updated on camera move, but did'nt trigger widget rebuild.
  LocationData get _currentLocation {
    final location = _mapCam.target;

    return LocationData(location.latitude, location.longitude);
  }

  /// Fetched map location on map camera idle.
  ///
  /// Used to prevent re-fetching [location] detail on map idle.
  late LocationData _fetchedLocation;

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
  // GOOGLE MAP CALLBACKS
  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

  void _onMapCamMoveStart() {
    setState(() => _isFetchingMapLocation = true);
  }

  void _onMapCamMove(cam) => _mapCam = cam;

  Future<void> _onMapCamIdle() async {
    if (location != null) {
      if (_fetchedLocation == _currentLocation) {
        setState(() => _isFetchingMapLocation = false);
        return;
      }
    }

    try {
      location = await ServiceLocator.find<ReverseGeocodingUseCase>()
          .execute(ReverseGeocodingRequestDto(
        _currentLocation.latitude,
        _currentLocation.longitude,
        includeDisplayName: true,
      ));
    } catch (err, trace) {
      kLogger.w(
        "Reverse Geocoding Fail",
        error: err,
        stackTrace: trace,
      );

      location = _currentLocation;
    } finally {
      setState(() {
        _isFetchingMapLocation = false;
        _fetchedLocation = _currentLocation;
      });
    }
  }

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
  // CUSTOM MAP ACTION
  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

  Future<void> _onLocationTap() async {
    final location =
        await ServiceLocator.find<GetLocationUseCase>().execute(null);

    await _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(location.latitude, location.longitude)),
    );
  }

  void _onMapZoomInTap() =>
      _mapController?.animateCamera(CameraUpdate.zoomIn());

  void _onMapZoomOutTap() =>
      _mapController?.animateCamera(CameraUpdate.zoomOut());

  /// Move map camera to [initialLocation].
  void _animateMapCameraToInitLocation() {
    if (initialLocation == null) return;

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(initialLocation!.latitude, initialLocation!.longitude),
      ),
    );
  }

  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
  // DESCRIBE
  // -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

  @override
  void initState() {
    super.initState();

    _fetchInitLocationValue = _fetchInitLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final appL10n = AppL10n.of(context)!;

    return Dialog.fullscreen(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // maps
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // map
                    ColoredBox(
                      color: theme.scaffoldBackgroundColor,
                      child: FutureBuilder(
                        future: _fetchInitLocationValue,
                        builder: (context, snapshot) {
                          final initLocation = snapshot.data;

                          if (initLocation == null) {
                            if (snapshot.hasError) {
                              return SizedErrorWidget(
                                error: snapshot.error,
                                trace: snapshot.stackTrace,
                                action: ElevatedButton(
                                  onPressed: () => setState(() {
                                    _fetchInitLocationValue =
                                        _fetchInitLocation();
                                  }),
                                  child: const Text("Retry"),
                                ),
                              );
                            }

                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final initMapCam = CameraPosition(
                            target: LatLng(
                              initLocation.latitude,
                              initLocation.longitude,
                            ),
                            zoom: 20,
                          );

                          return GoogleMap(
                            initialCameraPosition: initMapCam,
                            onMapCreated: (controller) => setState(() {
                              _mapController = controller;
                              _mapCam = initMapCam;
                              _fetchedLocation = _currentLocation;
                              _onMapCamIdle();
                            }),
                            onCameraMoveStarted: _onMapCamMoveStart,
                            onCameraMove: _onMapCamMove,
                            onCameraIdle: _onMapCamIdle,
                            style: context.theme.brightness == Brightness.dark
                                ? kDarkGoogleMapsStyle
                                : null,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                          );
                        },
                      ),
                    ),

                    // map marker
                    if (_mapController != null) ...[
                      Center(
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: colorScheme.primary,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isFetchingMapLocation
                              ? SizedBox.square(
                                  dimension: 20.0,
                                  child: CircularProgressIndicator(
                                    color: colorScheme.primary,
                                  ),
                                )
                              : Icon(
                                  Icons.place,
                                  size: 40.0,
                                  color: colorScheme.primary,
                                ),
                          const SizedBox(height: 56.0),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // filler for missing sheet space on shrink.
              Container(height: kToolbarHeight, color: theme.cardColor),
            ],
          ),

          // dialog actions and confirmation sheet
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // dialog actions
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton.filledTonal(
                        onPressed: () =>
                            Navigator.pop(context, initialLocation),
                        icon: const Icon(Icons.close),
                        tooltip: MaterialLocalizations.of(context)
                            .closeButtonTooltip,
                      ),
                      //

                      AnimatedCrossFade(
                        duration: Durations.medium1,
                        crossFadeState: switch (_mapController) {
                          null => CrossFadeState.showFirst,
                          _ => CrossFadeState.showSecond,
                        },
                        firstChild: const SizedBox.shrink(),
                        secondChild: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (readonly)
                              IconButton.filledTonal(
                                onPressed: _animateMapCameraToInitLocation,
                                icon: const Icon(Icons.restore),
                                tooltip: MaterialLocalizations.of(context)
                                    .refreshIndicatorSemanticLabel,
                              ),
                            if (!readonly)
                              IconButton.filledTonal(
                                onPressed: _onLocationTap,
                                icon: const Icon(Icons.gps_fixed),
                                tooltip: appL10n.deviceLocation,
                              ),
                            if (!kIsNativeMobile) ...[
                              const SizedBox(height: 8.0),
                              IconButton.filledTonal(
                                onPressed: _onMapZoomInTap,
                                icon: const Icon(Icons.zoom_in),
                                tooltip: appL10n.zoomIn,
                              ),
                              const SizedBox(height: 8.0),
                              IconButton.filledTonal(
                                onPressed: _onMapZoomOutTap,
                                icon: const Icon(Icons.zoom_out),
                                tooltip: appL10n.zoomOut,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // confirmation sheet
              AnimatedSize(
                duration: Durations.medium1,
                curve: Curves.easeInOutSine,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          readonly
                              ? title ?? appL10n.location
                              : appL10n.setLocation,
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      // location details
                      if (_isFetchingMapLocation)
                        const Center(child: CircularProgressIndicator()),
                      if (!_isFetchingMapLocation) ...[
                        ListTile(
                          leading: const Icon(Icons.place_outlined),
                          title: Text(
                            location?.displayName ??
                                location?.latLon ??
                                _currentLocation.latLon,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: location != null
                              ? Text(
                                  location?.address ??
                                      _currentLocation.address ??
                                      "Unknown Address",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null,
                        ),
                        if (!readonly) ...[
                          const SizedBox(height: 8.0),
                          Align(
                            alignment: Alignment.center,
                            child: FilledButton(
                              onPressed: () => Navigator.pop(context, location),
                              child: Text(appL10n.confirm),
                            ),
                          )
                        ]
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

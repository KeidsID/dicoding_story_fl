import "package:dicoding_story_fl/interfaces/libs/l10n.dart";
import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/interfaces/libs/widgets.dart";
import "package:dicoding_story_fl/libs/constants.dart";
import "package:dicoding_story_fl/libs/extensions.dart";
import "package:dicoding_story_fl/service_locator.dart";
import "package:dicoding_story_fl/use_cases.dart";

/// A fullscreen dialog that return [LocationData] on location selection.
///
/// Usecase:
/// ```dart
/// Builder(builder: (context) {
///   return ElevatedButton(
///     onPressed: () async {
///       final locationResult = await showDialog<LocationData?>(
///         context: context,
///         builder: (_) => const PickLocationDialog(),
///       )
///
///       debugPrint('${locationResult?.address}');
///     },
///     child: const Text('Set Location'),
///   );
/// });
/// ```
class GetLocationDialog extends StatefulWidget {
  const GetLocationDialog({super.key, this.initialLocation});

  final LocationData? initialLocation;

  @override
  State<GetLocationDialog> createState() => _GetLocationDialogState();
}

class _GetLocationDialogState extends State<GetLocationDialog> {
  LocationData? get initialLocation => widget.initialLocation;

  /// Indicate if the dialog is searching a place.
  bool _isSearching = false;
  final List<LocationData> _searchResults = [];

  /// Indicate if the dialog has searched a place at least once.
  bool _hasSearchedPlace = false;

  AppException? _searchError;

  late final TextEditingController _searchController;

  /// Search place by [query] and store the results in [_searchResults].
  ///
  /// [query] can be an address, place name, states, etc.
  Future<void> _handleSearchPlace(String query) async {
    if (_isSearching) return;

    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    try {
      _searchResults.clear();
      _searchResults.addAll(await ServiceLocator.find<SearchPlaceUseCase>()
          .execute(SearchPlaceRequestDto(
        query,
      )));
    } catch (error, trace) {
      _searchError = error.toAppException(trace: trace);

      kLogger.w(error, error: error, stackTrace: trace);
    } finally {
      setState(() {
        if (!_hasSearchedPlace) _hasSearchedPlace = true;
        _isSearching = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController(
      text: initialLocation?.displayName ??
          initialLocation?.address ??
          initialLocation?.latLon,
    );
    if (initialLocation != null) _searchResults.add(initialLocation!);
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appL10n = AppL10n.of(context)!;

    return Dialog.fullscreen(
      child: Column(
        children: [
          AppBar(
            leading: CloseButton(
              onPressed: () => Navigator.pop(context, initialLocation),
            ),
            title: Text(appL10n.setLocation),
          ),
          SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 800.0,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: appL10n.searchLocationHint,
                      ),
                      onChanged: (String text) async {
                        if (text.length < 3) return;

                        await _handleSearchPlace(text);
                      }.debounce(delay: Durations.long2),
                    ),
                    const SizedBox(height: 8.0),
                    Builder(builder: (context) {
                      return FilledButton.tonalIcon(
                        onPressed: () async {
                          final customMapsDialogResult =
                              await showDialog<LocationData?>(
                            context: context,
                            builder: (_) => CustomMapsDialog(
                              initialLocation: initialLocation,
                            ),
                          );

                          if (customMapsDialogResult != null) return;
                          if (customMapsDialogResult == initialLocation) return;

                          if (context.mounted) {
                            Navigator.pop(context, customMapsDialogResult);
                          }
                        },
                        icon: const Icon(Icons.map_outlined),
                        label: Text(appL10n.setFromMap),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _isSearching
                ? const SizedBox(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _hasSearchedPlace && _searchResults.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0).copyWith(top: 0),
                        child: SizedErrorWidget(
                          error: _searchError ??
                              AppException(
                                name: appL10n.searchLocationErrorTitle,
                                message: appL10n.searchLocationErrorMessage,
                              ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final location = _searchResults[index];

                          return ListTile(
                            leading: const Icon(Icons.place_outlined),
                            title: Text(
                              location.displayName ?? location.latLon,
                            ),
                            subtitle: Text(
                              location.address ?? "-",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => Navigator.pop(context, location),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

import 'package:fl_utilities/fl_utilities.dart';
import 'package:flutter/material.dart';

import 'package:dicoding_story_fl/common/constants.dart';
import 'package:dicoding_story_fl/common/utils.dart';
import 'package:dicoding_story_fl/container.dart' as container;
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/use_cases.dart';
import 'package:dicoding_story_fl/interfaces/ui.dart';

/// A fullscreen dialog that return [LocationCore] on location selection.
///
/// Usecase:
/// ```dart
/// Builder(builder: (context) {
///   return ElevatedButton(
///     onPressed: () async {
///       final locationResult = await showDialog<LocationCore?>(
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
  const GetLocationDialog({super.key});

  @override
  State<GetLocationDialog> createState() => _GetLocationDialogState();
}

class _GetLocationDialogState extends State<GetLocationDialog> {
  /// Indicate if the dialog is searching a place.
  bool _isSearching = false;
  final List<LocationCore> _searchResults = [];

  /// Indicate if the dialog has been search place once.
  bool _isSearchPlaceOnce = false;

  SimpleException? _searchError;

  final _searchController = TextEditingController();

  /// Search place by [query] and store the results in [_searchResults].
  ///
  /// [query] can be an address, place name, states, etc.
  Future<void> _searchPlace(String query) async {
    if (_isSearching) return;

    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    try {
      _searchResults.clear();
      _searchResults
          .addAll(await container.get<SearchPlaceCase>().execute(query));
    } catch (err, trace) {
      _searchError = err is SimpleHttpException
          ? err
          : err.toSimpleException(
              message: 'Make sure you have a good internet connection. '
                  'If the problem persists, please contact us',
              trace: trace,
            );

      kLogger.w('Search Place Fail', error: err, stackTrace: trace);
    } finally {
      setState(() {
        if (!_isSearchPlaceOnce) _isSearchPlaceOnce = true;
        _isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Column(
        children: [
          AppBar(
            leading: const CloseButton(),
            title: const Text('Set Location'),
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
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Place name, address, or description',
                      ),
                      onChanged: (String text) async {
                        if (text.length < 3) return;

                        await _searchPlace(text);
                      }.debounce(delay: Durations.extralong4),
                    ),
                    const SizedBox(height: 8.0),
                    FilledButton.tonalIcon(
                      onPressed: () async {
                        final gmapResult = await showDialog(
                          context: context,
                          builder: (_) => const CustomGMapsDialog(),
                        );

                        if (gmapResult == null) return;

                        if (context.mounted) {
                          Navigator.maybePop(context, gmapResult);
                        }
                      },
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Set from Map'),
                    ),
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
                : _isSearchPlaceOnce && _searchResults.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0).copyWith(top: 0),
                        child: SizedErrorWidget(
                          error: _searchError ??
                              const SimpleException(
                                name: 'No Results Found',
                                message:
                                    'Make sure you didn\'t misspell anything, '
                                    'or have a good internet connection.',
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
                              location.displayNameOrNull ?? location.latlng,
                            ),
                            subtitle: Text(
                              location.placeDetail?.address ??
                                  '${location.lat}, ',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => Navigator.maybePop(context, location),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
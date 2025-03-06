import "package:fl_utilities/fl_utilities.dart";
import "package:flex_color_scheme/flex_color_scheme.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:image_picker/image_picker.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/interfaces/libs/constants.dart";
import "package:dicoding_story_fl/interfaces/libs/extensions.dart";
import "package:dicoding_story_fl/interfaces/libs/l10n.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";
import "package:dicoding_story_fl/interfaces/libs/widgets.dart";
import "package:dicoding_story_fl/interfaces/modules.dart";
import "package:dicoding_story_fl/libs/constants.dart";
import "package:dicoding_story_fl/libs/extensions.dart";

/// [PostStoryRoute] build decorator.
const postStoryRouteBuild = TypedGoRoute<PostStoryRoute>(
  path: StoriesRoutePaths.post,
);

final class PostStoryRoute extends GoRouteData {
  const PostStoryRoute([this.description]);

  final String? description;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _PostStoryRouteScreen(description);
  }
}

class _PostStoryRouteScreen extends ConsumerStatefulWidget {
  const _PostStoryRouteScreen([this.description]);

  final String? description;

  @override
  ConsumerState<_PostStoryRouteScreen> createState() =>
      _PostStoryRouteScreenState();
}

class _PostStoryRouteScreenState extends ConsumerState<_PostStoryRouteScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _descriptionController;
  LocationData? _locationData;

  PickedImage get pickedImageProviderNotifier =>
      ref.read(pickedImageProvider.notifier);
  Stories get storiesProviderNotifier => ref.read(storiesProvider.notifier);

  VoidCallback _handleRepickImage(BuildContext context) {
    return () async {
      await showDialog(
        context: context,
        builder: (context) {
          final appL10n = AppL10n.of(context)!;

          return AlertDialog(
            title: Text("${appL10n.replaceImage}?"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${appL10n.from}:"),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        final img = await pickedImageProviderNotifier
                            .pickImage(context);

                        if (img == null) return;

                        if (context.mounted) Navigator.maybePop(context);
                      },
                      icon: const Icon(Icons.image_outlined),
                      label: Text(appL10n.gallery),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final img = await pickedImageProviderNotifier.pickImage(
                          context,
                          source: ImageSource.camera,
                        );

                        if (img == null) return;

                        if (context.mounted) Navigator.maybePop(context);
                      },
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: Text(appL10n.camera),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.maybePop(context),
                child: Text(
                  MaterialLocalizations.of(context)
                      .cancelButtonLabel
                      .capitalize,
                ),
              ),
            ],
          );
        },
      );
    };
  }

  VoidCallback _handlePostStory(BuildContext context) {
    return () async {
      final pickedImage = ref.read(pickedImageProvider).valueOrNull;

      if (pickedImage == null) return;

      try {
        if (!(_formKey.currentState?.validate() ?? false)) return;

        await storiesProviderNotifier.postStory(
          description: _descriptionController.text,
          imageBytes: await pickedImage.readAsBytes(),
          imageFilename: pickedImage.name,
          lat: _locationData?.latitude,
          lon: _locationData?.longitude,
        );

        if (context.mounted) {
          pickedImageProviderNotifier.removeCache();

          context.pop();
        }
      } catch (err, trace) {
        final exception = err.toAppException(trace: trace);

        kLogger.w(
          "On Post Story",
          error: exception,
          stackTrace: exception.trace,
        );

        if (context.mounted) {
          context.scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(exception.message),
          ));
        }
      }
    };
  }

  VoidCallback _handleLocationSet(BuildContext context) {
    return () async {
      final result = await showDialog<LocationData?>(
        context: context,
        builder: (_) => GetLocationDialog(initialLocation: _locationData),
      );

      if (result == null) return;

      setState(() => _locationData = result);
    };
  }

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey();
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appL10n = AppL10n.of(context)!;

    final pickedImageAsync = ref.watch(pickedImageProvider);
    final storiesAsync = ref.watch(storiesProvider);

    final pickedImage = pickedImageAsync.valueOrNull;
    final isLoading = pickedImageAsync.isLoading || storiesAsync.isLoading;

    if (pickedImage == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              appL10n.pickAnImageForYourStory,
              style: context.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8.0),

            //
            Expanded(
              child: Builder(builder: (context) {
                final labelStyle = context.textTheme.titleMedium;
                const iconSize = 32.0;

                return Row(
                  children: [
                    Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: isLoading
                            ? null
                            : () =>
                                pickedImageProviderNotifier.pickImage(context),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(appL10n.fromGallery, style: labelStyle),
                              const Icon(
                                Icons.image_outlined,
                                size: iconSize,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //
                    Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: isLoading
                            ? null
                            : () => pickedImageProviderNotifier.pickImage(
                                  context,
                                  source: ImageSource.camera,
                                ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(appL10n.fromCamera, style: labelStyle),
                              const Icon(
                                Icons.camera_alt_outlined,
                                size: iconSize,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ].map((e) => Expanded(child: e)).toList(),
                );
              }),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(appL10n.postStory)),
      body: _PostStoryForm(_PostStoryFormDelegate(
        pickedImage,
        formKey: _formKey,
        onImageTap: isLoading ? null : _handleRepickImage(context),
        descriptionFieldDelegate: _DescriptionFieldDelegate(
          controller: _descriptionController,
          enabled: !isLoading,
          onChanged: (String value) {
            PostStoryRoute(value.isEmpty ? null : value).go(context);
          }.debounce(),
        ),
        addressSectionDelegate: _AddressSectionDelegate(
          address: _locationData?.displayName ??
              _locationData?.address ??
              _locationData?.latLon,
          onTap: isLoading ? null : _handleLocationSet(context),
        ),
        onPostButtonTap: isLoading ? null : _handlePostStory(context),
      )),
    );
  }
}

class _PostStoryForm extends StatelessWidget {
  const _PostStoryForm(this.delegate);

  final _PostStoryFormDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: delegate.formKey,
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return _PostStoryFormScreenSmall(delegate);
        }

        return _PostStoryFormScreenWide(delegate);
      }),
    );
  }
}

class _PostStoryFormDelegate {
  const _PostStoryFormDelegate(
    this.imageFile, {
    this.formKey,
    this.onImageTap,
    this.descriptionFieldDelegate = const _DescriptionFieldDelegate(),
    this.addressSectionDelegate = const _AddressSectionDelegate(),
    this.onPostButtonTap,
  });

  final XFile imageFile;
  final VoidCallback? onImageTap;

  final Key? formKey;
  final _DescriptionFieldDelegate descriptionFieldDelegate;
  final _AddressSectionDelegate addressSectionDelegate;

  final VoidCallback? onPostButtonTap;
}

class _DescriptionFieldDelegate {
  const _DescriptionFieldDelegate({
    this.controller,
    this.enabled,
    this.onChanged,
  });

  final TextEditingController? controller;
  final bool? enabled;
  final ValueChanged<String>? onChanged;
}

class _AddressSectionDelegate {
  const _AddressSectionDelegate({this.address, this.onTap});

  final String? address;
  final VoidCallback? onTap;
}

abstract base class _PostStoryFormBase extends StatelessWidget {
  const _PostStoryFormBase(this.delegate);

  final _PostStoryFormDelegate delegate;

  Widget get _imageWidget {
    return InkWell(
      onTap: delegate.onImageTap,
      child: ImageFromXFile(
        delegate.imageFile,
        fit: BoxFit.cover,
      ).toInk(),
    );
  }

  Widget get _titleSection {
    return Consumer(builder: (context, ref, _) {
      final user = ref.watch(authProvider).valueOrNull;

      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Text(
            '${user?.name ?? 'Anonymous'} ',
            style: context.textTheme.headlineMedium,
          ),
          Text(kDateFormat.format(DateTime.now())).applyOpacity(opacity: 0.5),
        ],
      );
    });
  }

  Widget get _addressSection {
    final _AddressSectionDelegate(:address, :onTap) =
        delegate.addressSectionDelegate;

    return Builder(builder: (context) {
      return AddressSection(
        address ?? "Set Location",
        onTap: onTap,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    });
  }

  Widget get _descriptionFormField {
    final _DescriptionFieldDelegate(:controller, :enabled, :onChanged) =
        delegate.descriptionFieldDelegate;

    return Builder(builder: (context) {
      final appL10n = AppL10n.of(context)!;

      return TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(hintText: "${appL10n.tellUsYourStory}..."),
        onChanged: onChanged,
        validator: (text) {
          if (text == null || text.isEmpty) return appL10n.cannotBeEmpty;

          return null;
        },
      );
    });
  }

  Widget get _postButton {
    if (delegate.onPostButtonTap == null) {
      return const CircularProgressIndicator();
    }

    return FilledButton(
      onPressed: delegate.onPostButtonTap,
      child: Builder(
        builder: (context) => Text(AppL10n.of(context)!.postStory),
      ),
    );
  }
}

final class _PostStoryFormScreenSmall extends _PostStoryFormBase {
  const _PostStoryFormScreenSmall(super.delegate);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 3 / 2,
            child: _imageWidget,
          ),
          const Divider(height: 2.0, thickness: 2.0),
          //
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleSection,
                _addressSection,
                const SizedBox(height: 16.0),

                //
                _descriptionFormField,
                const SizedBox(height: 16.0),
                Align(alignment: Alignment.center, child: _postButton),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _PostStoryFormScreenWide extends _PostStoryFormBase {
  const _PostStoryFormScreenWide(super.delegate);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 8,
              child: _imageWidget,
            ),
            const VerticalDivider(width: 2.0, thickness: 2.0),
            Flexible(
              flex: 10,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleSection,
                    _addressSection,
                    const SizedBox(height: 16.0),

                    //
                    _descriptionFormField,
                    const SizedBox(height: 16.0),
                    Align(alignment: Alignment.center, child: _postButton),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

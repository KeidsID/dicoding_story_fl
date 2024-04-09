import 'package:fl_utilities/fl_utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_story_fl/common/constants.dart';
import 'package:dicoding_story_fl/common/utils.dart';
import 'package:dicoding_story_fl/interfaces/ui.dart';
import 'package:dicoding_story_fl/interfaces/ux.dart';

class PostStoryScreen extends StatefulWidget {
  const PostStoryScreen({super.key});

  @override
  State<PostStoryScreen> createState() => _PostStoryScreenState();
}

class _PostStoryScreenState extends State<PostStoryScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  /// Picked image from gallery or camera.
  XFile? pickedImage;

  Future<void> _pickImage(
    BuildContext context, {
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final image = await _imagePicker.pickImage(source: source);

      // prevent image from being null when replacing image.
      if (image == null) return;

      setState(() => pickedImage = image);
    } catch (err, trace) {
      final exception = err.toSimpleException(trace);

      kLogger.w(
        'On Pick Image',
        error: exception,
        stackTrace: exception.trace,
      );

      context.scaffoldMessenger?.showSnackBar(SnackBar(
        content: Text(exception.message),
      ));
    }
  }

  /// `Android` only.
  ///
  /// https://pub.dev/packages/image_picker#handling-mainactivity-destruction-on-android
  Future<void> _retrieveLostData() async {
    final LostDataResponse response = await _imagePicker.retrieveLostData();

    if (response.isEmpty) return;

    final file = response.file;

    if (file != null) {
      setState(() => pickedImage = response.file);
      return;
    }

    final rawException = response.exception;

    if (rawException != null) {
      final exception = rawException.toSimpleException(StackTrace.current);

      kLogger.w(
        'Android Retrieve Lost Data',
        error: exception,
        stackTrace: exception.trace,
      );

      return;
    }
  }

  Widget get _onNullImageScreen {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Pick image for your story'),
          const SizedBox(height: 8.0),

          //
          Expanded(
            child: Builder(builder: (context) {
              final labelStyle = context.textTheme.titleMedium;

              return Row(
                children: [
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => _pickImage(context),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('From Gallery', style: labelStyle),
                            const Icon(Icons.image_outlined),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () =>
                          _pickImage(context, source: ImageSource.camera),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('From Camera', style: labelStyle),
                            const Icon(Icons.camera_alt_outlined),
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  Widget get _screenHandler {
    final imageFile = pickedImage;

    if (imageFile == null) return _onNullImageScreen;

    return Builder(builder: (context) {
      final storiesProv = context.watch<StoriesProvider>();

      final isLoading = storiesProv.isLoading;

      return _PostStoryForm(_PostStoryFormLayoutDelegate(
        imageFile,
        onImageTap: isLoading
            ? null
            : () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Replace Image?'),
                      content: const Text('Replace from:'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await _pickImage(context);

                            if (context.mounted) Navigator.maybePop(context);
                          },
                          child: const Text('Gallery'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _pickImage(context,
                                source: ImageSource.camera);

                            if (context.mounted) Navigator.maybePop(context);
                          },
                          child: const Text('Camera'),
                        ),
                        //
                        TextButton(
                          onPressed: () => Navigator.maybePop(context),
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              },
        formKey: _formKey,
        descController: _descriptionController,
        descIsEnabled: !isLoading,
        onPostButtonTap: isLoading
            ? null
            : () async {
                try {
                  if (!(_formKey.currentState?.validate() ?? false)) return;

                  final userCreds = context.read<AuthProvider>().value!;
                  final imageBytes = await imageFile.readAsBytes();

                  await storiesProv.postStory(
                    userCreds,
                    description: _descriptionController.text,
                    imageBytes: imageBytes,
                    imageFilename: imageFile.name,
                  );

                  if (context.mounted) Navigator.maybePop(context);
                } catch (err, trace) {
                  final exception = err.toSimpleException(trace);

                  kLogger.w(
                    'On Post Story',
                    error: exception,
                    stackTrace: exception.trace,
                  );

                  context.scaffoldMessenger?.showSnackBar(SnackBar(
                    content: Text(exception.message),
                  ));
                }
              },
      ));
    });
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Story')),
      body: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
          ? FutureBuilder(
              future: _retrieveLostData(),
              builder: (context, snapshot) {
                return switch (snapshot.connectionState) {
                  ConnectionState.done => _screenHandler,
                  _ => _onNullImageScreen,
                };
              },
            )
          : _screenHandler,
    );
  }
}

class _PostStoryForm extends StatelessWidget {
  // ignore: unused_element
  const _PostStoryForm(this.layoutDelegate, {super.key});

  final _PostStoryFormLayoutDelegate layoutDelegate;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: layoutDelegate.formKey,
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return _PostStoryFormS(layoutDelegate);
        }

        return _PostStoryFormL(layoutDelegate);
      }),
    );
  }
}

class _PostStoryFormLayoutDelegate {
  const _PostStoryFormLayoutDelegate(
    this.imageFile, {
    this.onImageTap,
    this.formKey,
    this.descController,
    this.descIsEnabled,
    this.onPostButtonTap,
  });

  final XFile imageFile;
  final VoidCallback? onImageTap;

  final Key? formKey;
  final TextEditingController? descController;
  final bool? descIsEnabled;

  final VoidCallback? onPostButtonTap;
}

abstract base class _PostStoryFormLayoutBase extends StatelessWidget {
  const _PostStoryFormLayoutBase(this.layoutDelegate);

  final _PostStoryFormLayoutDelegate layoutDelegate;

  Widget get _imageWidget {
    return InkWell(
      onTap: layoutDelegate.onImageTap,
      child: ImageFromXFile(
        layoutDelegate.imageFile,
        fit: BoxFit.cover,
      ).toInk(),
    );
  }

  String get _dateTimeText => kDateFormat.format(DateTime.now());

  TextFormField get _descFormField {
    return TextFormField(
      controller: layoutDelegate.descController,
      enabled: layoutDelegate.descIsEnabled,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(
        hintText: 'Tell your story...',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Cannot be empty';

        return null;
      },
    );
  }
}

final class _PostStoryFormS extends _PostStoryFormLayoutBase {
  const _PostStoryFormS(super.layoutDelegate);

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthProvider>();

    final textTheme = context.textTheme;

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
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Text(
                      '${authProv.value?.name ?? 'Anonymous'} ',
                      style: textTheme.headlineMedium,
                    ),
                    Text(_dateTimeText).applyOpacity(opacity: 0.5),
                  ],
                ),
                const SizedBox(height: 16.0),

                //
                _descFormField,
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.center,
                  child: FilledButton(
                    onPressed: layoutDelegate.onPostButtonTap,
                    child: const Text('Post Story'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _PostStoryFormL extends _PostStoryFormLayoutBase {
  const _PostStoryFormL(super.layoutDelegate);

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthProvider>();

    final theme = context.theme;
    final textTheme = theme.textTheme;

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
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Text(
                          '${authProv.value?.name ?? 'Anonymous'} ',
                          style: textTheme.headlineMedium,
                        ),
                        Text(_dateTimeText).applyOpacity(opacity: 0.5),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    //
                    _descFormField,
                    const SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.center,
                      child: FilledButton(
                        onPressed: layoutDelegate.onPostButtonTap,
                        child: const Text('Post Story'),
                      ),
                    ),
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

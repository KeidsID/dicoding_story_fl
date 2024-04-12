import 'package:fl_utilities/fl_utilities.dart';
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
  State<PostStoryScreen> createState() => PostStoryScreenState();
}

class PostStoryScreenState extends State<PostStoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  VoidCallback _onRepickImage(BuildContext context) {
    return () {
      final pickedImageProv = context.read<PickedImageProvider>();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Replace Image?'),
            content: const Text('From:'),
            actions: [
              TextButton(
                onPressed: () async {
                  final img = await pickedImageProv.pickImage(context);

                  if (img == null) return;

                  if (context.mounted) {
                    Navigator.maybePop(context);
                  }
                },
                child: const Text('Gallery'),
              ),
              TextButton(
                onPressed: () async {
                  final img = await pickedImageProv.pickImage(
                    context,
                    source: ImageSource.camera,
                  );

                  if (img == null) return;

                  if (context.mounted) {
                    Navigator.maybePop(context);
                  }
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
    };
  }

  VoidCallback _onPostButtonTap(BuildContext context) {
    return () async {
      final imageFile = context.read<PickedImageProvider>().value;

      if (imageFile == null) return;

      try {
        if (!(_formKey.currentState?.validate() ?? false)) return;

        await context.read<StoriesProvider>().postStory(
              context.read<AuthProvider>().value!,
              description: _descriptionController.text,
              imageBytes: await imageFile.readAsBytes(),
              imageFilename: imageFile.name,
            );

        if (context.mounted) Navigator.maybePop(context);
      } catch (err, trace) {
        final exception = err.toSimpleException(trace: trace);

        kLogger.w(
          'On Post Story',
          error: exception,
          stackTrace: exception.trace,
        );

        context.scaffoldMessenger?.showSnackBar(SnackBar(
          content: Text(exception.message),
        ));
      }
    };
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PickedImageProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Post Story')),
        body: Builder(
          builder: (context) {
            final pickedImageProv = context.watch<PickedImageProvider>();
            final pickedImage = pickedImageProv.value;

            if (pickedImage == null) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Pick image for your story',
                      style: context.textTheme.titleMedium,
                    ),
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
                                onTap: () => pickedImageProv.pickImage(context),
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
                                onTap: () => pickedImageProv.pickImage(
                                  context,
                                  source: ImageSource.camera,
                                ),
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

            return Builder(builder: (context) {
              final storiesProv = context.watch<StoriesProvider>();

              final isLoading = storiesProv.isLoading;

              return _PostStoryFormScreen(_PostStoryFormScreenDelegate(
                pickedImage,
                onImageTap: isLoading ? null : _onRepickImage(context),
                formKey: _formKey,
                descController: _descriptionController,
                descIsEnabled: !isLoading,
                onPostButtonTap: isLoading ? null : _onPostButtonTap(context),
              ));
            });
          },
        ),
      ),
    );
  }
}

class _PostStoryFormScreen extends StatelessWidget {
  const _PostStoryFormScreen(this.delegate);

  final _PostStoryFormScreenDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: delegate.formKey,
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return _PostStoryFormScreenS(delegate);
        }

        return _PostStoryFormScreenL(delegate);
      }),
    );
  }
}

class _PostStoryFormScreenDelegate {
  const _PostStoryFormScreenDelegate(
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

abstract base class _PostStoryFormScreenLayoutBase extends StatelessWidget {
  const _PostStoryFormScreenLayoutBase(this.delegate);

  final _PostStoryFormScreenDelegate delegate;

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
    return Builder(builder: (context) {
      final userCreds = context.watch<AuthProvider>().value;

      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Text(
            '${userCreds?.name ?? 'Anonymous'} ',
            style: context.textTheme.headlineMedium,
          ),
          Text(kDateFormat.format(DateTime.now())).applyOpacity(opacity: 0.5),
        ],
      );
    });
  }

  TextFormField get _descFormField {
    return TextFormField(
      controller: delegate.descController,
      enabled: delegate.descIsEnabled,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: const InputDecoration(hintText: 'Tell your story...'),
      validator: (text) {
        if (text == null || text.isEmpty) return 'Cannot be empty';

        return null;
      },
    );
  }

  Widget get _postButton {
    return FilledButton(
      onPressed: delegate.onPostButtonTap,
      child: const Text('Post Story'),
    );
  }
}

final class _PostStoryFormScreenS extends _PostStoryFormScreenLayoutBase {
  const _PostStoryFormScreenS(super.delegate);

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
                const SizedBox(height: 16.0),

                //
                _descFormField,
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

final class _PostStoryFormScreenL extends _PostStoryFormScreenLayoutBase {
  const _PostStoryFormScreenL(super.delegate);

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
                    const SizedBox(height: 16.0),

                    //
                    _descFormField,
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

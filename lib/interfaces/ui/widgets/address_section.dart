import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AddressSection extends StatelessWidget {
  const AddressSection(
    this.address, {
    super.key,
    this.maxLines,
    this.overflow,
    this.onTap,
  });

  /// Address to be displayed.
  final String address;

  final int? maxLines;
  final TextOverflow? overflow;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const WidgetSpan(
            child: Icon(Icons.place_outlined),
            alignment: PlaceholderAlignment.middle,
          ),
          TextSpan(text: ' $address'),
        ],
        recognizer: TapGestureRecognizer()..onTap = onTap,
      ),
      // textAlign: TextAlign.center,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

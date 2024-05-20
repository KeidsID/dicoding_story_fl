import 'package:equatable/equatable.dart';

/// {@template dicoding_story_fl.core.entities.PlaceCore}
/// Core entity for place/address information.
/// {@endtemplate}
class PlaceCore extends Equatable {
  /// {@macro dicoding_story_fl.core.entities.PlaceCore}
  const PlaceCore(this.id, {this.address, this.displayName});

  final String id;
  final String? address;
  final String? displayName;

  @override
  List<Object?> get props => [address, displayName];
}

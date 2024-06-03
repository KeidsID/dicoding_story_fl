import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'g_maps_place.freezed.dart';
part 'g_maps_place.g.dart';

@freezed
class GMapsPlace with _$GMapsPlace {
  const factory GMapsPlace({
    String? id,
    String? formattedAddress,
    GMapsLocation? location,
    GMapsPlaceDisplayName? displayName,
  }) = _GMapsPlace;

  factory GMapsPlace.fromJson(Map<String, dynamic> json) =>
      _$GMapsPlaceFromJson(json);
}

@freezed
class GMapsLocation with _$GMapsLocation {
  const factory GMapsLocation({
    required double latitude,
    required double longitude,
  }) = _GMapsLocation;

  factory GMapsLocation.fromJson(Map<String, dynamic> json) =>
      _$GMapsLocationFromJson(json);
}

@freezed
class GMapsPlaceDisplayName with _$GMapsPlaceDisplayName {
  const factory GMapsPlaceDisplayName({
    required String text,
    required String languageCode,
  }) = _GMapsPlaceDisplayName;

  factory GMapsPlaceDisplayName.fromJson(Map<String, dynamic> json) =>
      _$GMapsPlaceDisplayNameFromJson(json);
}

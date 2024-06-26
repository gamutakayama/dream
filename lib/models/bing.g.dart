// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bing _$BingFromJson(Map<String, dynamic> json) => Bing(
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => BingImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

BingImage _$BingImageFromJson(Map<String, dynamic> json) => BingImage(
      url: json['url'] as String? ?? '',
    );

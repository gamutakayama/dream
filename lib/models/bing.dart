import 'package:json_annotation/json_annotation.dart';

part 'bing.g.dart';

@JsonSerializable(createToJson: false)
class Bing {
  const Bing({this.images = const []});

  factory Bing.fromJson(Map<String, dynamic> json) => _$BingFromJson(json);

  final List<BingImage> images;
}

@JsonSerializable(createToJson: false)
class BingImage {
  const BingImage({this.url = ''});

  factory BingImage.fromJson(Map<String, dynamic> json) {
    return _$BingImageFromJson(json);
  }

  final String url;
}

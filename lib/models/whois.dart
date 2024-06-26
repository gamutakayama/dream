import 'package:json_annotation/json_annotation.dart';

part 'whois.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Whois {
  const Whois({
    this.creationDate = '',
    this.domainName = '',
    this.expirationDate = '',
    this.registrar = '',
    this.status = const [],
    this.updatedDate = '',
  });

  factory Whois.fromJson(Map<String, dynamic> json) => _$WhoisFromJson(json);

  final String creationDate;

  final String domainName;

  final String expirationDate;

  final String registrar;

  @JsonKey(readValue: _readStatus)
  final List<String> status;

  final String updatedDate;

  static Object? _readStatus(Map<dynamic, dynamic> json, String key) {
    final value = json[key];

    if (value is String) {
      return [value.split(' ').first];
    } else if (value is List<dynamic>) {
      return value.map((state) => state.toString().split(' ').first).toList();
    }

    return json[key];
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whois.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Whois _$WhoisFromJson(Map<String, dynamic> json) => Whois(
      creationDate: json['creation_date'] as String? ?? '',
      domainName: json['domain_name'] as String? ?? '',
      expirationDate: json['expiration_date'] as String? ?? '',
      registrar: json['registrar'] as String? ?? '',
      status: (Whois._readStatus(json, 'status') as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedDate: json['updated_date'] as String? ?? '',
    );

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dream/constants.dart';
import 'package:dream/models/whois.dart';
import 'package:dream/utils/ext.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

Future<Response> onRequest(RequestContext context, String domain) async {
  try {
    final res = await dio.Dio().get<String>(
      'https://api.apilayer.com/whois/query',
      queryParameters: {'domain': domain},
      options: dio.Options(
        headers: {'apikey': 'cJ2qy4DK7gxQwJyW0WUr7KQ5dpPjN03t'},
        responseType: dio.ResponseType.plain,
      ),
    );
    final json = jsonDecode(res.data.toString()) as Map<String, dynamic>;
    final whois = Whois.fromJson(json['result'] as Map<String, dynamic>);

    final title = '${whois.domainName.toUpperCase()}的域名信息';

    final description = '''
<b>注册商：</b><br>
${whois.registrar}<br><br>
<b>注册时间：</b><br>
${whois.creationDate}<br><br>
<b>到期时间：</b><br>
${whois.expirationDate}<br><br>
<b>更新时间：</b><br>
${whois.updatedDate}<br><br>
<b>状态：</b><br>
${whois.status.map((state) => '$state（${domainStatus[state] ?? '-'}）').join('<br>')}
''';

    final pubDate = DateFormat('yyyy-MM-dd HH:mm:ss')
        .parse(whois.updatedDate, true)
        .toRfc822String();

    final builder = XmlBuilder();
    builder
      ..processing('xml', 'version="1.0" encoding="UTF-8"')
      ..element(
        'rss',
        attributes: {
          'xmlns:atom': 'http://www.w3.org/2005/Atom',
          'version': '2.0',
        },
        nest: () {
          builder.element(
            'channel',
            nest: () {
              builder
                ..element('title', nest: () => builder.cdata(title))
                ..element('description', nest: () => builder.cdata(title))
                ..element('link', nest: 'https://apilayer.com')
                ..element(
                  'lastBuildDate',
                  nest: DateTime.now().toUtc().toRfc822String(),
                )
                ..element(
                  'item',
                  nest: () {
                    builder
                      ..element('title', nest: () => builder.cdata(title))
                      ..element(
                        'description',
                        nest: () => builder.cdata(description),
                      )
                      ..element(
                        'link',
                        nest: 'https://whois.com/whois/${whois.domainName}',
                      )
                      ..element(
                        'guid',
                        attributes: {'isPermaLink': 'false'},
                        nest: pubDate,
                      )
                      ..element('pubDate', nest: pubDate);
                  },
                );
            },
          );
        },
      );

    return Response(
      body: builder.buildDocument().toXmlString(),
      headers: {
        'Content-Type': 'application/xml; charset=utf-8',
      },
    );
  } catch (e) {
    return Response(statusCode: 500, body: e.toString());
  }
}

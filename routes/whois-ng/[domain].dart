import 'package:dart_frog/dart_frog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dream/constants.dart';
import 'package:dream/utils/ext.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

Future<Response> onRequest(RequestContext context, String domain) async {
  try {
    final res = await dio.Dio().get<String>(
      'https://domains.upperlink.ng/wp-content/plugins/whmpress/whois.php',
      queryParameters: {'domain': '$domain.ng'},
      options: dio.Options(responseType: dio.ResponseType.plain),
    );

    final data = res.data ?? '';

    var regExp = RegExp('(?<=Domain Name: ).+');
    final domainName = regExp.stringMatch(data) ?? '';

    regExp = RegExp('(?<=Registrar: ).+');
    final registrar = regExp.stringMatch(data) ?? '';

    regExp = RegExp('(?<=Creation Date: ).+');
    final creationDate = DateTime.parse(regExp.stringMatch(data) ?? '');

    regExp = RegExp('(?<=Registry Expiry Date: ).+');
    final expirationDate = DateTime.parse(regExp.stringMatch(data) ?? '');

    regExp = RegExp('(?<=Updated Date: ).+');
    final updatedDate = DateTime.parse(regExp.stringMatch(data) ?? '');

    regExp = RegExp(r'(?<=Domain Status: ).+(?= https:\/\/icann\.org\/epp)');
    final status = regExp.allMatches(data).map((m) => m.group(0) ?? '');

    final title = '${domainName.toUpperCase()}的域名信息';

    final description = '''
<b>注册商：</b><br>
$registrar<br><br>
<b>注册时间：</b><br>
${DateFormat('yyyy-MM-dd HH:mm:ss').format(creationDate)}<br><br>
<b>到期时间：</b><br>
${DateFormat('yyyy-MM-dd HH:mm:ss').format(expirationDate)}<br><br>
<b>更新时间：</b><br>
${DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedDate)}<br><br>
<b>状态：</b><br>
${status.map((state) => '$state（${domainStatus[state] ?? '-'}）').join('<br>')}
''';

    final pubDate = updatedDate.toRfc822String();

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
                ..element('link', nest: 'https://domains.upperlink.ng')
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
                        nest: 'https://whois.com/whois/$domainName',
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

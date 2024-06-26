import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dream/models/bing.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    final res = await dio.Dio().get<String>(
      'https://bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN',
      options: dio.Options(responseType: dio.ResponseType.plain),
    );
    final json = jsonDecode(res.data.toString()) as Map<String, dynamic>;
    final bing = Bing.fromJson(json);

    return Response(
      statusCode: 302,
      headers: {
        'Location': 'https://bing.com${bing.images.first.url}',
      },
    );
  } catch (e) {
    return Response(statusCode: 500);
  }
}

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class HtmlRepository {
  Future<String?> getHtml(String url) async {
    try {
      final response = await get(Uri.parse(url));
      return response.body;
    } catch (e) {
      debugPrint('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}

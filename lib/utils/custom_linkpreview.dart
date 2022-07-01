import 'dart:convert';

import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/parsing.dart';
import 'package:link_preview_generator/src/models/types.dart';
import 'package:link_preview_generator/src/rules/amazon.scrapper.dart';
import 'package:link_preview_generator/src/rules/default.scrapper.dart';
import 'package:link_preview_generator/src/rules/image.scrapper.dart';
import 'package:link_preview_generator/src/rules/instagram.scrapper.dart';
import 'package:link_preview_generator/src/rules/twitter.scrapper.dart';
import 'package:link_preview_generator/src/rules/video.scrapper.dart';
import 'package:link_preview_generator/src/rules/youtube.scrapper.dart';
import 'package:link_preview_generator/src/utils/analyzer.dart';
import 'package:link_preview_generator/src/utils/canonical_url.dart';
import 'package:link_preview_generator/src/utils/scrapper.dart';

class CustomLinkPreview {
  static const _userAgent = 'WhatsApp/2.21.12.21 A';

  static Future<WebInfo> scrapeFromURL(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': _userAgent,
        },
      );

      final mimeType = response.headers['content-type'] ?? '';
      final data = utf8.decode(response.bodyBytes);
      final doc = parseHtmlDocument(data);

      if (LinkPreviewScrapper.isMimeVideo(mimeType)) {
        return VideoScrapper.scrape(doc, url);
      } else if (LinkPreviewScrapper.isMimeAudio(mimeType)) {
        return ImageScrapper.scrape(doc, url);
      } else if (LinkPreviewScrapper.isMimeImage(mimeType)) {
        return ImageScrapper.scrape(doc, url);
      } else if (LinkPreviewScrapper.isUrlInsta(url)) {
        final instagramResponse = await http.get(
          Uri.parse('$url?__a=1&max_id=endcursor'),
        );
        return InstagramScrapper.scrape(doc, instagramResponse.body, url);
      } else if (LinkPreviewScrapper.isUrlYoutube(url)) {
        return YouTubeScrapper.scrape(doc, url);
      } else if (LinkPreviewScrapper.isUrlAmazon(url)) {
        return AmazonScrapper.scrape(doc, url);
      } else if (LinkPreviewScrapper.isUrlTwitter(url)) {
        final twitterResponse = await http.get(
          Uri.parse('https://publish.twitter.com/oembed?url=$url'),
        );
        return TwitterScrapper.scrape(doc, twitterResponse.body, url);
      } else {
        return DefaultScrapper.scrape(doc, url);
      }
    } catch (e) {
      print('Default scrapper failure Error: $e');
      return WebInfo(
        description: '',
        domain: url,
        icon: '',
        image: '',
        video: '',
        title: '',
        type: LinkPreviewType.error,
      );
    }
  }
}

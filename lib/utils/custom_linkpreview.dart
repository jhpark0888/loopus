import 'dart:convert';

import 'package:cp949_dart/cp949_dart.dart' as cp949;
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/home_controller.dart';
import 'package:universal_html/html.dart';
import 'package:html/parser.dart';
import 'package:universal_html/parsing.dart';
import 'package:collection/collection.dart';
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
      final data = response.body;
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
      HomeController.to.newslist.removeWhere((element) => element == url);
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

class NewsFetchPreview {
  Future fetch(url) async {
    final client = http.Client();
    try {
      final response = await client.get(Uri.parse(_validateUrl(url)));

      late final document;
      try {
        document = parse(utf8.decode(response.bodyBytes));
      } catch (e) {
        try {
          document = parse(cp949.decode(response.bodyBytes));
        } catch (e) {
          document = parse(response.body);
        }
      }

      String? description, title, image, appleIcon, favIcon;

      var elements = document.getElementsByTagName('meta');
      final linkElements = document.getElementsByTagName('link');

      elements.forEach((tmp) {
        if (tmp.attributes['property'] == 'og:title') {
          //fetch seo title
          title = tmp.attributes['content'];
          try {
            title = cp949.decodeString(title!);
          } catch (e) {}
        }
        //if seo title is empty then fetch normal title
        title ??= document.getElementsByTagName('title')[0].text;

        //fetch seo description
        if (tmp.attributes['property'] == 'og:description') {
          description = tmp.attributes['content'];
        }
        //if seo description is empty then fetch normal description.
        if (description == null) {
          //fetch base title
          if (tmp.attributes['name'] == 'description') {
            description = tmp.attributes['content'];
          }
        }

        //fetch image
        if (tmp.attributes['property'] == 'og:image') {
          image = tmp.attributes['content'];
        }
      });

      linkElements.forEach((tmp) {
        if (tmp.attributes['rel'] == 'apple-touch-icon') {
          appleIcon = tmp.attributes['href'];
        }
        if (tmp.attributes['rel']?.contains('icon') == true) {
          favIcon = tmp.attributes['href'];
        }
      });

      return {
        'title': title ?? '',
        'description': description ?? '',
        'image': image ?? '',
        'appleIcon': appleIcon ?? '',
        'favIcon': favIcon ?? ''
      };
    } catch (e) {
      HomeController.to.newslist.remove(url);
    }
  }

  _validateUrl(String url) {
    if (url.startsWith('http://') == true ||
        url.startsWith('https://') == true) {
      return url;
    } else {
      return 'http://$url';
    }
  }
}
// /// Utils required for the link preview generator.
// class CustomLinkPreviewScrapper {
//   // static final RegExp _base64withMime = RegExp(
//   //     r'^(data:(.*);base64,)?(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');
//   static final RegExp _amazonUrl =
//       RegExp(r'https?:\/\/(.*amazon\..*\/.*|.*amzn\..*\/.*|.*a\.co\/.*)$');

//   static final RegExp _instaUrl =
//       RegExp(r'^(https?:\/\/www\.)?instagram\.com(\/p\/\w+\/?)');

//   static final RegExp _twitterUrl =
//       RegExp(r'^(https?:\/\/(www)?\.?)?twitter\.com\/.+');

//   static final RegExp _youtubeUrl =
//       RegExp(r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$');

//   static String fixRelativeUrls(String baseUrl, String itemUrl) {
//     final normalizedUrl = itemUrl.toLowerCase();
//     if (normalizedUrl.startsWith('http://') ||
//         normalizedUrl.startsWith('https://')) {
//       return itemUrl;
//     }
//     return UrlCanonicalizer(removeFragment: true)
//         .canonicalize('$baseUrl/$itemUrl');
//   }

//   static String? getAttrOfDocElement(
//       HtmlDocument doc, String query, String attr) {
//     var attribute = doc.querySelectorAll(query).firstOrNull?.getAttribute(attr);

//     if (attribute != null && attribute.isNotEmpty) return attribute;
//   }

//   static String getBaseUrl(HtmlDocument doc, String url) =>
//       getAttrOfDocElement(doc, 'base', 'href') ?? Uri.parse(url).origin;

//   static String? getDomain(HtmlDocument doc, String url) {
//     try {
//       final domainName = () {
//         final canonicalLink = doc.querySelector('link[rel=canonical]');
//         if (canonicalLink != null && canonicalLink.attributes['href'] != null) {
//           return canonicalLink.attributes['href'];
//         }
//         final ogUrlMeta = doc.querySelector('meta[property="og:url"]');
//         if (ogUrlMeta != null && ogUrlMeta.text!.isNotEmpty) {
//           return ogUrlMeta.text;
//         }
//         return null;
//       }();

//       return domainName != null
//           ? Uri.parse(domainName).host.replaceFirst('www.', '')
//           : Uri.parse(url).host.replaceFirst('www.', '');
//     } catch (e) {
//       print('Domain resolution failure Error:$e');
//       return null;
//     }
//   }

//   static String? getIcon(HtmlDocument doc, String url) {
//     final List<Element>? meta = doc.querySelectorAll('link');
//     String? icon = '';
//     Element? metaIcon;
//     if (meta != null && meta.isNotEmpty) {
//       // get icon first
//       metaIcon = meta.firstWhereOrNull((e) {
//         final rel = (e.attributes['rel'] ?? '').toLowerCase();
//         if (rel == 'icon') {
//           icon = e.attributes['href'];
//           if (icon != null && !icon!.toLowerCase().contains('.svg')) {
//             return true;
//           }
//         }
//         return false;
//       });

//       metaIcon ??= meta.firstWhereOrNull((e) {
//         final rel = (e.attributes['rel'] ?? '').toLowerCase();
//         if (rel == 'shortcut icon') {
//           icon = e.attributes['href'];
//           if (icon != null && !icon!.toLowerCase().contains('.svg')) {
//             return true;
//           }
//         }
//         return false;
//       });
//     }
//     if (metaIcon != null) {
//       icon = metaIcon.attributes['href'];
//       return CustomLinkPreviewScrapper.handleUrl(url, icon);
//     }
//     return '${Uri.parse(url).origin}/favicon.ico';
//   }

//   static String? getTitle(HtmlDocument doc) {
//     try {
//       final ogTitle = doc.querySelector('meta[property="og:title"]');
//       if (ogTitle != null &&
//           ogTitle.attributes['content'] != null &&
//           ogTitle.attributes['content']!.isNotEmpty) {
//         // print("ogTitle ${ogTitle.attributes['content'] as String}");
//         return ogTitle.attributes['content'];
//       }
//       final twitterTitle = doc.querySelector('meta[name="twitter:title"]');
//       if (twitterTitle != null &&
//           twitterTitle.attributes['content'] != null &&
//           twitterTitle.attributes['content']!.isNotEmpty) {
//         return twitterTitle.attributes['content'];
//       }
//       String? docTitle = doc.title;
//       // ignore: unnecessary_null_comparison
//       if (docTitle != null && docTitle.isNotEmpty) return docTitle;
//       final h1El = doc.querySelector('h1');
//       final h1 = h1El?.innerHtml;
//       print("h1 $h1");
//       if (h1 != null && h1.isNotEmpty) return h1;
//       final h2El = doc.querySelector('h2');
//       final h2 = h2El?.innerHtml;
//       print("h2 $h2");
//       if (h2 != null && h2.isNotEmpty) return h2;
//       return null;
//     } catch (e) {
//       print('Title resolution failure Error:$e');
//       return null;
//     }
//   }

//   static String? handleUrl(String url, String? source) {
//     var uri = Uri.parse(url);
//     if (LinkPreviewAnalyzer.isNotEmpty(source) && !source!.startsWith('http')) {
//       if (source.startsWith('//')) {
//         source = '${uri.scheme}:$source';
//       } else {
//         if (source.startsWith('/')) {
//           source = '${uri.origin}$source';
//         } else {
//           source = '${uri.origin}/$source';
//         }
//       }
//     }
//     return source;
//   }

//   static bool isMimeAudio(String mimeType) => mimeType.startsWith('audio/');

//   static bool isMimeImage(String mimeType) => mimeType.startsWith('image/');

//   static bool isMimeVideo(String mimeType) => mimeType.startsWith('video/');

//   static bool isUrlAmazon(String url) => _amazonUrl.hasMatch(url);

//   static bool isUrlInsta(String url) => _instaUrl.hasMatch(url);

//   static bool isUrlTwitter(String url) => _twitterUrl.hasMatch(url);

//   static bool isUrlYoutube(String url) => _youtubeUrl.hasMatch(url);
// }

// class CustomDefaultScrapper {
//   static WebInfo scrape(HtmlDocument doc, String url) {
//     try {
//       var baseUrl = CustomLinkPreviewScrapper.getBaseUrl(doc, url);

//       var image = [
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'meta[property="og:logo"]', 'content'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'meta[itemprop="logo"]', 'content'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'img[itemprop="logo"]', 'src'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, "meta[property='og:image']", 'content'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'img[class*="logo" i]', 'src'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'img[src*="logo" i]', 'src'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'meta[property="og:image:secure_url"]', 'content'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'meta[property="og:image:url"]', 'content'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'meta[property="og:image"]', 'content'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'meta[name="twitter:image:src"]', 'content'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'meta[name="twitter:image"]', 'content'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'meta[itemprop="image"]', 'content'),
//       ]
//           .where((i) => LinkPreviewAnalyzer.isNotEmpty(i))
//           .map((i) => CustomLinkPreviewScrapper.fixRelativeUrls(baseUrl, i!))
//           .firstOrNull;

//       var icon = [
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'meta[property="og:logo"]', 'content'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'meta[itemprop="logo"]', 'content'),
//         CustomLinkPreviewScrapper.getAttrOfDocElement(
//             doc, 'img[itemprop="logo"]', 'src'),
//       ]
//           .where((i) => LinkPreviewAnalyzer.isNotEmpty(i))
//           .map((i) => CustomLinkPreviewScrapper.fixRelativeUrls(baseUrl, i!))
//           .firstOrNull;

//       return WebInfo(
//         description: _getDescription(doc) ?? '',
//         domain: CustomLinkPreviewScrapper.getDomain(doc, url) ?? url,
//         icon: CustomLinkPreviewScrapper.getIcon(doc, url) ?? icon ?? '',
//         image: image ?? _getDocImage(doc, url) ?? '',
//         video: '',
//         title: CustomLinkPreviewScrapper.getTitle(doc) ?? '',
//         type: LinkPreviewType.def,
//       );
//     } catch (e) {
//       print('Default scrapper failure Error: $e');
//       return WebInfo(
//         description: '',
//         domain: url,
//         icon: '',
//         image: '',
//         video: '',
//         title: '',
//         type: LinkPreviewType.error,
//       );
//     }
//   }

//   static String? _getDescription(HtmlDocument doc) {
//     try {
//       final ogDescription = doc.querySelector('meta[name=description]');
//       if (ogDescription != null &&
//           ogDescription.attributes['content'] != null &&
//           ogDescription.attributes['content']!.isNotEmpty) {
//         return ogDescription.attributes['content'];
//       }
//       final twitterDescription =
//           doc.querySelector('meta[name="twitter:description"]');
//       if (twitterDescription != null &&
//           twitterDescription.attributes['content'] != null &&
//           twitterDescription.attributes['content']!.isNotEmpty) {
//         return twitterDescription.attributes['content'];
//       }
//       final metaDescription = doc.querySelector('meta[name="description"]');
//       if (metaDescription != null &&
//           metaDescription.attributes['content'] != null &&
//           metaDescription.attributes['content']!.isNotEmpty) {
//         return metaDescription.attributes['content'];
//       }
//       final paragraphs = doc.querySelectorAll('p');
//       String? fstVisibleParagraph;
//       for (var i = 0; i < paragraphs.length; i++) {
//         // if object is visible
//         if (paragraphs[i].offsetParent != null) {
//           fstVisibleParagraph = paragraphs[i].text;
//           break;
//         }
//       }
//       return fstVisibleParagraph;
//     } catch (e) {
//       print('Get default description resolution failure Error: $e');
//       return null;
//     }
//   }

//   static String? _getDocImage(HtmlDocument doc, String url) {
//     try {
//       List<ImageElement> imgs = doc.querySelectorAll('img');
//       var src = <String?>[];
//       if (imgs.isNotEmpty) {
//         imgs = imgs.where((img) {
//           // ignore: unnecessary_null_comparison
//           if (img == null ||
//               // ignore: unnecessary_null_comparison
//               img.naturalHeight == null ||
//               // ignore: unnecessary_null_comparison
//               img.naturalWidth == null) return false;
//           var addImg = true;
//           // ignore: unnecessary_non_null_assertion
//           if (img.naturalWidth! > img.naturalHeight!) {
//             // ignore: unnecessary_non_null_assertion
//             if (img.naturalWidth! / img.naturalHeight! > 3) {
//               addImg = false;
//             }
//           } else {
//             // ignore: unnecessary_non_null_assertion
//             if (img.naturalHeight! / img.naturalWidth! > 3) {
//               addImg = false;
//             }
//           }
//           // ignore: unnecessary_non_null_assertion
//           if (img.naturalHeight! <= 50 || img.naturalWidth! <= 50) {
//             addImg = false;
//           }
//           return addImg;
//         }).toList();
//         if (imgs.isNotEmpty) {
//           imgs.forEach((img) {
//             if (img.src != null && !img.src!.contains('//')) {
//               src.add('${Uri.parse(url).origin}/${img.src!}');
//             }
//           });
//           return CustomLinkPreviewScrapper.handleUrl(src.first!, 'image');
//         }
//       }
//       return null;
//     } catch (e) {
//       print('Get default image resolution failure Error: $e');
//       return null;
//     }
//   }
// }

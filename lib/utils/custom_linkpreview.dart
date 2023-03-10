import 'dart:convert';

import 'package:cp949_dart/cp949_dart.dart' as cp949;
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/model/issue_model.dart';
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
          'Person-Agent': _userAgent,
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
      // print('Default scrapper failure Error: $e');
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

// class NewsFetchPreview {
//   Future fetch(url) async {
//     final client = http.Client();
//     try {
//       final response = await client.get(Uri.parse(_validateUrl(url)));

//       late final document;
//       try {
//         document = parse(utf8.decode(response.bodyBytes));
//       } catch (e) {
//         // try {
//         document = parse(cp949.decode(response.bodyBytes));
//         // } catch (e) {
//         //   document = parse(response.body);
//         // }
//       }

//       String? description, title, image, appleIcon, favIcon;
//       String? authorImage, authorName;

//       var elements = document.getElementsByTagName('meta');
//       final linkElements = document.getElementsByTagName('link');

//       elements.forEach((tmp) {
//         if (tmp.attributes['property'] == 'og:title') {
//           //fetch seo title
//           title = tmp.attributes['content'];
//           try {
//             title = cp949.decodeString(title!);
//           } catch (e) {}
//         }
//         //if seo title is empty then fetch normal title
//         title ??= document.getElementsByTagName('title')[0].text;

//         //fetch seo description
//         if (tmp.attributes['property'] == 'og:description') {
//           description = tmp.attributes['content'];
//         }
//         //if seo description is empty then fetch normal description.
//         if (description == null) {
//           //fetch base title
//           if (tmp.attributes['name'] == 'description') {
//             description = tmp.attributes['content'];
//           }
//         }

//         //fetch image
//         if (tmp.attributes['property'] == 'og:image') {
//           image = tmp.attributes['content'];
//           if (image != null) {
//             if ((!image!.startsWith("www")) & (!image!.startsWith("http"))) {
//               image = 'https:' + image!;
//             }
//           }
//         }
//       });

//       linkElements.forEach((tmp) {
//         if (tmp.attributes['rel'] == 'apple-touch-icon') {
//           appleIcon = tmp.attributes['href'];
//         }
//         if (tmp.attributes['rel']?.contains('icon') == true) {
//           favIcon = tmp.attributes['href'];
//         }
//       });

//       if (url.toString().contains("youtu")) {
//         String? chUrl;
//         var spanelements = document.getElementsByTagName('span');
//         spanelements.forEach((tmp) {
//           if (tmp.attributes['itemprop'] == "author") {
//             var chelements = tmp.getElementsByTagName('link');
//             chelements.forEach((tmp) {
//               if (tmp.attributes['itemprop'] == 'url') {
//                 chUrl = tmp.attributes['href'];
//               }
//               if (tmp.attributes['itemprop'] == "name") {
//                 authorName = tmp.attributes['content'];
//               }
//             });
//           }
//         });

//         if (chUrl != null) {
//           authorImage = await getYoutubeChannelImage(chUrl!);
//         }
//       }

//       return {
//         'title': title ?? '',
//         'description': description ?? '',
//         'image': image ?? '',
//         'appleIcon': appleIcon ?? '',
//         'favIcon': favIcon ?? '',
//         'authorName': authorName ?? '',
//         'authorImage': authorImage ?? '',
//       };
//     } catch (e) {
//       HomeController.to.newsList.remove(url);
//     }
//   }

//   _validateUrl(String url) {
//     if (url.startsWith('http://') == true ||
//         url.startsWith('https://') == true) {
//       return url;
//     } else {
//       return 'http://$url';
//     }
//   }

//   Future<String?> getYoutubeChannelImage(String url) async {
//     final client = http.Client();
//     try {
//       final response = await client.get(Uri.parse(_validateUrl(url)));

//       final document = parse(utf8.decode(response.bodyBytes));
//       String? chImage;

//       var elements = document.getElementsByTagName('meta');

//       elements.forEach((tmp) {
//         //fetch image
//         if (tmp.attributes['property'] == 'og:image') {
//           chImage = tmp.attributes['content'];
//         }
//       });

//       return chImage ?? "";
//     } catch (e) {
//       return "";
//     }
//   }
// }

class NewsFetchPreview {
  Future fetch(Issue issue) async {
    final client = http.Client();
    try {
      final response = await client.get(Uri.parse(_validateUrl(issue.url)));

      late final document;
      try {
        document = parse(utf8.decode(response.bodyBytes));
      } catch (e) {
        // try {
        document = parse(cp949.decode(response.bodyBytes));
        // } catch (e) {
        //   document = parse(response.body);
        // }
      }

      String? title, image;
      String? chImage, chName;

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
        issue.title = title ?? "";

        //fetch seo description
        // if (tmp.attributes['property'] == 'og:description') {
        //   description = tmp.attributes['content'];
        // }
        // //if seo description is empty then fetch normal description.
        // if (description == null) {
        //   //fetch base title
        //   if (tmp.attributes['name'] == 'description') {
        //     description = tmp.attributes['content'];
        //   }
        // }

        //fetch image
        if (tmp.attributes['property'] == 'og:image') {
          image = tmp.attributes['content'];
          if (image != null) {
            if ((!image!.startsWith("www")) & (!image!.startsWith("http"))) {
              image = 'https:' + image!;
            }
          }
          issue.image = image ?? "";
        }
      });

      // linkElements.forEach((tmp) {
      //   if (tmp.attributes['rel'] == 'apple-touch-icon') {
      //     appleIcon = tmp.attributes['href'];
      //   }
      //   if (tmp.attributes['rel']?.contains('icon') == true) {
      //     favIcon = tmp.attributes['href'];
      //   }
      // });

      if (issue.runtimeType == YoutubeIssue) {
        String? chUrl;
        var spanelements = document.getElementsByTagName('span');
        spanelements.forEach((tmp) {
          if (tmp.attributes['itemprop'] == "author") {
            var chelements = tmp.getElementsByTagName('link');
            chelements.forEach((tmp) {
              if (tmp.attributes['itemprop'] == 'url') {
                chUrl = tmp.attributes['href'];
              }
              if (tmp.attributes['itemprop'] == "name") {
                chName = tmp.attributes['content'];
              }
            });
          }
        });

        if (chUrl != null) {
          chImage = await getYoutubeChannelImage(chUrl!);
        }

        (issue as YoutubeIssue).chImage = chImage ?? "";
        issue.chName = chName ?? "";
      }
    } catch (e) {
      if (issue.runtimeType == NewsIssue) {
        HomeController.to.newsList.remove(issue);
      } else if (issue.runtimeType == BrunchIssue) {
        HomeController.to.brunchList.remove(issue);
      } else if (issue.runtimeType == YoutubeIssue) {
        HomeController.to.youtubeList.remove(issue);
      }
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

  Future<String?> getYoutubeChannelImage(String url) async {
    final client = http.Client();
    try {
      final response = await client.get(Uri.parse(_validateUrl(url)));

      final document = parse(utf8.decode(response.bodyBytes));
      String? chImage;

      var elements = document.getElementsByTagName('meta');

      elements.forEach((tmp) {
        //fetch image
        if (tmp.attributes['property'] == 'og:image') {
          chImage = tmp.attributes['content'];
        }
      });

      return chImage ?? "";
    } catch (e) {
      return "";
    }
  }
}

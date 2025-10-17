//
// import 'dart:developer';
import 'package:apollo/main.dart';
// import 'package:apollo/resources/utils.dart';
// import 'package:apollo/screens/cms_pages/cms_page.dart';
// import 'package:app_links/app_links.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
//
//
// class AppLinksService {
//   static final AppLinks _appLinks = AppLinks();
//
//   static String _promoId = '';
//   static String _promoType = '';
//   static String get promoId => _promoId;
//   static String get promoType => _promoType;
//   static bool get hasPromoId => _promoId.isNotEmpty;
//   static bool get hasPromoType => _promoType.isNotEmpty;
//
//   static void reset() => _promoId = '';
//   static void reset1() => _promoType = '';
//
//   static Future<void> init() async {
//     try {
//       // Case 1: App opened via link (cold start)
//       final initialLink = await _appLinks.getInitialLink();
//       _handleLink(initialLink);
//
//       // Case 2: App already running (warm/hot)
//       _appLinks.uriLinkStream.listen(
//             (Uri? uri) {
//           _handleLink(uri);
//         },
//         onError: (err) {
//           if (kDebugMode) print("AppLinks error: $err");
//         },
//       );
//     } catch (e) {
//       if (kDebugMode) print("AppLinks initialization failed: $e");
//     }
//   }
//   static void _handleLink(Uri? uri) {
//     if (uri == null || uri.queryParameters.isEmpty) return;
//
//     final params = uri.queryParameters;
//     final receivedPromoId = params['refCode'] ?? '';
//
//     if (receivedPromoId.isEmpty) return;
//
//     _promoId = receivedPromoId;
//
//     log('AppLinksService:::::$uri');
//     print('AppLinksService:::::$uri');
//
//     if (_promoId.isNotEmpty) {
//       referralCode = _promoId;
//       log('AppLinksService::code :::$referralCode');
//       print('AppLinksService::code :::$referralCode');
//       showToast('Referral By $referralCode');
//
//     }
//   }
//
//   // static void _handleLink(Uri? uri) {
//   //   if (uri == null || uri.queryParameters.isEmpty) return;
//   //
//   //   final params = uri.queryParameters;
//   //   final receivedPromoId = params['refCode'] ?? '';
//   //   final receivedPromoType = params['promo-type'] ?? '';
//   //
//   //   if (receivedPromoId.isEmpty || receivedPromoType.isEmpty) return;
//   //
//   //   _promoId = receivedPromoId;
//   //   _promoType = receivedPromoType;
//   //
//   //   log('AppLinksService:::::$uri');
//   //   print('AppLinksService:::::$uri');
//   //
//   //  if(_promoId.isNotEmpty){
//   //    referralCode=promoId;
//   //    log('AppLinksService::code :::$referralCode');
//   //    print('AppLinksService::code :::$referralCode');
//   //    showToast('Referal By $referralCode');
//   //
//   //  }
//   // }
// }



import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:app_links/app_links.dart';
import 'package:apollo/resources/utils.dart';

class AppLinksService {
  static final AppLinks _appLinks = AppLinks();

  static String _promoId = '';
  static String get promoId => _promoId;
  static bool get hasPromoId => _promoId.isNotEmpty;

  static void reset() => _promoId = '';
  static Future<void> init() async {
    try {
      // Case 1: App opened via link (cold start)
      final initialLink = await _appLinks.getInitialLink();
      _handleLink(initialLink);

      // Case 2: App already running (warm/hot)
      _appLinks.uriLinkStream.listen(
            (Uri? uri) {
          _handleLink(uri);
        },
        onError: (err) {
          if (kDebugMode) print("AppLinks error: $err");
        },
      );
    } catch (e) {
      if (kDebugMode) print("AppLinks initialization failed: $e");
    }
  }

  static void _handleLink(Uri? uri) {
    if (uri == null || uri.queryParameters.isEmpty) return;

    final params = uri.queryParameters;
    final receivedPromoId = params['refCode'] ?? '';

    // If both are empty, ignore
    if (receivedPromoId.isEmpty) return;

    _promoId = receivedPromoId;

    log('AppLinksService:::::$uri');
    print('AppLinksService:::::$uri');

    if (_promoId.isNotEmpty) {
      referralCode = _promoId;
      log('AppLinksService::code :::$referralCode');
      print('AppLinksService::code :::$referralCode');
      showToast('Referral By $referralCode');
    }

  }

}


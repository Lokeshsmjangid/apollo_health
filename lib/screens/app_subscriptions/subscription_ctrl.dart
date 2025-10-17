// import 'dart:convert';
// import 'dart:async';
// import 'dart:io';
// import 'package:apollo/resources/Apis/api_repository/send_payment_detail_to_backend_repo.dart';
// import 'package:apollo/resources/custom_loader.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
// import 'package:get/get.dart';
// import 'package:apollo/resources/utils.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:apollo/resources/auth_data.dart';
// import 'package:apollo/resources/local_storage.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:apollo/custom_widgets/custom_snakebar.dart';
//
// class SubscriptionCtrl extends GetxController {
//   String selectedPlan = "";
//
//   final InAppPurchase iap = InAppPurchase.instance;
//   String monthlyId = 'monthly_plan';
//   String yearlyId = 'yearly_plan';
//   List<ProductDetails> products = [];
//   bool isAvailable = false;
//   RxBool isSubscribed = false.obs;
//   RxString activePlan = 'Starter Plan'.obs;
//   StreamSubscription<List<PurchaseDetails>>? _subscription;
//   Set<String> handledPurchaseIds = {};
//   String buttonMonth = '';
//   String buttonAnnual = '';
//   final features = [
//     ["‘Daily Dose’ Nuggets", true, true],
//     ["Solo Play", true, true],
//     ["Group Play", true, true],
//     ["Category Access", "5", "30+"],
//     ["High Stakes Mode", false, true],
//     ["Medpardy", false, true],
//     ["Wheel of Wellness", false, true],
//     ["MedLingo", false, true],
//     ["Ad-Free Experience", false, true],
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     initStoreInfo();
//   }
//
//   @override
//   void onClose() {
//     _subscription?.cancel();
//     super.onClose();
//   }
//
//   /// To Store initialize and fetch product details
//   Future<void> initStoreInfo() async {
//     isAvailable = await iap.isAvailable();
//     if (!isAvailable) {
//       apolloPrint(message: 'In-app purchase store not available');
//       update();
//       return;
//     }
//
//     Set<String> kProductIds = {monthlyId, yearlyId};
//     final ProductDetailsResponse response = await iap.queryProductDetails(
//       kProductIds,
//     );
//     if (response.productDetails.isNotEmpty) {
//       products = response.productDetails;
//       for (var product in response.productDetails) {
//         print('Title: ${product.title}'); // Product title
//         print('Description: ${product.description}');
//         print('Price: ${product.price}'); // localized price
//         print('Currency: ${product.currencyCode}');
//         print('plan id: ${product.id}');
//         if (product.id == yearlyId) {
//           buttonAnnual = product.price;
//         } else if (product.id == monthlyId) {
//           buttonMonth = product.price;
//         }
//       }
//     }
//
//     if (response.error != null) {
//       apolloPrint(message: 'Error fetching products: ${response.error}');
//     }
//
//     if (response.productDetails.isEmpty) {
//       apolloPrint(message: 'No products found for the IDs provided.');
//     }
//     products = response.productDetails;
//     _subscription = iap.purchaseStream.listen(
//           (List<PurchaseDetails> purchaseDetailsList) {
//         print('purchaseDetailsList - $purchaseDetailsList');
//         handlePurchaseUpdates(
//           purchaseDetailsList: purchaseDetailsList,
//         );
//       },
//       onDone: () {
//         _subscription?.cancel();
//       },
//       onError: (error) {
//         apolloPrint(message: 'Purchase stream error: $error');
//       },
//     );
//     // Auto restore purchases
//
//
//      if(activePlan.value.toString()=="Starter Plan")
//        {
//          await iap.restorePurchases();
//        }
//     update();
//   }
//
//   /// To handle Purchase updates
//   ///
//   RxList<PurchaseDetails> purchaseHistory =
//       <PurchaseDetails>[].obs; // details ek external screen pe dikhane k liye
//   // void listenToPurchaseUpdated(List<PurchaseDetails> purchases) {
//   //   if (purchases.isEmpty) {
//   //     apolloPrint(message:  "👉 No active purchases found (subscription expired)");
//   //     LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, false);
//   //     AuthData().getLoginData();
//   //   } else {
//   //     for (var purchase in purchases) {
//   //       purchaseHistory.add(purchase);
//   //
//   //
//   //       apolloPrint(message:  "\nlokii log:: productID:${purchase.productID}\n, purchaseID: ${purchase.purchaseID}\n, status: ${purchase.status}\n, transactionDate: ${purchase.transactionDate}\n, purchase.verificationData-1: ${purchase.verificationData.serverVerificationData}\n, purchase.verificationData-2: ${purchase.verificationData.localVerificationData}\n, purchase.verificationData-3: ${purchase.verificationData.source}\n lokii log end");
//   //       print( "\nlokii print:: productID:${purchase.productID}, status: ${purchase.status}, transactionDate: ${purchase.transactionDate}\n lokii log end");
//   //
//   //       if (purchase.status == PurchaseStatus.purchased) {
//   //         _handlePurchase(purchase, isRestore: false);
//   //       }
//   //       else if (purchase.status == PurchaseStatus.restored) {
//   //         print('// ✅ Only handle restore for iOS');
//   //         apolloPrint(message:  '// ✅ Only handle restore for iOS');
//   //         _handlePurchase(purchase, isRestore: true);
//   //       }
//   //       else if (purchase.status == PurchaseStatus.canceled) {
//   //         apolloPrint(message:  'Subscription canceled by user');
//   //         update();
//   //         _setLoadingFalse();
//   //       }
//   //       else if (purchase.status == PurchaseStatus.error) {
//   //         apolloPrint(message:  'Purchase error: ${purchase.error}');
//   //         CustomSnackBar().showSnack(
//   //           Get.context!,
//   //           message: 'Purchase failed: ${purchase.error?.message}',
//   //           isSuccess: false,
//   //         );
//   //         _setLoadingFalse();
//   //       }
//   //
//   //       if (purchase.pendingCompletePurchase) {
//   //         iap.completePurchase(purchase);
//   //       }
//   //     }
//   //   }
//   // }
//
//   /// Common handler for purchase/restore
//   /// Common handler for purchase/restore
//
//
//
//
//   /// Buy Subscription
//   bool loadingMplan = false;
//   bool loadingYplan = false;
//   void _setLoadingFalse() {
//     loadingMplan = false;
//     loadingYplan = false;
//     update();
//   }
//
//   void buySubscription({required String planId}) async {
//     print('planId - $planId');
//     if (products.isEmpty) {
//       CustomSnackBar().showSnack(
//         Get.context!,
//         message: 'Products not loaded',
//         isSuccess: false,
//       );
//       return;
//     }
//     try {
//       if (planId == monthlyId) {
//         loadingMplan = true;
//       } else {
//         loadingYplan = true;
//       }
//       update();
//       final product = products.firstWhere(
//         (prod) => prod.id == planId,
//         orElse: () {
//           throw Exception("Product plan not found");
//         },
//       );
//
//       print('product test tst- ${product.id}');
//
//       final purchaseParam = PurchaseParam(productDetails: product);
//       iap.buyNonConsumable(purchaseParam: purchaseParam);
//
//       apolloPrint(message: "Initiating purchase for ${product.id}");
//     } catch (e) {
//       apolloPrint(message: 'Error initiating purchase: $e');
//       CustomSnackBar().showSnack(
//         Get.context!,
//         message: 'Failed to initiate purchase',
//         isSuccess: false,
//       );
//     } finally {
//       if (planId == monthlyId) {
//         loadingMplan = false;
//       } else {
//         loadingYplan = false;
//       }
//       update();
//     }
//   }
//
//
//   bool apiCallDone = false;
//
//   Future<void> handlePurchaseUpdates({
//     required List<PurchaseDetails> purchaseDetailsList,
//   }) async {
//
//
//     for (int index = 0; index < purchaseDetailsList.length; index++) {
//       final purchase = purchaseDetailsList[index];
//       final purchaseStatus = purchase.status;
//       String inappCustomerId = "";
//       String inappCustomerId_new = "";
//       final id = purchase.purchaseID ?? purchase.verificationData.localVerificationData;
//
//       // if (handledPurchaseIds.contains(id)) {
//       //   apolloPrint(message: "Skipping already handled purchase: $id");
//       //   continue;
//       // }
//       handledPurchaseIds.add(id);
//       switch (purchaseStatus) {
//         case PurchaseStatus.pending:
//           apolloPrint(message: 'Purchase is pending.');
//           print("Purchase is pending.");
//           continue;
//
//         case PurchaseStatus.error:
//           apolloPrint(message: 'Purchase error: ${purchase.error}');
//           print("Purchase error: ${purchase.error}");
//           break;
//
//         case PurchaseStatus.canceled:
//           apolloPrint(message: 'Purchase canceled.');
//           print("Purchase canceled.");
//           break;
//
//         case PurchaseStatus.purchased:
//           if (Platform.isIOS) {
//             final transactions = await SKPaymentQueueWrapper().transactions();
//             final originalTransaction = transactions.firstWhere(
//                   (txn) =>
//               txn.originalTransaction?.transactionIdentifier != null,
//             );
//             inappCustomerId = originalTransaction.originalTransaction
//                 ?.transactionIdentifier ?? "";
//
//             final originalTransaction_new = transactions.firstWhere(
//                   (txn) => txn.transactionIdentifier != null,
//             );
//             inappCustomerId_new =
//                 originalTransaction_new.transactionIdentifier ?? "";
//           } else {
//             inappCustomerId = purchase.verificationData.serverVerificationData;
//           }
//
//           apolloPrint(
//             message: "Customer ID Purchasd:::::: ${purchaseDetailsList.first
//                 .productID}",
//           );
//           apolloPrint(
//               message: "inappCustomerId::(Purchased):::: $inappCustomerId");
//           apolloPrint(
//               message: "inappCustomerId_new::(Purchased):::: $inappCustomerId_new");
//           if (apiCallDone == false && inappCustomerId.isNotEmpty) {
//             apiCallDone = true;
//           showLoader(true);
//           await sendPaymentToBackendApi(
//             purchaseStatus: purchaseDetailsList.first.status.name,
//             plan_id: activePlan.value,
//             amount: activePlan.value == monthlyId ? buttonMonth : activePlan
//                 .value == yearlyId ? buttonAnnual : 0,
//             purchaseID: purchase.purchaseID,
//             customerId: inappCustomerId,
//             startDate: DateTime
//                 .now()
//                 .millisecondsSinceEpoch,
//             endDate: DateTime
//                 .now()
//                 .millisecondsSinceEpoch,
//             source: purchase.verificationData.source,
//           ).then((value) {
//             showLoader(false);
//             if (value.status == true) {
//               LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, true);
//               LocalStorage().setValue(
//                 LocalStorage.USER_DATA,
//                 jsonEncode(value.data),
//               );
//               AuthData().getLoginData();
//
//               update();
//             } else if (value.status == false) {
//               CustomSnackBar().showSnack(
//                 Get.context!,
//                 message: "${value.message}",
//                 isSuccess: false,
//               );
//               update();
//             }
//           });
//       }
//
//           apolloPrint(message: 'Purchase completed.');
//           break;
//
//         case PurchaseStatus.restored:
//           print('Restore Call step 1');
//           try {
//             print('Restore Call step 2');
//             if (Platform.isIOS) {
//               final transactions = await SKPaymentQueueWrapper().transactions();
//               final originalTransaction = transactions.firstWhere(
//                     (txn) =>
//                 txn.originalTransaction?.transactionIdentifier != null,
//               );
//               inappCustomerId = originalTransaction.originalTransaction
//                   ?.transactionIdentifier ?? "";
//
//               final originalTransaction_new = transactions.firstWhere(
//                     (txn) => txn.transactionIdentifier != null,
//               );
//               inappCustomerId_new =
//                   originalTransaction_new.transactionIdentifier ?? "";
//             } else {
//               inappCustomerId =
//                   purchase.verificationData.serverVerificationData;
//             }
//
//             apolloPrint(
//               message: "productID:::::: ${purchaseDetailsList.first.productID}",
//             );
//             apolloPrint(message: "inappCustomerId:::::: $inappCustomerId");
//             apolloPrint(
//                 message: "inappCustomerId_new:::::: $inappCustomerId_new");
//             if (apiCallDone == false && inappCustomerId.isNotEmpty) {
//               apiCallDone = true;
//             showLoader(true);
//             await sendPaymentToBackendApi(
//               purchaseStatus: purchaseDetailsList.first.status.name,
//               plan_id: activePlan.value,
//               amount: activePlan.value == monthlyId ? buttonMonth
//                   : activePlan.value == yearlyId ? buttonAnnual : 0,
//               purchaseID: purchase.purchaseID,
//               customerId: inappCustomerId,
//               startDate: DateTime.now().millisecondsSinceEpoch,
//               endDate: DateTime.now().millisecondsSinceEpoch,
//               source: purchase.verificationData.source,
//             ).then((value) {
//               showLoader(false);
//               if (value.status == true) {
//                 LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, true);
//                 LocalStorage().setValue(
//                   LocalStorage.USER_DATA,
//                   jsonEncode(value.data),
//                 );
//                 AuthData().getLoginData();
//                 update();
//               } else if (value.status == false) {
//                 CustomSnackBar().showSnack(
//                   Get.context!,
//                   message: "${value.message}",
//                   isSuccess: false,
//                 );
//                 update();
//               }
//             });
//           }
//
//             apolloPrint(message: 'Purchase restored.');
//           } catch (e) {
//             apolloPrint(message: "Error inside restore: $e");
//             print("Error inside restore: $e");
//           }
//           apolloPrint(message: 'Purchase restored.');
//           print('Purchase restored.');
//           break;
//       }
//
//       // Finalize the purchase if required
//       if (purchase.pendingCompletePurchase) {
//         await iap.completePurchase(purchase).then((_) {
//           apolloPrint(message: 'Pending purchase finalized.');
//           print("Pending purchase finalized.");
//         });
//       }
//
//       // Stop loading in all non-pending cases
//       if (purchaseStatus != PurchaseStatus.pending) {}
//     }
//   }
//
//   /// Restore Subscription manually
//   // Future<void> restoreSubscription() async {
//   //   try {
//   //     await iap.restorePurchases();
//   //     CustomSnackBar().showSnack(
//   //       Get.context!,
//   //       message: 'Restoring purchases...',
//   //       isSuccess: true,
//   //     );
//   //   } catch (e) {
//   //     apolloPrint(message:  'Error restoring purchases: $e');
//   //     CustomSnackBar().showSnack(
//   //       Get.context!,
//   //       message: 'Failed to restore purchases',
//   //       isSuccess: false,
//   //     );
//   //   }
//   // }
//
//   /// Cancel subscription (redirect to store)
//   Future<void> cancelSubscription() async {
//     print('object:::::cancelSubscription hitting');
//     const androidUrl =
//         "https://play.google.com/store/account/subscriptions"; // Play Store
//     const iosUrl = "https://apps.apple.com/account/subscriptions"; // App Store
//
//     final url = GetPlatform.isAndroid ? androidUrl : iosUrl;
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//     } else {
//       CustomSnackBar().showSnack(
//         Get.context!,
//         message: 'Could not open subscription management page',
//         isSuccess: false,
//       );
//     }
//   }
//
//   /*Future<void> sendSubscriptionDetailsToApi(PurchaseDetails purchase) async {
//     try {
//       final response = await YourApiClient.sendSubscriptionData(
//         productId: purchase.productID,
//         purchaseToken: purchase.verificationData.serverVerificationData,
//         transactionDate: purchase.transactionDate,
//       );
//       if (response.isSuccess) {
//         apolloPrint(message:  "Subscription details successfully sent to API");
//       } else {
//         apolloPrint(message:  "Failed to send subscription details to API");
//       }
//     } catch (e) {
//       apolloPrint(message:  "Error sending subscription details to API: $e");
//     }
//   }*/
// }

import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:apollo/controllers/settings_ctrl.dart';
import 'package:apollo/resources/Apis/api_repository/send_payment_detail_to_backend_repo.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:get/get.dart';
import 'package:apollo/resources/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';

class PremiumPlanCtrl extends GetxController {
  String selectedPlan = "";

  InAppPurchase iap = InAppPurchase.instance;
  String monthlyId = 'monthly_plan';
  String yearlyId = 'yearly_plan';
  List<ProductDetails> products = [];
  bool isAvailable = false;
  RxBool isSubscribed = false.obs;
  RxString activePlan = 'Starter Plan'.obs;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Set<String> handledPurchaseIds = {};
  String buttonMonth = '';
  String buttonAnnual = '';
  final features = [
    ["‘Daily Dose’ Nuggets", true, true],
    ["Solo Play", true, true],
    ["Group Play", true, true],
    ["Category Access", "5", "30+"],
    ["High Stakes Mode", false, true],
    ["Medpardy", false, true],
    ["Wheel of Wellness", false, true],
    ["MedLingo", false, true],
    ["Ad-Free Experience", false, true],
  ];

  @override
  void onInit() {
    super.onInit();
    initStoreInfo();
    if(AuthData().userModel?.subscriptionDetail!=null && AuthData().userModel?.subscriptionDetail?.planId==monthlyId){
      selectedPlan = "1m";
    } else if(AuthData().userModel?.subscriptionDetail!=null && AuthData().userModel?.subscriptionDetail?.planId==yearlyId){
      selectedPlan = "1y";
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  /// To Store initialize and fetch product details
  Future<void> initStoreInfo() async {
    isAvailable = await iap.isAvailable();
    if (!isAvailable) {
      apolloPrint(message: 'In-app purchase store not available');
      update();
      return;
    }

    Set<String> kProductIds = {monthlyId, yearlyId};
    final ProductDetailsResponse response = await iap.queryProductDetails(
      kProductIds,
    );
    if (response.productDetails.isNotEmpty) {
      products = response.productDetails;
      for (var product in response.productDetails) {
        print('Title: ${product.title}'); // Product title
        print('Description: ${product.description}');
        print('Price: ${product.price}'); // localized price
        print('Currency: ${product.currencyCode}');
        print('plan id: ${product.id}');
        if (product.id == yearlyId) {
          buttonAnnual = product.price;
        } else if (product.id == monthlyId) {
          buttonMonth = product.price;
        }
      }
    }

    if (response.error != null) {
      apolloPrint(message: 'Error fetching products: ${response.error}');
      log( 'Error fetching products: ${response.error}');
    }

    if (response.productDetails.isEmpty) {
      apolloPrint(message: 'No products found for the IDs provided.');
      log( 'No products found for the IDs provided.');
    }
    products = response.productDetails;
    setupPurchaseListener();
    update();
  }

  void setupPurchaseListener() {
    _subscription = iap.purchaseStream.listen(
          (List<PurchaseDetails> purchaseDetailsList) async {
        print('🎯 Listener triggered with: $purchaseDetailsList');
        await handlePurchaseUpdates(purchaseDetailsList: purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
        print('🔁 Listener done');
      },
      onError: (error) {
        print('❌ Listener error: $error');
      },
    );
  }


  /// To handle Purchase updates
  ///
  RxList<PurchaseDetails> purchaseHistory =
      <PurchaseDetails>[].obs; // details ek external screen pe dikhane k liye


  /// Common handler for purchase/restore

  /// Buy Subscription
  bool loadingMplan = false;
  bool loadingYplan = false;
  void _setLoadingFalse() {
    loadingMplan = false;
    loadingYplan = false;
    update();
  }

  void buySubscription({required String planId}) async {
    print('planId - $planId');
    log('planId - $planId');
    if (products.isEmpty) {
      CustomSnackBar().showSnack(
        Get.context!,
        message: 'Products not loaded',
        isSuccess: false,
      );
      return;
    }
    try {
      if (planId == monthlyId) {
        loadingMplan = true;
      } else {
        loadingYplan = true;
      }
      update();
      final product = products.firstWhere(
        (prod) => prod.id == planId,
        orElse: () {
          throw Exception("Product plan not found");
        },
      );

      print('product test tst- ${product.id}');
      log('product test tst- ${product.id}');

      final purchaseParam = PurchaseParam(productDetails: product);
      iap.buyNonConsumable(purchaseParam: purchaseParam);

      apolloPrint(message: "Initiating purchase for ${product.id}");
      log("Initiating purchase for ${product.id}");
      // showLoader(false);
    } catch (e) {
      apolloPrint(message: 'Error initiating purchase: $e');
      log('Error initiating purchase: $e');
      // showLoader(false);
      CustomSnackBar().showSnack(
        Get.context!,
        message: 'Failed to initiate purchase',
        isSuccess: false,
      );
    } finally {
      if (planId == monthlyId) {
        loadingMplan = false;
      } else {
        loadingYplan = false;
      }
      // showLoader(false);
      update();
    }
  }



  bool apiCallDone = false;


  Future<void> restoreSubscription() async {
    try {

      // 1. Cancel old subscription listener
      // 3. Trigger restore

     await iap.restorePurchases();

      if (Platform.isIOS) {
        SKPaymentTransactionWrapper orignalIdentifier;
        final transactions = await SKPaymentQueueWrapper().transactions();
        log("transactions.toList().length.toString()");
        log(transactions.toList().length.toString());
        print(transactions.toList());
        if(transactions.isEmpty)return;


        List<Map<String,dynamic>> customerIds=[];


        var productId ;
        var purchaseID ;

        for(int i=0;i<transactions.length;i++)
        {
          customerIds.add({
            "customer_id":transactions[i].originalTransaction?.transactionIdentifier,
            "product_id":transactions[i].payment.productIdentifier
          });
          productId =transactions[i].payment.productIdentifier;
          purchaseID =transactions[i].originalTransaction?.transactionIdentifier;
        }
        var extraIds= customerIds.toSet().toList();
              update();
              log('lokesh');
              showLoader(true);
                  await sendPaymentToBackendApi(
                    purchaseStatus: "restored",
                    plan_id: productId,
                    amount: productId == monthlyId ? buttonMonth : productId == yearlyId ? buttonAnnual : 0,
                    purchaseID: purchaseID,
                    customerId: purchaseID,
                    startDate: DateTime.now().millisecondsSinceEpoch,
                    endDate: DateTime.now().millisecondsSinceEpoch,
                    source: "app_store",
                    customerIds: extraIds
                  ).then((value) {
                    showLoader(false);
                    if (value.status == true) {
                      SettingsCtrl settingsCtrl=Get.find();
                      settingsCtrl.onInit();
                      // LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, true);
                      // LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                      // AuthData().getLoginData();
                      update();
                      update();
                    } else if (value.status == false ) {
                      if(value.message != null && value.message!.isNotEmpty){
                        CustomSnackBar().showSnack(
                          Get.context!,
                          message: "${value.message}",
                          isSuccess: false,
                        );
                      }

                      update();
                      update();
                    }
                  });


      // CustomSnackBar().showSnack(
      //   Get.context!,
      //   message: '🔄 Restoring purchases...',
      //   isSuccess: true,
      // );
    }} catch (e) {
      SettingsCtrl settingsCtrl=Get.find();
      settingsCtrl.onInit();
      apolloPrint(message: 'Error restoring purchases: $e');
      // CustomSnackBar().showSnack(
      //   Get.context!,
      //   message: 'Failed to restore purchases',
      //   isSuccess: false,
      // );
    }finally{
      SettingsCtrl settingsCtrl=Get.find();
      settingsCtrl.onInit();
    }
  }


  Future<void> handlePurchaseUpdates({
    required List<PurchaseDetails> purchaseDetailsList,
  }) async {


    for (int index = 0; index < purchaseDetailsList.length; index++) {
      final purchase = purchaseDetailsList[index];
      final purchaseStatus = purchase.status;
      String inappCustomerId = "";
      String inappCustomerId_new = "";
      final id = purchase.purchaseID ?? purchase.verificationData.localVerificationData;

      // if (handledPurchaseIds.contains(id)) {
      //   apolloPrint(message: "Skipping already handled purchase: $id");
      //   continue;
      // }
      handledPurchaseIds.add(id);
      switch (purchaseStatus) {
        case PurchaseStatus.pending:
          apolloPrint(message: 'Purchase is pending.');
          print("Purchase is pending.");
          continue;

        case PurchaseStatus.error:
          apolloPrint(message: 'Purchase error: ${purchase.error}');
          print("Purchase error: ${purchase.error}");
          break;

        case PurchaseStatus.canceled:
          apolloPrint(message: 'Purchase canceled.');
          print("Purchase canceled.");
          break;

        case PurchaseStatus.purchased:

          // Resolve platform-specific identifiers
          String planId = purchase.productID;
          String purchaseIdToSend = purchase.purchaseID ?? '';
          String customerIdToSend = '';

          if (Platform.isIOS) {
            final transactions = await SKPaymentQueueWrapper().transactions();
            final List<SKPaymentTransactionWrapper> txnsWithOrig = transactions
                .where((txn) => txn.originalTransaction?.transactionIdentifier != null)
                .toList();
            final List<SKPaymentTransactionWrapper> txnsWithId = transactions
                .where((txn) => txn.transactionIdentifier != null)
                .toList();

            final SKPaymentTransactionWrapper? originalTxnWithOrig =
                txnsWithOrig.isNotEmpty ? txnsWithOrig.first : null;
            final SKPaymentTransactionWrapper? anyTxnWithId =
                txnsWithId.isNotEmpty ? txnsWithId.first : null;

            customerIdToSend = originalTxnWithOrig?.originalTransaction?.transactionIdentifier
                ?? anyTxnWithId?.transactionIdentifier
                ?? '';
            purchaseIdToSend = anyTxnWithId?.transactionIdentifier ?? purchaseIdToSend;
          }
          else {
            customerIdToSend = purchase.verificationData.serverVerificationData;
          }

          final dynamic amountToSend = planId == yearlyId
              ? buttonAnnual
              : planId == monthlyId
                  ? buttonMonth
                  : 0;

          apolloPrint(message: 'Purchased planId:$planId purchaseId:$purchaseIdToSend');

          if (apiCallDone == false && customerIdToSend.isNotEmpty) {
            apiCallDone = true;

            showLoader(true);
            await sendPaymentToBackendApi(
              purchaseStatus: purchase.status.name,
              plan_id: planId,
              amount: amountToSend,
              purchaseID: purchaseIdToSend,
              customerId: customerIdToSend,
              startDate: DateTime.now().millisecondsSinceEpoch,
              endDate: DateTime.now().millisecondsSinceEpoch,
              source: Platform.isIOS ? 'app_store' : purchase.verificationData.source,
            ).then((value) {
              showLoader(false);
              if (value.status == true) {
                // Update premium locally and refresh settings

                // LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, true);
                // LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                // AuthData().getLoginData();


                if (Get.isRegistered<SettingsCtrl>()) {
                  Get.find<SettingsCtrl>().onInit();
                  Get.back();
                }
                CustomSnackBar().showSnack(
                  Get.context!,
                  message: "Subscription purchased successfully.",
                  isSuccess: true,
                );
                update();
                update();

              } else {
                if(value.message != null && value.message!.isNotEmpty){
                  CustomSnackBar().showSnack(
                    Get.context!,
                    message: "${value.message}",
                    isSuccess: false,
                  );
                }
                update();
                update();
              }
            });
          }

          apolloPrint(message: 'Purchase completed.');
          break;
          case PurchaseStatus.restored:
          print('Restore Call step 1 purchased');
          log('Restore Call step 1 purchased');

          try {

            // 1. Cancel old subscription listener
            // 3. Trigger restore

            if (Platform.isIOS) {
              final transactions = await SKPaymentQueueWrapper().transactions();
              if (transactions.isEmpty) {
                apolloPrint(message: 'Restore: No StoreKit transactions found');
                // Fallback: use data from purchase payload so user doesn't need to restart
                final String productId = purchase.productID;
                final dynamic amountToSend = productId == monthlyId ? buttonMonth : productId == yearlyId ? buttonAnnual : 0;
                final String purchaseId = purchase.purchaseID ?? '';
                final String customerId = purchase.verificationData.serverVerificationData.isNotEmpty
                    ? purchase.verificationData.serverVerificationData
                    : purchaseId;
                if (apiCallDone == false && customerId.isNotEmpty) {
                  apiCallDone = true;
                  showLoader(true);
                  await sendPaymentToBackendApi(
                    purchaseStatus: "restored",
                    plan_id: productId,
                    amount: amountToSend,
                    purchaseID: purchaseId,
                    customerId: customerId,
                    startDate: DateTime.now().millisecondsSinceEpoch,
                    endDate: DateTime.now().millisecondsSinceEpoch,
                    source: "app_store",
                    customerIds: const [],
                  ).then((value) {
                    showLoader(false);
                    if (value.status == true) {
                      if (Get.isRegistered<SettingsCtrl>()) {
                        Get.find<SettingsCtrl>().onInit();
                      }
                      update();
                      update();
                    } else {
                      if(value.message != null && value.message!.isNotEmpty){
                        CustomSnackBar().showSnack(
                          Get.context!,
                          message: "${value.message}",
                          isSuccess: false,
                        );
                      }
                    }
                    update();
                  });
                }
                break;
              }
              // Prefer the product that matches the restored purchase's productID
              final String restoredProductId = purchase.productID;
              final List<SKPaymentTransactionWrapper> productTxns =
                  transactions.where((t) => t.payment.productIdentifier == restoredProductId).toList();
              // Fallback to latest transaction if matching list is empty
              final List<SKPaymentTransactionWrapper> sourceTxns =
                  productTxns.isNotEmpty ? productTxns : transactions;

              if (sourceTxns.isEmpty) {
                apolloPrint(message: 'Restore: No transactions for productId $restoredProductId');
                break;
              }

              // Choose most recent by timestamp when available
              if (sourceTxns.length > 1) {
                sourceTxns.sort((a, b) {
                  final at = a.transactionTimeStamp ?? 0;
                  final bt = b.transactionTimeStamp ?? 0;
                  return bt.compareTo(at);
                });
              }

              final SKPaymentTransactionWrapper latestTxn = sourceTxns.first;
              final String productId = latestTxn.payment.productIdentifier;

              // IDs to send
              final String? originalId = latestTxn.originalTransaction?.transactionIdentifier;
              inappCustomerId = originalId ?? latestTxn.transactionIdentifier ?? '';
              inappCustomerId_new = latestTxn.transactionIdentifier ?? '';

              // Build filtered extraIds for only this product
              final List<Map<String, dynamic>> customerIds = sourceTxns
                  .map((t) => {
                        "customer_id": t.originalTransaction?.transactionIdentifier ?? t.transactionIdentifier,
                        "product_id": t.payment.productIdentifier,
                      }).toList();

              if (apiCallDone == false && inappCustomerId.isNotEmpty) {
                apiCallDone = true;
                update();
                log('lokesh');
                showLoader(true);

                final dynamic amountToSend = productId == monthlyId
                    ? buttonMonth
                    : productId == yearlyId
                        ? buttonAnnual
                        : 0;

                await sendPaymentToBackendApi(
                    purchaseStatus: "restored",
                    plan_id: productId,
                    amount: amountToSend,
                    purchaseID: inappCustomerId_new,
                    customerId: inappCustomerId,
                    startDate: DateTime.now().millisecondsSinceEpoch,
                    endDate: DateTime.now().millisecondsSinceEpoch,
                    source: "app_store",
                    customerIds: customerIds).then((value) {
                  showLoader(false);
                  if (value.status == true) {
                    SettingsCtrl settingsCtrl = Get.find();
                    settingsCtrl.onInit();
                    update();
                    update();
                  } else if (value.status == false) {
                    if(value.message != null && value.message!.isNotEmpty){
                      CustomSnackBar().showSnack(
                        Get.context!,
                        message: "${value.message}",
                        isSuccess: false,
                      );
                    }
                    update();
                  }
                });
              }
            }
            else {
              // Android restore path
              inappCustomerId = purchase.verificationData.serverVerificationData;
              if (apiCallDone == false && inappCustomerId.isNotEmpty) {
              apiCallDone = true;
              showLoader(true);
              await sendPaymentToBackendApi(
                purchaseStatus: "restored",
                plan_id: purchase.productID,
                amount: purchase.productID == monthlyId ? buttonMonth : purchase.productID == yearlyId ? buttonAnnual : 0,
                purchaseID: purchase.purchaseID,
                customerId: inappCustomerId,
                startDate: DateTime.now().millisecondsSinceEpoch,
                endDate: DateTime.now().millisecondsSinceEpoch,
                source: Platform.isIOS ? 'app_store' : purchase.verificationData.source,
                customerIds: const [],
              ).then((value) {
                showLoader(false);
                if (value.status == true) {
                  SettingsCtrl settingsCtrl = Get.find();
                  settingsCtrl.onInit();
                  update();
                  update();
                } else if (value.status == false) {
                  if(value.message != null && value.message!.isNotEmpty){
                    CustomSnackBar().showSnack(
                      Get.context!,
                      message: "${value.message}",
                      isSuccess: false,
                    );
                    update();
                  }
                }
              });
            }
            }
          } catch (e) {
            apolloPrint(message: 'Error restoring purchases: $e');
            // CustomSnackBar().showSnack(
            //   Get.context!,
            //   message: 'Failed to restore purchases',
            //   isSuccess: false,
            // );
          }
          //
          // if (latestValidPurchase == null ||
          //     purchase.transactionDate != null &&
          //         (latestValidPurchase.transactionDate == null ||
          //             int.parse(purchase.transactionDate!) > int.parse(latestValidPurchase.transactionDate!))) {
          //   latestValidPurchase = purchase;
          // }

          // if (latestValidPurchase != null) {
          //   var productId ;
          //   var purchaseID ;

            // try {
            //   print('Restore Call step 2');
            //   if (Platform.isIOS) {
            //     SKPaymentTransactionWrapper orignalIdentifier;
            //     final transactions = await SKPaymentQueueWrapper().transactions();
            //     if(transactions.isEmpty)return ;
            //     final originalTransaction = transactions.lastWhere((txn) =>
            //       txn.originalTransaction?.transactionIdentifier != null,
            //     );
            //     for(int i=0;i<transactions.length;i++)
            //       {
            //         apolloPrint(
            //           message: "productID:::$i::: ${transactions[i].payment} ",
            //         );
            //         apolloPrint(
            //           message: "productID:::$i::: ${transactions[i].transactionIdentifier} ",
            //         );
            //         apolloPrint(
            //           message: "productID:::$i::: ${transactions[i].originalTransaction} ",
            //         );
            //         apolloPrint(
            //           message: "productID:::$i::: ${transactions[i].transactionTimeStamp} ",
            //         );
            //         apolloPrint(
            //           message: "productID:::$i::: ${transactions[i].transactionTimeStamp} ",
            //         );
            //         apolloPrint(
            //           message: "productID:::$i::: ${transactions[i].payment.productIdentifier} ",
            //         );
            //         apolloPrint(
            //           message: "productID:::$i::: ${transactions[i].payment.applicationUsername} ",
            //         );
            //         apolloPrint(
            //           message: "productID:::$i::: ${transactions[i].payment.requestData} ",
            //         );
            //
            //         productId = transactions[i].payment.productIdentifier;
            //         purchaseID = transactions[i].transactionIdentifier;
            //
            //       }
            //     inappCustomerId = originalTransaction.transactionIdentifier ?? "";
            //
            //     final originalTransaction_new = transactions.firstWhere(
            //           (txn) => txn.transactionIdentifier != null,
            //     );
            //     inappCustomerId_new =
            //         originalTransaction_new.transactionIdentifier ?? "";
            //     orignalIdentifier = originalTransaction_new;
            //     apolloPrint(
            //       message: "productID:::::: ${orignalIdentifier.payment} ",
            //     );
            //     apolloPrint(
            //       message: "productID:::::: ${orignalIdentifier.transactionIdentifier} ",
            //     );
            //     apolloPrint(
            //       message: "productID:::::: ${orignalIdentifier.transactionTimeStamp} ",
            //     );
            //     apolloPrint(
            //       message: "productID:::::: ${orignalIdentifier.payment.productIdentifier} ",
            //     );
            //     apolloPrint(
            //       message: "productID:::::: ${orignalIdentifier.payment.applicationUsername} ",
            //     );
            //     apolloPrint(
            //       message: "productID:::::: ${orignalIdentifier.payment.requestData} ",
            //     );
            //   }
            //   else {
            //     inappCustomerId =
            //         purchase.verificationData.serverVerificationData;
            //   }
            //   apolloPrint(
            //     message: "productID:::::: ${purchaseDetailsList.last.productID} ",
            //   );
            //
            //
            //   apolloPrint(message: "inappCustomerId:::::: $inappCustomerId");
            //   apolloPrint(
            //       message: "inappCustomerId_new:::::: $inappCustomerId_new");
            //   if(AuthData().userModel?.subscriptionDetail == null || AuthData().userModel?.subscriptionDetail?.planId=="Starter Plan")
            //   {
            //     if (apiCallDone == false && inappCustomerId.isNotEmpty) {
            //       apolloPrint(
            //         message: "productID::::::== ${purchaseDetailsList.last.productID}",
            //       );
            //       if(purchaseDetailsList.last.productID==monthlyId){
            //         selectedPlan = "1m";
            //       } else if(purchaseDetailsList.last.productID==yearlyId){
            //         selectedPlan = "1y";
            //       }
            //       apiCallDone = true;
            //       update();
            //       log('lokesh');
            //      /* showLoader(true);
            //
            //
            //       await sendPaymentToBackendApi(
            //         purchaseStatus: purchaseDetailsList.last.status.name,
            //         plan_id: productId,
            //         amount: productId == monthlyId ? buttonMonth : productId == yearlyId ? buttonAnnual : 0,
            //         purchaseID: purchaseID,
            //         customerId: inappCustomerId,
            //         startDate: DateTime.now().millisecondsSinceEpoch,
            //         endDate: DateTime.now().millisecondsSinceEpoch,
            //         source: purchase.verificationData.source,
            //       ).then((value) {
            //         showLoader(false);
            //         if (value.status == true) {
            //           LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, true);
            //           LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
            //           AuthData().getLoginData();
            //           update();
            //         } else if (value.status == false) {
            //           CustomSnackBar().showSnack(
            //             Get.context!,
            //             message: "${value.message}",
            //             isSuccess: false,
            //           );
            //           update();
            //         }
            //       });*/
            //     }
            //   }
            //
            //
            //   apolloPrint(message: 'Purchase restored.');
            // } catch (e) {
            //   apolloPrint(message: "Error inside restore: $e");
            //   print("Error inside restore: $e");
            // }
            // apolloPrint(message: 'Purchase restored.');
            // print('Purchase restored.');
         // }
          break;
      }

      // Finalize the purchase if required
      if (purchase.pendingCompletePurchase) {
        await iap.completePurchase(purchase).then((_) {
          apolloPrint(message: 'Pending purchase finalized.');
          print("Pending purchase finalized.");
        });
      }

      // Stop loading in all non-pending cases
      if (purchaseStatus != PurchaseStatus.pending) {}
    }
  }
  /// Restore Subscription manually
  // Future<void> restoreSubscription() async {
  //   try {
  //     await iap.restorePurchases();
  //     CustomSnackBar().showSnack(
  //       Get.context!,
  //       message: 'Restoring purchases...',
  //       isSuccess: true,
  //     );
  //   } catch (e) {
  //     apolloPrint(message:  'Error restoring purchases: $e');
  //     CustomSnackBar().showSnack(
  //       Get.context!,
  //       message: 'Failed to restore purchases',
  //       isSuccess: false,
  //     );
  //   }
  // }

  /// Cancel subscription (redirect to store)
  Future<void> cancelSubscription() async {
    print('object:::::cancelSubscription hitting');
    const androidUrl =
        "https://play.google.com/store/account/subscriptions"; // Play Store
    const iosUrl = "https://apps.apple.com/account/subscriptions"; // App Store

    final url = GetPlatform.isAndroid ? androidUrl : iosUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      CustomSnackBar().showSnack(
        Get.context!,
        message: 'Could not open subscription management page',
        isSuccess: false,
      );
    }
  }

  /*Future<void> sendSubscriptionDetailsToApi(PurchaseDetails purchase) async {
    try {
      final response = await YourApiClient.sendSubscriptionData(
        productId: purchase.productID,
        purchaseToken: purchase.verificationData.serverVerificationData,
        transactionDate: purchase.transactionDate,
      );
      if (response.isSuccess) {
        apolloPrint(message:  "Subscription details successfully sent to API");
      } else {
        apolloPrint(message:  "Failed to send subscription details to API");
      }
    } catch (e) {
      apolloPrint(message:  "Error sending subscription details to API: $e");
    }
  }*/
}


/// lokesh code above

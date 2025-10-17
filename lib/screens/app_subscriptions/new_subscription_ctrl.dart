import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:apollo/resources/Apis/api_repository/send_payment_detail_to_backend_repo.dart';
import 'package:get/get.dart';
import 'package:apollo/resources/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

class NewSubscriptionCtrl extends GetxController {
  final InAppPurchase iap = InAppPurchase.instance;
  final String monthlyId = 'monthly_plan';
  final String yearlyId  = 'yearly_plan';
  List<ProductDetails> products = [];
  bool isAvailable = false;
  RxBool isSubscribed = false.obs;
  RxString activePlan = 'Starter Plan'.obs;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

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
    checkSubscription();
    initStoreInfo();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  checkSubscription() async{
    _subscription = iap.purchaseStream.listen((purchases) => listenToPurchaseUpdated(purchases),
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        apolloPrint(message: 'Subscription error: $error');
        _setLoadingFalse();
      },
    );
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
    final ProductDetailsResponse response = await iap.queryProductDetails(kProductIds);
    if (response.productDetails.isNotEmpty) {
      products = response.productDetails;
      for (var product in response.productDetails) {
        print('Title: ${product.title}'); // Product title
        print('Description: ${product.description}');
        print('Price: ${product.price}'); // localized price
        print('Currency: ${product.currencyCode}');
        print('plan id: ${product.id}');
        if(product.id==yearlyId){
          buttonAnnual = product.price;
        } else if(product.id==monthlyId){
          buttonMonth = product.price;
        }}}

    if (response.error != null) {
      apolloPrint(message: 'Error fetching products: ${response.error}');
    }

    if (response.productDetails.isEmpty) {
      apolloPrint(message: 'No products found for the IDs provided.');
    }
    products = response.productDetails;

    // Auto restore purchases
    await iap.restorePurchases();
    update();
  }

  /// To handle Purchase updates
  ///
  RxList<PurchaseDetails> purchaseHistory = <PurchaseDetails>[].obs; // details ek external screen pe dikhane k liye
  void listenToPurchaseUpdated(List<PurchaseDetails> purchases) {
    if (purchases.isEmpty) {
      apolloPrint(message: "👉 No active purchases found (subscription expired)");
      LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, false);
      AuthData().getLoginData();
    } else {
      for (var purchase in purchases) {
        purchaseHistory.add(purchase);

        apolloPrint(message: "\nlokii log:: productID:${purchase.productID}, status: ${purchase.status}, transactionDate: ${purchase.transactionDate}\n lokii log end");
        print( "\nlokii print:: productID:${purchase.productID}, status: ${purchase.status}, transactionDate: ${purchase.transactionDate}\n lokii log end");

        if (purchase.status == PurchaseStatus.purchased) {
          _handlePurchase(purchase, isRestore: false);
        }
        else if (purchase.status == PurchaseStatus.restored && Platform.isIOS) {
          // ✅ Only handle restore for iOS
          _handlePurchase(purchase, isRestore: true);
        }
        else if (purchase.status == PurchaseStatus.canceled) {
          apolloPrint(message: 'Subscription canceled by user');
          update();
          _setLoadingFalse();
        }
        else if (purchase.status == PurchaseStatus.error) {
          apolloPrint(message: 'Purchase error: ${purchase.error}');
          CustomSnackBar().showSnack(
            Get.context!,
            message: 'Purchase failed: ${purchase.error?.message}',
            isSuccess: false,
          );
          _setLoadingFalse();
        }

        if (purchase.pendingCompletePurchase) {
          iap.completePurchase(purchase);
        }
      }
    }
  }

  /// Common handler for purchase/restore
  /// Common handler for purchase/restore
  void _handlePurchase(PurchaseDetails purchase, {bool isRestore = false}) {
    final productId = purchase.productID;

    if ([monthlyId, yearlyId].contains(productId)) {
      int startDate = 0;
      int endDate = 0;

      if (Platform.isAndroid) {
        startDate = int.tryParse(purchase.transactionDate ?? "0") ?? 0;
        endDate = DateTime.fromMillisecondsSinceEpoch(startDate)
            .add(Duration(days: productId == monthlyId ? 30 : 365))
            .millisecondsSinceEpoch;
      } else {
        startDate = (DateTime.tryParse(purchase.transactionDate ?? "") ??
            DateTime.now())
            .millisecondsSinceEpoch;
        endDate = DateTime.fromMillisecondsSinceEpoch(startDate)
            .add(Duration(days: productId == monthlyId ? 30 : 365))
            .millisecondsSinceEpoch;
      }

      // ✅ Safe lookup
      final product = products.firstWhereOrNull((p) => p.id == productId);

      if (product == null) {
        apolloPrint(message: "⚠️ Product not found in queried products: $productId");
        _setLoadingFalse();
        return;
      }

      final double rawAmount = product.rawPrice;

      apolloPrint(message: 'Lokesh ka data1--->${purchase.verificationData.serverVerificationData}');
      print( 'Lokesh ka data2--->${purchase.verificationData.serverVerificationData}');

      // Convert string to bytes
      List<int> bytes = utf8.encode(purchase.verificationData.serverVerificationData);

      // Encode bytes to Base64
      String base64Str = base64.encode(bytes);

      print("Base64: $base64Str");

      sendPurchaseToBackend(purchase,base64Str);

      /*sendPaymentToBackendApi(
        purchaseStatus: isRestore ? 'restored' : 'purchased',
        plan_id: productId,
        purchaseID: purchase.purchaseID,
        amount: rawAmount,
        customerId: purchase.verificationData.serverVerificationData,
        startDate: startDate,
        endDate: endDate,
      ).then((value) {
        if (value.status == true) {
          LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, true);
          LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
          AuthData().getLoginData();

          CustomSnackBar().showSnack(
            Get.context!,
            message: isRestore
                ? "✅ Subscription restored successfully!"
                : "🎉 Subscription purchased successfully!",
            isSuccess: true,
          );

          update();
        }
      });*/
    } else {
      apolloPrint(message: "⚠️ Ignored purchase for productId=$productId");
    }

    _setLoadingFalse();
  }




  /*void listenToPurchaseUpdated(List<PurchaseDetails> purchases) {
    if (purchases.isEmpty) {
      print("👉 No active purchases found (subscription expired)");
      apolloPrint(message: "👉 No active purchases found (subscription expired)");
      // isSubscribed.value = true;
      // activePlan.value = 'Starter Plan'; // to identify which plan is active
      LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, false);
      AuthData().getLoginData();
    }else{
      for (var purchase in purchases) {
        purchaseHistory.add(purchase);
        apolloPrint(message: "\nlokii log:: productID:${purchase.productID}\n, purchaseID: ${purchase.purchaseID}\n, status: ${purchase.status}\n, transactionDate: ${purchase.transactionDate}\n, purchase.verificationData-1: ${purchase.verificationData.serverVerificationData}\n, purchase.verificationData-2: ${purchase.verificationData.localVerificationData}\n, purchase.verificationData-3: ${purchase.verificationData.source}\n lokii log end");
        print("\nlokii print:: productID:${purchase.productID}, purchaseID: ${purchase.purchaseID}, status: ${purchase.status}, transactionDate: ${purchase.transactionDate}, purchase.verificationData-1: ${purchase.verificationData.serverVerificationData}, purchase.verificationData-2: ${purchase.verificationData.localVerificationData}, purchase.verificationData-3: ${purchase.verificationData.source}\n lokii print end");
        if (purchase.status == PurchaseStatus.purchased) {
          // if (purchase.productID == planId) {
          if ([monthlyId, yearlyId].contains(purchase.productID)) {
            int startDate = 0;
            int endDate = 0;
            if(Platform.isAndroid) {
              startDate = int.parse('${purchase.transactionDate}') ?? 0;
              endDate = DateTime.fromMillisecondsSinceEpoch(startDate).add(Duration(days: purchase.productID == monthlyId ? 30 : 365)).millisecondsSinceEpoch;
            }else{
              startDate = (DateTime.tryParse(purchase.transactionDate ?? "") ?? DateTime.now()).millisecondsSinceEpoch;
              endDate = DateTime.fromMillisecondsSinceEpoch(startDate).add(Duration(days: purchase.productID == monthlyId ? 30 : 365)).millisecondsSinceEpoch;

            }
            isSubscribed.value = true;
            // activePlan.value = purchase.productID; // to identify which plan is active
            // LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, true);
            // AuthData().getLoginData();
            Future.delayed(Duration(seconds: 2),(){
              showLoader(true);
              sendPaymentToBackendApi(
                  purchaseStatus: 'purchased',
                  plan_id: purchase.productID,
                  purchaseID: purchase.purchaseID,
                  amount: purchase.productID==monthlyId?buttonMonth:purchase.productID==yearlyId?buttonAnnual:0,
                  customerId: purchase.verificationData.serverVerificationData,
                  startDate: startDate,
                  endDate: endDate).then((value){
                showLoader(false);
                if(value.status==true){
                  LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, true);
                  LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                  AuthData().getLoginData();
                  update();
                }
              });
            });
            apolloPrint(message: 'Subscription purchased or restored:::-> '
                '${purchase.status},${purchase.transactionDate},'
                ' ${purchase.verificationData.serverVerificationData},'
                ' ${purchase.purchaseID} ${purchase.productID}');
            update();

          }
          _setLoadingFalse();
        }
        // else if(purchase.status == PurchaseStatus.restored){
        //   isSubscribed.value = true;
        //   //activePlan.value = purchase.productID; // to identify which plan is active
        //   //LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, true);
        //   // AuthData().getLoginData();
        //   // apolloPrint(message: "\nInside PurchaseStatus.restored :: productID:${purchase.productID}, purchaseID: ${purchase.purchaseID}, status: ${purchase.status}, transactionDate: ${purchase.transactionDate}, purchase.verificationData-1: ${purchase.verificationData.serverVerificationData}, purchase.verificationData-2: ${purchase.verificationData.localVerificationData}, purchase.verificationData-3: ${purchase.verificationData.source}\n Inside PurchaseStatus.restored end");
        //   // print("\nInside PurchaseStatus.restored :: productID:${purchase.productID}, purchaseID: ${purchase.purchaseID}, status: ${purchase.status}, transactionDate: ${purchase.transactionDate}, purchase.verificationData-1: ${purchase.verificationData.serverVerificationData}, purchase.verificationData-2: ${purchase.verificationData.localVerificationData}, purchase.verificationData-3: ${purchase.verificationData.source}\n Inside PurchaseStatus.restored end");
        // }
        else if(purchase.status == PurchaseStatus.canceled){
          // isSubscribed.value = false;
          // activePlan.value = 'Starter Plan'; // to identify which plan is active
          // LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, false);
          // AuthData().getLoginData();

          apolloPrint(message: 'Subscription purchased or restored:::-> '
              '${purchase.status},${purchase.transactionDate},'
              ' ${purchase.verificationData.serverVerificationData},'
              ' ${purchase.purchaseID}');
          print('Subscription purchased or restored:::-> '
              '${purchase.status},${purchase.transactionDate},'
              ' ${purchase.verificationData.serverVerificationData},'
              ' ${purchase.purchaseID}');
          update();
          _setLoadingFalse();
        }
        else if (purchase.status == PurchaseStatus.error) {
          apolloPrint(message: 'Purchase error: ${purchase.error}');
          CustomSnackBar().showSnack(
            Get.context!,
            message: 'Purchase failed: ${purchase.error?.message}',
            isSuccess: false,
          );
          _setLoadingFalse();
        }

        if (purchase.pendingCompletePurchase) {
          iap.completePurchase(purchase);
        }
      }
    }

  }*/

  /// Buy Subscription
  bool loadingMplan = false;
  bool loadingYplan = false;
  void _setLoadingFalse() {
    loadingMplan = false;
    loadingYplan = false;
    update();
  }
  void buySubscription({required String planId}) async{
    // checkSubscription();
    if (products.isEmpty) {
      CustomSnackBar().showSnack(
        Get.context!,
        message: 'Products not loaded',
        isSuccess: false,
      ); return;
    }

    try {
      if(planId==monthlyId){
        loadingMplan=true;
      }else{
        loadingYplan=true;
      }
      update();
      final product = products.firstWhere((prod) => prod.id == planId, orElse: () {
        throw Exception("Product plan not found");
      });

      final purchaseParam = PurchaseParam(productDetails: product);
      await iap.buyNonConsumable(purchaseParam: purchaseParam);

      apolloPrint(message: "Initiating purchase for ${product.id}");
    } catch (e) {
      apolloPrint(message: 'Error initiating purchase: $e');
      CustomSnackBar().showSnack(
        Get.context!,
        message: 'Failed to initiate purchase',
        isSuccess: false,
      );
    }
    finally {
      if(planId==monthlyId){
        loadingMplan=false;
      }else{
        loadingYplan=false;
      }
      update();
    }

  }

  /// Restore Subscription manually
  Future<void> restoreSubscription() async {
    try {
      await iap.restorePurchases();
      CustomSnackBar().showSnack(
        Get.context!,
        message: 'Restoring purchases...',
        isSuccess: true,
      );
    } catch (e) {
      apolloPrint(message: 'Error restoring purchases: $e');
      CustomSnackBar().showSnack(
        Get.context!,
        message: 'Failed to restore purchases',
        isSuccess: false,
      );
    }
  }

  /// Cancel subscription (redirect to store)
  Future<void> cancelSubscription() async {

    print('object:::::cancelSubscription hitting');
    const androidUrl = "https://play.google.com/store/account/subscriptions"; // Play Store
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

  Future<void> sendPurchaseToBackend(PurchaseDetails purchase,base64) async {
    final String token = purchase.verificationData.serverVerificationData;

    final response = await http.post(
      Uri.parse("https://sandbox.itunes.apple.com/verifyReceipt"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "platform": Platform.isIOS ? "ios" : "android",
        "productId": purchase.productID,
        "purchaseId": purchase.purchaseID,
        "token": token,
      }),
    );

    if (response.statusCode == 200) {
      print("Purchase verified successfully!");
      // JSON decode for further processing if needed
      final decoded = jsonDecode(response.body);
      print("Decoded response: $decoded");
      print("Purchase verified successfully! ${decoded}");
    } else {
      print("Purchase verification failed!");
    }
  }

}

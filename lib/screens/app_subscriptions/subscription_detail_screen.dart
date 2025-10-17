// import 'package:apollo/screens/app_subscriptions/subscription_ctrl.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// class PurchaseHistoryScreen extends StatelessWidget {
//   final SubscriptionCtrl ctrl = Get.find<SubscriptionCtrl>();
//
//   /// Safe date formatter
//   String formatDate(String? ms) {
//     if (ms == null || ms.isEmpty) return "-";
//     try {
//       final dt = DateTime.fromMillisecondsSinceEpoch(int.parse(ms));
//       return DateFormat("dd MMM yyyy, hh:mm a").format(dt);
//     } catch (e) {
//       debugPrint("❌ Date parse error: $e , input: $ms");
//       return "-";
//     }
//   }
//
//   /// Convert enum to readable string
//   String formatStatus(dynamic status) {
//     if (status == null) return "Unknown";
//     return status.toString().replaceAll("PurchaseStatus.", "");
//   }
//   /// Print full verification data (Apple receipt / Google token)
//   String formatVerification(String? data) {
//     if (data == null || data.isEmpty) return "-";
//     return data;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Purchase History")),
//       body: Obx(() {
//         if (ctrl.purchaseHistory.isEmpty) {
//           return const Center(child: Text("No purchases yet"));
//         }
//         return ListView.builder(
//           itemCount: ctrl.purchaseHistory.length,
//           itemBuilder: (context, index) {
//             final purchase = ctrl.purchaseHistory[index];
//             return Card(
//               margin: const EdgeInsets.all(8),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Plan: ${purchase.productID}",
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16)),
//                     const SizedBox(height: 4),
//                     Text("Purchase ID: ${purchase.purchaseID ?? '-'}"),
//                     Text("Status: ${formatStatus(purchase.status)}"),
//                     Text("Date: ${formatDate(purchase.transactionDate)}"),
//                     Text("Source: ${purchase.verificationData.source}"),
//                     Text("Verification: ${formatVerification(purchase.verificationData.serverVerificationData)}"),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }

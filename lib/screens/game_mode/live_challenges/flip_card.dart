// import 'package:flutter/material.dart';
// import 'package:flip_card_swiper/flip_card_swiper.dart';
//
// class Question {
//   final String question;
//   final List<String> options;
//   final int correctIndex;
//   final String description;
//   bool isAnswered = false;
//   int? selectedIndex;
//
//   Question({
//     required this.question,
//     required this.options,
//     required this.correctIndex,
//     required this.description,
//   });
// }
//
// class QuizScreen extends StatefulWidget {
//   const QuizScreen({Key? key}) : super(key: key);
//
//   @override
//   State<QuizScreen> createState() => _QuizScreenState();
// }
//
// class _QuizScreenState extends State<QuizScreen> {
//   final List<Question> questions = [
//     Question(
//       question: "What is Flutter?",
//       options: ["Framework", "Language", "IDE", "OS"],
//       correctIndex: 0,
//       description: "Flutter is an open-source UI software development framework.",
//     ),
//     Question(
//       question: "Which language does Flutter use?",
//       options: ["Java", "Dart", "C#", "Kotlin"],
//       correctIndex: 1,
//       description: "Flutter uses Dart as its primary programming language.",
//     ),
//   ];
//
//   int currentIndex = 0;
//   // late FlipCardSwiperController _swiperController;
//
//   @override
//   void initState() {
//     super.initState();
//     // _swiperController = FlipCardSwiperController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Flip Card Quiz")),
//       body: Center(
//         child: SizedBox(
//           width: 350,
//           height: 300,
//           child: FlipCardSwiper(
//             onCardChange: (index) {
//               setState(() => currentIndex = index);
//             },
//             cardBuilder: (context, index, visibleIndex) {
//               final q = questions[index];
//               return FlipCardWidget(
//                 question: q,
//                 onOptionSelected: (optIndex) {
//                   if (!q.isAnswered) {
//                     setState(() {
//                       q.isAnswered = true;
//                       q.selectedIndex = optIndex;
//                     });
//                   }
//                 },
//                 onNext: () {
//                   if (currentIndex < questions.length - 1) {
//                     // _swiperController.swipeToNextCard();
//                   }
//                 });
//             },
//             cardData: questions,
//             onCardCollectionAnimationComplete: (bool value) {  },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FlipCardWidget extends StatefulWidget {
//   final Question question;
//   final void Function(int) onOptionSelected;
//   final VoidCallback onNext;
//
//   const FlipCardWidget({
//     required this.question,
//     required this.onOptionSelected,
//     required this.onNext,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<FlipCardWidget> createState() => _FlipCardWidgetState();
// }
//
// class _FlipCardWidgetState extends State<FlipCardWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   bool isFront = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
//   }
//
//   @override
//   void didUpdateWidget(covariant FlipCardWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.question.isAnswered &&
//         widget.question.selectedIndex == widget.question.correctIndex &&
//         isFront) {
//       _flipCard();
//     }
//   }
//
//   void _flipCard() {
//     _controller.forward();
//     setState(() => isFront = false);
//   }
//
//   void _flipBack() {
//     _controller.reverse();
//     setState(() => isFront = true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (_, __) {
//         final angle = _animation.value * 3.1416;
//         final isBack = angle > 3.1416 / 2;
//         return Transform(
//           alignment: Alignment.center,
//           transform: Matrix4.identity()
//             ..setEntry(3, 2, 0.001)
//             ..rotateY(angle),
//           child: isBack
//               ? _buildBack()
//               : _buildFront(),
//         );
//       },
//     );
//   }
//
//   Widget _buildFront() {
//     final q = widget.question;
//     return Card(
//       elevation: 6,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(q.question, style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 20),
//             ...List.generate(q.options.length, (i) {
//               final isSelected = q.selectedIndex == i;
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4),
//                 child: ElevatedButton(
//                   // style: ElevatedButton.styleFrom(
//                   //   primary: isSelected
//                   //       ? (i == q.correctIndex
//                   //       ? Colors.green
//                   //       : Colors.red)
//                   //       : null,
//                   // ),
//                   onPressed: () {
//                     widget.onOptionSelected(i);
//                   },
//                   child: Text(q.options[i]),
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBack() {
//     final q = widget.question;
//     final isCorrect = q.selectedIndex == q.correctIndex;
//     return Card(
//       elevation: 6,
//       color: isCorrect ? Colors.green[50] : Colors.red[50],
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isCorrect ? Icons.check_circle : Icons.cancel,
//               color: isCorrect ? Colors.green : Colors.red,
//               size: 48,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               isCorrect ? "Correct!" : "Incorrect",
//               style: TextStyle(
//                 fontSize: 20,
//                 color: isCorrect ? Colors.green : Colors.red,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(q.description, textAlign: TextAlign.center),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 _flipBack();
//                 widget.onNext();
//               },
//               child: const Text("Next"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

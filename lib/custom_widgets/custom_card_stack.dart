/*
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';


class StackedDraggableSwiper extends StatefulWidget {
  final List<Widget> cards;
  final int stackCount;
  final double maxAngle;
  final double backCardOffset;
  final double backCardScale;
  final Duration duration;
  final bool swipeEnabled;

  final Set<SwipeDirection> allowedDirections;
  final void Function(double dragDx, double dragAngle)? onDrag;

  final void Function(int swipedCardIndex, SwipeDirection direction)? onSwipe;

  const StackedDraggableSwiper({
    super.key,
    required this.cards,
    this.stackCount = 3,
    this.maxAngle = 20,
    this.backCardOffset = 24,
    this.backCardScale = 0.04,
    this.duration = const Duration(milliseconds: 400),
    this.onDrag,
    this.onSwipe,
    this.swipeEnabled = true,
    this.allowedDirections = const {SwipeDirection.left, SwipeDirection.right},
  });

  @override
  State<StackedDraggableSwiper> createState() => StackedDraggableSwiperState();
}

enum SwipeDirection { left, right, none }

class StackedDraggableSwiperState extends State<StackedDraggableSwiper> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  double _dragDx = 0.0;
  double _dragAngle = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false;
  double _swipeEndDx = 0.0;
  double _swipeEndAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.addListener(() {
      setState(() {
        _dragDx = lerpDouble(_dragDx, _swipeEndDx, _animation.value)!;
        _dragAngle = lerpDouble(_dragAngle, _swipeEndAngle, _animation.value)!;
      });
      // Optionally call onDrag during animation
      widget.onDrag?.call(_dragDx, _dragAngle);
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _resetSwipe();
      }
    });
  }

  void _resetSwipe() {
    // Determine swipe direction for callback
    SwipeDirection direction = SwipeDirection.none;
    if (_swipeEndDx < 0) direction = SwipeDirection.left;
    if (_swipeEndDx > 0) direction = SwipeDirection.right;
    if (direction != SwipeDirection.none && widget.onSwipe != null) {
      widget.onSwipe!(_currentIndex, direction);
    }
    setState(() {
      _isAnimating = false;
      _dragDx = 0.0;
      _dragAngle = 0.0;
      _swipeEndDx = 0.0;
      _swipeEndAngle = 0.0;
      if (_currentIndex < widget.cards.length - 1 && direction != SwipeDirection.none) {
        _currentIndex++;
      }
      _controller.reset();
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isAnimating || !widget.swipeEnabled) return;
    setState(() {
      _dragDx += details.delta.dx;
      if (!widget.allowedDirections.contains(SwipeDirection.right) && _dragDx > 0) _dragDx = 0;
      if (!widget.allowedDirections.contains(SwipeDirection.left) && _dragDx < 0) _dragDx = 0;
      double leftLimit = widget.allowedDirections.contains(SwipeDirection.left) ? -1.0 : 0.0;
      double rightLimit = widget.allowedDirections.contains(SwipeDirection.right) ? 1.0 : 0.0;
      _dragAngle = (widget.maxAngle * pi / 180) * (_dragDx / 300).clamp(leftLimit, rightLimit);
    });
    widget.onDrag?.call(_dragDx, _dragAngle);
  }


  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isAnimating || !widget.swipeEnabled) return;
    final velocity = details.primaryVelocity ?? 0.0;
    if (widget.allowedDirections.contains(SwipeDirection.left) &&
        (_dragDx < -120 || velocity < -700)) {
      // Swipe left allowed
      _animateSwipe(-2 * MediaQuery.of(context).size.width, -widget.maxAngle * pi / 180);
    } else if (widget.allowedDirections.contains(SwipeDirection.right) &&
        (_dragDx > 120 || velocity > 700)) {
      // Swipe right allowed
      _animateSwipe(2 * MediaQuery.of(context).size.width, widget.maxAngle * pi / 180);
    } else {
      // Return to center for any other direction or if not allowed
      _animateSwipe(0.0, 0.0);
    }
  }


  void _animateSwipe(double endDx, double endAngle) {
    setState(() {
      _isAnimating = true;
      _swipeEndDx = endDx;
      _swipeEndAngle = endAngle;
    });
    _controller.forward(from: 0.0);
  }

  // Programmatic swipe left
  void swipeLeft() {
    if (!widget.allowedDirections.contains(SwipeDirection.left)) return;
    if (_isAnimating || _currentIndex >= widget.cards.length - 1 || !widget.swipeEnabled) return;
    // Use a longer duration for programmatic swipe
    _controller.duration = const Duration(milliseconds: 1500);
    _animateSwipe(-2 * MediaQuery.of(context).size.width, -widget.maxAngle * pi / 180);
    _controller.duration = widget.duration; // Reset to default for next time
  }

  void swipeRight() {
    if (!widget.allowedDirections.contains(SwipeDirection.right)) return;
    if (_isAnimating || _currentIndex >= widget.cards.length - 1 || !widget.swipeEnabled) return;
    _animateSwipe(2 * MediaQuery.of(context).size.width, widget.maxAngle * pi / 180);
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _buildStackedCards(BuildContext context) {
    final cards = <Widget>[];
    final total = widget.cards.length;
    final maxStack = widget.stackCount;

    // Custom offset calculation for tighter stacking
    double getCardOffset(int i) {
      if (i == 0) return 0.0;                                    // 1st card: 0
      if (i == 1) return widget.backCardOffset;                  // 2nd card: full offset
      if (i == 2) return widget.backCardOffset + (widget.backCardOffset * 1); // 3rd card: less increment
      // For 4th+ cards, even smaller increments
      return widget.backCardOffset + (widget.backCardOffset * 0.4) + (widget.backCardOffset * 0.2 * (i - 2));
    }

    for (int i = 0; i < maxStack; i++) {
      int cardIndex = _currentIndex + i;
      if (cardIndex >= total) break;

      double offsetY = getCardOffset(i);

      if (i == 0) {
        // Top card: draggable and animated
        cards.add(
          GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: Transform.translate(
              offset: Offset(_dragDx, offsetY),
              child: Transform.rotate(
                angle: _dragAngle,
                child: Transform.scale(
                  scale: 1.0 - widget.backCardScale * i,
                  child: widget.cards[cardIndex],
                ),
              ),
            ),
          ),
        );
      } else {
        // Back cards: static, stacked
        cards.add(
          Transform.translate(
            offset: Offset(0, offsetY),
            child: Transform.scale(
              scale: 1.0 - widget.backCardScale * i,
              child: widget.cards[cardIndex],
            ),
          ),
        );
      }
    }
    return cards.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.cards.length) {
      return const Center(child: Text("No more cards"));
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        ..._buildStackedCards(context),
        */
/*Positioned(
          bottom: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: swipeLeft,
                child: const Text('Programmatic Swipe Left'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: swipeRight,
                child: const Text('Programmatic Swipe Right'),
              ),
            ],
          ),
        ),*//*

      ],
    );
  }
}
*/



import 'dart:math';
import 'dart:ui';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';

/// Directions the user (or code) can swipe.
enum SwipeDirection { left, right, none }

class StackedDraggableSwiper extends StatefulWidget {
  final List<Widget> cards;
  final int stackCount;
  final double maxAngle;
  final double backCardOffset;
  final double backCardScale;
  final Duration duration;
  final bool swipeEnabled;

  final Set<SwipeDirection> allowedDirections;
  // final void Function(double dragDx, double dragAngle)? onDrag;
  final void Function(int index, double dragDx, double dragAngle)? onDrag;
  final void Function(int swipedCardIndex, SwipeDirection direction)? onSwipe;

  const StackedDraggableSwiper({
    super.key,
    required this.cards,

    /* ✨ tuning knobs */
    this.stackCount      = 3,
    this.maxAngle        = 18,        // deg
    this.backCardOffset  = 24,
    this.backCardScale   = .04,
    this.duration        = const Duration(milliseconds: 400),
    this.swipeEnabled    = true,
    this.allowedDirections = const {SwipeDirection.left, SwipeDirection.right},

    /* callbacks */
    this.onDrag,
    this.onSwipe,
  });

  @override
  State<StackedDraggableSwiper> createState() => StackedDraggableSwiperState();
}


class StackedDraggableSwiperState extends State<StackedDraggableSwiper> with SingleTickerProviderStateMixin {
  /* ────────────────────────────────
   *  state
   * ──────────────────────────────── */
  int    _currentIndex   = 0;
  double _dragDx         = 0;
  double _dragAngle      = 0;
  bool   _isAnimating    = false;

  late AnimationController _controller;
  late Animation<double>   _anim;

  // Where the fling will finish.
  double _endDx    = 0;
  double _endAngle = 0;

  /* ────────────────────────────────
   *  consts
   * ──────────────────────────────── */
  static const double _swipeTriggerDx   = 120;   // px
  static const double _swipeTriggerVel  = 700;   // px/s

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _anim       = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addListener(_tick);
    _controller.addStatusListener(_onStatus);
  }

  void _tick() {
    setState(() {
      _dragDx    = lerpDouble(_dragDx,    _endDx,    _anim.value)!;
      _dragAngle = lerpDouble(_dragAngle, _endAngle, _anim.value)!;
    });
    widget.onDrag?.call(_currentIndex, _dragDx, _dragAngle);
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _finishSwipe();

    apolloPrint(message: 'AnimationStatus.completed::::${status}');
  }

  /* ────────────────────────────────
   *  gesture handlers
   * ──────────────────────────────── */
  void _onDragUpdate(DragUpdateDetails d) {
    if (_isAnimating || !widget.swipeEnabled) return;

    setState(() {
      _dragDx += d.delta.dx;

      /* clamp if direction not allowed */
      if (!widget.allowedDirections.contains(SwipeDirection.right) && _dragDx > 0) _dragDx = 0;
      if (!widget.allowedDirections.contains(SwipeDirection.left)  && _dragDx < 0) _dragDx = 0;

      final left  = widget.allowedDirections.contains(SwipeDirection.left)  ? -1.0 : 0.0;
      final right = widget.allowedDirections.contains(SwipeDirection.right) ?  1.0 : 0.0;

      _dragAngle = (widget.maxAngle * pi / 180) * (_dragDx / 300).clamp(left, right);
    });

    widget.onDrag?.call(_currentIndex, _dragDx, _dragAngle);

  }

  void _onDragEnd(DragEndDetails d) {
    if (_isAnimating || !widget.swipeEnabled) return;

    final v  = d.primaryVelocity ?? 0.0;
    final dx = _dragDx;

    final canLeft  = widget.allowedDirections.contains(SwipeDirection.left);
    final canRight = widget.allowedDirections.contains(SwipeDirection.right);

    if (canLeft  && (dx < -_swipeTriggerDx || v < -_swipeTriggerVel)) {
      _animateSwipe(-2 * MediaQuery.sizeOf(context).width,
          -widget.maxAngle * pi / 180);
    } else if (canRight && (dx >  _swipeTriggerDx || v >  _swipeTriggerVel)) {
      _animateSwipe( 2 * MediaQuery.sizeOf(context).width,
          widget.maxAngle * pi / 180);
    } else {
      _animateSwipe(0, 0);                       // snap back
    }
  }

  /* ────────────────────────────────
   *  programmatic swipe helpers
   * ──────────────────────────────── */
  void swipeLeft()  => _startProgSwipe(SwipeDirection.left);
  void swipeRight() => _startProgSwipe(SwipeDirection.right);

  void _startProgSwipe(SwipeDirection dir) {
    if (!widget.swipeEnabled ||
        _isAnimating ||
        _currentIndex >= widget.cards.length - 1) return;

    if (dir == SwipeDirection.left  && !widget.allowedDirections.contains(dir)) return;
    if (dir == SwipeDirection.right && !widget.allowedDirections.contains(dir)) return;

    _controller.duration = const Duration(milliseconds: 800);
    _animateSwipe(
      dir == SwipeDirection.left
          ? -2 * MediaQuery.sizeOf(context).width
          :  2 * MediaQuery.sizeOf(context).width,
      dir == SwipeDirection.left
          ? -widget.maxAngle * pi / 180
          :  widget.maxAngle * pi / 180,
    );
    _controller.duration = widget.duration; // restore
  }

  /* ────────────────────────────────
   *  animation helpers
   * ──────────────────────────────── */
  void _animateSwipe(double dx, double angle) {
    _isAnimating = true;
    _endDx       = dx;
    _endAngle    = angle;
    _controller.forward(from: 0);
  }

  void _finishSwipe() {
    SwipeDirection dir = SwipeDirection.none;
    if (_endDx < 0) dir = SwipeDirection.left;
    if (_endDx > 0) dir = SwipeDirection.right;

    widget.onSwipe?.call(_currentIndex, dir);

    setState(() {
      if (dir != SwipeDirection.none &&
          _currentIndex < widget.cards.length - 1) {
        _currentIndex++;
      }
      _dragDx       = 0;
      _dragAngle    = 0;
      _endDx        = 0;
      _endAngle     = 0;
      _isAnimating  = false;
      _controller.reset();
    });
  }
  double _easedProgress() {
    return Curves.easeOut.transform(_progress);
  }

  /* ────────────────────────────────
   *  build helpers
   * ──────────────────────────────── */

  /// Card Y offset for the “rest” position.
  double _baseOffset(int i) {
    if (i == 0) return 0;
    if (i == 1) return widget.backCardOffset;
    if (i == 2) return widget.backCardOffset * 2;
    return widget.backCardOffset * (2.4 + .2 * (i - 2));
  }

  /// How far (0-1) through a swipe we are.
  double get _progress {
    final p = _dragDx.abs() / (MediaQuery.sizeOf(context).width * .8);
    return p.clamp(0, 1);
  }

  /// Build the visual stack.  The *top* card is index 0.
  List<Widget> _buildStack(BuildContext ctx) {
    final cards = <Widget>[];

    final total     = widget.cards.length;
    final maxShown  = widget.stackCount;

    for (var stackPos = 0; stackPos < maxShown; ++stackPos) {
      final cardPos = _currentIndex + stackPos;
      if (cardPos >= total) break;

      /* -----------------------------------------
       * compute animated offset / scale for back cards
       * -----------------------------------------
       */
      final baseY  = _baseOffset(stackPos);
      final nextY  = _baseOffset(max(0, stackPos - 1)); // where it will slide to
      final slideY = lerpDouble(baseY, nextY, _easedProgress())!;

      final baseScale = 1 - widget.backCardScale * stackPos;
      final nextScale = 1 - widget.backCardScale * max(0, stackPos - 1);
      final scale = lerpDouble(baseScale, nextScale, _easedProgress())!;

      Widget child = widget.cards[cardPos];

      if (stackPos == 0) {
        // top (draggable) card
        child = GestureDetector(
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd:   _onDragEnd,
          child: Transform.translate(
            offset: Offset(_dragDx, slideY),
            child: Transform.rotate(
              angle: _dragAngle,
              child: Transform.scale(scale: scale, child: child),
            ),
          ),
        );
      } else {
        // back cards
        child = Transform.translate(
          offset: Offset(0, slideY),
          child: Transform.scale(scale: scale, child: child),
        );
      }

      cards.add(child);
    }

    /* paint lowest first */
    return cards.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.cards.length) {
      return const Center(child: Text('No more cards'));
    }

    return Stack(
      alignment: Alignment.center,
      children: _buildStack(context),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
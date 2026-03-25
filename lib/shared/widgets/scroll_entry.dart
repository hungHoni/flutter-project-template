import 'package:flutter/material.dart';

/// Fades in + slides up when first built. Use with staggered [delay]
/// for list items: `ScrollEntryWidget(delay: Duration(milliseconds: 80 * index))`.
class ScrollEntryWidget extends StatefulWidget {
  const ScrollEntryWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.slideOffset = 24.0,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slideOffset;

  @override
  State<ScrollEntryWidget> createState() => _ScrollEntryWidgetState();
}

class _ScrollEntryWidgetState extends State<ScrollEntryWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(curved);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.slideOffset),
      end: Offset.zero,
    ).animate(curved);

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _slide.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

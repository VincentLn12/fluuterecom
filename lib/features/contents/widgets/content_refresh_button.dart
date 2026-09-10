import 'package:flutter/material.dart';

class ContentRefreshButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const ContentRefreshButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  State<ContentRefreshButton> createState() => _ContentRefreshButtonState();
}

class _ContentRefreshButtonState extends State<ContentRefreshButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ContentRefreshButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isLoading && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'ล้างตัวกรอง / รีโหลด',
      icon: RotationTransition(
        turns: _controller,
        child: const Icon(Icons.refresh_rounded, color: Colors.white),
      ),
      onPressed: _handleTap,
    );
  }
}

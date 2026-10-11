import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedGlassTextPreviewCard extends StatefulWidget {
  final String fullText;
  final int previewLength;
  final String title;

  const AnimatedGlassTextPreviewCard({
    super.key,
    required this.fullText,
    this.previewLength = 120,
    this.title = 'Text Preview',
  });

  @override
  State<AnimatedGlassTextPreviewCard> createState() =>
      _AnimatedGlassTextPreviewCardState();
}

class _AnimatedGlassTextPreviewCardState
    extends State<AnimatedGlassTextPreviewCard> {
  bool _isPressed = false;

  String get previewText {
    if (widget.fullText.length <= widget.previewLength) {
      return widget.fullText;
    }
    return '${widget.fullText.substring(0, widget.previewLength)}...';
  }

  void _showFullTextSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return AnimatedGlassBottomSheet(
          title: widget.title,
          fullText: widget.fullText,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _showFullTextSheet(context);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.03),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.14),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.45),
                    blurRadius: 24,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    previewText,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Tap to read more',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fade(duration: 350.ms)
        .slideY(begin: 0.12, end: 0, duration: 350.ms)
        .scale(
          begin: const Offset(0.98, 0.98),
          end: const Offset(1, 1),
          duration: 350.ms,
        );
  }
}

class AnimatedGlassBottomSheet extends StatelessWidget {
  final String title;
  final String fullText;

  const AnimatedGlassBottomSheet({
    super.key,
    required this.title,
    required this.fullText,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.03),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.14),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 24,
                spreadRadius: 1,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  )
                      .animate()
                      .fade(duration: 250.ms)
                      .slideY(begin: -0.4, end: 0, duration: 250.ms),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                      .animate()
                      .fade(delay: 80.ms, duration: 250.ms)
                      .slideX(begin: -0.08, end: 0, duration: 250.ms),
                  const SizedBox(height: 14),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        fullText,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fade(delay: 140.ms, duration: 280.ms)
                      .slideY(begin: 0.06, end: 0, duration: 280.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fade(duration: 250.ms)
        .slideY(begin: 0.12, end: 0, duration: 300.ms);
  }
}

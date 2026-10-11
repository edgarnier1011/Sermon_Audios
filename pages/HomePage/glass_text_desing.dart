import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GlassPostCard extends StatefulWidget {
  final String author;
  final String text;
  final String date;

  const GlassPostCard({
    super.key,
    required this.author,
    required this.text,
    required this.date,
  });

  @override
  State<GlassPostCard> createState() => _GlassPostCardState();
}

class _GlassPostCardState extends State<GlassPostCard> {
  bool isLiked = false;
  bool isPlaying = false;

  void toggleLike() {
    setState(() => isLiked = !isLiked);
  }

  void togglePlay() {
    setState(() => isPlaying = !isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              // 🔥 Glass gradient (dark)
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              // subtle border
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),

              // soft glow
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // TOP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.author,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "•••",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // MIDDLE
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              widget.text,
                              style: const TextStyle(
                                color: Colors.white70,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: togglePlay,
                          iconSize: 42,
                          icon: Icon(
                            isPlaying ? Icons.pause_circle : Icons.play_circle,
                            color: Colors.white,
                          ),
                        ).animate(target: isPlaying ? 1 : 0).scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.2, 1.2),
                              duration: 300.ms,
                            ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // BOTTOM
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.date,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isLiked ? Colors.redAccent : Colors.white54,
                          )
                              .animate(target: isLiked ? 1 : 0)
                              .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.4, 1.4),
                                duration: 200.ms,
                              )
                              .then()
                              .scale(
                                begin: const Offset(1.4, 1.4),
                                end: const Offset(1, 1),
                              ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: toggleLike,
                            child: Text(
                              isLiked ? "Liked" : "Like",
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        // ENTRY ANIMATION
        .animate()
        .fade(duration: 400.ms)
        .slideY(begin: 0.2, end: 0)
        .scale(begin: const Offset(0.95, 0.95));
  }
}

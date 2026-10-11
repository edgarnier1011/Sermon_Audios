import 'dart:ui';
import 'package:flutter/material.dart';

class LightGlassPostCard extends StatefulWidget {
  final String author;
  final String text;
  final String date;

  const LightGlassPostCard({
    super.key,
    required this.author,
    required this.text,
    required this.date,
  });

  @override
  State<LightGlassPostCard> createState() => _LightGlassPostCardState();
}

class _LightGlassPostCardState extends State<LightGlassPostCard> {
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
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              // 🤍 Light glass gradient
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.7),
                  Colors.white.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              // soft border
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 1,
              ),

              // soft shadow (light theme)
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
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
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "•••",
                          style: TextStyle(color: Colors.black54),
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
                                color: Colors.black87,
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
                            color: Colors.black87,
                          ),
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
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isLiked ? Colors.redAccent : Colors.black45,
                          ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: toggleLike,
                            child: Text(
                              isLiked ? "Liked" : "Like",
                              style: const TextStyle(
                                color: Colors.black87,
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
    );
  }
}

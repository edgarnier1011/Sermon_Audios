import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedPostCard extends StatefulWidget {
  final String author;
  final String text;
  final String date;

  const AnimatedPostCard({
    super.key,
    required this.author,
    required this.text,
    required this.date,
  });

  @override
  State<AnimatedPostCard> createState() => _AnimatedPostCardState();
}

class _AnimatedPostCardState extends State<AnimatedPostCard> {
  bool isLiked = false;
  bool isPlaying = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 220,
          child: Column(
            children: [
              // TOP
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.author,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Option"),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // MIDDLE
              Expanded(
                child: Row(
                  children: [
                    // Scrollable text
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(widget.text),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Play button with animation
                    IconButton(
                      onPressed: togglePlay,
                      iconSize: 40,
                      icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle,
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
                  Text(widget.date),
                  Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isLiked ? Colors.red : Colors.grey,
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
                        child: Text(isLiked ? "Liked" : "Like"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        // ENTRY ANIMATION (when card appears)
        .animate()
        .fade(duration: 400.ms);
    // .slideY(begin: 0.2, end: 0, duration: 400.ms);
    // .scale(begin: const Offset(0.95, 0.95));
  }
}

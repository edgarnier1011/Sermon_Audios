import 'dart:ui';
import 'package:flutter/material.dart';

class AudioPlayerPlaceholder extends StatelessWidget {
  final String title;

  const AudioPlayerPlaceholder({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),

            // subtle dark glass look
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.06),
                Colors.white.withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Controls (disabled look)
              Row(
                children: [
                  // Disabled play button
                  Icon(
                    Icons.play_circle_outline,
                    size: 36,
                    color: Colors.white24,
                  ),

                  const SizedBox(width: 8),

                  // Disabled slider
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 0,
                        ),
                      ),
                      child: Slider(
                        value: 0,
                        min: 0,
                        max: 1,
                        onChanged: null, // disabled
                        activeColor: Colors.white24,
                        inactiveColor: Colors.white10,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Time + label
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "00:00",
                    style: TextStyle(color: Colors.white30),
                  ),
                  Text(
                    "No audio selected",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

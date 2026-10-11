import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GlassPostSkeleton extends StatelessWidget {
  const GlassPostSkeleton({super.key});

  Widget _box({double height = 12, double width = double.infinity}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.06),
                  Colors.white.withOpacity(0.03),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.05),
              highlightColor: Colors.white.withOpacity(0.15),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _box(width: 100, height: 14),
                        _box(width: 30, height: 14),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // TEXT LINES
                    _box(),
                    const SizedBox(height: 8),
                    _box(width: double.infinity),
                    const SizedBox(height: 8),
                    _box(width: 200),

                    const Spacer(),

                    // BOTTOM
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _box(width: 80),
                        Row(
                          children: [
                            _box(width: 20),
                            const SizedBox(width: 6),
                            _box(width: 40),
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
      ),
    );
  }
}

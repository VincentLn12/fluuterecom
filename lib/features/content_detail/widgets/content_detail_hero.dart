import 'package:flutter/material.dart';
import '../models/content_detail_model.dart';
import '../../contents/widgets/content_video_player.dart';

class ContentDetailHero extends StatefulWidget {
  final ContentDetailModel item;

  const ContentDetailHero({super.key, required this.item});

  @override
  State<ContentDetailHero> createState() => _ContentDetailHeroState();
}

class _ContentDetailHeroState extends State<ContentDetailHero> {
  bool _isPlayingVideo = true;

  @override
  Widget build(BuildContext context) {
    final hasVideo =
        widget.item.youtubeUrl != null && widget.item.youtubeUrl!.isNotEmpty;
    final coverUrl =
        widget.item.coverImageUrl ??
        (hasVideo ? widget.item.youtubeThumbnail : null);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F1713),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: _isPlayingVideo && hasVideo
              ? ContentVideoPlayer(videoUrl: widget.item.youtubeUrl!)
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    if (coverUrl != null && coverUrl.isNotEmpty)
                      Image.network(
                        coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      )
                    else
                      _buildPlaceholder(),

                    // Subtle gradient overlay for contrast
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.65),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Play Button overlay if YouTube video exists
                    if (hasVideo && !_isPlayingVideo)
                      Center(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isPlayingVideo = true;
                              });
                            },
                            customBorder: const CircleBorder(),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFD96C2C), Color(0xFFED8936)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD96C2C)
                                        .withValues(alpha: 0.5),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Video Pill Badge (Bottom Left)
                    if (hasVideo && !_isPlayingVideo)
                      Positioned(
                        bottom: 12,
                        left: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[700]!.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_circle_fill_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'วิดีโอพาเที่ยว',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD96C2C), Color(0xFF2B1F17)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.landscape_rounded, size: 48, color: Colors.white70),
            SizedBox(height: 8),
            Text(
              'มหัศจรรย์เมืองกาญจนบุรี',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



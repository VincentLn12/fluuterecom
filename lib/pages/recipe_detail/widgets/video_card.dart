import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({
    super.key,
    required this.videoUrl,
    required this.onOpen,
    required this.onCopy,
  });

  final String videoUrl;
  final VoidCallback onOpen;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = VideoUrlParser.thumbnailUrl(videoUrl);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3EA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFD8BF)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 8, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.play_circle_fill_rounded,
                  color: Color(0xFFE85D24),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'วิดีโอสอนทำ',
                    style: TextStyle(
                      color: Color(0xFF8A3A18),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'เปิดวิดีโอ',
                  onPressed: onOpen,
                  icon: const Icon(Icons.play_arrow_rounded),
                ),
                IconButton(
                  tooltip: 'คัดลอกลิงก์',
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_rounded),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onOpen,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (thumbnailUrl == null)
                    const ColoredBox(color: Color(0xFF8A3A18))
                  else
                    Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const ColoredBox(color: Color(0xFF8A3A18)),
                    ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Color(0xFFE85D24),
                        size: 48,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: Text(
                      'แตะเพื่อดูวิดีโอ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              videoUrl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF8A3A18),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoUrlParser {
  const VideoUrlParser._();

  static String? thumbnailUrl(String rawUrl) {
    final uri = Uri.tryParse(rawUrl.trim());
    if (uri == null) {
      return null;
    }

    final host = uri.host.toLowerCase().replaceFirst('www.', '');
    final videoId = _youtubeVideoId(uri, host);
    if (videoId == null || videoId.isEmpty) {
      return null;
    }

    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  static String? _youtubeVideoId(Uri uri, String host) {
    if (host == 'youtu.be') {
      return uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
    }

    if (!host.endsWith('youtube.com')) {
      return null;
    }

    if (uri.pathSegments.isEmpty) {
      return uri.queryParameters['v'];
    }

    final firstSegment = uri.pathSegments.first;
    if (firstSegment == 'watch') {
      return uri.queryParameters['v'];
    }
    if (firstSegment == 'embed' || firstSegment == 'shorts') {
      return uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
    }

    return uri.queryParameters['v'];
  }
}

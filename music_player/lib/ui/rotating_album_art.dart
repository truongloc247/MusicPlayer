import 'package:flutter/material.dart';
import 'dart:math';

class RotatingAlbumArt extends StatefulWidget {
  final String imageUrl;
  final bool isPlaying;

  const RotatingAlbumArt({
    super.key,
    required this.imageUrl,
    required this.isPlaying,
  });

  @override
  State<RotatingAlbumArt> createState() => _RotatingAlbumArtState();
}

class _RotatingAlbumArtState extends State<RotatingAlbumArt>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Tạo controller quay 1 vòng hết 10 giây (tuỳ chỉnh tốc độ ở đây)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    // Logic: Quay vô tận (Loop)
    // Khi chạy hết 1 vòng (completed), nó tự reset về 0 và chạy tiếp
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });
  }

  @override
  void didUpdateWidget(covariant RotatingAlbumArt oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Lắng nghe sự thay đổi của biến isPlaying từ Widget cha
    if (widget.isPlaying && !_controller.isAnimating) {
      // Nếu đang Play -> Quay tiếp từ vị trí hiện tại
      _controller.forward(from: _controller.value);
    } else if (!widget.isPlaying && _controller.isAnimating) {
      // Nếu Pause -> Dừng lại (giữ nguyên vị trí)
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: 191,
        height: 191,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Ảnh bìa bài hát (Cắt tròn)
            ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: Image.network(
                widget.imageUrl,
                width: 190,
                height: 190,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.music_note,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            // 2. (Tuỳ chọn) Lỗ tròn ở giữa để nhìn giống đĩa than
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.white, // Hoặc màu nền của App
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:programa/Styles/app_colors.dart';

class VideoBackground extends StatefulWidget {
  const VideoBackground({super.key});

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late VideoPlayerController _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/fondo_udec.mp4")
      ..initialize().then((_) {
        _controller.setVolume(0.0); 
        _controller.setLooping(true);
        _controller.play();
        
        setState(() {
          _visible = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // CAPA 1: Imagen de respaldo (mientras el video carga)
          Container(
            color: AppColors.primay,
            child: Image.asset(
              "assets/images/fondo_de_carga.png",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
              errorBuilder: (c, e, s) => Container(color: AppColors.primay),
            ),
          ),

          AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.isInitialized
                    ? _controller.value.size.width
                    : 0,
                height: _controller.value.isInitialized
                    ? _controller.value.size.height
                    : 0,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
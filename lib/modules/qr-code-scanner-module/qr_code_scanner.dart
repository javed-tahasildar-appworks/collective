import 'package:collectiv/di_container.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class QRCodeScannerScreen extends StatefulWidget {
  static String routeName =
      "/modules/qr-code-scanner-module/qr_code_scanner_screen";

  const QRCodeScannerScreen({
    super.key,
  });

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen>
    with SingleTickerProviderStateMixin {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isFlashlightOn = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Set system UI to be fullscreen and transparent
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    // Initialize camera controller
    _controller = CameraController(
      locator<CameraDescription>(),
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();

    // Setup scanning animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Toggle flashlight
  void _toggleFlashlight() async {
    if (_controller.value.isInitialized) {
      if (_isFlashlightOn) {
        await _controller.setFlashMode(FlashMode.off);
      } else {
        await _controller.setFlashMode(FlashMode.torch);
      }

      setState(() {
        _isFlashlightOn = !_isFlashlightOn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double scanWindowSize = screenSize.width * 0.7;

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Camera Preview
                CameraPreview(_controller),

                // Dark overlay with transparent QR window
                ScanOverlayWidget(
                  scanWindowSize: scanWindowSize,
                  animation: _animation,
                ),

                // Top title bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildTopBar(),
                ),

                // Bottom action bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomBar(),
                ),
              ],
            );
          } else {
            return Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6C3CD1),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button with animation
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
            ),
          ),

          // Scan title
          const Text(
            'Scan QR Code',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),

          // Placeholder to balance layout
          const SizedBox(width: 40.0),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 20.0,
        top: 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Instructions
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Text(
              'Align the QR code within the square',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),

          const SizedBox(height: 20.0),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Flashlight toggle button
              _buildActionButton(
                icon: _isFlashlightOn
                    ? Icons.flashlight_off
                    : Icons.flashlight_on,
                label: _isFlashlightOn ? 'Turn off' : 'Flashlight',
                onTap: _toggleFlashlight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom overlay widget with scan animation
class ScanOverlayWidget extends StatelessWidget {
  final double scanWindowSize;
  final Animation<double> animation;

  const ScanOverlayWidget({
    super.key,
    required this.scanWindowSize,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScanWindow(scanWindowSize),
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              left: (MediaQuery.of(context).size.width - scanWindowSize) / 2,
              top: (MediaQuery.of(context).size.height - scanWindowSize) / 2 +
                  animation.value * (scanWindowSize - 4),
              child: Container(
                height: 2.0,
                width: scanWindowSize - 8.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6C3CD1),
                      Color(0xFF2C8CF4),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C3CD1).withOpacity(0.6),
                      blurRadius: 12.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ScanWindow extends StatelessWidget {
  final double scanWindowSize;

  const ScanWindow(this.scanWindowSize, {super.key});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.6),
        BlendMode.srcOut,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Center(
              child: Container(
                height: scanWindowSize,
                width: scanWindowSize,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: scanWindowSize,
              width: scanWindowSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Top-left corner
                  _buildCorner(Alignment.topLeft),
                  // Top-right corner
                  _buildCorner(Alignment.topRight),
                  // Bottom-left corner
                  _buildCorner(Alignment.bottomLeft),
                  // Bottom-right corner
                  _buildCorner(Alignment.bottomRight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    const double cornerSize = 20.0;
    final double dx = alignment.x < 0 ? -1 : 1;
    final double dy = alignment.y < 0 ? -1 : 1;

    return Align(
      alignment: alignment,
      child: Container(
        width: cornerSize,
        height: cornerSize,
        decoration: BoxDecoration(
          // Corner gradient based on corner position
          gradient: LinearGradient(
            begin: Alignment(dx, dy),
            end: Alignment.center,
            colors: const [
              Color(0xFF6C3CD1), // PhonePe purple
              Color(0xFF2C8CF4), // PhonePe blue
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C3CD1).withOpacity(0.6),
              blurRadius: 8.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: CustomPaint(
          painter: CornerPainter(
            alignment: alignment,
            cornerWidth: 3.0,
            cornerColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Custom painter for drawing L-shaped corners
class CornerPainter extends CustomPainter {
  final Alignment alignment;
  final double cornerWidth;
  final Color cornerColor;

  CornerPainter({
    required this.alignment,
    required this.cornerWidth,
    required this.cornerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cornerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Draw L-shaped corner based on alignment
    if (alignment == Alignment.topLeft) {
      // Top-left corner
      path.moveTo(0, size.height / 2);
      path.lineTo(0, 0);
      path.lineTo(size.width / 2, 0);
    } else if (alignment == Alignment.topRight) {
      // Top-right corner
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height / 2);
    } else if (alignment == Alignment.bottomLeft) {
      // Bottom-left corner
      path.moveTo(0, size.height / 2);
      path.lineTo(0, size.height);
      path.lineTo(size.width / 2, size.height);
    } else if (alignment == Alignment.bottomRight) {
      // Bottom-right corner
      path.moveTo(size.width / 2, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, size.height / 2);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CornerPainter oldDelegate) => false;
}

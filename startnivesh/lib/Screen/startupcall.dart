import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VideoCallScreen extends StatefulWidget {
  final String callId;
  final String peerName;
  final String userId;
  final String serverUrl;

  const VideoCallScreen({
    Key? key,
    required this.callId,
    required this.peerName,
    required this.userId,
    required this.serverUrl,
  }) : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> with SingleTickerProviderStateMixin {
  bool _isCameraInitialized = false;
  bool _isMicMuted = false;
  bool _isCameraOff = false;
  bool _isSpeakerOn = true;
  CameraController? _cameraController;
  bool _isFrontCamera = true;
  IO.Socket? _socket;
  bool _isConnected = false;
  String _callStatus = 'Connecting...';
  late AnimationController _connectingAnimationController;
  late Animation<double> _connectingAnimation;

  // Call quality indicators
  int _signalStrength = 3; // 0-4 scale
  String _connectionQuality = 'Good';

  // Call duration tracker
  Duration _callDuration = Duration.zero;
  DateTime? _callStartTime;

  // Panel visibility
  bool _controlsVisible = true;

  Widget _remoteVideo = Container(
    color: const Color(0xFF1A1A2E),
    child: const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
            strokeWidth: 2,
          ),
          SizedBox(height: 20),
          Text(
            'Waiting for peer to join...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initCamera();
    _initSocketConnection();

    // Initialize animation controller for connecting animation
    _connectingAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _connectingAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _connectingAnimationController, curve: Curves.easeInOut)
    );

    // Auto-hide controls after inactivity
    _startControlsTimer();
  }

  void _startControlsTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _controlsVisible) {
        setState(() {
          _controlsVisible = false;
        });
      }
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  void _initSocketConnection() {
    try {
      _socket = IO.io(
        widget.serverUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setExtraHeaders({'userId': widget.userId})
            .build(),
      );

      _setupSocketListeners();
      _socket!.connect();
    } catch (e) {
      if (mounted) {
        setState(() {
          _callStatus = 'Connection error: $e';
          _connectionQuality = 'Poor';
          _signalStrength = 0;
        });
      }
    }
  }

  void _setupSocketListeners() {
    _socket!.on('connect', (_) {
      debugPrint('Socket connected');
      if (!mounted) return;

      setState(() {
        _isConnected = true;
        _callStatus = 'Connected';
        _signalStrength = 3;
        _connectionQuality = 'Good';
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        _socket?.emit('join_call', {
          'callId': widget.callId,
          'userId': widget.userId,
          'userName': 'User ${widget.userId}',
        });
      });
    });

    _socket!.on('user_joined', (data) {
      debugPrint('User joined: ${data['userId']}');
      if (!mounted) return;
      setState(() {
        _callStatus = 'In call';
        _callStartTime = DateTime.now();
        // Start call timer
        _startCallDurationTimer();
      });
    });

    _socket!.on('user_left', (data) {
      debugPrint('User left: ${data['userId']}');
      if (!mounted) return;
      setState(() {
        _callStatus = '${data['userName']} left the call';
      });
    });

    _socket!.on('call_ended', (data) {
      debugPrint('Call ended by: ${data['userId']}');
      _showCallEndedDialog(data['reason'] ?? 'Call ended by peer');
    });

    _socket!.on('disconnect', (_) {
      debugPrint('Socket disconnected');
      if (!mounted) return;
      setState(() {
        _isConnected = false;
        _callStatus = 'Disconnected';
        _signalStrength = 0;
        _connectionQuality = 'Poor';
      });
    });

    _socket!.on('error', (error) {
      debugPrint('Socket error: $error');
      if (!mounted) return;
      setState(() {
        _callStatus = 'Connection error';
        _signalStrength = 1;
        _connectionQuality = 'Poor';
      });
    });

    // Add connection quality listener
    _socket!.on('connection_quality', (data) {
      if (!mounted) return;
      setState(() {
        _signalStrength = data['signalStrength'] ?? 3;
        _connectionQuality = data['quality'] ?? 'Good';
      });
    });
  }

  void _startCallDurationTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _callStartTime != null) {
        setState(() {
          _callDuration = DateTime.now().difference(_callStartTime!);
        });
        _startCallDurationTimer(); // Loop for every second
      }
    });
  }

  void _showCallEndedDialog(String reason) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF2D2D42),
        title: const Text('Call Ended', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.call_end, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(reason, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
              'Call duration: ${_formatDuration(_callDuration)}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop(); // Close dialog
              }
              await Future.delayed(const Duration(milliseconds: 100));
              if (mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop(); // Exit screen
              }
            },
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _toggleMicrophone() {
    if (!mounted) return;
    setState(() {
      _isMicMuted = !_isMicMuted;
    });

    if (_isConnected) {
      _socket!.emit('toggle_audio', {
        'callId': widget.callId,
        'userId': widget.userId,
        'isMuted': _isMicMuted,
      });
    }
  }

  void _toggleCamera() {
    if (!mounted) return;
    setState(() {
      _isCameraOff = !_isCameraOff;
    });

    if (_isConnected) {
      _socket!.emit('toggle_video', {
        'callId': widget.callId,
        'userId': widget.userId,
        'isDisabled': _isCameraOff,
      });
    }
  }

  void _toggleSpeaker() {
    if (!mounted) return;
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
  }

  Future<void> _switchCamera() async {
    if (_cameraController == null || !_isCameraInitialized) return;

    final cameras = await availableCameras();
    final newLensDirection = _isFrontCamera
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    final newCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == newLensDirection,
      orElse: () => cameras.first,
    );

    await _cameraController!.dispose();

    _cameraController = CameraController(
      newCamera,
      ResolutionPreset.medium,
      enableAudio: true,
    );

    await _cameraController!.initialize();

    if (mounted) {
      setState(() {
        _isFrontCamera = !_isFrontCamera;
      });
    }
  }

  void _endCall() {
    if (_isConnected) {
      _socket?.emit('end_call', {
        'callId': widget.callId,
        'userId': widget.userId,
        'reason': 'User ended call',
      });
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours == '00' ? '$minutes:$seconds' : '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _connectingAnimationController.dispose();

    if (_socket != null) {
      _socket!.off('connect');
      _socket!.off('user_joined');
      _socket!.off('user_left');
      _socket!.off('call_ended');
      _socket!.off('disconnect');
      _socket!.off('error');
      _socket!.off('connection_quality');
      _socket!.disconnect();
      _socket!.destroy(); // clean disconnect
      _socket = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _controlsVisible = !_controlsVisible;
            if (_controlsVisible) {
              _startControlsTimer();
            }
          });
        },
        child: SafeArea(
          child: Stack(
            children: [
              // Remote video fills the entire background
              Positioned.fill(child: _remoteVideo),

              // Add gradient overlay for better readability
              Positioned.fill(
                child: _isConnected
                    ? const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      stops: [0.0, 0.2],
                      colors: [
                        Color(0x99000000),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                    : Container(),
              ),

              // Bottom gradient for controls
              Positioned.fill(
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      stops: [0.0, 0.3],
                      colors: [
                        Color(0x99000000),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Connection status bar (top center)
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _controlsVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: _buildStatusBar(),
                ),
              ),

              // Local video preview
              Positioned(
                right: 16,
                top: 16,
                child: GestureDetector(
                  onTap: _switchCamera,
                  child: Container(
                    width: 120,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: _isCameraInitialized && !_isCameraOff
                        ? CameraPreview(_cameraController!)
                        : Container(
                      color: const Color(0xFF1A1A2E),
                      child: const Center(
                        child: Icon(
                          Icons.videocam_off,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Peer info (top-left)
              Positioned(
                top: 16,
                left: 16,
                child: AnimatedOpacity(
                  opacity: _controlsVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: _buildPeerInfo(),
                ),
              ),

              // Call controls
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: 0,
                right: 0,
                bottom: _controlsVisible ? 32 : -100,
                child: _buildBottomControls(),
              ),

              // Connection quality indicator
              Positioned(
                top: 16,
                right: 150,
                child: AnimatedOpacity(
                  opacity: _controlsVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: _buildConnectionQuality(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isConnected
              ? const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 16,
          )
              : FadeTransition(
            opacity: _connectingAnimation,
            child: const Icon(
              Icons.sync,
              color: Colors.amber,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _callStatus,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionQuality() {
    Color qualityColor;
    switch (_signalStrength) {
      case 0:
      case 1:
        qualityColor = Colors.red;
        break;
      case 2:
        qualityColor = Colors.orange;
        break;
      case 3:
      case 4:
        qualityColor = Colors.green;
        break;
      default:
        qualityColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.network_cell,
            color: qualityColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            _connectionQuality,
            style: TextStyle(
              color: qualityColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeerInfo() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF3F72AF),
            child: Text(
              widget.peerName[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.peerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              _callStartTime != null
                  ? Text(
                _formatDuration(_callDuration),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              )
                  : Text(
                _callStatus,
                style: TextStyle(
                  color: _isConnected ? Colors.green : Colors.amber,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildBottomControls() => Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(36),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _controlButton(
          icon: _isMicMuted ? Icons.mic_off : Icons.mic,
          color: _isMicMuted ? Colors.red : const Color(0xFF3F72AF),
          onTap: _toggleMicrophone,
          label: _isMicMuted ? 'Unmute' : 'Mute',
        ),
        _controlButton(
          icon: _isCameraOff ? Icons.videocam_off : Icons.videocam,
          color: _isCameraOff ? Colors.red : const Color(0xFF3F72AF),
          onTap: _toggleCamera,
          label: _isCameraOff ? 'Show Video' : 'Hide Video',
        ),
        _controlButton(
          icon: Icons.flip_camera_ios,
          color: const Color(0xFF3F72AF),
          onTap: _switchCamera,
          label: 'Flip',
        ),
        _controlButton(
          icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
          color: const Color(0xFF3F72AF),
          onTap: _toggleSpeaker,
          label: _isSpeakerOn ? 'Speaker' : 'Earpiece',
        ),
        _controlButton(
          icon: Icons.call_end,
          color: Colors.red,
          size: 25,
          onTap: _endCall,
          label: 'End',
        ),
      ],
    ),
  );

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String label,
    double size = 28,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: size + 4,
          backgroundColor: color,
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            iconSize: size,
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
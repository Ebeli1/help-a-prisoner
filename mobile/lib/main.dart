import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/activity/screens/activity_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/campaigns/screens/home_screen.dart';
import 'features/explore/screens/explore_screen.dart';
import 'features/give/screens/give_screen.dart';
import 'features/give/widgets/give_volunteer_popup.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help A Prisoner',
      theme: ThemeData(
        primaryColor: const Color(0xFF0D1B2A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D1B2A),
          secondary: const Color(0xFFD4AF37),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1B2A),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 16,
          ),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ============ SPLASH SCREEN ============

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _isVideoPlaying = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(
        'assets/videos/splash_video.mp4',
      );

      await _controller.initialize();
      _controller.setLooping(false);

      setState(() {
        _isVideoInitialized = true;
      });

      await _tryAutoplay();
    } catch (e) {
      debugPrint('Error loading video: $e');
      _fallbackNavigate();
    }
  }

  Future<void> _tryAutoplay() async {
    try {
      await _controller.setVolume(1.0);
      await _controller.play();

      setState(() {
        _isVideoPlaying = true;
      });

      Future.delayed(const Duration(seconds: 6), () {
        if (mounted && _isVideoPlaying && !_hasNavigated) {
          _navigateToOnboarding();
        }
      });
    } catch (e) {
      debugPrint('Autoplay blocked. Tap the screen to play.');
      setState(() {
        _isVideoPlaying = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('👆 Tap the screen to play the video'),
            duration: Duration(seconds: 3),
            backgroundColor: Color(0xFFD4AF37),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  void _handleTapToPlay() async {
    if (!_isVideoPlaying && !_hasNavigated) {
      await _controller.play();
      setState(() {
        _isVideoPlaying = true;
      });

      Future.delayed(const Duration(seconds: 6), () {
        if (mounted && _isVideoPlaying && !_hasNavigated) {
          _navigateToOnboarding();
        }
      });
    }
  }

  void _navigateToOnboarding() {
    if (_hasNavigated) return;
    _hasNavigated = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  void _fallbackNavigate() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) _navigateToOnboarding();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _handleTapToPlay,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isVideoInitialized)
              VideoPlayer(_controller)
            else
              Container(
                color: const Color(0xFF0D1B2A),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.handshake,
                      size: 40,
                      color: Color(0xFF0D1B2A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Help A Prisoner',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Support rehabilitation, education and opportunity',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFD4AF37),
                      fontFamily: 'Georgia',
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _navigateToOnboarding,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: const Color(0xFF0D1B2A),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _navigateToOnboarding,
                    child: const Text(
                      'Skip ›',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (_isVideoInitialized && !_isVideoPlaying)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Tap to play',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontFamily: 'Georgia',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (!_isVideoInitialized)
              Container(
                color: const Color(0xFF0D1B2A),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFFD4AF37),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============ MAIN SCREEN WITH BOTTOM NAVIGATION ============

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    GiveScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            // When Give tab is tapped, show the popup instead of navigating
            _showGiveVolunteerPopup(context);
            return;
          }
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: const Color(0xFF4A5A6A),
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Georgia',
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Georgia',
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Give',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
    );
  }

  void _showGiveVolunteerPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const GiveVolunteerPopup(),
    );
  }
}

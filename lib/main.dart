
// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'dart:async';
// import 'dart:ui' as ui; 
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:typed_data';
// import 'package:audioplayers/audioplayers.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'firebase_options.dart';
// import 'package:flutter/foundation.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   } catch (e) {
//     debugPrint("Firebase Login Error: $e");
//   }
//   runApp(const FlowFixApp());
// }

// enum GameMode { single, hardcore, battle, coop, royale, tournament, dailyChallenge }
// enum IslandTheme { nature, winter, cyberpunk }
// enum Faction { none, fire, ice, energy }
// enum TileStyle { classic, neon, wooden, marble }

// // ==========================================
// // SOUND MANAGER
// // ==========================================
// class SoundManager {
//   static final AudioPlayer _sfxPlayer = AudioPlayer();
//   static final AudioPlayer _bgmPlayer = AudioPlayer();
//   static Timer? _bgmTimer;
//   static bool isMuted = false;
//   static double bgmVolume = 0.1;
//   static double sfxVolume = 1.0;
//   static String currentBgmTrack = 'audio/Background Music (BGM) - Lobby.mp3';

//   static Future<void> loadAudioSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     isMuted = prefs.getBool('is_muted') ?? false;
//     bgmVolume = prefs.getDouble('bgm_volume') ?? 0.1;
//     sfxVolume = prefs.getDouble('sfx_volume') ?? 1.0;
//     currentBgmTrack = prefs.getString('bgm_track') ?? 'audio/Background Music (BGM) - Lobby.mp3';
//   }

//   static Future<void> toggleMute() async {
//     isMuted = !isMuted;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('is_muted', isMuted);
//     if (isMuted) {
//       stopBackgroundMusic();
//       try { await _sfxPlayer.stop(); } catch (_) {}
//     }
//   }

//   static Future<void> setBgmVolume(double vol) async {
//     bgmVolume = vol;
//     await _bgmPlayer.setVolume(bgmVolume);
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('bgm_volume', bgmVolume);
//   }

//   static Future<void> setSfxVolume(double vol) async {
//     sfxVolume = vol;
//     await _sfxPlayer.setVolume(sfxVolume);
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('sfx_volume', sfxVolume);
//   }

//   static Future<void> setBgmTrack(String trackPath) async {
//     currentBgmTrack = trackPath;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('bgm_track', currentBgmTrack);
//   }

//   static void playClick() async {
//     if (isMuted) return;
//     try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/button_click.ogg')); } catch (_) {}
//   }

//   static void playTileSound() async {
//     if (isMuted) return;
//     try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/tile_sound.ogg')); } catch (_) {}
//   }

//   static void playBonusSound() async {
//     if (isMuted) return;
//     try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/bonus.ogg')); } catch (_) {}
//   }

//   static void playSuccessConnection() async {
//     if (isMuted) return;
//     try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/Success-Connection.ogg')); } catch (_) {}
//   }

//   static void playLootBoxSound() async {
//     if (isMuted) return;
//     try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/loot-box-open-.ogg')); } catch (_) {}
//   }

//   static void playTimeWarning() async {
//     if (isMuted) return;
//     try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/Time-Warning.ogg')); } catch (_) {}
//   }

//   static void playWin() async {
//     if (isMuted) return;
//     try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/win.ogg')); } catch (_) {}
//   }

//   static void playLoss() async {
//     if (isMuted) return;
//     try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/lose.ogg')); } catch (_) {}
//   }

//   static void playTimedLobbyBGM() async {
//     if (isMuted) return;
//     try {
//       _bgmTimer?.cancel();
//       await _bgmPlayer.setReleaseMode(ReleaseMode.stop);
//       await _bgmPlayer.play(AssetSource(currentBgmTrack));
//       await _bgmPlayer.setVolume(bgmVolume); 
//       _bgmTimer = Timer(const Duration(seconds: 10), () { stopBackgroundMusic(); });
//     } catch (_) {}
//   }

//   static void playTimedGameplayBGM() async {
//     if (isMuted) return;
//     try {
//       _bgmTimer?.cancel();
//       await _bgmPlayer.setReleaseMode(ReleaseMode.stop);
//       await _bgmPlayer.play(AssetSource('audio/Background Music (BGM).mp3'));
//       await _bgmPlayer.setVolume(bgmVolume); 
//       _bgmTimer = Timer(const Duration(seconds: 10), () { stopBackgroundMusic(); });
//     } catch (_) {}
//   }

//   static void stopBackgroundMusic() async {
//     try { _bgmTimer?.cancel(); await _bgmPlayer.stop(); } catch (_) {}
//   }
// }

// class FlowFixApp extends StatelessWidget {
//   const FlowFixApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Mindora: Puzzle Quest',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: const Color(0xFF0B0C10), 
//         bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//           backgroundColor: Color(0xFF12141D),
//           selectedItemColor: Color(0xFF00E676),
//           unselectedItemColor: Colors.white54,
//         ),
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }

// // ==========================================
// // SPLASH SCREEN
// // ==========================================
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToLobby();
//   }

//   _navigateToLobby() async {
//     await SoundManager.loadAudioSettings();
//     await Future.delayed(const Duration(seconds: 3)); 
//     if (!mounted) return;
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainLobbyScreen()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0B0C10),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1A1C29),
//                 shape: BoxShape.circle,
//                 border: Border.all(color: const Color(0xFF00E676), width: 3),
//                 boxShadow: [BoxShadow(color: const Color(0xFF00E676).withOpacity(0.4), blurRadius: 30, spreadRadius: 10)],
//               ),
//               child: const Icon(Icons.hub, size: 80, color: Color(0xFF00E676)),
//             ),
//             const SizedBox(height: 25),
//             const Text('MINDORA: PUZZLE QUEST', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 3, color: Colors.white)),
//             const SizedBox(height: 10),
//             const Text('Connect & Solve', style: TextStyle(fontSize: 14, color: Colors.white54, letterSpacing: 1.5)),
//             const SizedBox(height: 40),
//             const CircularProgressIndicator(color: Color(0xFF00E676)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ==========================================
// // MAIN LOBBY SCREEN
// // ==========================================
// class MainLobbyScreen extends StatefulWidget {
//   const MainLobbyScreen({super.key});
//   @override State<MainLobbyScreen> createState() => _MainLobbyScreenState();
// }

// class _MainLobbyScreenState extends State<MainLobbyScreen> {
//   int _currentTabIndex = 0; 
//   int completedZones = 0; int selectedZoneToPlay = 0; int totalIQ = 0;
//   IslandTheme currentTheme = IslandTheme.nature;
//   TileStyle currentTileStyle = TileStyle.classic;
//   Faction playerFaction = Faction.none;
//   String clanName = ''; 
//   int activePet = 0; 
//   String playerName = 'Player'; 
//   String playerAvatar = '🦸‍♂️'; 
//   String playerImagePath = ''; 
//   Uint8List? playerImageBytes; 
  
//   String playerCountry = 'US';
//   String playerFlag = '🇺🇸';
  
//   int loginStreak = 1; int invTimeFreeze = 2; int invAutoRow = 1;
//   bool isFeverActive = false; int fastWinsInRow = 0; 
  
//   int assetSilver = 0; int assetGold = 0; int assetCars = 0; int assetHouses = 0;
//   bool isLoading = true;

//   int totalPuzzlesSolved = 0;
//   int consecutiveWins = 0;

//   final List<String> avatars = ['🦸‍♂️', '🥷', '🧙‍♂️', '🤖', '🧛', '👽', '🧟', '🕵️'];
//   final List<String> mockNames = ["Ninja_X", "ProSniper", "LudoKing", "Shadow", "Alpha_01", "GamerGirl", "Zero", "Ghost"];

//   int get netWorth => totalIQ + (assetSilver * 1000) + (assetGold * 5000) + (assetCars * 20000) + (assetHouses * 100000) + (totalPuzzlesSolved * 50);

//   @override void initState() { 
//     super.initState(); 
//     _getDeviceCountry();
//     _loadProgress(); 
//     SoundManager.playTimedLobbyBGM(); 
//   }

//   void _getDeviceCountry() {
//     try {
//       final locale = ui.PlatformDispatcher.instance.locale;
//       playerCountry = locale.countryCode ?? 'US'; 
//       int flagOffset = 0x1F1E6; int asciiOffset = 0x41;
//       String country = playerCountry.toUpperCase();
//       int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
//       int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;
//       playerFlag = String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
//     } catch (_) {
//       playerCountry = 'US'; playerFlag = '🇺🇸';
//     }
//   }

//   Future<void> _loadProgress() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       final prefs = await SharedPreferences.getInstance();

//       if (user != null) {
//         var doc = await FirebaseFirestore.instance.collection('players').doc(user.uid).get();
//         if (doc.exists) {
//           var data = doc.data()!;
//           setState(() {
//             playerName = data['name'] ?? 'Player';
//             playerAvatar = data['avatar'] ?? '🦸‍♂️';
//             playerImagePath = data['image_path'] ?? '';
//             clanName = data['clan'] ?? '';
//             totalIQ = data['net_worth'] ?? 0;
//             completedZones = data['completed_zones'] ?? 0;
//             selectedZoneToPlay = completedZones;
//           });
//         }
//       } else {
//         setState(() {
//           completedZones = prefs.getInt('saved_zone') ?? 0;
//           selectedZoneToPlay = completedZones; 
//           totalIQ = prefs.getInt('total_iq') ?? 0;
//         });
//       }

//       String lastLoginStr = prefs.getString('last_login') ?? '';
//       DateTime now = DateTime.now();
//       int currentStreak = prefs.getInt('login_streak') ?? 1;
      
//       if (lastLoginStr.isNotEmpty) {
//         DateTime lastLogin = DateTime.parse(lastLoginStr);
//         if (now.difference(lastLogin).inDays == 1) currentStreak++; 
//         else if (now.difference(lastLogin).inDays > 1) currentStreak = 1; 
        
//         int hoursAway = now.difference(lastLogin).inHours;
//         int tempCars = prefs.getInt('asset_cars') ?? 0;
//         int tempHouses = prefs.getInt('asset_houses') ?? 0;
//         if (hoursAway > 0 && (tempCars > 0 || tempHouses > 0)) {
//           int generatedIQ = (hoursAway * tempCars * 50) + (hoursAway * tempHouses * 500);
//           if (generatedIQ > 0 && user == null) {
//             WidgetsBinding.instance.addPostFrameCallback((_) => _showIdleRewardDialog(generatedIQ));
//             totalIQ += generatedIQ;
//           }
//         }
//       }
//       await prefs.setString('last_login', now.toIso8601String());
//       await prefs.setInt('login_streak', currentStreak);

//       setState(() {
//         int themeIdx = prefs.getInt('theme') ?? 0;
//         currentTheme = (themeIdx >= 0 && themeIdx < IslandTheme.values.length) ? IslandTheme.values[themeIdx] : IslandTheme.nature;
//         int tileStyleIdx = prefs.getInt('tile_style') ?? 0;
//         currentTileStyle = (tileStyleIdx >= 0 && tileStyleIdx < TileStyle.values.length) ? TileStyle.values[tileStyleIdx] : TileStyle.classic;
//         int factionIdx = prefs.getInt('faction') ?? 0;
//         playerFaction = (factionIdx >= 0 && factionIdx < Faction.values.length) ? Faction.values[factionIdx] : Faction.none;
//         activePet = prefs.getInt('active_pet') ?? 0;
//         loginStreak = currentStreak;
//         invTimeFreeze = prefs.getInt('inv_freeze') ?? 2;
//         invAutoRow = prefs.getInt('inv_autorow') ?? 1;
//         fastWinsInRow = prefs.getInt('fast_wins') ?? 0;
//         isFeverActive = fastWinsInRow >= 3; 
//         assetSilver = prefs.getInt('asset_silver') ?? 0;
//         assetGold = prefs.getInt('asset_gold') ?? 0;
//         assetCars = prefs.getInt('asset_cars') ?? 0;
//         assetHouses = prefs.getInt('asset_houses') ?? 0;
//         totalPuzzlesSolved = prefs.getInt('total_solved') ?? 0;
//         consecutiveWins = prefs.getInt('consecutive_wins') ?? 0;
//         isLoading = false;
//       });

//       _syncDataToFirebase();
//       if (playerFaction == Faction.none && !isLoading) WidgetsBinding.instance.addPostFrameCallback((_) => _showFactionSelectionDialog());
//     } catch (_) { setState(() => isLoading = false); }
//   }

//   Future<void> _syncDataToFirebase() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await FirebaseFirestore.instance.collection('players').doc(user.uid).set({
//         'name': playerName,
//         'avatar': playerAvatar,
//         'image_path': playerImagePath,
//         'clan': clanName,
//         'net_worth': netWorth,
//         'completed_zones': completedZones,
//         'total_solved': totalPuzzlesSolved,
//         'asset_silver': assetSilver,
//         'asset_gold': assetGold,
//         'asset_cars': assetCars,
//         'asset_houses': assetHouses,
//         'faction': playerFaction.name,
//         'country': playerCountry, 
//         'flag': playerFlag,       
//         'last_active': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));
//     }
//   }

//   Future<void> _saveAssets() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('asset_silver', assetSilver); 
//     await prefs.setInt('asset_gold', assetGold); 
//     await prefs.setInt('asset_cars', assetCars); 
//     await prefs.setInt('asset_houses', assetHouses);
//     _syncDataToFirebase();
//   }

//   void _showIdleRewardDialog(int amount) {
//     SoundManager.playBonusSound();
//     showDialog(context: context, builder: (_) => AlertDialog(backgroundColor: const Color(0xFF1E1E2E), title: const Text('Offline Income 💰', style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)), content: Text('While you were away, your Cars and Houses generated\n+$amount IQ!', style: const TextStyle(color: Colors.white70)), actions: [ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)), onPressed: () { SoundManager.playClick(); Navigator.pop(context); }, child: const Text('Collect', style: TextStyle(color: Colors.black)))]));
//   }

//   void _showFactionSelectionDialog() {
//     showDialog(
//       context: context, barrierDismissible: false,
//       builder: (_) => AlertDialog(backgroundColor: const Color(0xFF1A1C29), title: const Text('Join a Faction 🌍', style: TextStyle(color: Colors.white)), content: Column(mainAxisSize: MainAxisSize.min, children: [
//         _factionCard(Faction.fire, 'FIRE', Icons.local_fire_department, Colors.redAccent), _factionCard(Faction.ice, 'ICE', Icons.ac_unit, Colors.lightBlue), _factionCard(Faction.energy, 'ENERGY', Icons.bolt, Colors.yellowAccent),
//       ])),
//     );
//   }

//   Widget _factionCard(Faction faction, String name, IconData icon, Color color) {
//     return GestureDetector(onTap: () async { SoundManager.playClick(); final prefs = await SharedPreferences.getInstance(); await prefs.setInt('faction', faction.index); setState(() => playerFaction = faction); Navigator.pop(context); _syncDataToFirebase(); HapticFeedback.heavyImpact(); }, child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: color, width: 2)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: color, size: 28), const SizedBox(width: 10), Text('JOIN $name', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18))])));
//   }

//   Future<void> _saveProgress(int zone, int addedIQ, bool wasFastWin) async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       if (zone > completedZones) { completedZones = zone; selectedZoneToPlay = completedZones; }
//       totalIQ += addedIQ; if (totalIQ < 0) totalIQ = 0; 
//       if (addedIQ > 0 && wasFastWin) fastWinsInRow++; else if (addedIQ <= 0) fastWinsInRow = 0; 
//       isFeverActive = fastWinsInRow >= 3;
//       totalPuzzlesSolved++;
//       consecutiveWins++;
//     });
//     await prefs.setInt('saved_zone', completedZones); 
//     await prefs.setInt('total_iq', totalIQ); 
//     await prefs.setInt('fast_wins', fastWinsInRow);
//     await prefs.setInt('total_solved', totalPuzzlesSolved);
//     await prefs.setInt('consecutive_wins', consecutiveWins);
//     _syncDataToFirebase();
//   }

//   Future<void> _updateInventory(int freezeChange, int autoRowChange, int iqChange) async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() { 
//       invTimeFreeze += freezeChange; 
//       invAutoRow += autoRowChange; 
//       totalIQ += iqChange; 
//       if(totalIQ < 0) totalIQ = 0; 
//     });
//     await prefs.setInt('inv_freeze', invTimeFreeze); 
//     await prefs.setInt('inv_autorow', invAutoRow); 
//     await prefs.setInt('total_iq', totalIQ);
//     if(iqChange != 0) _syncDataToFirebase();
//   }

//   Future<void> _setTheme(IslandTheme theme) async { 
//     SoundManager.playClick();
//     final prefs = await SharedPreferences.getInstance(); 
//     setState(() => currentTheme = theme); 
//     await prefs.setInt('theme', theme.index); 
//   }

//   Future<void> _setTileStyle(TileStyle style) async {
//     SoundManager.playClick();
//     final prefs = await SharedPreferences.getInstance();
//     setState(() => currentTileStyle = style);
//     await prefs.setInt('tile_style', style.index);
//   }

//   String getRankName() { if (totalIQ < 500) return 'Bronze'; if (totalIQ < 1500) return 'Silver'; if (totalIQ < 3000) return 'Gold'; if (totalIQ < 6000) return 'Diamond'; return 'Heroic'; }
//   Color getRankColor() { if (totalIQ < 500) return const Color(0xFFCD7F32); if (totalIQ < 1500) return const Color(0xFFC0C0C0); if (totalIQ < 3000) return const Color(0xFFFFD700); if (totalIQ < 6000) return const Color(0xFF00E5FF); return const Color(0xFFFF1744); }
//   Color getThemeColor() { if (currentTheme == IslandTheme.winter) return const Color(0xFF80DEEA); if (currentTheme == IslandTheme.cyberpunk) return const Color(0xFFD500F9); return const Color(0xFF00E676); }
  
//   Widget getThemeIcons(int progress) {
//     if (currentTheme == IslandTheme.winter) return Row(children: [Icon(Icons.ac_unit, color: Colors.white, size: progress >= 1 ? 50 : 0), const SizedBox(width: 20), Icon(Icons.holiday_village, color: progress >= 2 ? Colors.white : Colors.transparent, size: 80)]);
//     if (currentTheme == IslandTheme.cyberpunk) return Row(children: [Icon(Icons.memory, color: const Color(0xFF00E5FF), size: progress >= 1 ? 50 : 0), const SizedBox(width: 20), Icon(Icons.precision_manufacturing, color: progress >= 2 ? const Color(0xFFD500F9) : Colors.transparent, size: 80)]);
//     return Row(children: [Icon(Icons.water_drop, color: const Color(0xFF4FC3F7), size: progress >= 1 ? 50 : 0), const SizedBox(width: 20), Icon(Icons.home_work, color: progress >= 2 ? const Color(0xFFF9A826) : Colors.transparent, size: 80)]);
//   }

//   void _watchAdForReward() async {
//     SoundManager.playClick();
//     showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(backgroundColor: Colors.transparent, elevation: 0, content: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: Color(0xFF00E676)), SizedBox(height: 10), Text('Loading Video Ad...', style: TextStyle(color: Colors.white))])));
//     await Future.delayed(const Duration(seconds: 2));
//     if(!mounted) return; Navigator.pop(context); _updateInventory(0, 0, 50); SoundManager.playBonusSound(); HapticFeedback.vibrate(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reward: +50 IQ Added!'), backgroundColor: Colors.green));
//   }

//   void _openLootBox() {
//     SoundManager.playClick();
//     if (totalIQ < 300) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough IQ!'))); return; }
//     _updateInventory(0, 0, -300); HapticFeedback.heavyImpact();
//     SoundManager.playLootBoxSound();
//     showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(backgroundColor: Colors.transparent, elevation: 0, content: TweenAnimationBuilder(tween: Tween<double>(begin: 0, end: 1), duration: const Duration(seconds: 2), builder: (context, val, child) { return Transform.scale(scale: val, child: const Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.card_giftcard, size: 100, color: Color(0xFFF9A826)), SizedBox(height: 20), Text('Opening...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))])); })));

//     Future.delayed(const Duration(seconds: 2), () {
//       if(!mounted) return; Navigator.pop(context); 
//       int chance = Random().nextInt(100); String rewardText = '';
//       if (chance < 40) { _updateInventory(2, 0, 0); rewardText = '🎁 2x Time Freeze!'; }
//       else if (chance < 70) { _updateInventory(0, 1, 0); rewardText = '🎁 1x Auto-Row!'; }
//       else if (chance < 90) { _updateInventory(0, 0, 500); rewardText = '🎁 +500 IQ Points!'; }
//       else { _updateInventory(5, 2, 0); rewardText = '💎 JACKPOT! 5 Freeze, 2 Magic!'; }
//       SoundManager.playBonusSound();
//       HapticFeedback.vibrate();
//       showDialog(context: context, builder: (_) => AlertDialog(backgroundColor: const Color(0xFF1A1C29), title: const Text('Reward ✨', style: TextStyle(color: Color(0xFF00E676))), content: Text(rewardText, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), actions: [ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF9A826)), onPressed: () { SoundManager.playClick(); Navigator.pop(context); }, child: const Text('Collect', style: TextStyle(color: Colors.black)))]));
//     });
//   }

//   void _showAudioSettingsDialog() {
//     SoundManager.playClick();
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) => AlertDialog(
//           backgroundColor: const Color(0xFF1E1E2E),
//           title: const Text('Sound & Audio Settings 🎵', style: TextStyle(color: Color(0xFF00E676))),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('BGM Volume', style: TextStyle(color: Colors.white70)),
//               Slider(
//                 value: SoundManager.bgmVolume, min: 0.0, max: 1.0, divisions: 10, activeColor: const Color(0xFF00E676),
//                 onChanged: (val) async { await SoundManager.setBgmVolume(val); setDialogState(() {}); },
//               ),
//               const Text('SFX Volume', style: TextStyle(color: Colors.white70)),
//               Slider(
//                 value: SoundManager.sfxVolume, min: 0.0, max: 1.0, divisions: 10, activeColor: const Color(0xFF00E5FF),
//                 onChanged: (val) async { await SoundManager.setSfxVolume(val); setDialogState(() {}); },
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)), onPressed: () { SoundManager.playClick(); Navigator.pop(context); }, child: const Text('Close', style: TextStyle(color: Colors.black)))
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAchievementsDialog() {
//     SoundManager.playClick();
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: const Color(0xFF1E1E2E),
//         title: const Text('Achievements & Badges 🏆', style: TextStyle(color: Color(0xFFF9A826))),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _achievementTile('🧠 Master Solver', 'Solve 10 Puzzles', totalPuzzlesSolved >= 10),
//             _achievementTile('🔥 Winning Streak', 'Win 3 Matches in Row', consecutiveWins >= 3),
//             _achievementTile('💰 Wealthy Mind', 'Reach 5,000 Net Worth', netWorth >= 5000),
//           ],
//         ),
//         actions: [
//           ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF9A826)), onPressed: () { SoundManager.playClick(); Navigator.pop(context); }, child: const Text('Awesome', style: TextStyle(color: Colors.black)))
//         ],
//       ),
//     );
//   }

//   Widget _achievementTile(String title, String desc, bool isUnlocked) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(color: isUnlocked ? const Color(0xFF00E676).withOpacity(0.15) : const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(12), border: Border.all(color: isUnlocked ? const Color(0xFF00E676) : Colors.transparent)),
//       child: Row(
//         children: [
//           Icon(isUnlocked ? Icons.verified : Icons.lock, color: isUnlocked ? const Color(0xFF00E676) : Colors.grey, size: 28),
//           const SizedBox(width: 12),
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text(title, style: TextStyle(color: isUnlocked ? Colors.white : Colors.white54, fontWeight: FontWeight.bold)),
//             Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 11)),
//           ]),
//         ],
//       ),
//     );
//   }

//   // Feature: Email, Password & Unique Username Registration / Sign-In Dialog
//   void _showEmailAuthDialog() {
//     SoundManager.playClick();
//     final emailController = TextEditingController();
//     final passController = TextEditingController();
//     final usernameController = TextEditingController();
//     bool isSignUp = false;

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) => AlertDialog(
//           backgroundColor: const Color(0xFF1E1E2E),
//           title: Text(isSignUp ? 'Create Cloud Account ☁️' : 'Sign In to Cloud 🔐', style: const TextStyle(color: Color(0xFF00E5FF))),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text('Secure your progress across mobile devices with Email & Unique Username!', style: TextStyle(color: Colors.white70, fontSize: 12)),
//                 const SizedBox(height: 15),
//                 if (isSignUp) ...[
//                   TextField(controller: usernameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Unique Username', labelStyle: TextStyle(color: Colors.white54))),
//                   const SizedBox(height: 10),
//                 ],
//                 TextField(controller: emailController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Email Address', labelStyle: TextStyle(color: Colors.white54))),
//                 const SizedBox(height: 10),
//                 TextField(controller: passController, obscureText: true, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Password', labelStyle: TextStyle(color: Colors.white54))),
//                 const SizedBox(height: 10),
//                 TextButton(
//                   onPressed: () => setDialogState(() => isSignUp = !isSignUp),
//                   child: Text(isSignUp ? 'Already have an account? Sign In' : 'Need an account? Register', style: const TextStyle(color: Color(0xFF00E676))),
//                 )
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF)),
//               onPressed: () async {
//                 SoundManager.playClick();
//                 String email = emailController.text.trim();
//                 String pass = passController.text.trim();
//                 String uName = usernameController.text.trim();
//                 if (email.isEmpty || pass.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields! ❌'), backgroundColor: Colors.red));
//                   return;
//                 }
//                 if (isSignUp && uName.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a username! ❌'), backgroundColor: Colors.red));
//                   return;
//                 }

//                 try {
//                   if (isSignUp) {
//                     var query = await FirebaseFirestore.instance.collection('players').where('name', isEqualTo: uName).get();
//                     if (query.docs.isNotEmpty) {
//                       if (!context.mounted) return;
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This username is already taken. Please choose another! ❌'), backgroundColor: Colors.red));
//                       return;
//                     }

//                     await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
//                     setState(() {
//                       playerName = uName;
//                       totalIQ = 0;
//                       completedZones = 0;
//                       selectedZoneToPlay = 0;
//                     });
//                     await _syncDataToFirebase();
//                   } else {
//                     UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
//                     var doc = await FirebaseFirestore.instance.collection('players').doc(cred.user!.uid).get();
//                     if (doc.exists) {
//                       var data = doc.data()!;
//                       setState(() {
//                         playerName = data['name'] ?? 'Player';
//                         playerAvatar = data['avatar'] ?? '🦸‍♂️';
//                         playerImagePath = data['image_path'] ?? '';
//                         clanName = data['clan'] ?? '';
//                         totalIQ = data['net_worth'] ?? 0;
//                         completedZones = data['completed_zones'] ?? 0;
//                         selectedZoneToPlay = completedZones;
//                       });
//                     }
//                   }
//                   if (!context.mounted) return;
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully authenticated & synced! ✅'), backgroundColor: Colors.green));
//                 } catch (e) {
//                   String friendlyMessage = 'Authentication failed. Please try again.';
//                   String errStr = e.toString();
//                   if (errStr.contains('email-already-in-use')) {
//                     friendlyMessage = 'This email address is already registered. Please sign in instead.';
//                   } else if (errStr.contains('invalid-email')) {
//                     friendlyMessage = 'The email address format is invalid.';
//                   } else if (errStr.contains('weak-password')) {
//                     friendlyMessage = 'The password is too weak. Please use at least 6 characters.';
//                   } else if (errStr.contains('user-not-found') || errStr.contains('wrong-password') || errStr.contains('invalid-credential')) {
//                     friendlyMessage = 'Incorrect email or password. Please check your credentials.';
//                   } else if (errStr.contains('network-request-failed')) {
//                     friendlyMessage = 'Network error. Please check your internet connection.';
//                   }

//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyMessage), backgroundColor: Colors.red));
//                 }
//               },
//               child: Text(isSignUp ? 'Register' : 'Sign In', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   // Feature: Friends System & Direct Invites Dialog with Push Notifications (FCM simulation trigger)
//   void _showFriendsDialog() {
//     SoundManager.playClick();
//     final friendUsernameController = TextEditingController();

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1E1E2E),
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
//       builder: (context) => StatefulBuilder(
//         builder: (context, setModalState) => Container(
//           height: MediaQuery.of(context).size.height * 0.6,
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               const Text('Friends & Direct Invites 👥', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 15),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: friendUsernameController,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: const InputDecoration(labelText: "Enter Friend's Username", labelStyle: TextStyle(color: Colors.white54)),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF)),
//                     onPressed: () async {
//                       SoundManager.playClick();
//                       String fName = friendUsernameController.text.trim();
//                       if (fName.isEmpty) return;

//                       User? user = FirebaseAuth.instance.currentUser;
//                       if (user == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please sign in to add friends! ❌'), backgroundColor: Colors.red));
//                         return;
//                       }

//                       var query = await FirebaseFirestore.instance.collection('players').where('name', isEqualTo: fName).get();
//                       if (query.docs.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Player not found! ❌'), backgroundColor: Colors.red));
//                         return;
//                       }

//                       String friendUid = query.docs.first.id;
//                       if (friendUid == user.uid) {
//                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You cannot add yourself! ❌'), backgroundColor: Colors.red));
//                         return;
//                       }

//                       await FirebaseFirestore.instance.collection('players').doc(user.uid).collection('friends').doc(friendUid).set({
//                         'friend_uid': friendUid,
//                         'name': fName,
//                         'added_at': FieldValue.serverTimestamp(),
//                       });

//                       friendUsernameController.clear();
//                       setModalState(() {});
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Friend added successfully! ✅'), backgroundColor: Colors.green));
//                     },
//                     child: const Text('Add', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Align(alignment: Alignment.centerLeft, child: Text('My Friends List:', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: FirebaseAuth.instance.currentUser == null
//                     ? const Center(child: Text('Please sign in to view your friends.', style: TextStyle(color: Colors.white54)))
//                     : StreamBuilder<QuerySnapshot>(
//                         stream: FirebaseFirestore.instance.collection('players').doc(FirebaseAuth.instance.currentUser!.uid).collection('friends').snapshots(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)));
//                           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                             return const Center(child: Text('No friends added yet.', style: TextStyle(color: Colors.white54)));
//                           }
//                           final docs = snapshot.data!.docs;
//                           return ListView.builder(
//                             itemCount: docs.length,
//                             itemBuilder: (context, index) {
//                               var data = docs[index].data() as Map<String, dynamic>;
//                               return Container(
//                                 margin: const EdgeInsets.only(bottom: 8),
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(color: const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(10)),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(children: [
//                                       const Icon(Icons.person, color: Color(0xFF00E676)),
//                                       const SizedBox(width: 10),
//                                       Text(data['name'] ?? 'Friend', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                                     ]),
//                                     ElevatedButton(
//                                       style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
//                                       onPressed: () async {
//                                         // FCM Push Notification trigger simulation for 1v1 invite
//                                         String friendUid = data['friend_uid'];
//                                         await FirebaseFirestore.instance.collection('notifications').add({
//                                           'target_uid': friendUid,
//                                           'title': '1v1 Battle Invite! ⚔️',
//                                           'body': '$playerName has challenged you to a 1v1 duel!',
//                                           'timestamp': FieldValue.serverTimestamp(),
//                                         });

//                                         Navigator.pop(context);
//                                         _showBetSelectionDialog(GameMode.battle);
//                                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invite sent via Push Notification! 🚀'), backgroundColor: Colors.green));
//                                       },
//                                       child: const Text('Invite 1v1', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
//                                     )
//                                   ],
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Daily Challenge Speedboard (Top 100 Best List & User Rank Display)
//   void _showDailyLeaderboard() {
//     SoundManager.playClick();
//     User? currentUser = FirebaseAuth.instance.currentUser;

//     showModalBottomSheet(
//       context: context, 
//       backgroundColor: const Color(0xFF1E1E2E), 
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
//       builder: (_) => DraggableScrollableSheet(
//         initialChildSize: 0.70,
//         minChildSize: 0.4,
//         maxChildSize: 0.9,
//         expand: false,
//         builder: (context, scrollController) => Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               const Text('Daily Challenge Top 100 Speedboard ⚡', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 5),
//               const Text('Ranked by best daily score (Resets daily)', style: TextStyle(color: Colors.white54, fontSize: 11)),
//               const SizedBox(height: 15),
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance.collection('daily_scores').orderBy('score_points', descending: true).limit(100).snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)));
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const Center(child: Text('No records today yet! Be the first.', style: TextStyle(color: Colors.white54)));
//                     }
                    
//                     final docs = snapshot.data!.docs;
//                     int myRank = -1;
//                     if (currentUser != null) {
//                       for (int i = 0; i < docs.length; i++) {
//                         var data = docs[i].data() as Map<String, dynamic>;
//                         if (data['uid'] == currentUser.uid) {
//                           myRank = i + 1;
//                           break;
//                         }
//                       }
//                     }

//                     return Column(
//                       children: [
//                         if (currentUser != null) ...[
//                           Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(color: const Color(0xFF00E5FF).withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF00E5FF))),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(myRank != -1 ? 'Your Today\'s Rank: #$myRank 🏆' : 'You haven\'t played today\'s challenge yet! 🎮', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                         ],
//                         Expanded(
//                           child: ListView.builder(
//                             controller: scrollController,
//                             itemCount: docs.length,
//                             itemBuilder: (context, index) {
//                               var data = docs[index].data() as Map<String, dynamic>;
//                               bool isMe = currentUser != null && data['uid'] == currentUser.uid;
//                               return Container(
//                                 margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(color: isMe ? const Color(0xFF00E5FF).withOpacity(0.2) : const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(12), border: isMe ? Border.all(color: const Color(0xFF00E5FF)) : null),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(children: [
//                                       Text('#${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
//                                       const SizedBox(width: 12),
//                                       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                                         Text(data['name'] ?? 'Player', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                                         Text('Time: ${data['time_taken']}s | Hints: ${data['hints']} | Moves: ${data['moves']}', style: const TextStyle(color: Colors.white54, fontSize: 10)),
//                                       ]),
//                                     ]),
//                                     Text('${data['score_points']} pts', style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Global Rich List with Top 100 limit restriction check
//   void _showLeaderboard() {
//     SoundManager.playClick();
//     showModalBottomSheet(
//       context: context, backgroundColor: const Color(0xFF1E1E2E), isScrollControlled: true,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
//       builder: (_) => Container(
//         height: MediaQuery.of(context).size.height * 0.7, padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const Text('Global Rich List (Top 100) 🌍💰', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance.collection('players').orderBy('net_worth', descending: true).limit(100).snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)));
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return ListView(children: [_buildRankRow(1, 'Elon_Mask', 2500000, false, '🇺🇸', 'US', '🦸‍♂️', '', {})]);
//                   }
//                   final docs = snapshot.data!.docs;
//                   return ListView.builder(
//                     itemCount: docs.length,
//                     itemBuilder: (context, index) {
//                       var data = docs[index].data() as Map<String, dynamic>;
//                       bool isMe = docs[index].id == FirebaseAuth.instance.currentUser?.uid;
//                       return _buildRankRow(
//                         index + 1, 
//                         data['name'] ?? '', 
//                         data['net_worth'] ?? 0, 
//                         isMe, 
//                         data['flag'] ?? '🌐', 
//                         data['country'] ?? 'UN', 
//                         data['avatar'] ?? '🦸‍♂️', 
//                         data['image_path'] ?? '', 
//                         data
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRankRow(int rank, String name, int score, bool isMe, String flag, String country, String avatar, String imgPath, Map<String, dynamic> extraData) {
//     int silver = extraData['asset_silver'] ?? 0;
//     int gold = extraData['asset_gold'] ?? 0;
//     int cars = extraData['asset_cars'] ?? 0;
//     int houses = extraData['asset_houses'] ?? 0;
//     int solved = extraData['total_solved'] ?? 0;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(color: isMe ? const Color(0xFF00E5FF).withOpacity(0.2) : const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(15)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(children: [
//                 SizedBox(width: 35, child: Text('#$rank', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber))),
//                 Text(flag), const SizedBox(width: 5), Text(avatar, style: const TextStyle(fontSize: 18)), const SizedBox(width: 8),
//                 Text(name, style: TextStyle(color: isMe ? const Color(0xFF00E5FF) : Colors.white, fontWeight: FontWeight.bold)),
//               ]),
//               Text('Net Worth: \$$score', style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Wrap(
//             spacing: 10,
//             runSpacing: 4,
//             children: [
//               Text('🧩 Solved: $solved', style: const TextStyle(color: Colors.white54, fontSize: 10)),
//               Text('🥈 Silver: $silver', style: const TextStyle(color: Colors.grey, fontSize: 10)),
//               Text('🥇 Gold: $gold', style: const TextStyle(color: Colors.amber, fontSize: 10)),
//               Text('🏎️ Cars: $cars', style: const TextStyle(color: Colors.redAccent, fontSize: 10)),
//               Text('🏡 Villas: $houses', style: const TextStyle(color: Colors.purpleAccent, fontSize: 10)),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   void _showBetSelectionDialog(GameMode mode) {
//     SoundManager.playClick();
//     int selectedBet = 100;
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) => AlertDialog(
//           backgroundColor: const Color(0xFF1E1E2E),
//           title: const Text('Select Bet Amount 💰', style: TextStyle(color: Color(0xFFF9A826))),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Your Balance: $totalIQ IQ', style: const TextStyle(color: Colors.white54)),
//               const SizedBox(height: 20),
//               Wrap(
//                 spacing: 15,
//                 children: [50, 100, 500, 1000].map((bet) => ChoiceChip(
//                   label: Text('$bet IQ'), selected: selectedBet == bet, selectedColor: const Color(0xFFF9A826),
//                   onSelected: (bool selected) { SoundManager.playClick(); setDialogState(() => selectedBet = bet); },
//                 )).toList(),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(onPressed: () { SoundManager.playClick(); Navigator.pop(context); }, child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF9A826)),
//               onPressed: () {
//                 SoundManager.playClick();
//                 if (totalIQ < selectedBet) {
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough IQ for this bet! ❌', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
//                   return;
//                 }
//                 Navigator.pop(context);
//                 _startAutoMatch(mode, betAmount: selectedBet);
//               },
//               child: const Text('Start Battle', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void _startAutoMatch(GameMode mode, {int betAmount = 100}) async {
//     if (mode == GameMode.battle) {
//       if (totalIQ >= betAmount) {
//         _updateInventory(0, 0, -betAmount);
//       }
//       String oppName = "Searching..."; String oppAvatar = '❓'; bool matchFound = false;

//       showDialog(
//         context: context, barrierDismissible: false,
//         builder: (dialogContext) => StatefulBuilder(
//           builder: (context, setDialogState) {
//             Timer.periodic(const Duration(milliseconds: 100), (timer) {
//               if (matchFound) { timer.cancel(); } 
//               else { setDialogState(() { oppName = mockNames[Random().nextInt(mockNames.length)]; oppAvatar = avatars[Random().nextInt(avatars.length)]; }); }
//             });
//             return AlertDialog(
//               backgroundColor: const Color(0xFF1E1E2E),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text('MATCHMAKING (Bet: $betAmount IQ)', style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 20),
//                   Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//                     Column(children: [Text(playerAvatar, style: const TextStyle(fontSize: 40)), const Text('YOU', style: TextStyle(color: Colors.white))]),
//                     const Text('VS', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 24)),
//                     Column(children: [Text(oppAvatar, style: const TextStyle(fontSize: 40)), Text(oppName, style: const TextStyle(color: Colors.white54))]),
//                   ]),
//                   const SizedBox(height: 20),
//                   if (!matchFound) const CircularProgressIndicator(color: Color(0xFF00E676))
//                   else const Text('MATCH FOUND!', style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
//                 ],
//               ),
//             );
//           },
//         ),
//       );

//       String uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest_${Random().nextInt(99999)}';
//       String displayName = clanName.isNotEmpty ? '[$clanName] $playerName' : playerName;

//       try {
//         var snapshot = await FirebaseFirestore.instance.collection('rooms').where('mode', isEqualTo: 'battle').where('status', isEqualTo: 'waiting').limit(1).get();
//         String roomId = ''; String finalOppName = ''; String finalOppAvatar = ''; bool host = false; int gameSeed = Random().nextInt(99999); 

//         if (snapshot.docs.isNotEmpty) {
//           var room = snapshot.docs.first; roomId = room.id; finalOppName = room['player1_name']; finalOppAvatar = room['player1_avatar'] ?? avatars[Random().nextInt(avatars.length)]; gameSeed = room['seed'];
//           await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({'status': 'playing', 'player2': uid, 'player2_name': displayName, 'player2_avatar': playerAvatar, 'player2_progress': 0.0});
//         } else {
//           host = true;
//           var newRoom = await FirebaseFirestore.instance.collection('rooms').add({'mode': 'battle', 'status': 'waiting', 'seed': gameSeed, 'player1': uid, 'player1_name': displayName, 'player1_avatar': playerAvatar, 'player1_progress': 0.0, 'player2': '', 'player2_name': '', 'player2_avatar': '', 'player2_progress': 0.0, 'created_at': FieldValue.serverTimestamp()});
//           roomId = newRoom.id;
//           bool playerJoined = false;
//           for (int i = 0; i < 20; i++) {
//             await Future.delayed(const Duration(seconds: 1));
//             var check = await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();
//             if (check.exists && check['status'] == 'playing') {
//               finalOppName = check['player2_name']; finalOppAvatar = check['player2_avatar'] ?? avatars[Random().nextInt(avatars.length)]; playerJoined = true; break;
//             }
//           }
//           if (!playerJoined) {
//             await FirebaseFirestore.instance.collection('rooms').doc(roomId).delete();
//             if (mounted) Navigator.pop(context); 
//             _updateInventory(0, 0, betAmount);
//             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No opponent found! Bet refunded.'), backgroundColor: Colors.red));
//             return;
//           }
//         }

//         matchFound = true; SoundManager.playSuccessConnection(); HapticFeedback.heavyImpact();
//         await Future.delayed(const Duration(seconds: 1)); 
//         if (!mounted) return;
//         Navigator.pop(context); 
//         SoundManager.stopBackgroundMusic();

//         final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => GameScreen(
//           levelIndex: selectedZoneToPlay, mode: GameMode.battle, themeColor: getThemeColor(), tileStyle: currentTileStyle,
//           isFeverActive: false, invTimeFreeze: invTimeFreeze, invAutoRow: invAutoRow, 
//           opponentName: finalOppName, opponentAvatar: finalOppAvatar, isPracticeMode: false, activePet: activePet,
//           roomId: roomId, isHost: host, gameSeed: gameSeed, playerImagePath: playerImagePath, playerAvatar: playerAvatar, playerImageBytes: playerImageBytes, betAmount: betAmount,
//         )));

//         SoundManager.playTimedLobbyBGM();
//         if(result != null) {
//           if(result['iq'] > 0) _updateInventory(0, 0, betAmount * 2);
//           _updateInventory(result['freezeUsed'] * -1, result['rowUsed'] * -1, 0);
//         }
//       } catch (_) {
//         Navigator.pop(context);
//         _updateInventory(0, 0, betAmount);
//       }
//     } else {
//       _startGame(mode);
//     }
//   }

//   void _startGame(GameMode mode) async {
//     if (mode == GameMode.dailyChallenge) {
//       User? currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser == null) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please sign in or register to play Daily Challenge! 🔐'), backgroundColor: Colors.orange));
//         _showEmailAuthDialog();
//         return;
//       }

//       final prefs = await SharedPreferences.getInstance();
//       String lastPlayedDate = prefs.getString('last_daily_date') ?? '';
//       String todayStr = DateTime.now().toIso8601String().substring(0, 10);
//       if (lastPlayedDate == todayStr) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have already completed today\'s Daily Challenge! Come back tomorrow 🌟', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
//         return;
//       }
//     }

//     SoundManager.playClick();
//     showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(backgroundColor: Colors.transparent, elevation: 0, content: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: Color(0xFF00E676)), SizedBox(height: 15), Text('ENTERING MATCH...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2))])));
//     await Future.delayed(const Duration(seconds: 1));
//     if (!mounted) return;
//     Navigator.pop(context); 

//     bool isPractice = mode == GameMode.single && selectedZoneToPlay < completedZones;
//     int seed = mode == GameMode.dailyChallenge ? DateTime.now().day * 99 : Random().nextInt(99999);
    
//     SoundManager.stopBackgroundMusic();

//     final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => GameScreen(
//       levelIndex: mode==GameMode.tournament ? 15 : (mode == GameMode.dailyChallenge ? 4 : selectedZoneToPlay), 
//       mode: mode, themeColor: getThemeColor(), tileStyle: currentTileStyle,
//       isFeverActive: isPractice ? false : isFeverActive, invTimeFreeze: invTimeFreeze, invAutoRow: invAutoRow, 
//       opponentName: mockNames[Random().nextInt(mockNames.length)], opponentAvatar: avatars[Random().nextInt(avatars.length)],
//       isPracticeMode: isPractice, activePet: activePet,
//       roomId: '', isHost: true, gameSeed: seed, playerImagePath: playerImagePath, playerAvatar: playerAvatar, playerImageBytes: playerImageBytes, betAmount: 0,
//     )));

//     SoundManager.playTimedLobbyBGM();

//     if(result != null) {
//       _updateInventory(result['freezeUsed'] * -1, result['rowUsed'] * -1, 0); 
//       if (mode == GameMode.tournament) {
//         if(result['iq'] > 0) _updateInventory(0, 0, 10000); 
//       } else if (mode == GameMode.dailyChallenge && result['iq'] > 0) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('last_daily_date', DateTime.now().toIso8601String().substring(0, 10));
//       } else if (!isPractice && (mode == GameMode.single || mode == GameMode.hardcore)) {
//         if(result['iq'] < 0) {
//           _updateInventory(0, 0, result['iq']); 
//         } else if (result['iq'] > 0) {
//           _saveProgress(selectedZoneToPlay + 1, result['iq'], result['isFast'] ?? false);
//         }
//       }
//     }
//   }

//   // Feature: Cloud Storage Profile Picture Upload
//   void _showProfileDialog() {
//     SoundManager.playClick();
//     final nameController = TextEditingController(text: playerName);
//     String tempAvatar = playerAvatar; String tempImagePath = playerImagePath; Uint8List? tempImageBytes = playerImageBytes;
//     bool isChecking = false;

//     showDialog(
//       context: context, barrierDismissible: false,
//       builder: (dialogContext) => StatefulBuilder(
//         builder: (context, setDialogState) {
//           return AlertDialog(
//             backgroundColor: const Color(0xFF1E1E2E),
//             title: const Text('Gamer Profile 🥷', style: TextStyle(color: Colors.white)),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       SoundManager.playClick();
//                       final picker = ImagePicker();
//                       final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//                       if (pickedFile != null) {
//                         var bytes = await pickedFile.readAsBytes();
//                         setDialogState(() { tempImagePath = pickedFile.path; tempImageBytes = bytes; });
//                       }
//                     },
//                     child: Center(
//                       child: Stack(
//                         alignment: Alignment.bottomRight,
//                         children: [
//                           Container(
//                             width: 80, height: 80,
//                             decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2A2A35), border: Border.all(color: const Color(0xFF00E676), width: 2)),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(40),
//                               child: tempImageBytes != null ? Image.memory(tempImageBytes!, fit: BoxFit.cover) : (tempImagePath.isNotEmpty && !kIsWeb ? Image.file(File(tempImagePath), fit: BoxFit.cover) : Center(child: Text(tempAvatar, style: const TextStyle(fontSize: 40)))),
//                             ),
//                           ),
//                           const CircleAvatar(radius: 14, backgroundColor: Color(0xFF00E676), child: Icon(Icons.camera_alt, size: 14, color: Colors.black))
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   const Text('Or Choose Emoji Avatar:', style: TextStyle(color: Colors.white70, fontSize: 13)),
//                   const SizedBox(height: 10),
//                   Wrap(
//                     spacing: 10, runSpacing: 10,
//                     children: avatars.map((a) => GestureDetector(
//                       onTap: () { SoundManager.playClick(); setDialogState(() { tempAvatar = a; tempImagePath = ''; tempImageBytes = null; }); },
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(color: (tempAvatar == a && tempImagePath.isEmpty && tempImageBytes == null) ? const Color(0xFF00E676).withOpacity(0.3) : const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(12), border: Border.all(color: (tempAvatar == a && tempImagePath.isEmpty && tempImageBytes == null) ? const Color(0xFF00E676) : Colors.transparent, width: 2)),
//                         child: Text(a, style: const TextStyle(fontSize: 28)),
//                       ),
//                     )).toList(),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Username', labelStyle: TextStyle(color: Colors.white54))),
//                   if (isChecking) const Padding(padding: EdgeInsets.only(top: 10), child: CircularProgressIndicator(color: Color(0xFF00E676)))
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(onPressed: () { SoundManager.playClick(); Navigator.pop(dialogContext); }, child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
//                 onPressed: isChecking ? null : () async {
//                   SoundManager.playClick();
//                   String newName = nameController.text.trim();
//                   if (newName.isEmpty) return;
                  
//                   setDialogState(() => isChecking = true);
//                   try {
//                     User? user = FirebaseAuth.instance.currentUser;
//                     if (tempImageBytes != null && user != null) {
//                       Reference ref = FirebaseStorage.instance.ref().child('profile_images').child('${user.uid}.jpg');
//                       UploadTask uploadTask = ref.putData(tempImageBytes!);
//                       TaskSnapshot snapshot = await uploadTask;
//                       tempImagePath = await snapshot.ref.getDownloadURL();
//                     }

//                     setState(() { 
//                       playerName = newName; 
//                       playerAvatar = tempAvatar; 
//                       playerImagePath = tempImagePath; 
//                       playerImageBytes = tempImageBytes; 
//                     }); 
//                     await _syncDataToFirebase();
//                     if (context.mounted) Navigator.pop(dialogContext);
//                   } catch (_) { setDialogState(() => isChecking = false); }
//                 },
//                 child: const Text('Save', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//               )
//             ],
//           );
//         }
//       ),
//     );
//   }

//   Widget _buildTopStatus() {
//     bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: const BoxDecoration(color: Color(0xFF12141D), border: Border(bottom: BorderSide(color: Colors.white10))),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: _showProfileDialog, 
//               child: Row(children: [
//                 Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF00E676), width: 1.5)),
//                   child: playerImageBytes != null ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.memory(playerImageBytes!, width: 30, height: 30, fit: BoxFit.cover)) : (playerImagePath.isNotEmpty && playerImagePath.startsWith('http') ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(playerImagePath, width: 30, height: 30, fit: BoxFit.cover)) : Text(playerAvatar, style: const TextStyle(fontSize: 22))),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                     Text('$playerFlag ${clanName.isNotEmpty ? '[$clanName] $playerName' : playerName} ${activePet == 1 ? '🐲' : (activePet == 2 ? '🐧' : '🧠')}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
//                     Text(getRankName(), style: TextStyle(color: getRankColor(), fontSize: 12)),
//                   ]),
//                 ),
//               ]),
//             ),
//           ),
//           Row(children: [
//             IconButton(
//               icon: Icon(SoundManager.isMuted ? Icons.volume_off : Icons.volume_up, color: SoundManager.isMuted ? Colors.redAccent : const Color(0xFF00E676)),
//               onPressed: () async { await SoundManager.toggleMute(); setState(() {}); },
//             ),
//             IconButton(icon: const Icon(Icons.settings_outlined, color: Colors.white70, size: 22), onPressed: _showAudioSettingsDialog),
//             IconButton(icon: const Icon(Icons.emoji_events, color: Color(0xFFF9A826), size: 22), onPressed: _showAchievementsDialog),
            
//             // Friends System Button
//             IconButton(icon: const Icon(Icons.group_add, color: Color(0xFF00E5FF), size: 22), tooltip: 'Friends & Invites', onPressed: _showFriendsDialog),

//             // Dynamic Sign In / Sign Out button based on authentication status
//             IconButton(
//               icon: Icon(isLoggedIn ? Icons.logout : Icons.login, color: isLoggedIn ? Colors.redAccent : const Color(0xFF00E5FF), size: 22), 
//               tooltip: isLoggedIn ? 'Sign Out' : 'Sign In / Register',
//               onPressed: () async {
//                 if (isLoggedIn) {
//                   await FirebaseAuth.instance.signOut();
//                   setState(() {
//                     totalIQ = 0;
//                     completedZones = 0;
//                     selectedZoneToPlay = 0;
//                     playerName = 'Player';
//                   });
//                   _loadProgress();
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully signed out! 🔒'), backgroundColor: Colors.orange));
//                 } else {
//                   _showEmailAuthDialog();
//                 }
//               },
//             ),

//             const SizedBox(width: 3),
//             const Icon(Icons.account_balance_wallet, color: Color(0xFF00E5FF), size: 18), const SizedBox(width: 2),
//             Text('$totalIQ', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
//           ]),
//         ],
//       ),
//     );
//   }

//   Widget _buildIslandTab() {
//     int islandProgress = completedZones > 3 ? 3 : completedZones;
//     bool isPractice = selectedZoneToPlay < completedZones;

//     return Column(
//       children: [
//         _buildTopStatus(),
//         Expanded(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               children: [
//                 const SizedBox(height: 15),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () => _startGame(GameMode.dailyChallenge),
//                           child: Container(
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF1744), Color(0xFFD500F9)]), borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.3), blurRadius: 10)]),
//                             child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                               Icon(Icons.flash_on, color: Colors.white, size: 20),
//                               SizedBox(width: 6),
//                               Text('DAILY CHALLENGE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
//                             ]),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1C29), side: const BorderSide(color: Color(0xFF00E5FF)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding: const EdgeInsets.all(14)),
//                         onPressed: _showDailyLeaderboard,
//                         child: const Icon(Icons.leaderboard, color: Color(0xFF00E5FF), size: 22),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Stack(
//                   alignment: Alignment.bottomCenter,
//                   children: [
//                     AnimatedOpacity(opacity: islandProgress >= 3 ? 1.0 : 0.0, duration: const Duration(seconds: 2), child: Container(width: 250, height: 250, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: isFeverActive ? Colors.redAccent.withOpacity(0.4) : getThemeColor().withOpacity(0.2), blurRadius: 80, spreadRadius: 20)]))),
//                     AnimatedPositioned(duration: const Duration(seconds: 1), curve: Curves.elasticOut, bottom: islandProgress >= 2 ? 90 : 70, child: AnimatedOpacity(opacity: islandProgress >= 2 ? 1.0 : 0.0, duration: const Duration(seconds: 1), child: getThemeIcons(islandProgress))),
//                     AnimatedPositioned(duration: const Duration(seconds: 1), curve: Curves.elasticOut, bottom: islandProgress >= 1 ? 80 : 60, left: 60, child: AnimatedOpacity(opacity: islandProgress >= 1 ? 1.0 : 0.0, duration: const Duration(seconds: 1), child: const Icon(Icons.park, color: Color(0xFF00E676), size: 80))),
//                     AnimatedContainer(duration: const Duration(seconds: 1), width: 250, height: 90, decoration: BoxDecoration(color: islandProgress >= 1 ? (currentTheme == IslandTheme.winter ? Colors.white : (currentTheme == IslandTheme.cyberpunk ? const Color(0xFF311B92) : const Color(0xFF1B5E20))) : const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(150), border: Border.all(color: isFeverActive ? Colors.redAccent : (islandProgress >= 3 ? getThemeColor() : Colors.transparent), width: isFeverActive ? 6 : 4), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))])),
//                     if (assetCars > 0) const Positioned(bottom: 50, right: 40, child: Icon(Icons.directions_car, color: Colors.redAccent, size: 35)),
//                     if (assetHouses > 0) const Positioned(bottom: 100, left: 90, child: Icon(Icons.villa, color: Colors.purpleAccent, size: 50)),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(icon: const Icon(Icons.arrow_left, size: 40, color: Colors.white), onPressed: selectedZoneToPlay > 0 ? () { SoundManager.playClick(); setState(() => selectedZoneToPlay--); } : null),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), 
//                       decoration: BoxDecoration(color: isPractice ? Colors.blueAccent.withOpacity(0.2) : const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15), border: Border.all(color: isPractice ? Colors.blueAccent : getThemeColor())), 
//                       child: Column(
//                         children: [
//                           Text('ZONE ${selectedZoneToPlay + 1}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), 
//                           const SizedBox(height: 2),
//                           Text('Level: ${selectedZoneToPlay + 1}', style: const TextStyle(fontSize: 12, color: Colors.white70)), 
//                           if (isPractice) const Text('Practice Mode', style: TextStyle(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold))
//                         ]
//                       )
//                     ),
//                     IconButton(icon: const Icon(Icons.arrow_right, size: 40, color: Colors.white), onPressed: selectedZoneToPlay < completedZones ? () { SoundManager.playClick(); setState(() => selectedZoneToPlay++); } : null),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.all(20),
//           decoration: const BoxDecoration(color: Color(0xFF12141D), border: Border(top: BorderSide(color: Colors.white10))),
//           child: Row(
//             children: [
//               GestureDetector(onTap: () => _startGame(GameMode.hardcore), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.redAccent.withOpacity(0.5))), child: const Icon(Icons.visibility_off, color: Colors.redAccent, size: 26))),
//               const SizedBox(width: 15),
//               Expanded(child: GestureDetector(onTap: () => _startGame(GameMode.single), child: Container(padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(gradient: LinearGradient(colors: isPractice ? [Colors.blueAccent, Colors.lightBlue] : [const Color(0xFF00E676), const Color(0xFF00C853)]), borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: isPractice ? Colors.blueAccent.withOpacity(0.4) : const Color(0xFF00E676).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))]), child: Center(child: Text(isPractice ? 'PRACTICE' : 'START (SOLO)', style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)))))),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//  Widget _buildMultiplayerTab() {
//     return ListView(
//       padding: const EdgeInsets.all(20),
//       children: [
//         _buildTopStatus(), const SizedBox(height: 20),
//         GestureDetector(onTap: _showLeaderboard, child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF00E5FF).withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFF00E5FF))), child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.leaderboard, color: Color(0xFF00E5FF), size: 30), SizedBox(width: 15), Text('Global Leaderboard (Top 100)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]), Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16)]))), const SizedBox(height: 20),
//         const Text('MULTIPLAYER SERVER 🌐', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)), const SizedBox(height: 15),
        
//         _modeCard(title: '1v1 Battle', subtitle: 'Bet custom IQ. Winner takes all!', icon: Icons.flash_on, color: Colors.redAccent, mode: GameMode.battle, onTapped: () => _showBetSelectionDialog(GameMode.battle)), 
//         const SizedBox(height: 15),
//         _modeCard(title: 'Flow Royale', subtitle: '100 Players Survival Mode', icon: Icons.public, color: Colors.purpleAccent, mode: GameMode.royale, onTapped: () => _startGame(GameMode.royale)), 
//         const SizedBox(height: 15),
//         _modeCard(title: 'Co-op Squad', subtitle: 'Solve big puzzles together', icon: Icons.handshake, color: const Color(0xFF4FC3F7), mode: GameMode.coop, onTapped: () => _startGame(GameMode.coop)),
//       ],
//     );
//   }

//   Widget _modeCard({required String title, required String subtitle, required IconData icon, required Color color, required GameMode mode, VoidCallback? onTapped}) {
//     return GestureDetector(onTap: onTapped ?? () => _startGame(mode), child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(0.2), const Color(0xFF1A1C29)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.5))), child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle), child: Icon(icon, color: color, size: 30)), const SizedBox(width: 20), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12))])), Icon(Icons.play_circle_fill, color: color, size: 40)])));
//   }

//   Widget _buildStoreTab() {
//     return ListView(
//       padding: const EdgeInsets.all(20),
//       children: [
//         _buildTopStatus(), const SizedBox(height: 20),
//         const Text('STORE & VIP 🛒', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)), const SizedBox(height: 20),
//         _luxuryListTile('Pet Egg 🥚', '1,000 IQ', 1000, activePet>0?1:0, Icons.pets, Colors.orange, () async { 
//           if(activePet == 0) { 
//             int newPet = Random().nextBool() ? 1 : 2; 
//             final prefs = await SharedPreferences.getInstance(); 
//             await prefs.setInt('active_pet', newPet); 
//             setState(() => activePet = newPet); 
//             SoundManager.playBonusSound();
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hatched a ${newPet==1?'Fire Dragon 🐲':'Ice Penguin 🐧'}!', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.orange)); 
//           } else { 
//             _updateInventory(0,0,1000); 
//             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You already own a pet!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red)); 
//           } 
//         }),
//         GestureDetector(onTap: _watchAdForReward, child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.ondemand_video, color: Colors.green, size: 28), SizedBox(width: 10), Text('WATCH AD FOR +50 IQ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]))), const SizedBox(height: 20),
//         GestureDetector(onTap: _openLootBox, child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF9A826), Color(0xFFFFB74D)]), borderRadius: BorderRadius.circular(20)), child: const Row(children: [Icon(Icons.card_giftcard, color: Colors.black, size: 50), SizedBox(width: 20), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('MYSTERY LOOT BOX', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)), Text('Cost: 300 IQ', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))])]))), const SizedBox(height: 30),
//         const Text('ISLAND THEMES', style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
//         Row(children: [
//           Expanded(child: GestureDetector(onTap: () => _setTheme(IslandTheme.nature), child: Container(padding: const EdgeInsets.symmetric(vertical: 15), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green.withOpacity(0.5))), child: const Column(children: [Icon(Icons.park, color: Colors.green, size: 35), SizedBox(height: 5), Text('Nature', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text('Free', style: TextStyle(color: Colors.green, fontSize: 10))])))), const SizedBox(width: 10),
//           Expanded(child: GestureDetector(onTap: () { if(totalIQ>=1000) _setTheme(IslandTheme.winter); }, child: Container(padding: const EdgeInsets.symmetric(vertical: 15), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.lightBlue.withOpacity(0.5))), child: const Column(children: [Icon(Icons.ac_unit, color: Colors.lightBlue, size: 35), SizedBox(height: 5), Text('Winter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text('1k IQ', style: TextStyle(color: Colors.lightBlue, fontSize: 10))])))), const SizedBox(width: 10),
//           Expanded(child: GestureDetector(onTap: () { if(totalIQ>=2500) _setTheme(IslandTheme.cyberpunk); }, child: Container(padding: const EdgeInsets.symmetric(vertical: 15), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.purpleAccent.withOpacity(0.5))), child: const Column(children: [Icon(Icons.memory, color: Colors.purpleAccent, size: 35), SizedBox(height: 5), Text('Cyber', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text('2.5k IQ', style: TextStyle(color: Colors.purpleAccent, fontSize: 10))])))),
//         ]), 
//         const SizedBox(height: 30),
//         const Text('TILE SKINS STYLES', style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
//         Row(children: [
//           Expanded(child: GestureDetector(onTap: () => _setTileStyle(TileStyle.classic), child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(12), border: Border.all(color: currentTileStyle == TileStyle.classic ? Colors.green : Colors.transparent)), child: const Center(child: Text('Classic', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))))),
//           const SizedBox(width: 8),
//           Expanded(child: GestureDetector(onTap: () { if(totalIQ>=500) _setTileStyle(TileStyle.neon); }, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(12), border: Border.all(color: currentTileStyle == TileStyle.neon ? Colors.cyan : Colors.transparent)), child: const Center(child: Text('Neon (500)', style: TextStyle(color: Colors.cyan, fontSize: 12, fontWeight: FontWeight.bold)))))),
//           const SizedBox(width: 8),
//           Expanded(child: GestureDetector(onTap: () { if(totalIQ>=1200) _setTileStyle(TileStyle.wooden); }, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(12), border: Border.all(color: currentTileStyle == TileStyle.wooden ? Colors.amber : Colors.transparent)), child: const Center(child: Text('Wood (1.2k)', style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)))))),
//         ]),
//         const SizedBox(height: 30),
//         const Text('LUXURY REAL ESTATE', style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
//         _luxuryListTile('Silver Bar', '1,000 IQ', 1000, assetSilver, Icons.view_comfy_alt, Colors.grey, () { setState(() => assetSilver++); _saveAssets(); }), 
//         _luxuryListTile('Gold Bar', '5,000 IQ', 5000, assetGold, Icons.view_comfy_alt, Colors.amber, () { setState(() => assetGold++); _saveAssets(); }), 
//         _luxuryListTile('Supercar', '20,000 IQ', 20000, assetCars, Icons.directions_car, Colors.redAccent, () { setState(() => assetCars++); _saveAssets(); }), 
//         _luxuryListTile('Luxury Villa', '100,000 IQ', 100000, assetHouses, Icons.villa, Colors.purpleAccent, () { setState(() => assetHouses++); _saveAssets(); }),
//       ],
//     );
//   }

//   Widget _luxuryListTile(String name, String priceTxt, int price, int owned, IconData icon, Color color, VoidCallback onBuy) {
//     return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15)), child: ListTile(leading: Icon(icon, color: color, size: 35), title: Text(name, style: TextStyle(color: color, fontWeight: FontWeight.bold)), subtitle: Text('Owned: $owned\nCost: $priceTxt', style: const TextStyle(color: Colors.white54, fontSize: 12)), trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: totalIQ >= price ? const Color(0xFF00E676) : Colors.grey), onPressed: () { if (totalIQ >= price) { SoundManager.playBonusSound(); _updateInventory(0, 0, -price); onBuy(); HapticFeedback.heavyImpact(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchased $name! 🎉', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.green)); } else { SoundManager.playClick(); } }, child: const Text('Buy', style: TextStyle(color: Colors.black)))));
//   }

//   @override Widget build(BuildContext context) {
//     if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF00E676))));
//     return Scaffold(
//       body: SafeArea(child: IndexedStack(index: _currentTabIndex, children: [_buildIslandTab(), _buildMultiplayerTab(), _buildStoreTab()])), 
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentTabIndex, 
//         onTap: (index) { SoundManager.playClick(); setState(() => _currentTabIndex = index); }, 
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.terrain), label: 'Island'), 
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Multiplayer'), 
//           BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Store')
//         ]
//       )
//     );
//   }
// }

// // ==========================================
// // TILE MODEL & GENERATOR
// // ==========================================
// class TileModel {
//   final String type; int rotation; final int correctRotation; final bool isGolden; 
//   TileModel({required this.type, required this.rotation, required this.correctRotation, this.isGolden = false});
// }

// class LevelGenerator {
//   static List<List<TileModel>> generate(int size, {int? seed, int retryCount = 0}) {
//     if (retryCount > 50) {
//       return List.generate(size, (r) => List.generate(size, (c) => TileModel(type: 'I', rotation: 0, correctRotation: 0)));
//     }

//     final rand = seed != null ? Random(seed + retryCount) : Random();
//     List<List<TileModel>> grid = List.generate(size, (r) => List.generate(size, (c) => TileModel(type: 'empty', rotation: 0, correctRotation: 0)));
//     int currR = 0, currC = 0; grid[currR][currC] = TileModel(type: 'S', rotation: 0, correctRotation: 0);
//     List<List<int>> path = [[0,0]]; Set<String> visited = {'0,0'};

//     while (currR != size - 1 || currC != size - 1) {
//       List<List<int>> pMoves = [];
//       if (currR > 0 && !visited.contains('${currR-1},$currC')) pMoves.add([currR-1, currC]);
//       if (currR < size - 1 && !visited.contains('${currR+1},$currC')) pMoves.add([currR+1, currC]);
//       if (currC > 0 && !visited.contains('$currR,${currC-1}')) pMoves.add([currR, currC-1]);
//       if (currC < size - 1 && !visited.contains('$currR,${currC+1}')) pMoves.add([currR, currC+1]);
      
//       if (pMoves.isEmpty) {
//         return generate(size, seed: seed, retryCount: retryCount + 1);
//       }
      
//       pMoves.shuffle(rand); currR = pMoves.first[0]; currC = pMoves.first[1]; path.add([currR, currC]); visited.add('$currR,$currC');
//     }
//     grid[size-1][size-1] = TileModel(type: 'E', rotation: 0, correctRotation: 0);
//     int getDir(int r1, int c1, int r2, int c2) { if (r2 < r1) return 0; if (c2 > c1) return 1; if (r2 > r1) return 2; if (c2 < c1) return 3; return -1; }

//     for (int i = 1; i < path.length - 1; i++) {
//       int prevR = path[i-1][0], prevC = path[i-1][1], r = path[i][0], c = path[i][1], nextR = path[i+1][0], nextC = path[i+1][1];
//       int inDir = getDir(r, c, prevR, prevC), outDir = getDir(r, c, nextR, nextC);
//       int correctRot = 0; String type = 'L';
//       if ((inDir == 0 && outDir == 2) || (inDir == 2 && outDir == 0)) { type = 'I'; correctRot = 0; }
//       else if ((inDir == 1 && outDir == 3) || (inDir == 3 && outDir == 1)) { type = 'I'; correctRot = 1; }
//       else { type = 'L'; if ((inDir == 0 && outDir == 1) || (inDir == 1 && outDir == 0)) correctRot = 0; else if ((inDir == 1 && outDir == 2) || (inDir == 2 && outDir == 1)) correctRot = 1; else if ((inDir == 2 && outDir == 3) || (inDir == 3 && outDir == 2)) correctRot = 2; else correctRot = 3; }
//       grid[r][c] = TileModel(type: type, rotation: correctRot, correctRotation: correctRot);
//     }
//     bool goldenPlaced = false;
//     for (int r = 0; r < size; r++) {
//       for (int c = 0; c < size; c++) {
//         if (grid[r][c].type == 'empty') {
//           bool makeGolden = (!goldenPlaced && rand.nextInt(10) > 7);
//           if (makeGolden) goldenPlaced = true;
//           grid[r][c] = TileModel(type: rand.nextBool() ? 'I' : 'L', rotation: rand.nextInt(4), correctRotation: rand.nextInt(4), isGolden: makeGolden);
//         } else if (grid[r][c].type != 'S' && grid[r][c].type != 'E') {
//           grid[r][c] = TileModel(type: grid[r][c].type, rotation: (grid[r][c].correctRotation + rand.nextInt(3) + 1) % 4, correctRotation: grid[r][c].correctRotation); 
//         }
//       }
//     }
//     return grid;
//   }
// }

// // ==========================================
// // GAME SCREEN
// // ==========================================
// class GameScreen extends StatefulWidget {
//   final int levelIndex; final GameMode mode; final Color themeColor; final TileStyle tileStyle; final bool isFeverActive; final int invTimeFreeze; final int invAutoRow; final String opponentName; final String opponentAvatar; final bool isPracticeMode; final int activePet;
//   final String roomId; final bool isHost; final int gameSeed;
//   final String playerImagePath; final String playerAvatar; final Uint8List? playerImageBytes;
//   final int betAmount;

//   const GameScreen({super.key, required this.levelIndex, required this.mode, required this.themeColor, required this.tileStyle, required this.isFeverActive, required this.invTimeFreeze, required this.invAutoRow, required this.opponentName, required this.opponentAvatar, this.isPracticeMode = false, required this.activePet, required this.roomId, required this.isHost, required this.gameSeed, required this.playerImagePath, required this.playerAvatar, required this.playerImageBytes, required this.betAmount});
//   @override State<GameScreen> createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   bool isSolved = false; late List<List<TileModel>> grid; Set<String> illuminatedPaths = {'0,0'}; bool goldenCollected = false;
//   int timeLeft = 60; int initialTime = 60; int moves = 0; int hintsTaken = 0; int calculatedIQ = 0;
//   int freezeUsed = 0; int rowUsed = 0; bool isFrozen = false; Timer? _timer; Timer? _multiplayerSimTimer;
//   bool usedHint = false; 
//   int totalFrozenSeconds = 0; 

//   double opponentProgress = 0.0; int playersAlive = 100;
//   String currentKillfeed = "Match Started!";
//   List<String> killNames = ["Ninja", "ProSniper", "LudoKing", "NoobMaster", "Alpha", "Zero"];

//   StreamSubscription? _roomSubscription;

//   @override void initState() { 
//     super.initState(); 
//     loadLevel(); 
//     SoundManager.playTimedGameplayBGM(); 
//   }
  
//   @override void dispose() { _timer?.cancel(); _multiplayerSimTimer?.cancel(); _roomSubscription?.cancel(); super.dispose(); }

//   void loadLevel() {
//     setState(() {
//       isSolved = false; moves = 0; hintsTaken = 0; illuminatedPaths = {'0,0'}; isFrozen = false; opponentProgress = 0.0; goldenCollected = false; usedHint = false; totalFrozenSeconds = 0;
//       int size = widget.levelIndex < 3 ? 3 : (widget.levelIndex < 10 ? 4 : 5);
//       if (widget.mode == GameMode.royale) size = 5; if (widget.mode == GameMode.tournament || widget.mode == GameMode.dailyChallenge) size = 5;
//       grid = LevelGenerator.generate(size, seed: (widget.mode == GameMode.battle || widget.mode == GameMode.dailyChallenge) ? widget.gameSeed : null);
//       timeLeft = widget.mode == GameMode.battle ? 60 : (size == 3 ? 30 : (size == 4 ? 60 : 90)); 
//       initialTime = timeLeft; checkPath();
//     });
//     _startTimer();
    
//     if (widget.mode == GameMode.battle && widget.roomId.isNotEmpty) _startRealtimeBattle();
//     else if (widget.mode == GameMode.royale) _startRoyaleSimulation();
//   }

//   void _startRealtimeBattle() {
//     _roomSubscription = FirebaseFirestore.instance.collection('rooms').doc(widget.roomId).snapshots().listen((snapshot) {
//       if (!snapshot.exists || isSolved) return;
//       var data = snapshot.data() as Map<String, dynamic>;
//       double oppProg = widget.isHost ? data['player2_progress'] : data['player1_progress'];
//       if (oppProg > opponentProgress) {
//         setState(() {
//           opponentProgress = oppProg;
//           if (opponentProgress >= 1.0) { 
//             _timer?.cancel(); _roomSubscription?.cancel(); SoundManager.playLoss();
//             _showGameOverDialog("YOU LOSE THE GAME 💔", "${widget.opponentName} won the ${widget.betAmount} IQ bet!", 0); 
//           }
//         });
//       }
//     });
//   }

//   void _syncMyProgressToFirebase() {
//     if (widget.mode != GameMode.battle || widget.roomId.isEmpty) return;
//     double totalTiles = (grid.length * grid[0].length).toDouble();
//     double myProg = illuminatedPaths.length / totalTiles;
//     if (isSolved) myProg = 1.0;
//     String fieldToUpdate = widget.isHost ? 'player1_progress' : 'player2_progress';
//     FirebaseFirestore.instance.collection('rooms').doc(widget.roomId).update({fieldToUpdate: myProg});
//   }

//   void _startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (isFrozen) {
//         totalFrozenSeconds++;
//         return;
//       } 
//       if (timeLeft > 0 && !isSolved) {
//         if (timeLeft == 7) { SoundManager.playTimeWarning(); }
//         setState(() => timeLeft--);
//       } else if (timeLeft == 0 && !isSolved) { 
//         timer.cancel(); SoundManager.stopBackgroundMusic(); SoundManager.playLoss();
//         _showGameOverDialog("Time's Up! ⏱️", "You lost the match.", 0); 
//       }
//     });
//   }

//   void _startRoyaleSimulation() { 
//     _multiplayerSimTimer?.cancel(); 
//     _multiplayerSimTimer = Timer.periodic(const Duration(seconds: 3), (timer) { 
//       if (isSolved) { timer.cancel(); return; } 
//       setState(() { 
//         if (playersAlive > 2) {
//           playersAlive -= Random().nextInt(5) + 1; 
//           String dead = killNames[Random().nextInt(killNames.length)];
//           String killer = killNames[Random().nextInt(killNames.length)];
//           currentKillfeed = "🔫 $killer eliminated $dead";
//         } else if (playersAlive == 2) { currentKillfeed = "🔥 1 VS 1 - CLUTCH TIME! 🔥"; }
//       }); 
//     }); 
//   }

//   void _useTimeFreeze() {
//     if(isFrozen) return;
//     if(widget.invTimeFreeze - freezeUsed <= 0) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No Freeze left!'))); return; }
//     SoundManager.playBonusSound();
//     int freezeDur = widget.activePet == 2 ? 15 : 10; 
//     setState(() { isFrozen = true; freezeUsed++; });
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❄️ Time Frozen for ${freezeDur}s!')));
//     Future.delayed(Duration(seconds: freezeDur), () { if(mounted) setState(() => isFrozen = false); });
//   }

//   void _useAutoRow() {
//     if(widget.invAutoRow - rowUsed <= 0) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No Magic left!'))); return; }
//     SoundManager.playBonusSound();
//     setState(() {
//       rowUsed++; bool changed = false;
//       for (int r = 0; r < grid.length; r++) { for (int c = 0; c < grid[r].length; c++) { if (grid[r][c].rotation != grid[r][c].correctRotation && grid[r][c].type != 'S' && grid[r][c].type != 'E') { grid[r][c].rotation = grid[r][c].correctRotation; changed = true; } } if (changed) break; }
//       checkPath();
//     });
//   }

//   void _watchAdForHint() async {
//     SoundManager.playClick();
//     showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(backgroundColor: Colors.transparent, elevation: 0, content: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: Color(0xFFF9A826)), SizedBox(height: 10), Text('Loading Ad for Hint...', style: TextStyle(color: Colors.white))])));
//     await Future.delayed(const Duration(seconds: 2));
//     if(!mounted) return; Navigator.pop(context);
//     setState(() {
//       hintsTaken++; 
//       int hintsGiven = 0;
//       for (int r = 0; r < grid.length; r++) { for (int c = 0; c < grid[r].length; c++) { if (grid[r][c].type != 'empty' && grid[r][c].type != 'S' && grid[r][c].type != 'E' && grid[r][c].rotation != grid[r][c].correctRotation) { grid[r][c].rotation = grid[r][c].correctRotation; hintsGiven++; if (hintsGiven >= 2) break; } } if (hintsGiven >= 2) break; }
//       if (checkPath()) { 
//         isSolved = true; _timer?.cancel(); SoundManager.playWin(); _showWinDialog(); 
//       }
//     });
//   }

//   void rotateTile(int row, int col) {
//     if (isSolved || timeLeft == 0) return;
//     if (grid[row][col].type == 'S' || grid[row][col].type == 'E') return;
    
//     SoundManager.playTileSound(); HapticFeedback.lightImpact(); 

//     setState(() { 
//       grid[row][col].rotation = (grid[row][col].rotation + 1) % 4; moves++; 
//       if (checkPath()) { 
//         isSolved = true; _timer?.cancel(); _roomSubscription?.cancel(); _multiplayerSimTimer?.cancel();
//         SoundManager.playWin(); HapticFeedback.heavyImpact(); _showWinDialog(); 
//       }
//       _syncMyProgressToFirebase();
//     });
//   }

//   List<int> getOpenPorts(TileModel tile) {
//     if (tile.type == 'S' || tile.type == 'E') return [0, 1, 2, 3];
//     List<int> bp = []; if (tile.type == 'I') bp = [0, 2]; if (tile.type == 'L') bp = [0, 1];
//     return bp.map((p) => (p + tile.rotation) % 4).toList();
//   }

//   bool checkPath() {
//     List<List<int>> q = [[0, 0]]; Set<String> vis = {'0,0'}; bool tempGold = false;
//     while (q.isNotEmpty) {
//       var curr = q.removeAt(0); int r = curr[0], c = curr[1]; TileModel ct = grid[r][c];
//       if (ct.isGolden) tempGold = true;
//       if (ct.type == 'E') { setState(() { illuminatedPaths = vis; goldenCollected = tempGold; }); return true; }
//       for (int p in getOpenPorts(ct)) {
//         int nr = r, nc = c, op = (p + 2) % 4;
//         if (p == 0) nr--; if (p == 1) nc++; if (p == 2) nr++; if (p == 3) nc--; 
//         if (nr >= 0 && nr < grid.length && nc >= 0 && nc < grid[0].length && !vis.contains('$nr,$nc')) {
//           if (getOpenPorts(grid[nr][nc]).contains(op)) { vis.add('$nr,$nc'); q.add([nr, nc]); }
//         }
//       }
//     }
//     setState(() => illuminatedPaths = vis); return false;
//   }

//   void _showGameOverDialog(String title, String message, int penaltyIQ) {
//     showDialog(
//       context: context, barrierDismissible: false, 
//       builder: (_) => AlertDialog(
//         backgroundColor: const Color(0xFF1E1E2E), 
//         title: Text(title, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)), 
//         content: Text(message, style: const TextStyle(color: Colors.white70)), 
//         actions: [ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), onPressed: () { SoundManager.playClick(); Navigator.pop(context); Navigator.pop(context, {'iq': penaltyIQ, 'freezeUsed': freezeUsed, 'rowUsed': rowUsed}); }, child: const Text('Exit to Lobby', style: TextStyle(color: Colors.white)))]
//       )
//     );
//   }

//   void _showWinDialog() async {
//     if (widget.mode == GameMode.dailyChallenge) {
//       int totalPuzzleTiles = 0;
//       for (var row in grid) {
//         for (var tile in row) {
//           if (tile.type != 'empty' && tile.type != 'S' && tile.type != 'E') totalPuzzleTiles++;
//         }
//       }

//       bool is100PercentHints = totalPuzzleTiles > 0 && hintsTaken >= totalPuzzleTiles;

//       if (is100PercentHints) {
//         showDialog(
//           context: context, barrierDismissible: false,
//           builder: (_) => AlertDialog(
//             backgroundColor: const Color(0xFF1E1E2E),
//             title: const Text('SOLVED WITH 100% HINTS! 💡', style: TextStyle(color: Color(0xFFF9A826), fontWeight: FontWeight.bold), textAlign: TextAlign.center),
//             content: const Text('Since you used hints for the entire puzzle, no points or leaderboard rank were awarded for this daily challenge.', style: TextStyle(color: Colors.white70)),
//             actions: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF9A826)),
//                 onPressed: () { SoundManager.playClick(); Navigator.pop(context); Navigator.pop(context, {'iq': 0, 'freezeUsed': freezeUsed, 'rowUsed': rowUsed}); },
//                 child: const Text('Okay', style: TextStyle(color: Colors.black)),
//               )
//             ],
//           ),
//         );
//         return;
//       }

//       int timeTaken = initialTime - timeLeft;
//       int scorePoints = 10000 - (timeTaken * 10) - (hintsTaken * 300) - (totalFrozenSeconds * 5) - (moves * 2);
//       if (scorePoints < 10) scorePoints = 10;

//       String todayDateStr = DateTime.now().toIso8601String().substring(0, 10);

//       try {
//         User? user = FirebaseAuth.instance.currentUser;
//         if (user != null) {
//           var userDoc = await FirebaseFirestore.instance.collection('players').doc(user.uid).get();
//           String uname = userDoc.exists ? (userDoc.data()?['name'] ?? 'Player') : 'Player';

//           var existingScoreQuery = await FirebaseFirestore.instance
//               .collection('daily_scores')
//               .where('uid', isEqualTo: user.uid)
//               .where('date_str', isEqualTo: todayDateStr)
//               .get();

//           if (existingScoreQuery.docs.isNotEmpty) {
//             var docRef = existingScoreQuery.docs.first.reference;
//             int existingPoints = existingScoreQuery.docs.first.data()['score_points'] ?? 0;

//             if (scorePoints > existingPoints) {
//               await docRef.update({
//                 'time_taken': timeTaken,
//                 'hints': hintsTaken,
//                 'frozen_time': totalFrozenSeconds,
//                 'moves': moves,
//                 'score_points': scorePoints,
//                 'timestamp': FieldValue.serverTimestamp(),
//               });
//             }
//           } else {
//             await FirebaseFirestore.instance.collection('daily_scores').add({
//               'uid': user.uid,
//               'name': uname,
//               'date_str': todayDateStr,
//               'time_taken': timeTaken,
//               'hints': hintsTaken,
//               'frozen_time': totalFrozenSeconds,
//               'moves': moves,
//               'score_points': scorePoints,
//               'timestamp': FieldValue.serverTimestamp(),
//             });
//           }
//         }
//       } catch (_) {}
//     }

//     int baseIQ = widget.mode == GameMode.battle ? widget.betAmount * 2 : (widget.mode == GameMode.royale ? 500 : (widget.mode == GameMode.dailyChallenge ? 300 : 150));
//     int movePenaltyOrBonus = max(10, 50 - (moves * 2)); 
//     calculatedIQ = baseIQ + movePenaltyOrBonus;

//     if (widget.activePet == 1 && calculatedIQ > 0) calculatedIQ = (calculatedIQ * 1.1).toInt();
//     if (goldenCollected && !widget.isPracticeMode) calculatedIQ += 100;
//     if (widget.isFeverActive) calculatedIQ = calculatedIQ * 3;

//     String winTitle = widget.mode == GameMode.battle ? 'YOU WON THE ${widget.betAmount * 2} IQ POT! 🏆' : (widget.isFeverActive ? '🔥 FEVER CLEARED! 3X IQ' : 'VICTORY! ⚡');

//     Future.delayed(const Duration(milliseconds: 600), () {
//       showDialog(
//         context: context, barrierDismissible: false,
//         builder: (_) => AlertDialog(
//           backgroundColor: const Color(0xFF1E1E2E),
//           title: Text(winTitle, style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold), textAlign: TextAlign.center),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Level: ${widget.levelIndex + 1} | Moves: $moves | Time left: ${timeLeft}s', style: const TextStyle(color: Colors.white70)),
//               if (widget.activePet == 1) const Text('🐲 Dragon Bonus: +10% IQ', style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
//               if (goldenCollected) const Text('🎁 Golden Airdrop: +100 IQ!', style: TextStyle(color: Color(0xFFF9A826), fontWeight: FontWeight.bold)),
//               const SizedBox(height: 15),
//               Text('+$calculatedIQ IQ', style: const TextStyle(color: Color(0xFF00E676), fontSize: 32, fontWeight: FontWeight.bold)),
//             ],
//           ),
//           actionsAlignment: MainAxisAlignment.spaceAround,
//           actions: [
//             TextButton(
//               onPressed: () { SoundManager.playClick(); Navigator.pop(context); Navigator.pop(context, {'iq': calculatedIQ, 'freezeUsed': freezeUsed, 'rowUsed': rowUsed, 'isFast': moves < 15}); }, 
//               child: const Text('Normal (1x)', style: TextStyle(color: Colors.white54))
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)), 
//               onPressed: () async {
//                 SoundManager.playClick();
//                 showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(backgroundColor: Colors.transparent, elevation: 0, content: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: Color(0xFF00E676)), SizedBox(height: 10), Text('Processing Bonus (2s)...', style: TextStyle(color: Colors.white))])));
//                 await Future.delayed(const Duration(seconds: 2));
//                 if (!context.mounted) return;
//                 Navigator.pop(context); Navigator.pop(context);
//                 Navigator.pop(context, {'iq': calculatedIQ * 2, 'freezeUsed': freezeUsed, 'rowUsed': rowUsed, 'isFast': moves < 15});
//               }, 
//               child: const Text('Collect 2x ⭐', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             if (widget.mode == GameMode.battle) Padding(padding: const EdgeInsets.all(15.0), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//               Row(children: [widget.playerImageBytes != null ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.memory(widget.playerImageBytes!, width: 30, height: 30, fit: BoxFit.cover)) : Text(widget.playerAvatar, style: const TextStyle(fontSize: 20)), const SizedBox(width: 8), const Text('You', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]), 
//               const Text('vs', style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic)), 
//               Row(children: [Text(widget.opponentAvatar, style: const TextStyle(fontSize: 20)), const SizedBox(width: 5), Text(widget.opponentName, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18))])
//             ]), const SizedBox(height: 5), LinearProgressIndicator(value: opponentProgress, color: Colors.redAccent, minHeight: 10)])),
//             if (widget.mode == GameMode.royale) Container(width: double.infinity, padding: const EdgeInsets.all(8), color: Colors.purpleAccent.withOpacity(0.1), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('💀 Alive: $playersAlive/100', style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16)), Text(currentKillfeed, style: const TextStyle(color: Colors.white70, fontSize: 12))])),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () { SoundManager.playClick(); Navigator.pop(context); }),
//                   Column(
//                     children: [
//                       Text(widget.mode == GameMode.dailyChallenge ? 'DAILY CHALLENGE 🌟' : 'LEVEL ${widget.levelIndex + 1}', style: const TextStyle(fontSize: 14, color: Colors.amber, fontWeight: FontWeight.bold)), 
//                       Text(isFrozen ? '❄️ FROZEN' : 'TIME: ${timeLeft}s | Moves: $moves', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isFrozen ? Colors.lightBlue : (timeLeft <= 7 ? Colors.redAccent : Colors.greenAccent))),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Stack(alignment: Alignment.topRight, children: [IconButton(icon: const Icon(Icons.ac_unit, color: Colors.lightBlue, size: 26), onPressed: _useTimeFreeze), if ((widget.invTimeFreeze - freezeUsed) > 0) CircleAvatar(radius: 7, backgroundColor: Colors.red, child: Text('${widget.invTimeFreeze - freezeUsed}', style: const TextStyle(fontSize: 9, color: Colors.white)))]),
//                       Stack(alignment: Alignment.topRight, children: [IconButton(icon: const Icon(Icons.auto_fix_high, color: Colors.purpleAccent, size: 26), onPressed: _useAutoRow), if ((widget.invAutoRow - rowUsed) > 0) CircleAvatar(radius: 7, backgroundColor: Colors.red, child: Text('${widget.invAutoRow - rowUsed}', style: const TextStyle(fontSize: 9, color: Colors.white)))]),
//                       IconButton(icon: const Icon(Icons.lightbulb, color: Color(0xFFF9A826), size: 28), onPressed: _watchAdForHint),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
            
//             Expanded(
//               child: Center(
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: widget.tileStyle == TileStyle.wooden ? const Color(0xFF3E2723) : const Color(0xFF1A1C29), 
//                     borderRadius: BorderRadius.circular(24), 
//                     border: widget.tileStyle == TileStyle.neon ? Border.all(color: Colors.cyan, width: 2) : null,
//                     boxShadow: [BoxShadow(color: widget.themeColor.withOpacity(0.2), blurRadius: 30)]
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: List.generate(grid.length, (rowIdx) {
//                       return Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: List.generate(grid[rowIdx].length, (colIdx) {
//                           final tile = grid[rowIdx][colIdx];
//                           final isEmpty = tile.type == 'empty';
//                           const double tileSize = 60; 

//                           return GestureDetector(
//                             onTap: () => rotateTile(rowIdx, colIdx),
//                             child: Container(
//                               width: tileSize, height: tileSize, margin: const EdgeInsets.all(4),
//                               decoration: BoxDecoration(
//                                 color: isEmpty ? Colors.transparent : (widget.tileStyle == TileStyle.wooden ? const Color(0xFF4E342E) : (widget.tileStyle == TileStyle.neon ? const Color(0xFF001E1D) : const Color(0xFF25253D))), 
//                                 borderRadius: BorderRadius.circular(16)
//                               ),
//                               alignment: Alignment.center,
//                               child: isEmpty ? null : AnimatedRotation(turns: tile.rotation * 0.25, duration: const Duration(milliseconds: 200), child: CustomPathWidget(tile: tile, isSolved: isSolved, size: tileSize, themeColor: widget.themeColor, tileStyle: widget.tileStyle)),
//                             ),
//                           );
//                         }),
//                       );
//                     }),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomPathWidget extends StatelessWidget {
//   final TileModel tile; final bool isSolved; final double size; final Color themeColor; final TileStyle tileStyle;
//   const CustomPathWidget({super.key, required this.tile, required this.isSolved, required this.size, required this.themeColor, required this.tileStyle});

//   @override Widget build(BuildContext context) {
//     final Color pathColor = tile.isGolden ? const Color(0xFFF9A826) : (isSolved ? (tileStyle == TileStyle.neon ? Colors.cyanAccent : themeColor) : (tileStyle == TileStyle.wooden ? const Color(0xFF8D6E63) : const Color(0xFF4A4A6A)));
//     final double thickness = size * 0.25;
//     return Stack(alignment: Alignment.center, children: [
//       if (tile.isGolden) Icon(Icons.star, color: Colors.yellow.withOpacity(0.3), size: size * 0.8),
//       if (tile.type == 'S') Container(width: size * 0.5, height: size * 0.5, decoration: BoxDecoration(color: pathColor, shape: BoxShape.circle)),
//       if (tile.type == 'E') Container(width: size * 0.4, height: size * 0.4, decoration: BoxDecoration(border: Border.all(color: pathColor, width: 4), shape: BoxShape.circle)),
//       if (tile.type == 'I') Container(width: thickness, height: size, decoration: BoxDecoration(color: pathColor)),
//       if (tile.type == 'L') Stack(children: [Positioned(top: 0, left: (size - thickness) / 2, child: Container(width: thickness, height: size / 2 + (thickness / 2), decoration: BoxDecoration(color: pathColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(thickness/2))))), Positioned(top: (size - thickness) / 2, left: size / 2, child: Container(width: size / 2, height: thickness, decoration: BoxDecoration(color: pathColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(thickness/2)))))]),
//     ]);
//   }
// }


































import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:ui' as ui; 
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint("Firebase Login Error: $e");
  }
  runApp(const FlowFixApp());
}

enum GameMode { single, hardcore, battle, coop, royale, tournament, dailyChallenge }
enum IslandTheme { nature, winter, cyberpunk }
enum Faction { none, fire, ice, energy }
enum TileStyle { classic, neon, wooden, marble }

// ==========================================
// SOUND MANAGER
// ==========================================
class SoundManager {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgmPlayer = AudioPlayer();
  static Timer? _bgmTimer;
  static bool isMuted = false;
  static double bgmVolume = 0.1;
  static double sfxVolume = 1.0;
  static String currentBgmTrack = 'audio/Background Music (BGM) - Lobby.mp3';

  static Future<void> loadAudioSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isMuted = prefs.getBool('is_muted') ?? false;
    bgmVolume = prefs.getDouble('bgm_volume') ?? 0.1;
    sfxVolume = prefs.getDouble('sfx_volume') ?? 1.0;
    currentBgmTrack = prefs.getString('bgm_track') ?? 'audio/Background Music (BGM) - Lobby.mp3';
  }

  static Future<void> toggleMute() async {
    isMuted = !isMuted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_muted', isMuted);
    if (isMuted) {
      stopBackgroundMusic();
      try { await _sfxPlayer.stop(); } catch (_) {}
    }
  }

  static Future<void> setBgmVolume(double vol) async {
    bgmVolume = vol;
    await _bgmPlayer.setVolume(bgmVolume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('bgm_volume', bgmVolume);
  }

  static Future<void> setSfxVolume(double vol) async {
    sfxVolume = vol;
    await _sfxPlayer.setVolume(sfxVolume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sfx_volume', sfxVolume);
  }

  static Future<void> setBgmTrack(String trackPath) async {
    currentBgmTrack = trackPath;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bgm_track', currentBgmTrack);
  }

  static void playClick() async {
    if (isMuted) return;
    try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/button_click.ogg')); } catch (_) {}
  }

  static void playTileSound() async {
    if (isMuted) return;
    try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/tile_sound.ogg')); } catch (_) {}
  }

  static void playBonusSound() async {
    if (isMuted) return;
    try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/bonus.ogg')); } catch (_) {}
  }

  static void playSuccessConnection() async {
    if (isMuted) return;
    try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/Success-Connection.ogg')); } catch (_) {}
  }

  static void playLootBoxSound() async {
    if (isMuted) return;
    try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/loot-box-open-.ogg')); } catch (_) {}
  }

  static void playTimeWarning() async {
    if (isMuted) return;
    try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/Time-Warning.ogg')); } catch (_) {}
  }

  static void playWin() async {
    if (isMuted) return;
    try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/win.ogg')); } catch (_) {}
  }

  static void playLoss() async {
    if (isMuted) return;
    try { await _sfxPlayer.setVolume(sfxVolume); await _sfxPlayer.stop(); await _sfxPlayer.play(AssetSource('audio/lose.ogg')); } catch (_) {}
  }

  static void playTimedLobbyBGM() async {
    if (isMuted) return;
    try {
      _bgmTimer?.cancel();
      await _bgmPlayer.setReleaseMode(ReleaseMode.stop);
      await _bgmPlayer.play(AssetSource(currentBgmTrack));
      await _bgmPlayer.setVolume(bgmVolume); 
      _bgmTimer = Timer(const Duration(seconds: 10), () { stopBackgroundMusic(); });
    } catch (_) {}
  }

  static void playTimedGameplayBGM() async {
    if (isMuted) return;
    try {
      _bgmTimer?.cancel();
      await _bgmPlayer.setReleaseMode(ReleaseMode.stop);
      await _bgmPlayer.play(AssetSource('audio/Background Music (BGM).mp3'));
      await _bgmPlayer.setVolume(bgmVolume); 
      _bgmTimer = Timer(const Duration(seconds: 10), () { stopBackgroundMusic(); });
    } catch (_) {}
  }

  static void stopBackgroundMusic() async {
    try { _bgmTimer?.cancel(); await _bgmPlayer.stop(); } catch (_) {}
  }
}

class FlowFixApp extends StatelessWidget {
  const FlowFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mindora: Puzzle Quest',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0C10), 
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF12141D),
          selectedItemColor: Color(0xFF00E676),
          unselectedItemColor: Colors.white54,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ==========================================
// SPLASH SCREEN
// ==========================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLobby();
  }

  _navigateToLobby() async {
    await SoundManager.loadAudioSettings();
    await Future.delayed(const Duration(seconds: 3)); 
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainLobbyScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C10),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1C29),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00E676), width: 3),
                boxShadow: [BoxShadow(color: const Color(0xFF00E676).withOpacity(0.4), blurRadius: 30, spreadRadius: 10)],
              ),
              child: const Icon(Icons.hub, size: 80, color: Color(0xFF00E676)),
            ),
            const SizedBox(height: 25),
            const Text('MINDORA: PUZZLE QUEST', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 3, color: Colors.white)),
            const SizedBox(height: 10),
            const Text('Connect & Solve', style: TextStyle(fontSize: 14, color: Colors.white54, letterSpacing: 1.5)),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Color(0xFF00E676)),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// MAIN LOBBY SCREEN
// ==========================================
class MainLobbyScreen extends StatefulWidget {
  const MainLobbyScreen({super.key});
  @override State<MainLobbyScreen> createState() => _MainLobbyScreenState();
}

class _MainLobbyScreenState extends State<MainLobbyScreen> {
  int _currentTabIndex = 0; 
  int completedZones = 0; int selectedZoneToPlay = 0; int totalIQ = 0;
  IslandTheme currentTheme = IslandTheme.nature;
  TileStyle currentTileStyle = TileStyle.classic;
  Faction playerFaction = Faction.none;
  String clanName = ''; 
  int activePet = 0; 
  String playerName = 'Player'; 
  String playerAvatar = '🦸‍♂️'; 
  String playerImagePath = ''; 
  Uint8List? playerImageBytes; 
  
  String playerCountry = 'US';
  String playerFlag = '🇺🇸';
  
  int loginStreak = 1; int invTimeFreeze = 2; int invAutoRow = 1;
  bool isFeverActive = false; int fastWinsInRow = 0; 
  
  int assetSilver = 0; int assetGold = 0; int assetCars = 0; int assetHouses = 0;
  bool isLoading = true;

  int totalPuzzlesSolved = 0;
  int consecutiveWins = 0;

  final List<String> avatars = ['🦸‍♂️', '🥷', '🧙‍♂️', '🤖', '🧛', '👽', '🧟', '🕵️'];
  final List<String> mockNames = ["Ninja_X", "ProSniper", "LudoKing", "Shadow", "Alpha_01", "GamerGirl", "Zero", "Ghost"];

  int get netWorth => totalIQ + (assetSilver * 1000) + (assetGold * 5000) + (assetCars * 20000) + (assetHouses * 100000) + (totalPuzzlesSolved * 50);

  @override void initState() { 
    super.initState(); 
    _getDeviceCountry();
    _loadProgress(); 
    SoundManager.playTimedLobbyBGM(); 
  }



// ==========================================
  // ACHIEVEMENTS & BADGES DIALOG
  // ==========================================
  void _showAchievementsDialog() {
    SoundManager.playClick();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text('Achievements & Badges 🏆', style: TextStyle(color: Color(0xFFF9A826))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _achievementTile('🧠 Master Solver', 'Solve 10 Puzzles', totalPuzzlesSolved >= 10),
            _achievementTile('🔥 Winning Streak', 'Win 3 Matches in Row', consecutiveWins >= 3),
            _achievementTile('💰 Wealthy Mind', 'Reach 5,000 Net Worth', netWorth >= 5000),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF9A826)),
            onPressed: () { SoundManager.playClick(); Navigator.pop(context); },
            child: const Text('Awesome', style: TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }

  Widget _achievementTile(String title, String desc, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), 
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isUnlocked ? const Color(0xFF00E676).withOpacity(0.15) : const Color(0xFF2A2A35), 
        borderRadius: BorderRadius.circular(12), 
        border: Border.all(color: isUnlocked ? const Color(0xFF00E676) : Colors.transparent)
      ),
      child: Row(
        children: [
          Icon(isUnlocked ? Icons.verified : Icons.lock, color: isUnlocked ? const Color(0xFF00E676) : Colors.grey, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(title, style: TextStyle(color: isUnlocked ? Colors.white : Colors.white54, fontWeight: FontWeight.bold)),
              Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
  void _getDeviceCountry() {
    try {
      final locale = ui.PlatformDispatcher.instance.locale;
      playerCountry = locale.countryCode ?? 'US'; 
      int flagOffset = 0x1F1E6; int asciiOffset = 0x41;
      String country = playerCountry.toUpperCase();
      int firstChar = country.codeUnitAt(0) - asciiOffset + flagOffset;
      int secondChar = country.codeUnitAt(1) - asciiOffset + flagOffset;
      playerFlag = String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
    } catch (_) {
      playerCountry = 'US'; playerFlag = '🇺🇸';
    }
  }

  Future<void> _loadProgress() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      final prefs = await SharedPreferences.getInstance();

      if (user != null) {
        var doc = await FirebaseFirestore.instance.collection('players').doc(user.uid).get();
        if (doc.exists) {
          var data = doc.data()!;
          setState(() {
            playerName = data['name'] ?? 'Player';
            playerAvatar = data['avatar'] ?? '🦸‍♂️';
            playerImagePath = data['image_path'] ?? '';
            clanName = data['clan'] ?? '';
            totalIQ = data['net_worth'] ?? 0;
            completedZones = data['completed_zones'] ?? 0;
            selectedZoneToPlay = completedZones;
          });
        }
      } else {
        setState(() {
          completedZones = prefs.getInt('saved_zone') ?? 0;
          selectedZoneToPlay = completedZones; 
          totalIQ = prefs.getInt('total_iq') ?? 0;
        });
      }

      String lastLoginStr = prefs.getString('last_login') ?? '';
      DateTime now = DateTime.now();
      int currentStreak = prefs.getInt('login_streak') ?? 1;
      
      if (lastLoginStr.isNotEmpty) {
        DateTime lastLogin = DateTime.parse(lastLoginStr);
        if (now.difference(lastLogin).inDays == 1) currentStreak++; 
        else if (now.difference(lastLogin).inDays > 1) currentStreak = 1; 
        
        int hoursAway = now.difference(lastLogin).inHours;
        int tempCars = prefs.getInt('asset_cars') ?? 0;
        int tempHouses = prefs.getInt('asset_houses') ?? 0;
        if (hoursAway > 0 && (tempCars > 0 || tempHouses > 0)) {
          int generatedIQ = (hoursAway * tempCars * 50) + (hoursAway * tempHouses * 500);
          if (generatedIQ > 0 && user == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _showIdleRewardDialog(generatedIQ));
            totalIQ += generatedIQ;
          }
        }
      }
      await prefs.setString('last_login', now.toIso8601String());
      await prefs.setInt('login_streak', currentStreak);

      setState(() {
        int themeIdx = prefs.getInt('theme') ?? 0;
        currentTheme = (themeIdx >= 0 && themeIdx < IslandTheme.values.length) ? IslandTheme.values[themeIdx] : IslandTheme.nature;
        int tileStyleIdx = prefs.getInt('tile_style') ?? 0;
        currentTileStyle = (tileStyleIdx >= 0 && tileStyleIdx < TileStyle.values.length) ? TileStyle.values[tileStyleIdx] : TileStyle.classic;
        int factionIdx = prefs.getInt('faction') ?? 0;
        playerFaction = (factionIdx >= 0 && factionIdx < Faction.values.length) ? Faction.values[factionIdx] : Faction.none;
        activePet = prefs.getInt('active_pet') ?? 0;
        loginStreak = currentStreak;
        invTimeFreeze = prefs.getInt('inv_freeze') ?? 2;
        invAutoRow = prefs.getInt('inv_autorow') ?? 1;
        fastWinsInRow = prefs.getInt('fast_wins') ?? 0;
        isFeverActive = fastWinsInRow >= 3; 
        assetSilver = prefs.getInt('asset_silver') ?? 0;
        assetGold = prefs.getInt('asset_gold') ?? 0;
        assetCars = prefs.getInt('asset_cars') ?? 0;
        assetHouses = prefs.getInt('asset_houses') ?? 0;
        totalPuzzlesSolved = prefs.getInt('total_solved') ?? 0;
        consecutiveWins = prefs.getInt('consecutive_wins') ?? 0;
        isLoading = false;
      });

      _syncDataToFirebase();
      if (playerFaction == Faction.none && !isLoading) WidgetsBinding.instance.addPostFrameCallback((_) => _showFactionSelectionDialog());
    } catch (_) { setState(() => isLoading = false); }
  }

  Future<void> _syncDataToFirebase() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('players').doc(user.uid).set({
        'name': playerName,
        'avatar': playerAvatar,
        'image_path': playerImagePath,
        'clan': clanName,
        'net_worth': netWorth,
        'completed_zones': completedZones,
        'total_solved': totalPuzzlesSolved,
        'asset_silver': assetSilver,
        'asset_gold': assetGold,
        'asset_cars': assetCars,
        'asset_houses': assetHouses,
        'faction': playerFaction.name,
        'country': playerCountry, 
        'flag': playerFlag,       
        'last_active': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> _saveAssets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('asset_silver', assetSilver); 
    await prefs.setInt('asset_gold', assetGold); 
    await prefs.setInt('asset_cars', assetCars); 
    await prefs.setInt('asset_houses', assetHouses);
    _syncDataToFirebase();
  }

  void _showIdleRewardDialog(int amount) {
    SoundManager.playBonusSound();
    showDialog(context: context, builder: (_) => AlertDialog(backgroundColor: const Color(0xFF1E1E2E), title: const Text('Offline Income 💰', style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)), content: Text('While you were away, your Cars and Houses generated\n+$amount IQ!', style: const TextStyle(color: Colors.white70)), actions: [ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)), onPressed: () { SoundManager.playClick(); Navigator.pop(context); }, child: const Text('Collect', style: TextStyle(color: Colors.black)))]));
  }

  void _showFactionSelectionDialog() {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (_) => AlertDialog(backgroundColor: const Color(0xFF1A1C29), title: const Text('Join a Faction 🌍', style: TextStyle(color: Colors.white)), content: Column(mainAxisSize: MainAxisSize.min, children: [
        _factionCard(Faction.fire, 'FIRE', Icons.local_fire_department, Colors.redAccent), _factionCard(Faction.ice, 'ICE', Icons.ac_unit, Colors.lightBlue), _factionCard(Faction.energy, 'ENERGY', Icons.bolt, Colors.yellowAccent),
      ])),
    );
  }

  Widget _factionCard(Faction faction, String name, IconData icon, Color color) {
    return GestureDetector(onTap: () async { SoundManager.playClick(); final prefs = await SharedPreferences.getInstance(); await prefs.setInt('faction', faction.index); setState(() => playerFaction = faction); Navigator.pop(context); _syncDataToFirebase(); HapticFeedback.heavyImpact(); }, child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: color, width: 2)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: color, size: 28), const SizedBox(width: 10), Text('JOIN $name', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18))])));
  }

  Future<void> _saveProgress(int zone, int addedIQ, bool wasFastWin) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (zone > completedZones) { completedZones = zone; selectedZoneToPlay = completedZones; }
      totalIQ += addedIQ; if (totalIQ < 0) totalIQ = 0; 
      if (addedIQ > 0 && wasFastWin) fastWinsInRow++; else if (addedIQ <= 0) fastWinsInRow = 0; 
      isFeverActive = fastWinsInRow >= 3;
      totalPuzzlesSolved++;
      consecutiveWins++;
    });
    await prefs.setInt('saved_zone', completedZones); 
    await prefs.setInt('total_iq', totalIQ); 
    await prefs.setInt('fast_wins', fastWinsInRow);
    await prefs.setInt('total_solved', totalPuzzlesSolved);
    await prefs.setInt('consecutive_wins', consecutiveWins);
    _syncDataToFirebase();
  }

  Future<void> _updateInventory(int freezeChange, int autoRowChange, int iqChange) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() { 
      invTimeFreeze += freezeChange; 
      invAutoRow += autoRowChange; 
      totalIQ += iqChange; 
      if(totalIQ < 0) totalIQ = 0; 
    });
    await prefs.setInt('inv_freeze', invTimeFreeze); 
    await prefs.setInt('inv_autorow', invAutoRow); 
    await prefs.setInt('total_iq', totalIQ);
    if(iqChange != 0) _syncDataToFirebase();
  }

  Future<void> _setTheme(IslandTheme theme) async { 
    SoundManager.playClick();
    final prefs = await SharedPreferences.getInstance(); 
    setState(() => currentTheme = theme); 
    await prefs.setInt('theme', theme.index); 
  }

  Future<void> _setTileStyle(TileStyle style) async {
    SoundManager.playClick();
    final prefs = await SharedPreferences.getInstance();
    setState(() => currentTileStyle = style);
    await prefs.setInt('tile_style', style.index);
  }

  String getRankName() { if (totalIQ < 500) return 'Bronze'; if (totalIQ < 1500) return 'Silver'; if (totalIQ < 3000) return 'Gold'; if (totalIQ < 6000) return 'Diamond'; return 'Heroic'; }
  Color getRankColor() { if (totalIQ < 500) return const Color(0xFFCD7F32); if (totalIQ < 1500) return const Color(0xFFC0C0C0); if (totalIQ < 3000) return const Color(0xFFFFD700); if (totalIQ < 6000) return const Color(0xFF00E5FF); return const Color(0xFFFF1744); }
  Color getThemeColor() { if (currentTheme == IslandTheme.winter) return const Color(0xFF80DEEA); if (currentTheme == IslandTheme.cyberpunk) return const Color(0xFFD500F9); return const Color(0xFF00E676); }
  
  Widget getThemeIcons(int progress) {
    if (currentTheme == IslandTheme.winter) return Row(children: [Icon(Icons.ac_unit, color: Colors.white, size: progress >= 1 ? 50 : 0), const SizedBox(width: 20), Icon(Icons.holiday_village, color: progress >= 2 ? Colors.white : Colors.transparent, size: 80)]);
    if (currentTheme == IslandTheme.cyberpunk) return Row(children: [Icon(Icons.memory, color: const Color(0xFF00E5FF), size: progress >= 1 ? 50 : 0), const SizedBox(width: 20), Icon(Icons.precision_manufacturing, color: progress >= 2 ? const Color(0xFFD500F9) : Colors.transparent, size: 80)]);
    return Row(children: [Icon(Icons.water_drop, color: const Color(0xFF4FC3F7), size: progress >= 1 ? 50 : 0), const SizedBox(width: 20), Icon(Icons.home_work, color: progress >= 2 ? const Color(0xFFF9A826) : Colors.transparent, size: 80)]);
  }

  void _watchAdForReward() async {
    SoundManager.playClick();
    showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(backgroundColor: Colors.transparent, elevation: 0, content: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: Color(0xFF00E676)), SizedBox(height: 10), Text('Loading Video Ad...', style: TextStyle(color: Colors.white))])));
    await Future.delayed(const Duration(seconds: 2));
    if(!mounted) return; Navigator.pop(context); _updateInventory(0, 0, 50); SoundManager.playBonusSound(); HapticFeedback.vibrate(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reward: +50 IQ Added!'), backgroundColor: Colors.green));
  }

  void _openLootBox() {
    SoundManager.playClick();
    if (totalIQ < 300) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough IQ!'))); return; }
    _updateInventory(0, 0, -300); HapticFeedback.heavyImpact();
    SoundManager.playLootBoxSound();
    showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(backgroundColor: Colors.transparent, elevation: 0, content: TweenAnimationBuilder(tween: Tween<double>(begin: 0, end: 1), duration: const Duration(seconds: 2), builder: (context, val, child) { return Transform.scale(scale: val, child: const Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.card_giftcard, size: 100, color: Color(0xFFF9A826)), SizedBox(height: 20), Text('Opening...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))])); })));

    Future.delayed(const Duration(seconds: 2), () {
      if(!mounted) return; Navigator.pop(context); 
      int chance = Random().nextInt(100); String rewardText = '';
      if (chance < 40) { _updateInventory(2, 0, 0); rewardText = '🎁 2x Time Freeze!'; }
      else if (chance < 70) { _updateInventory(0, 1, 0); rewardText = '🎁 1x Auto-Row!'; }
      else if (chance < 90) { _updateInventory(0, 0, 500); rewardText = '🎁 +500 IQ Points!'; }
      else { _updateInventory(5, 2, 0); rewardText = '💎 JACKPOT! 5 Freeze, 2 Magic!'; }
      SoundManager.playBonusSound();
      HapticFeedback.vibrate();
      showDialog(context: context, builder: (_) => AlertDialog(backgroundColor: const Color(0xFF1A1C29), title: const Text('Reward ✨', style: TextStyle(color: Color(0xFF00E676))), content: Text(rewardText, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), actions: [ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF9A826)), onPressed: () { SoundManager.playClick(); Navigator.pop(context); }, child: const Text('Collect', style: TextStyle(color: Colors.black)))]));
    });
  }

  void _showAudioSettingsDialog() {
    SoundManager.playClick();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          title: const Text('Sound & Audio Settings 🎵', style: TextStyle(color: Color(0xFF00E676))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('BGM Volume', style: TextStyle(color: Colors.white70)),
              Slider(
                value: SoundManager.bgmVolume, min: 0.0, max: 1.0, divisions: 10, activeColor: const Color(0xFF00E676),
                onChanged: (val) async { await SoundManager.setBgmVolume(val); setDialogState(() {}); },
              ),
              const Text('SFX Volume', style: TextStyle(color: Colors.white70)),
              Slider(
                value: SoundManager.sfxVolume, min: 0.0, max: 1.0, divisions: 10, activeColor: const Color(0xFF00E5FF),
                onChanged: (val) async { await SoundManager.setSfxVolume(val); setDialogState(() {}); },
              ),
            ],
          ),
          actions: [
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)), onPressed: () { SoundManager.playClick(); Navigator.pop(context); }, child: const Text('Close', style: TextStyle(color: Colors.black)))
          ],
        ),
      ),
    );
  }

  // ==========================================
  // NEW FEATURE 1: TROPHY ROOM (অ্যাচিভমেন্ট ও ট্রফি রুম)
  // ==========================================
  void _showTrophyRoomDialog() {
    SoundManager.playClick();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text('🏆 Trophy Room & Showcases', style: TextStyle(color: Color(0xFFF9A826), fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _trophyTile('🥇 Gold Master Trophy', 'Completed 10+ Puzzles without hints', totalPuzzlesSolved >= 5),
              _trophyTile('⚡ Lightning Reflexes', 'Achieved 3x Fever Win Streak', isFeverActive),
              _trophyTile('👑 High Roller Trophy', 'Reached Net Worth over 5,000 IQ', netWorth >= 5000),
              _trophyTile('🛡️ Clan Champion', 'Active member of a verified clan', clanName.isNotEmpty),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF9A826)),
            onPressed: () { SoundManager.playClick(); Navigator.pop(context); },
            child: const Text('Close', style: TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }

  Widget _trophyTile(String title, String desc, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked ? const Color(0xFFF9A826).withOpacity(0.15) : const Color(0xFF2A2A35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isUnlocked ? const Color(0xFFF9A826) : Colors.transparent),
      ),
      child: Row(
        children: [
          Icon(isUnlocked ? Icons.emoji_events : Icons.lock_outline, color: isUnlocked ? const Color(0xFFF9A826) : Colors.grey, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: isUnlocked ? Colors.white : Colors.white54, fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // NEW FEATURE 2: CLAN / GUILD SYSTEM (গিল্ড বা ক্ল্যান সিস্টেম)
  // ==========================================
  void _showClanDialog() {
    SoundManager.playClick();
    final clanController = TextEditingController(text: clanName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text('🛡️ Guild & Clan Headquarters', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Create or join a Clan to chat, team up, and compete in tournaments!', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 15),
            TextField(
              controller: clanController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Clan / Guild Tag Name', labelStyle: TextStyle(color: Colors.white54)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF)),
              icon: const Icon(Icons.chat, color: Colors.black),
              label: const Text('Open Clan Chat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pop(context);
                _showClanChatSheet();
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
            onPressed: () async {
              SoundManager.playClick();
              setState(() => clanName = clanController.text.trim());
              await _syncDataToFirebase();
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Clan updated successfully! 🛡️'), backgroundColor: Colors.green));
            },
            child: const Text('Save Clan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void _showClanChatSheet() {
    final msgController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text('💬 Clan Chat (${clanName.isEmpty ? "No Clan" : clanName})', style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Expanded(
                child: clanName.isEmpty
                    ? const Center(child: Text('Please join or create a clan first to chat!', style: TextStyle(color: Colors.white54)))
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('clans').doc(clanName).collection('messages').orderBy('timestamp', descending: true).limit(50).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)));
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('No messages yet. Say hello to your guild!', style: TextStyle(color: Colors.white54)));
                          }
                          final docs = snapshot.data!.docs;
                          return ListView.builder(
                            reverse: true,
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              var data = docs[index].data() as Map<String, dynamic>;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['sender'] ?? 'Member', style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 12)),
                                    const SizedBox(height: 2),
                                    Text(data['message'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 14)),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(hintText: 'Type guild message...', hintStyle: TextStyle(color: Colors.white54)),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF00E5FF)),
                    onPressed: () async {
                      if (msgController.text.trim().isEmpty || clanName.isEmpty) return;
                      String msg = msgController.text.trim();
                      msgController.clear();
                      await FirebaseFirestore.instance.collection('clans').doc(clanName).collection('messages').add({
                        'sender': playerName,
                        'message': msg,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // NEW FEATURE 3: DAILY MISSIONS & BATTLE PASS (ডেইলি মিশন ও ব্যাটল পাস)
  // ==========================================
  void _showBattlePassDialog() {
    SoundManager.playClick();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text('🎯 Daily Quests & Battle Pass', style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Complete daily puzzle challenges to earn exclusive rewards!', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 15),
            _questTile('Solve 3 Puzzles Today', 'Progress: ${totalPuzzlesSolved % 3}/3', totalPuzzlesSolved >= 3),
            _questTile('Win 1 Multiplayer Battle', 'Progress: $consecutiveWins/1', consecutiveWins >= 1),
            _questTile('Open a Loot Box', 'Progress: Reward Unlocked', true),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
            onPressed: () {
              SoundManager.playClick();
              Navigator.pop(context);
              _updateInventory(1, 1, 200);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Claimed Battle Pass Rewards: +200 IQ & Bonuses! 🎁'), backgroundColor: Colors.green));
            },
            child: const Text('Claim Reward', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _questTile(String task, String progress, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(progress, style: const TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
          Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: isCompleted ? Color(0xFF00E676) : Colors.grey),
        ],
      ),
    );
  }

  // Account Deletion Feature for Authenticated Users (Google Play Compliance)
  void _showDeleteAccountConfirmationDialog() {
    SoundManager.playClick();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text('Delete Account ⚠️', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you sure you want to permanently delete your account and all associated cloud data? This action cannot be undone and your game progress will be wiped.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () { SoundManager.playClick(); Navigator.pop(context); },
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              SoundManager.playClick();
              Navigator.pop(context); 
              
              try {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  String uid = user.uid;
                  await FirebaseFirestore.instance.collection('players').doc(uid).delete();
                  try {
                    await FirebaseStorage.instance.ref().child('profile_images').child('$uid.jpg').delete();
                  } catch (_) {}
                  await user.delete();

                  setState(() {
                    totalIQ = 0;
                    completedZones = 0;
                    selectedZoneToPlay = 0;
                    playerName = 'Player';
                    playerAvatar = '🦸‍♂️';
                    playerImagePath = '';
                    playerImageBytes = null;
                  });

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account successfully deleted! 🗑️'), backgroundColor: Colors.red),
                  );
                }
              } catch (e) {
                if (!context.mounted) return;
                String errStr = e.toString();
                String msg = 'Failed to delete account. Please re-sign in and try again.';
                if (errStr.contains('requires-recent-login')) {
                  msg = 'Security check: Please sign out, sign back in, and then delete your account.';
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(msg), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Delete Permanently', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showEmailAuthDialog() {
    SoundManager.playClick();
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final usernameController = TextEditingController();
    bool isSignUp = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          title: Text(isSignUp ? 'Create Cloud Account ☁️' : 'Sign In to Cloud 🔐', style: const TextStyle(color: Color(0xFF00E5FF))),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Secure your progress across mobile devices with Email & Unique Username!', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 15),
                if (isSignUp) ...[
                  TextField(controller: usernameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Unique Username', labelStyle: TextStyle(color: Colors.white54))),
                  const SizedBox(height: 10),
                ],
                TextField(controller: emailController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Email Address', labelStyle: TextStyle(color: Colors.white54))),
                const SizedBox(height: 10),
                TextField(controller: passController, obscureText: true, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Password', labelStyle: TextStyle(color: Colors.white54))),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => setDialogState(() => isSignUp = !isSignUp),
                  child: Text(isSignUp ? 'Already have an account? Sign In' : 'Need an account? Register', style: const TextStyle(color: Color(0xFF00E676))),
                )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF)),
              onPressed: () async {
                SoundManager.playClick();
                String email = emailController.text.trim();
                String pass = passController.text.trim();
                String uName = usernameController.text.trim();
                if (email.isEmpty || pass.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields! ❌'), backgroundColor: Colors.red));
                  return;
                }
                if (isSignUp && uName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a username! ❌'), backgroundColor: Colors.red));
                  return;
                }

                try {
                  if (isSignUp) {
                    var query = await FirebaseFirestore.instance.collection('players').where('name', isEqualTo: uName).get();
                    if (query.docs.isNotEmpty) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This username is already taken. Please choose another! ❌'), backgroundColor: Colors.red));
                      return;
                    }

                    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
                    setState(() {
                      playerName = uName;
                      totalIQ = 0;
                      completedZones = 0;
                      selectedZoneToPlay = 0;
                    });
                    await _syncDataToFirebase();
                  } else {
                    UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
                    var doc = await FirebaseFirestore.instance.collection('players').doc(cred.user!.uid).get();
                    if (doc.exists) {
                      var data = doc.data()!;
                      setState(() {
                        playerName = data['name'] ?? 'Player';
                        playerAvatar = data['avatar'] ?? '🦸‍♂️';
                        playerImagePath = data['image_path'] ?? '';
                        clanName = data['clan'] ?? '';
                        totalIQ = data['net_worth'] ?? 0;
                        completedZones = data['completed_zones'] ?? 0;
                        selectedZoneToPlay = completedZones;
                      });
                    }
                  }
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully authenticated & synced! ✅'), backgroundColor: Colors.green));
                } catch (e) {
                  String friendlyMessage = 'Authentication failed. Please try again.';
                  String errStr = e.toString();
                  if (errStr.contains('email-already-in-use')) {
                    friendlyMessage = 'This email address is already registered. Please sign in instead.';
                  } else if (errStr.contains('invalid-email')) {
                    friendlyMessage = 'The email address format is invalid.';
                  } else if (errStr.contains('weak-password')) {
                    friendlyMessage = 'The password is too weak. Please use at least 6 characters.';
                  } else if (errStr.contains('user-not-found') || errStr.contains('wrong-password') || errStr.contains('invalid-credential')) {
                    friendlyMessage = 'Incorrect email or password. Please check your credentials.';
                  } else if (errStr.contains('network-request-failed')) {
                    friendlyMessage = 'Network error. Please check your internet connection.';
                  }

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyMessage), backgroundColor: Colors.red));
                }
              },
              child: Text(isSignUp ? 'Register' : 'Sign In', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  void _showFriendsDialog() {
    SoundManager.playClick();
    final friendUsernameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Friends & Direct Invites 👥', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: friendUsernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: "Enter Friend's Username", labelStyle: TextStyle(color: Colors.white54)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF)),
                    onPressed: () async {
                      SoundManager.playClick();
                      String fName = friendUsernameController.text.trim();
                      if (fName.isEmpty) return;

                      User? user = FirebaseAuth.instance.currentUser;
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please sign in to add friends! ❌'), backgroundColor: Colors.red));
                        return;
                      }

                      var query = await FirebaseFirestore.instance.collection('players').where('name', isEqualTo: fName).get();
                      if (query.docs.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Player not found! ❌'), backgroundColor: Colors.red));
                        return;
                      }

                      String friendUid = query.docs.first.id;
                      if (friendUid == user.uid) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You cannot add yourself! ❌'), backgroundColor: Colors.red));
                        return;
                      }

                      await FirebaseFirestore.instance.collection('players').doc(user.uid).collection('friends').doc(friendUid).set({
                        'friend_uid': friendUid,
                        'name': fName,
                        'added_at': FieldValue.serverTimestamp(),
                      });

                      friendUsernameController.clear();
                      setModalState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Friend added successfully! ✅'), backgroundColor: Colors.green));
                    },
                    child: const Text('Add', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Align(alignment: Alignment.centerLeft, child: Text('My Friends List:', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              Expanded(
                child: FirebaseAuth.instance.currentUser == null
                    ? const Center(child: Text('Please sign in to view your friends.', style: TextStyle(color: Colors.white54)))
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('players').doc(FirebaseAuth.instance.currentUser!.uid).collection('friends').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)));
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('No friends added yet.', style: TextStyle(color: Colors.white54)));
                          }
                          final docs = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              var data = docs[index].data() as Map<String, dynamic>;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      const Icon(Icons.person, color: Color(0xFF00E676)),
                                      const SizedBox(width: 10),
                                      Text(data['name'] ?? 'Friend', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ]),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
                                      onPressed: () async {
                                        String friendUid = data['friend_uid'];
                                        await FirebaseFirestore.instance.collection('notifications').add({
                                          'target_uid': friendUid,
                                          'title': '1v1 Battle Invite! ⚔️',
                                          'body': '$playerName has challenged you to a 1v1 duel!',
                                          'timestamp': FieldValue.serverTimestamp(),
                                        });

                                        Navigator.pop(context);
                                        _showBetSelectionDialog(GameMode.battle);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invite sent via Push Notification! 🚀'), backgroundColor: Colors.green));
                                      },
                                      child: const Text('Invite 1v1', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDailyLeaderboard() {
    SoundManager.playClick();
    User? currentUser = FirebaseAuth.instance.currentUser;

    showModalBottomSheet(
      context: context, 
      backgroundColor: const Color(0xFF1E1E2E), 
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.70,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Daily Challenge Top 100 Speedboard ⚡', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text('Ranked by best daily score (Resets daily)', style: TextStyle(color: Colors.white54, fontSize: 11)),
              const SizedBox(height: 15),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('daily_scores').orderBy('score_points', descending: true).limit(100).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)));
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No records today yet! Be the first.', style: TextStyle(color: Colors.white54)));
                    }
                    
                    final docs = snapshot.data!.docs;
                    int myRank = -1;
                    if (currentUser != null) {
                      for (int i = 0; i < docs.length; i++) {
                        var data = docs[i].data() as Map<String, dynamic>;
                        if (data['uid'] == currentUser.uid) {
                          myRank = i + 1;
                          break;
                        }
                      }
                    }

                    return Column(
                      children: [
                        if (currentUser != null) ...[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: const Color(0xFF00E5FF).withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF00E5FF))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(myRank != -1 ? 'Your Today\'s Rank: #$myRank 🏆' : 'You haven\'t played today\'s challenge yet! 🎮', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              var data = docs[index].data() as Map<String, dynamic>;
                              bool isMe = currentUser != null && data['uid'] == currentUser.uid;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: isMe ? const Color(0xFF00E5FF).withOpacity(0.2) : const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(12), border: isMe ? Border.all(color: const Color(0xFF00E5FF)) : null),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Text('#${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                                      const SizedBox(width: 12),
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text(data['name'] ?? 'Player', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        Text('Time: ${data['time_taken']}s | Hints: ${data['hints']} | Moves: ${data['moves']}', style: const TextStyle(color: Colors.white54, fontSize: 10)),
                                      ]),
                                    ]),
                                    Text('${data['score_points']} pts', style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLeaderboard() {
    SoundManager.playClick();
    showModalBottomSheet(
      context: context, backgroundColor: const Color(0xFF1E1E2E), isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.7, padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Global Rich List (Top 100) 🌍💰', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('players').orderBy('net_worth', descending: true).limit(100).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)));
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return ListView(children: [_buildRankRow(1, 'Elon_Mask', 2500000, false, '🇺🇸', 'US', '🦸‍♂️', '', {})]);
                  }
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var data = docs[index].data() as Map<String, dynamic>;
                      bool isMe = docs[index].id == FirebaseAuth.instance.currentUser?.uid;
                      return _buildRankRow(
                        index + 1, 
                        data['name'] ?? '', 
                        data['net_worth'] ?? 0, 
                        isMe, 
                        data['flag'] ?? '🌐', 
                        data['country'] ?? 'UN', 
                        data['avatar'] ?? '🦸‍♂️', 
                        data['image_path'] ?? '', 
                        data
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankRow(int rank, String name, int score, bool isMe, String flag, String country, String avatar, String imgPath, Map<String, dynamic> extraData) {
    int silver = extraData['asset_silver'] ?? 0;
    int gold = extraData['asset_gold'] ?? 0;
    int cars = extraData['asset_cars'] ?? 0;
    int houses = extraData['asset_houses'] ?? 0;
    int solved = extraData['total_solved'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: isMe ? const Color(0xFF00E5FF).withOpacity(0.2) : const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                SizedBox(width: 35, child: Text('#$rank', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber))),
                Text(flag), const SizedBox(width: 5), Text(avatar, style: const TextStyle(fontSize: 18)), const SizedBox(width: 8),
                Text(name, style: TextStyle(color: isMe ? const Color(0xFF00E5FF) : Colors.white, fontWeight: FontWeight.bold)),
              ]),
              Text('Net Worth: \$$score', style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 10,
            runSpacing: 4,
            children: [
              Text('🧩 Solved: $solved', style: const TextStyle(color: Colors.white54, fontSize: 10)),
              Text('🥈 Silver: $silver', style: const TextStyle(color: Colors.grey, fontSize: 10)),
              Text('🥇 Gold: $gold', style: const TextStyle(color: Colors.amber, fontSize: 10)),
              Text('🏎️ Cars: $cars', style: const TextStyle(color: Colors.redAccent, fontSize: 10)),
              Text('🏡 Villas: $houses', style: const TextStyle(color: Colors.purpleAccent, fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }

  void _showBetSelectionDialog(GameMode mode) {
    SoundManager.playClick();
    int selectedBet = 100;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          title: const Text('Select Bet Amount 💰', style: TextStyle(color: Color(0xFFF9A826))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your Balance: $totalIQ IQ', style: const TextStyle(color: Colors.white54)),
              const SizedBox(height: 20),
              Wrap(
                spacing: 15,
                children: [50, 100, 500, 1000].map((bet) => ChoiceChip(
                  label: Text('$bet IQ'), selected: selectedBet == bet, selectedColor: const Color(0xFFF9A826),
                  onSelected: (bool selected) { SoundManager.playClick(); setDialogState(() => selectedBet = bet); },
                )).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () { SoundManager.playClick(); Navigator.pop(context); }, child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF9A826)),
              onPressed: () {
                SoundManager.playClick();
                if (totalIQ < selectedBet) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough IQ for this bet! ❌', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
                  return;
                }
                Navigator.pop(context);
                _startAutoMatch(mode, betAmount: selectedBet);
              },
              child: const Text('Start Battle', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  void _startAutoMatch(GameMode mode, {int betAmount = 100}) async {
    if (mode == GameMode.battle) {
      if (totalIQ >= betAmount) {
        _updateInventory(0, 0, -betAmount);
      }
      String oppName = "Searching..."; String oppAvatar = '❓'; bool matchFound = false;

      showDialog(
        context: context, barrierDismissible: false,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) {
            Timer.periodic(const Duration(milliseconds: 100), (timer) {
              if (matchFound) { timer.cancel(); } 
              else { setDialogState(() { oppName = mockNames[Random().nextInt(mockNames.length)]; oppAvatar = avatars[Random().nextInt(avatars.length)]; }); }
            });
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E2E),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('MATCHMAKING (Bet: $betAmount IQ)', style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    Column(children: [Text(playerAvatar, style: const TextStyle(fontSize: 40)), const Text('YOU', style: TextStyle(color: Colors.white))]),
                    const Text('VS', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 24)),
                    Column(children: [Text(oppAvatar, style: const TextStyle(fontSize: 40)), Text(oppName, style: const TextStyle(color: Colors.white54))]),
                  ]),
                  const SizedBox(height: 20),
                  if (!matchFound) const CircularProgressIndicator(color: Color(0xFF00E676))
                  else const Text('MATCH FOUND!', style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
                ],
              ),
            );
          },
        ),
      );

      String uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest_${Random().nextInt(99999)}';
      String displayName = clanName.isNotEmpty ? '[$clanName] $playerName' : playerName;

      try {
        var snapshot = await FirebaseFirestore.instance.collection('rooms').where('mode', isEqualTo: 'battle').where('status', isEqualTo: 'waiting').limit(1).get();
        String roomId = ''; String finalOppName = ''; String finalOppAvatar = ''; bool host = false; int gameSeed = Random().nextInt(99999); 

        if (snapshot.docs.isNotEmpty) {
          var room = snapshot.docs.first; roomId = room.id; finalOppName = room['player1_name']; finalOppAvatar = room['player1_avatar'] ?? avatars[Random().nextInt(avatars.length)]; gameSeed = room['seed'];
          await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({'status': 'playing', 'player2': uid, 'player2_name': displayName, 'player2_avatar': playerAvatar, 'player2_progress': 0.0});
        } else {
          host = true;
          var newRoom = await FirebaseFirestore.instance.collection('rooms').add({'mode': 'battle', 'status': 'waiting', 'seed': gameSeed, 'player1': uid, 'player1_name': displayName, 'player1_avatar': playerAvatar, 'player1_progress': 0.0, 'player2': '', 'player2_name': '', 'player2_avatar': '', 'player2_progress': 0.0, 'created_at': FieldValue.serverTimestamp()});
          roomId = newRoom.id;
          bool playerJoined = false;
          for (int i = 0; i < 20; i++) {
            await Future.delayed(const Duration(seconds: 1));
            var check = await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();
            if (check.exists && check['status'] == 'playing') {
              finalOppName = check['player2_name']; finalOppAvatar = check['player2_avatar'] ?? avatars[Random().nextInt(avatars.length)]; playerJoined = true; break;
            }
          }
          if (!playerJoined) {
            await FirebaseFirestore.instance.collection('rooms').doc(roomId).delete();
            if (mounted) Navigator.pop(context); 
            _updateInventory(0, 0, betAmount);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No opponent found! Bet refunded.'), backgroundColor: Colors.red));
            return;
          }
        }

        matchFound = true; SoundManager.playSuccessConnection(); HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(seconds: 1)); 
        if (!mounted) return;
        Navigator.pop(context); 
        SoundManager.stopBackgroundMusic();

        final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => GameScreen(
          levelIndex: selectedZoneToPlay, mode: GameMode.battle, themeColor: getThemeColor(), tileStyle: currentTileStyle,
          isFeverActive: false, invTimeFreeze: invTimeFreeze, invAutoRow: invAutoRow, 
          opponentName: finalOppName, opponentAvatar: finalOppAvatar, isPracticeMode: false, activePet: activePet,
          roomId: roomId, isHost: host, gameSeed: gameSeed, playerImagePath: playerImagePath, playerAvatar: playerAvatar, playerImageBytes: playerImageBytes, betAmount: betAmount,
        )));

        SoundManager.playTimedLobbyBGM();
        if(result != null) {
          if(result['iq'] > 0) _updateInventory(0, 0, betAmount * 2);
          _updateInventory(result['freezeUsed'] * -1, result['rowUsed'] * -1, 0);
        }
      } catch (_) {
        Navigator.pop(context);
        _updateInventory(0, 0, betAmount);
      }
    } else {
      _startGame(mode);
    }
  }

  void _startGame(GameMode mode) async {
    if (mode == GameMode.dailyChallenge) {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please sign in or register to play Daily Challenge! 🔐'), backgroundColor: Colors.orange));
        _showEmailAuthDialog();
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      String lastPlayedDate = prefs.getString('last_daily_date') ?? '';
      String todayStr = DateTime.now().toIso8601String().substring(0, 10);
      if (lastPlayedDate == todayStr) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have already completed today\'s Daily Challenge! Come back tomorrow 🌟', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
        return;
      }
    }

    SoundManager.playClick();
    showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(backgroundColor: Colors.transparent, elevation: 0, content: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: Color(0xFF00E676)), SizedBox(height: 15), Text('ENTERING MATCH...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2))])));
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pop(context); 

    bool isPractice = mode == GameMode.single && selectedZoneToPlay < completedZones;
    int seed = mode == GameMode.dailyChallenge ? DateTime.now().day * 99 : Random().nextInt(99999);
    
    SoundManager.stopBackgroundMusic();

    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => GameScreen(
      levelIndex: mode==GameMode.tournament ? 15 : (mode == GameMode.dailyChallenge ? 4 : selectedZoneToPlay), 
      mode: mode, themeColor: getThemeColor(), tileStyle: currentTileStyle,
      isFeverActive: isPractice ? false : isFeverActive, invTimeFreeze: invTimeFreeze, invAutoRow: invAutoRow, 
      opponentName: mockNames[Random().nextInt(mockNames.length)], opponentAvatar: avatars[Random().nextInt(avatars.length)],
      isPracticeMode: isPractice, activePet: activePet,
      roomId: '', isHost: true, gameSeed: seed, playerImagePath: playerImagePath, playerAvatar: playerAvatar, playerImageBytes: playerImageBytes, betAmount: 0,
    )));

    SoundManager.playTimedLobbyBGM();

    if(result != null) {
      _updateInventory(result['freezeUsed'] * -1, result['rowUsed'] * -1, 0); 
      if (mode == GameMode.tournament) {
        if(result['iq'] > 0) _updateInventory(0, 0, 10000); 
      } else if (mode == GameMode.dailyChallenge && result['iq'] > 0) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('last_daily_date', DateTime.now().toIso8601String().substring(0, 10));
      } else if (!isPractice && (mode == GameMode.single || mode == GameMode.hardcore)) {
        if(result['iq'] < 0) {
          _updateInventory(0, 0, result['iq']); 
        } else if (result['iq'] > 0) {
          _saveProgress(selectedZoneToPlay + 1, result['iq'], result['isFast'] ?? false);
        }
      }
    }
  }

  void _showProfileDialog() {
    SoundManager.playClick();
    final nameController = TextEditingController(text: playerName);
    String tempAvatar = playerAvatar; String tempImagePath = playerImagePath; Uint8List? tempImageBytes = playerImageBytes;
    bool isChecking = false;
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    showDialog(
      context: context, barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E2E),
            title: const Text('Gamer Profile 🥷', style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      SoundManager.playClick();
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        var bytes = await pickedFile.readAsBytes();
                        setDialogState(() { tempImagePath = pickedFile.path; tempImageBytes = bytes; });
                      }
                    },
                    child: Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2A2A35), border: Border.all(color: const Color(0xFF00E676), width: 2)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: tempImageBytes != null ? Image.memory(tempImageBytes!, fit: BoxFit.cover) : (tempImagePath.isNotEmpty && !kIsWeb ? Image.file(File(tempImagePath), fit: BoxFit.cover) : Center(child: Text(tempAvatar, style: const TextStyle(fontSize: 40)))),
                            ),
                          ),
                          const CircleAvatar(radius: 14, backgroundColor: Color(0xFF00E676), child: Icon(Icons.camera_alt, size: 14, color: Colors.black))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text('Or Choose Emoji Avatar:', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10, runSpacing: 10,
                    children: avatars.map((a) => GestureDetector(
                      onTap: () { SoundManager.playClick(); setDialogState(() { tempAvatar = a; tempImagePath = ''; tempImageBytes = null; }); },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: (tempAvatar == a && tempImagePath.isEmpty && tempImageBytes == null) ? const Color(0xFF00E676).withOpacity(0.3) : const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(12), border: Border.all(color: (tempAvatar == a && tempImagePath.isEmpty && tempImageBytes == null) ? const Color(0xFF00E676) : Colors.transparent, width: 2)),
                        child: Text(a, style: const TextStyle(fontSize: 28)),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 20),
                  TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Username', labelStyle: TextStyle(color: Colors.white54))),
                  if (isChecking) const Padding(padding: EdgeInsets.only(top: 10), child: CircularProgressIndicator(color: Color(0xFF00E676))),
                  
                  if (isLoggedIn) ...[
                    const SizedBox(height: 25),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _showDeleteAccountConfirmationDialog();
                      },
                      icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                      label: const Text('Delete Account & Data', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () { SoundManager.playClick(); Navigator.pop(dialogContext); }, child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
                onPressed: isChecking ? null : () async {
                  SoundManager.playClick();
                  String newName = nameController.text.trim();
                  if (newName.isEmpty) return;
                  
                  setDialogState(() => isChecking = true);
                  try {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (tempImageBytes != null && user != null) {
                      Reference ref = FirebaseStorage.instance.ref().child('profile_images').child('${user.uid}.jpg');
                      UploadTask uploadTask = ref.putData(tempImageBytes!);
                      TaskSnapshot snapshot = await uploadTask;
                      tempImagePath = await snapshot.ref.getDownloadURL();
                    }

                    setState(() { 
                      playerName = newName; 
                      playerAvatar = tempAvatar; 
                      playerImagePath = tempImagePath; 
                      playerImageBytes = tempImageBytes; 
                    }); 
                    await _syncDataToFirebase();
                    if (context.mounted) Navigator.pop(dialogContext);
                  } catch (_) { setDialogState(() => isChecking = false); }
                },
                child: const Text('Save', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ],
          );
        }
      ),
    );
  }

  Widget _buildTopStatus() {
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(color: Color(0xFF12141D), border: Border(bottom: BorderSide(color: Colors.white10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _showProfileDialog, 
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF00E676), width: 1.5)),
                  child: playerImageBytes != null ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.memory(playerImageBytes!, width: 30, height: 30, fit: BoxFit.cover)) : (playerImagePath.isNotEmpty && playerImagePath.startsWith('http') ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(playerImagePath, width: 30, height: 30, fit: BoxFit.cover)) : Text(playerAvatar, style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('$playerFlag ${clanName.isNotEmpty ? '[$clanName] $playerName' : playerName} ${activePet == 1 ? '🐲' : (activePet == 2 ? '🐧' : '🧠')}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                    Text(getRankName(), style: TextStyle(color: getRankColor(), fontSize: 12)),
                  ]),
                ),
              ]),
            ),
          ),
          Row(children: [
            IconButton(
              icon: Icon(SoundManager.isMuted ? Icons.volume_off : Icons.volume_up, color: SoundManager.isMuted ? Colors.redAccent : const Color(0xFF00E676)),
              onPressed: () async { await SoundManager.toggleMute(); setState(() {}); },
            ),
            IconButton(icon: const Icon(Icons.settings_outlined, color: Colors.white70, size: 22), onPressed: _showAudioSettingsDialog),
            IconButton(icon: const Icon(Icons.emoji_events, color: Color(0xFFF9A826), size: 22), onPressed: _showAchievementsDialog),
            
            // Friends System Button
            IconButton(icon: const Icon(Icons.group_add, color: Color(0xFF00E5FF), size: 22), tooltip: 'Friends & Invites', onPressed: _showFriendsDialog),

            // Dynamic Sign In / Sign Out button
            IconButton(
              icon: Icon(isLoggedIn ? Icons.logout : Icons.login, color: isLoggedIn ? Colors.redAccent : const Color(0xFF00E5FF), size: 22), 
              tooltip: isLoggedIn ? 'Sign Out' : 'Sign In / Register',
              onPressed: () async {
                if (isLoggedIn) {
                  await FirebaseAuth.instance.signOut();
                  setState(() {
                    totalIQ = 0;
                    completedZones = 0;
                    selectedZoneToPlay = 0;
                    playerName = 'Player';
                  });
                  _loadProgress();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully signed out! 🔒'), backgroundColor: Colors.orange));
                } else {
                  _showEmailAuthDialog();
                }
              },
            ),

            const SizedBox(width: 3),
            const Icon(Icons.account_balance_wallet, color: Color(0xFF00E5FF), size: 18), const SizedBox(width: 2),
            Text('$totalIQ', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ]),
        ],
      ),
    );
  }

  Widget _buildIslandTab() {
    int islandProgress = completedZones > 3 ? 3 : completedZones;
    bool isPractice = selectedZoneToPlay < completedZones;

    return Column(
      children: [
        _buildTopStatus(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _startGame(GameMode.dailyChallenge),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF1744), Color(0xFFD500F9)]), borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.3), blurRadius: 10)]),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.flash_on, color: Colors.white, size: 20),
                              SizedBox(width: 6),
                              Text('DAILY CHALLENGE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1C29), side: const BorderSide(color: Color(0xFF00E5FF)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding: const EdgeInsets.all(14)),
                        onPressed: _showDailyLeaderboard,
                        child: const Icon(Icons.leaderboard, color: Color(0xFF00E5FF), size: 22),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // ==========================================
                // QUICK ACCESS FOR NEW FEATURES IN LOBBY
                // ==========================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1C29), side: const BorderSide(color: Color(0xFF00E5FF))),
                        icon: const Icon(Icons.shield, color: Color(0xFF00E5FF), size: 18),
                        label: const Text('Clan/Guild', style: TextStyle(color: Colors.white, fontSize: 12)),
                        onPressed: _showClanDialog,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1C29), side: const BorderSide(color: Color(0xFF00E676))),
                        icon: const Icon(Icons.card_giftcard, color: Color(0xFF00E676), size: 18),
                        label: const Text('Battle Pass', style: TextStyle(color: Colors.white, fontSize: 12)),
                        onPressed: _showBattlePassDialog,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1C29), side: const BorderSide(color: Color(0xFFF9A826))),
                        icon: const Icon(Icons.emoji_events, color: Color(0xFFF9A826), size: 18),
                        label: const Text('Trophies', style: TextStyle(color: Colors.white, fontSize: 12)),
                        onPressed: _showTrophyRoomDialog,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedOpacity(opacity: islandProgress >= 3 ? 1.0 : 0.0, duration: const Duration(seconds: 2), child: Container(width: 250, height: 250, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: isFeverActive ? Colors.redAccent.withOpacity(0.4) : getThemeColor().withOpacity(0.2), blurRadius: 80, spreadRadius: 20)]))),
                    AnimatedPositioned(duration: const Duration(seconds: 1), curve: Curves.elasticOut, bottom: islandProgress >= 2 ? 90 : 70, child: AnimatedOpacity(opacity: islandProgress >= 2 ? 1.0 : 0.0, duration: const Duration(seconds: 1), child: getThemeIcons(islandProgress))),
                    AnimatedPositioned(duration: const Duration(seconds: 1), curve: Curves.elasticOut, bottom: islandProgress >= 1 ? 80 : 60, left: 60, child: AnimatedOpacity(opacity: islandProgress >= 1 ? 1.0 : 0.0, duration: const Duration(seconds: 1), child: const Icon(Icons.park, color: Color(0xFF00E676), size: 80))),
                    AnimatedContainer(duration: const Duration(seconds: 1), width: 250, height: 90, decoration: BoxDecoration(color: islandProgress >= 1 ? (currentTheme == IslandTheme.winter ? Colors.white : (currentTheme == IslandTheme.cyberpunk ? const Color(0xFF311B92) : const Color(0xFF1B5E20))) : const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(150), border: Border.all(color: isFeverActive ? Colors.redAccent : (islandProgress >= 3 ? getThemeColor() : Colors.transparent), width: isFeverActive ? 6 : 4), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))])),
                    if (assetCars > 0) const Positioned(bottom: 50, right: 40, child: Icon(Icons.directions_car, color: Colors.redAccent, size: 35)),
                    if (assetHouses > 0) const Positioned(bottom: 100, left: 90, child: Icon(Icons.villa, color: Colors.purpleAccent, size: 50)),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_left, size: 40, color: Colors.white), onPressed: selectedZoneToPlay > 0 ? () { SoundManager.playClick(); setState(() => selectedZoneToPlay--); } : null),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), 
                      decoration: BoxDecoration(color: isPractice ? Colors.blueAccent.withOpacity(0.2) : const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15), border: Border.all(color: isPractice ? Colors.blueAccent : getThemeColor())), 
                      child: Column(
                        children: [
                          Text('ZONE ${selectedZoneToPlay + 1}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), 
                          const SizedBox(height: 2),
                          Text('Level: ${selectedZoneToPlay + 1}', style: const TextStyle(fontSize: 12, color: Colors.white70)), 
                          if (isPractice) const Text('Practice Mode', style: TextStyle(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold))
                        ]
                      )
                    ),
                    IconButton(icon: const Icon(Icons.arrow_right, size: 40, color: Colors.white), onPressed: selectedZoneToPlay < completedZones ? () { SoundManager.playClick(); setState(() => selectedZoneToPlay++); } : null),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Color(0xFF12141D), border: Border(top: BorderSide(color: Colors.white10))),
          child: Row(
            children: [
              GestureDetector(onTap: () => _startGame(GameMode.hardcore), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.redAccent.withOpacity(0.5))), child: const Icon(Icons.visibility_off, color: Colors.redAccent, size: 26))),
              const SizedBox(width: 15),
              Expanded(child: GestureDetector(onTap: () => _startGame(GameMode.single), child: Container(padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(gradient: LinearGradient(colors: isPractice ? [Colors.blueAccent, Colors.lightBlue] : [const Color(0xFF00E676), const Color(0xFF00C853)]), borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: isPractice ? Colors.blueAccent.withOpacity(0.4) : const Color(0xFF00E676).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))]), child: Center(child: Text(isPractice ? 'PRACTICE' : 'START (SOLO)', style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)))))),
            ],
          ),
        ),
      ],
    );
  }

 Widget _buildMultiplayerTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTopStatus(), const SizedBox(height: 20),
        GestureDetector(onTap: _showLeaderboard, child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF00E5FF).withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFF00E5FF))), child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.leaderboard, color: Color(0xFF00E5FF), size: 30), SizedBox(width: 15), Text('Global Leaderboard (Top 100)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]), Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16)]))), const SizedBox(height: 20),
        const Text('MULTIPLAYER SERVER 🌐', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)), const SizedBox(height: 15),
        
        _modeCard(title: 'Live 1v1 PvP Battle', subtitle: 'Enhanced real-time betting & animations!', icon: Icons.flash_on, color: Colors.redAccent, mode: GameMode.battle, onTapped: () => _showBetSelectionDialog(GameMode.battle)), 
        const SizedBox(height: 15),
        _modeCard(title: 'Flow Royale', subtitle: '100 Players Survival Mode', icon: Icons.public, color: Colors.purpleAccent, mode: GameMode.royale, onTapped: () => _startGame(GameMode.royale)), 
        const SizedBox(height: 15),
        _modeCard(title: 'Co-op Squad', subtitle: 'Solve big puzzles together', icon: Icons.handshake, color: const Color(0xFF4FC3F7), mode: GameMode.coop, onTapped: () => _startGame(GameMode.coop)),
      ],
    );
  }

  Widget _modeCard({required String title, required String subtitle, required IconData icon, required Color color, required GameMode mode, VoidCallback? onTapped}) {
    return GestureDetector(onTap: onTapped ?? () => _startGame(mode), child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(0.2), const Color(0xFF1A1C29)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.5))), child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle), child: Icon(icon, color: color, size: 30)), const SizedBox(width: 20), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12))])), Icon(Icons.play_circle_fill, color: color, size: 40)])));
  }

  Widget _buildStoreTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTopStatus(), const SizedBox(height: 20),
        const Text('STORE & VIP 🛒', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)), const SizedBox(height: 20),
        _luxuryListTile('Pet Egg 🥚', '1,000 IQ', 1000, activePet>0?1:0, Icons.pets, Colors.orange, () async { 
          if(activePet == 0) { 
            int newPet = Random().nextBool() ? 1 : 2; 
            final prefs = await SharedPreferences.getInstance(); 
            await prefs.setInt('active_pet', newPet); 
            setState(() => activePet = newPet); 
            SoundManager.playBonusSound();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hatched a ${newPet==1?'Fire Dragon 🐲':'Ice Penguin 🐧'}!', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.orange)); 
          } else { 
            _updateInventory(0,0,1000); 
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You already own a pet!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red)); 
          } 
        }),
        GestureDetector(onTap: _watchAdForReward, child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.ondemand_video, color: Colors.green, size: 28), SizedBox(width: 10), Text('WATCH AD FOR +50 IQ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]))), const SizedBox(height: 20),
        GestureDetector(onTap: _openLootBox, child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF9A826), Color(0xFFFFB74D)])), child: const Row(children: [Icon(Icons.card_giftcard, color: Colors.black, size: 50), SizedBox(width: 20), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('MYSTERY LOOT BOX', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)), Text('Cost: 300 IQ', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))])]))), const SizedBox(height: 30),
        const Text('ISLAND THEMES', style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
        Row(children: [
          Expanded(child: GestureDetector(onTap: () => _setTheme(IslandTheme.nature), child: Container(padding: const EdgeInsets.symmetric(vertical: 15), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green.withOpacity(0.5))), child: const Column(children: [Icon(Icons.park, color: Colors.green, size: 35), SizedBox(height: 5), Text('Nature', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text('Free', style: TextStyle(color: Colors.green, fontSize: 10))])))), const SizedBox(width: 10),
          Expanded(child: GestureDetector(onTap: () { if(totalIQ>=1000) _setTheme(IslandTheme.winter); }, child: Container(padding: const EdgeInsets.symmetric(vertical: 15), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.lightBlue.withOpacity(0.5))), child: const Column(children: [Icon(Icons.ac_unit, color: Colors.lightBlue, size: 35), SizedBox(height: 5), Text('Winter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text('1k IQ', style: TextStyle(color: Colors.lightBlue, fontSize: 10))])))), const SizedBox(width: 10),
          Expanded(child: GestureDetector(onTap: () { if(totalIQ>=2500) _setTheme(IslandTheme.cyberpunk); }, child: Container(padding: const EdgeInsets.symmetric(vertical: 15), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.purpleAccent.withOpacity(0.5))), child: const Column(children: [Icon(Icons.memory, color: Colors.purpleAccent, size: 35), SizedBox(height: 5), Text('Cyber', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text('2.5k IQ', style: TextStyle(color: Colors.purpleAccent, fontSize: 10))])))),
        ]), 
        const SizedBox(height: 30),
        const Text('TILE SKINS STYLES', style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
        Row(children: [
          Expanded(child: GestureDetector(onTap: () => _setTileStyle(TileStyle.classic), child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(12), border: Border.all(color: currentTileStyle == TileStyle.classic ? Colors.green : Colors.transparent)), child: const Center(child: Text('Classic', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))))),
          const SizedBox(width: 8),
          Expanded(child: GestureDetector(onTap: () { if(totalIQ>=500) _setTileStyle(TileStyle.neon); }, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(12), border: Border.all(color: currentTileStyle == TileStyle.neon ? Colors.cyan : Colors.transparent)), child: const Center(child: Text('Neon (500)', style: TextStyle(color: Colors.cyan, fontSize: 12, fontWeight: FontWeight.bold)))))),
          const SizedBox(width: 8),
          Expanded(child: GestureDetector(onTap: () { if(totalIQ>=1200) _setTileStyle(TileStyle.wooden); }, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(12), border: Border.all(color: currentTileStyle == TileStyle.wooden ? Colors.amber : Colors.transparent)), child: const Center(child: Text('Wood (1.2k)', style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)))))),
        ]),
        const SizedBox(height: 30),
        const Text('LUXURY REAL ESTATE', style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
        _luxuryListTile('Silver Bar', '1,000 IQ', 1000, assetSilver, Icons.view_comfy_alt, Colors.grey, () { setState(() => assetSilver++); _saveAssets(); }), 
        _luxuryListTile('Gold Bar', '5,000 IQ', 5000, assetGold, Icons.view_comfy_alt, Colors.amber, () { setState(() => assetGold++); _saveAssets(); }), 
        _luxuryListTile('Supercar', '20,000 IQ', 20000, assetCars, Icons.directions_car, Colors.redAccent, () { setState(() => assetCars++); _saveAssets(); }), 
        _luxuryListTile('Luxury Villa', '100,000 IQ', 100000, assetHouses, Icons.villa, Colors.purpleAccent, () { setState(() => assetHouses++); _saveAssets(); }),
      ],
    );
  }

  Widget _luxuryListTile(String name, String priceTxt, int price, int owned, IconData icon, Color color, VoidCallback onBuy) {
    return Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF1A1C29), borderRadius: BorderRadius.circular(15)), child: ListTile(leading: Icon(icon, color: color, size: 35), title: Text(name, style: TextStyle(color: color, fontWeight: FontWeight.bold)), subtitle: Text('Owned: $owned\nCost: $priceTxt', style: const TextStyle(color: Colors.white54, fontSize: 12)), trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: totalIQ >= price ? const Color(0xFF00E676) : Colors.grey), onPressed: () { if (totalIQ >= price) { SoundManager.playBonusSound(); _updateInventory(0, 0, -price); onBuy(); HapticFeedback.heavyImpact(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchased $name! 🎉', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.green)); } else { SoundManager.playClick(); } }, child: const Text('Buy', style: TextStyle(color: Colors.black)))));
  }

  @override Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF00E676))));
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _currentTabIndex, children: [_buildIslandTab(), _buildMultiplayerTab(), _buildStoreTab()])), 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex, 
        onTap: (index) { SoundManager.playClick(); setState(() => _currentTabIndex = index); }, 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.terrain), label: 'Island'), 
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Multiplayer'), 
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Store')
        ]
      )
    );
  }
}

// ==========================================
// TILE MODEL & GENERATOR
// ==========================================
class TileModel {
  final String type; int rotation; final int correctRotation; final bool isGolden; 
  TileModel({required this.type, required this.rotation, required this.correctRotation, this.isGolden = false});
}

class LevelGenerator {
  static List<List<TileModel>> generate(int size, {int? seed, int retryCount = 0}) {
    if (retryCount > 50) {
      return List.generate(size, (r) => List.generate(size, (c) => TileModel(type: 'I', rotation: 0, correctRotation: 0)));
    }

    final rand = seed != null ? Random(seed + retryCount) : Random();
    List<List<TileModel>> grid = List.generate(size, (r) => List.generate(size, (c) => TileModel(type: 'empty', rotation: 0, correctRotation: 0)));
    int currR = 0, currC = 0; grid[currR][currC] = TileModel(type: 'S', rotation: 0, correctRotation: 0);
    List<List<int>> path = [[0,0]]; Set<String> visited = {'0,0'};

    while (currR != size - 1 || currC != size - 1) {
      List<List<int>> pMoves = [];
      if (currR > 0 && !visited.contains('${currR-1},$currC')) pMoves.add([currR-1, currC]);
      if (currR < size - 1 && !visited.contains('${currR+1},$currC')) pMoves.add([currR+1, currC]);
      if (currC > 0 && !visited.contains('$currR,${currC-1}')) pMoves.add([currR, currC-1]);
      if (currC < size - 1 && !visited.contains('$currR,${currC+1}')) pMoves.add([currR, currC+1]);
      
      if (pMoves.isEmpty) {
        return generate(size, seed: seed, retryCount: retryCount + 1);
      }
      
      pMoves.shuffle(rand); currR = pMoves.first[0]; currC = pMoves.first[1]; path.add([currR, currC]); visited.add('$currR,$currC');
    }
    grid[size-1][size-1] = TileModel(type: 'E', rotation: 0, correctRotation: 0);
    int getDir(int r1, int c1, int r2, int c2) { if (r2 < r1) return 0; if (c2 > c1) return 1; if (r2 > r1) return 2; if (c2 < c1) return 3; return -1; }

    for (int i = 1; i < path.length - 1; i++) {
      int prevR = path[i-1][0], prevC = path[i-1][1], r = path[i][0], c = path[i][1], nextR = path[i+1][0], nextC = path[i+1][1];
      int inDir = getDir(r, c, prevR, prevC), outDir = getDir(r, c, nextR, nextC);
      int correctRot = 0; String type = 'L';
      if ((inDir == 0 && outDir == 2) || (inDir == 2 && outDir == 0)) { type = 'I'; correctRot = 0; }
      else if ((inDir == 1 && outDir == 3) || (inDir == 3 && outDir == 1)) { type = 'I'; correctRot = 1; }
      else { type = 'L'; if ((inDir == 0 && outDir == 1) || (inDir == 1 && outDir == 0)) correctRot = 0; else if ((inDir == 1 && outDir == 2) || (inDir == 2 && outDir == 1)) correctRot = 1; else if ((inDir == 2 && outDir == 3) || (inDir == 3 && outDir == 2)) correctRot = 2; else correctRot = 3; }
      grid[r][c] = TileModel(type: type, rotation: correctRot, correctRotation: correctRot);
    }
    bool goldenPlaced = false;
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (grid[r][c].type == 'empty') {
          bool makeGolden = (!goldenPlaced && rand.nextInt(10) > 7);
          if (makeGolden) goldenPlaced = true;
          grid[r][c] = TileModel(type: rand.nextBool() ? 'I' : 'L', rotation: rand.nextInt(4), correctRotation: rand.nextInt(4), isGolden: makeGolden);
        } else if (grid[r][c].type != 'S' && grid[r][c].type != 'E') {
          grid[r][c] = TileModel(type: grid[r][c].type, rotation: (grid[r][c].correctRotation + rand.nextInt(3) + 1) % 4, correctRotation: grid[r][c].correctRotation); 
        }
      }
    }
    return grid;
  }
}

// ==========================================
// GAME SCREEN
// ==========================================
class GameScreen extends StatefulWidget {
  final int levelIndex; final GameMode mode; final Color themeColor; final TileStyle tileStyle; final bool isFeverActive; final int invTimeFreeze; final int invAutoRow; final String opponentName; final String opponentAvatar; final bool isPracticeMode; final int activePet;
  final String roomId; final bool isHost; final int gameSeed;
  final String playerImagePath; final String playerAvatar; final Uint8List? playerImageBytes;
  final int betAmount;

  const GameScreen({super.key, required this.levelIndex, required this.mode, required this.themeColor, required this.tileStyle, required this.isFeverActive, required this.invTimeFreeze, required this.invAutoRow, required this.opponentName, required this.opponentAvatar, this.isPracticeMode = false, required this.activePet, required this.roomId, required this.isHost, required this.gameSeed, required this.playerImagePath, required this.playerAvatar, required this.playerImageBytes, required this.betAmount});
  @override State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool isSolved = false; late List<List<TileModel>> grid; Set<String> illuminatedPaths = {'0,0'}; bool goldenCollected = false;
  int timeLeft = 60; int initialTime = 60; int moves = 0; int hintsTaken = 0; int calculatedIQ = 0;
  int freezeUsed = 0; int rowUsed = 0; bool isFrozen = false; Timer? _timer; Timer? _multiplayerSimTimer;
  bool usedHint = false; 
  int totalFrozenSeconds = 0; 

  double opponentProgress = 0.0; int playersAlive = 100;
  String currentKillfeed = "Match Started!";
  List<String> killNames = ["Ninja", "ProSniper", "LudoKing", "NoobMaster", "Alpha", "Zero"];

  StreamSubscription? _roomSubscription;

  @override void initState() { 
    super.initState(); 
    loadLevel(); 
    SoundManager.playTimedGameplayBGM(); 
  }
  
  @override void dispose() { _timer?.cancel(); _multiplayerSimTimer?.cancel(); _roomSubscription?.cancel(); super.dispose(); }

  void loadLevel() {
    setState(() {
      isSolved = false; moves = 0; hintsTaken = 0; illuminatedPaths = {'0,0'}; isFrozen = false; opponentProgress = 0.0; goldenCollected = false; usedHint = false; totalFrozenSeconds = 0;
      int size = widget.levelIndex < 3 ? 3 : (widget.levelIndex < 10 ? 4 : 5);
      if (widget.mode == GameMode.royale) size = 5; if (widget.mode == GameMode.tournament || widget.mode == GameMode.dailyChallenge) size = 5;
      grid = LevelGenerator.generate(size, seed: (widget.mode == GameMode.battle || widget.mode == GameMode.dailyChallenge) ? widget.gameSeed : null);
      timeLeft = widget.mode == GameMode.battle ? 60 : (size == 3 ? 30 : (size == 4 ? 60 : 90)); 
      initialTime = timeLeft; checkPath();
    });
    _startTimer();
    
    if (widget.mode == GameMode.battle && widget.roomId.isNotEmpty) _startRealtimeBattle();
    else if (widget.mode == GameMode.royale) _startRoyaleSimulation();
  }

  void _startRealtimeBattle() {
    _roomSubscription = FirebaseFirestore.instance.collection('rooms').doc(widget.roomId).snapshots().listen((snapshot) {
      if (!snapshot.exists || isSolved) return;
      var data = snapshot.data() as Map<String, dynamic>;
      double oppProg = widget.isHost ? data['player2_progress'] : data['player1_progress'];
      if (oppProg > opponentProgress) {
        setState(() {
          opponentProgress = oppProg;
          if (opponentProgress >= 1.0) { 
            _timer?.cancel(); _roomSubscription?.cancel(); SoundManager.playLoss();
            _showGameOverDialog("YOU LOSE THE GAME 💔", "${widget.opponentName} won the ${widget.betAmount} IQ bet!", 0); 
          }
        });
      }
    });
  }

  void _syncMyProgressToFirebase() {
    if (widget.mode != GameMode.battle || widget.roomId.isEmpty) return;
    double totalTiles = (grid.length * grid[0].length).toDouble();
    double myProg = illuminatedPaths.length / totalTiles;
    if (isSolved) myProg = 1.0;
    String fieldToUpdate = widget.isHost ? 'player1_progress' : 'player2_progress';
    FirebaseFirestore.instance.collection('rooms').doc(widget.roomId).update({fieldToUpdate: myProg});
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isFrozen) {
        totalFrozenSeconds++;
        return;
      } 
      if (timeLeft > 0 && !isSolved) {
        if (timeLeft == 7) { SoundManager.playTimeWarning(); }
        setState(() => timeLeft--);
      } else if (timeLeft == 0 && !isSolved) { 
        timer.cancel(); SoundManager.stopBackgroundMusic(); SoundManager.playLoss();
        _showGameOverDialog("Time's Up! ⏱️", "You lost the match.", 0); 
      }
    });
  }

  void _startRoyaleSimulation() { 
    _multiplayerSimTimer?.cancel(); 
    _multiplayerSimTimer = Timer.periodic(const Duration(seconds: 3), (timer) { 
      if (isSolved) { timer.cancel(); return; } 
      setState(() { 
        if (playersAlive > 2) {
          playersAlive -= Random().nextInt(5) + 1; 
          String dead = killNames[Random().nextInt(killNames.length)];
          String killer = killNames[Random().nextInt(killNames.length)];
          currentKillfeed = "🔫 $killer eliminated $dead";
        } else if (playersAlive == 2) { currentKillfeed = "🔥 1 VS 1 - CLUTCH TIME! 🔥"; }
      }); 
    }); 
  }

  void _useTimeFreeze() {
    if(isFrozen) return;
    if(widget.invTimeFreeze - freezeUsed <= 0) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No Freeze left!'))); return; }
    SoundManager.playBonusSound();
    int freezeDur = widget.activePet == 2 ? 15 : 10; 
    setState(() { isFrozen = true; freezeUsed++; });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❄️ Time Frozen for ${freezeDur}s!')));
    Future.delayed(Duration(seconds: freezeDur), () { if(mounted) setState(() => isFrozen = false); });
  }

  void _useAutoRow() {
    if(widget.invAutoRow - rowUsed <= 0) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No Magic left!'))); return; }
    SoundManager.playBonusSound();
    setState(() {
      rowUsed++; bool changed = false;
      for (int r = 0; r < grid.length; r++) { for (int c = 0; c < grid[r].length; c++) { if (grid[r][c].rotation != grid[r][c].correctRotation && grid[r][c].type != 'S' && grid[r][c].type != 'E') { grid[r][c].rotation = grid[r][c].correctRotation; changed = true; } } if (changed) break; }
      checkPath();
    });
  }

  void _watchAdForHint() async {
    SoundManager.playClick();
    showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(backgroundColor: Colors.transparent, elevation: 0, content: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: Color(0xFFF9A826)), SizedBox(height: 10), Text('Loading Ad for Hint...', style: TextStyle(color: Colors.white))])));
    await Future.delayed(const Duration(seconds: 2));
    if(!mounted) return; Navigator.pop(context);
    setState(() {
      hintsTaken++; 
      int hintsGiven = 0;
      for (int r = 0; r < grid.length; r++) { for (int c = 0; c < grid[r].length; c++) { if (grid[r][c].type != 'empty' && grid[r][c].type != 'S' && grid[r][c].type != 'E' && grid[r][c].rotation != grid[r][c].correctRotation) { grid[r][c].rotation = grid[r][c].correctRotation; hintsGiven++; if (hintsGiven >= 2) break; } } if (hintsGiven >= 2) break; }
      if (checkPath()) { 
        isSolved = true; _timer?.cancel(); SoundManager.playWin(); _showWinDialog(); 
      }
    });
  }

  void rotateTile(int row, int col) {
    if (isSolved || timeLeft == 0) return;
    if (grid[row][col].type == 'S' || grid[row][col].type == 'E') return;
    
    SoundManager.playTileSound(); HapticFeedback.lightImpact(); 

    setState(() { 
      grid[row][col].rotation = (grid[row][col].rotation + 1) % 4; moves++; 
      if (checkPath()) { 
        isSolved = true; _timer?.cancel(); _roomSubscription?.cancel(); _multiplayerSimTimer?.cancel();
        SoundManager.playWin(); HapticFeedback.heavyImpact(); _showWinDialog(); 
      }
      _syncMyProgressToFirebase();
    });
  }

  List<int> getOpenPorts(TileModel tile) {
    if (tile.type == 'S' || tile.type == 'E') return [0, 1, 2, 3];
    List<int> bp = []; if (tile.type == 'I') bp = [0, 2]; if (tile.type == 'L') bp = [0, 1];
    return bp.map((p) => (p + tile.rotation) % 4).toList();
  }

  bool checkPath() {
    List<List<int>> q = [[0, 0]]; Set<String> vis = {'0,0'}; bool tempGold = false;
    while (q.isNotEmpty) {
      var curr = q.removeAt(0); int r = curr[0], c = curr[1]; TileModel ct = grid[r][c];
      if (ct.isGolden) tempGold = true;
      if (ct.type == 'E') { setState(() { illuminatedPaths = vis; goldenCollected = tempGold; }); return true; }
      for (int p in getOpenPorts(ct)) {
        int nr = r, nc = c, op = (p + 2) % 4;
        if (p == 0) nr--; if (p == 1) nc++; if (p == 2) nr++; if (p == 3) nc--; 
        if (nr >= 0 && nr < grid.length && nc >= 0 && nc < grid[0].length && !vis.contains('$nr,$nc')) {
          if (getOpenPorts(grid[nr][nc]).contains(op)) { vis.add('$nr,$nc'); q.add([nr, nc]); }
        }
      }
    }
    setState(() => illuminatedPaths = vis); return false;
  }

  void _showGameOverDialog(String title, String message, int penaltyIQ) {
    showDialog(
      context: context, barrierDismissible: false, 
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E), 
        title: Text(title, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)), 
        content: Text(message, style: const TextStyle(color: Colors.white70)), 
        actions: [ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), onPressed: () { SoundManager.playClick(); Navigator.pop(context); Navigator.pop(context, {'iq': penaltyIQ, 'freezeUsed': freezeUsed, 'rowUsed': rowUsed}); }, child: const Text('Exit to Lobby', style: TextStyle(color: Colors.white)))]
      )
    );
  }

  void _showWinDialog() async {
    if (widget.mode == GameMode.dailyChallenge) {
      int totalPuzzleTiles = 0;
      for (var row in grid) {
        for (var tile in row) {
          if (tile.type != 'empty' && tile.type != 'S' && tile.type != 'E') totalPuzzleTiles++;
        }
      }

      bool is100PercentHints = totalPuzzleTiles > 0 && hintsTaken >= totalPuzzleTiles;

      if (is100PercentHints) {
        showDialog(
          context: context, barrierDismissible: false,
          builder: (_) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E2E),
            title: const Text('SOLVED WITH 100% HINTS! 💡', style: TextStyle(color: Color(0xFFF9A826), fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            content: const Text('Since you used hints for the entire puzzle, no points or leaderboard rank were awarded for this daily challenge.', style: TextStyle(color: Colors.white70)),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF9A826)),
                onPressed: () { SoundManager.playClick(); Navigator.pop(context); Navigator.pop(context, {'iq': 0, 'freezeUsed': freezeUsed, 'rowUsed': rowUsed}); },
                child: const Text('Okay', style: TextStyle(color: Colors.black)),
              )
            ],
          ),
        );
        return;
      }

      int timeTaken = initialTime - timeLeft;
      int scorePoints = 10000 - (timeTaken * 10) - (hintsTaken * 300) - (totalFrozenSeconds * 5) - (moves * 2);
      if (scorePoints < 10) scorePoints = 10;

      String todayDateStr = DateTime.now().toIso8601String().substring(0, 10);

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          var userDoc = await FirebaseFirestore.instance.collection('players').doc(user.uid).get();
          String uname = userDoc.exists ? (userDoc.data()?['name'] ?? 'Player') : 'Player';

          var existingScoreQuery = await FirebaseFirestore.instance
              .collection('daily_scores')
              .where('uid', isEqualTo: user.uid)
              .where('date_str', isEqualTo: todayDateStr)
              .get();

          if (existingScoreQuery.docs.isNotEmpty) {
            var docRef = existingScoreQuery.docs.first.reference;
            int existingPoints = existingScoreQuery.docs.first.data()['score_points'] ?? 0;

            if (scorePoints > existingPoints) {
              await docRef.update({
                'time_taken': timeTaken,
                'hints': hintsTaken,
                'frozen_time': totalFrozenSeconds,
                'moves': moves,
                'score_points': scorePoints,
                'timestamp': FieldValue.serverTimestamp(),
              });
            }
          } else {
            await FirebaseFirestore.instance.collection('daily_scores').add({
              'uid': user.uid,
              'name': uname,
              'date_str': todayDateStr,
              'time_taken': timeTaken,
              'hints': hintsTaken,
              'frozen_time': totalFrozenSeconds,
              'moves': moves,
              'score_points': scorePoints,
              'timestamp': FieldValue.serverTimestamp(),
            });
          }
        }
      } catch (_) {}
    }

    int baseIQ = widget.mode == GameMode.battle ? widget.betAmount * 2 : (widget.mode == GameMode.royale ? 500 : (widget.mode == GameMode.dailyChallenge ? 300 : 150));
    int movePenaltyOrBonus = max(10, 50 - (moves * 2)); 
    calculatedIQ = baseIQ + movePenaltyOrBonus;

    if (widget.activePet == 1 && calculatedIQ > 0) calculatedIQ = (calculatedIQ * 1.1).toInt();
    if (goldenCollected && !widget.isPracticeMode) calculatedIQ += 100;
    if (widget.isFeverActive) calculatedIQ = calculatedIQ * 3;

    String winTitle = widget.mode == GameMode.battle ? 'YOU WON THE ${widget.betAmount * 2} IQ POT! 🏆' : (widget.isFeverActive ? '🔥 FEVER CLEARED! 3X IQ' : 'VICTORY! ⚡');

    Future.delayed(const Duration(milliseconds: 600), () {
      showDialog(
        context: context, barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          title: Text(winTitle, style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Level: ${widget.levelIndex + 1} | Moves: $moves | Time left: ${timeLeft}s', style: const TextStyle(color: Colors.white70)),
              if (widget.activePet == 1) const Text('🐲 Dragon Bonus: +10% IQ', style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
              if (goldenCollected) const Text('🎁 Golden Airdrop: +100 IQ!', style: TextStyle(color: Color(0xFFF9A826), fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Text('+$calculatedIQ IQ', style: const TextStyle(color: Color(0xFF00E676), fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(
              onPressed: () { SoundManager.playClick(); Navigator.pop(context); Navigator.pop(context, {'iq': calculatedIQ, 'freezeUsed': freezeUsed, 'rowUsed': rowUsed, 'isFast': moves < 15}); }, 
              child: const Text('Normal (1x)', style: TextStyle(color: Colors.white54))
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)), 
              onPressed: () async {
                SoundManager.playClick();
                showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(backgroundColor: Colors.transparent, elevation: 0, content: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: Color(0xFF00E676)), SizedBox(height: 10), Text('Processing Bonus (2s)...', style: TextStyle(color: Colors.white))])));
                await Future.delayed(const Duration(seconds: 2));
                if (!context.mounted) return;
                Navigator.pop(context); Navigator.pop(context);
                Navigator.pop(context, {'iq': calculatedIQ * 2, 'freezeUsed': freezeUsed, 'rowUsed': rowUsed, 'isFast': moves < 15});
              }, 
              child: const Text('Collect 2x ⭐', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (widget.mode == GameMode.battle) Padding(padding: const EdgeInsets.all(15.0), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [widget.playerImageBytes != null ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.memory(widget.playerImageBytes!, width: 30, height: 30, fit: BoxFit.cover)) : Text(widget.playerAvatar, style: const TextStyle(fontSize: 20)), const SizedBox(width: 8), const Text('You', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]), 
              const Text('vs', style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic)), 
              Row(children: [Text(widget.opponentAvatar, style: const TextStyle(fontSize: 20)), const SizedBox(width: 5), Text(widget.opponentName, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18))])
            ]), const SizedBox(height: 5), LinearProgressIndicator(value: opponentProgress, color: Colors.redAccent, minHeight: 10)])),
            if (widget.mode == GameMode.royale) Container(width: double.infinity, padding: const EdgeInsets.all(8), color: Colors.purpleAccent.withOpacity(0.1), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('💀 Alive: $playersAlive/100', style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16)), Text(currentKillfeed, style: const TextStyle(color: Colors.white70, fontSize: 12))])),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () { SoundManager.playClick(); Navigator.pop(context); }),
                  Column(
                    children: [
                      Text(widget.mode == GameMode.dailyChallenge ? 'DAILY CHALLENGE 🌟' : 'LEVEL ${widget.levelIndex + 1}', style: const TextStyle(fontSize: 14, color: Colors.amber, fontWeight: FontWeight.bold)), 
                      Text(isFrozen ? '❄️ FROZEN' : 'TIME: ${timeLeft}s | Moves: $moves', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isFrozen ? Colors.lightBlue : (timeLeft <= 7 ? Colors.redAccent : Colors.greenAccent))),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(alignment: Alignment.topRight, children: [IconButton(icon: const Icon(Icons.ac_unit, color: Colors.lightBlue, size: 26), onPressed: _useTimeFreeze), if ((widget.invTimeFreeze - freezeUsed) > 0) CircleAvatar(radius: 7, backgroundColor: Colors.red, child: Text('${widget.invTimeFreeze - freezeUsed}', style: const TextStyle(fontSize: 9, color: Colors.white)))]),
                      Stack(alignment: Alignment.topRight, children: [IconButton(icon: const Icon(Icons.auto_fix_high, color: Colors.purpleAccent, size: 26), onPressed: _useAutoRow), if ((widget.invAutoRow - rowUsed) > 0) CircleAvatar(radius: 7, backgroundColor: Colors.red, child: Text('${widget.invAutoRow - rowUsed}', style: const TextStyle(fontSize: 9, color: Colors.white)))]),
                      IconButton(icon: const Icon(Icons.lightbulb, color: Color(0xFFF9A826), size: 28), onPressed: _watchAdForHint),
                    ],
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.tileStyle == TileStyle.wooden ? const Color(0xFF3E2723) : const Color(0xFF1A1C29), 
                    borderRadius: BorderRadius.circular(24), 
                    border: widget.tileStyle == TileStyle.neon ? Border.all(color: Colors.cyan, width: 2) : null,
                    boxShadow: [BoxShadow(color: widget.themeColor.withOpacity(0.2), blurRadius: 30)]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(grid.length, (rowIdx) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(grid[rowIdx].length, (colIdx) {
                          final tile = grid[rowIdx][colIdx];
                          final isEmpty = tile.type == 'empty';
                          const double tileSize = 60; 

                          return GestureDetector(
                            onTap: () => rotateTile(rowIdx, colIdx),
                            child: Container(
                              width: tileSize, height: tileSize, margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isEmpty ? Colors.transparent : (widget.tileStyle == TileStyle.wooden ? const Color(0xFF4E342E) : (widget.tileStyle == TileStyle.neon ? const Color(0xFF001E1D) : const Color(0xFF25253D))), 
                                borderRadius: BorderRadius.circular(16)
                              ),
                              alignment: Alignment.center,
                              child: isEmpty ? null : AnimatedRotation(turns: tile.rotation * 0.25, duration: const Duration(milliseconds: 200), child: CustomPathWidget(tile: tile, isSolved: isSolved, size: tileSize, themeColor: widget.themeColor, tileStyle: widget.tileStyle)),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPathWidget extends StatelessWidget {
  final TileModel tile; final bool isSolved; final double size; final Color themeColor; final TileStyle tileStyle;
  const CustomPathWidget({super.key, required this.tile, required this.isSolved, required this.size, required this.themeColor, required this.tileStyle});

  @override Widget build(BuildContext context) {
    final Color pathColor = tile.isGolden ? const Color(0xFFF9A826) : (isSolved ? (tileStyle == TileStyle.neon ? Colors.cyanAccent : themeColor) : (tileStyle == TileStyle.wooden ? const Color(0xFF8D6E63) : const Color(0xFF4A4A6A)));
    final double thickness = size * 0.25;
    return Stack(alignment: Alignment.center, children: [
      if (tile.isGolden) Icon(Icons.star, color: Colors.yellow.withOpacity(0.3), size: size * 0.8),
      if (tile.type == 'S') Container(width: size * 0.5, height: size * 0.5, decoration: BoxDecoration(color: pathColor, shape: BoxShape.circle)),
      if (tile.type == 'E') Container(width: size * 0.4, height: size * 0.4, decoration: BoxDecoration(border: Border.all(color: pathColor, width: 4), shape: BoxShape.circle)),
      if (tile.type == 'I') Container(width: thickness, height: size, decoration: BoxDecoration(color: pathColor)),
      if (tile.type == 'L') Stack(children: [Positioned(top: 0, left: (size - thickness) / 2, child: Container(width: thickness, height: size / 2 + (thickness / 2), decoration: BoxDecoration(color: pathColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(thickness/2))))), Positioned(top: (size - thickness) / 2, left: size / 2, child: Container(width: size / 2, height: thickness, decoration: BoxDecoration(color: pathColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(thickness/2)))))]),
    ]);
  }
}
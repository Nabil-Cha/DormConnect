// lib/pages/profile/settings_home_page.dart
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:hci_mi5y_dormconnect/theme/colors.dart';
import 'help_support_page.dart';
import 'about_page.dart';


class SettingsHomePage extends StatefulWidget {
  const SettingsHomePage({super.key});

  @override
  State<SettingsHomePage> createState() => _SettingsHomePageState();
}

class _SettingsHomePageState extends State<SettingsHomePage>
    with TickerProviderStateMixin {
  /* ───────── avatar state ───────── */
  File? _avatar;
  static const _prefsKeyAvatarPath = 'avatar_path';
  final ImagePicker _picker = ImagePicker();

  Future<void> _readStoredAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKeyAvatarPath);
    if (stored != null && File(stored).existsSync()) {
      setState(() => _avatar = File(stored));
    }
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('username');
    if (stored != null && mounted) {
      setState(() => _nameCtrl.text = stored);
    }
  }

  Future<void> _pickAvatar() async {
    final XFile? img =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (img == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final newPath =
    p.join(dir.path, 'profile_${DateTime.now().millisecondsSinceEpoch}${p.extension(img.path)}');
    final saved = await File(img.path).copy(newPath);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKeyAvatarPath, saved.path);

    setState(() => _avatar = saved);
  }

  /* ───────── logout helper ───────── */
  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title  : const Text('Sign out?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(c, true ), child: const Text('Sign out')),
        ],
      ),
    );
    if (ok != true) return;

    try { await Supabase.instance.client.auth.signOut(); } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('community');

    // Reveal root scaffold (which has the nav bar); sign-in dialog appears there
    if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
  }

  /* ───────── colour & layout helpers ───────── */
  Color _chipBg(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
          ? const Color(0xFF3A3A3A)
          : const Color(0xFF212121);

  double _dropdownTop(BuildContext ctx, double y, int count) {
    const maxH = 150.0, rowH = 48.0;
    final h = math.min(count * rowH + 16, maxH);
    final scr = MediaQuery.of(ctx).size.height;
    final safe = MediaQuery.of(ctx).padding.bottom + 20;
    return (y + h + safe > scr) ? scr - h - safe : y;
  }

  /* ───────── local state ───────── */
  bool _editing = false;
  late final TextEditingController _nameCtrl;

  bool _openTheme = false, _openLang = false, _openNotif = false;
  String _theme = 'Light', _lang = 'English', _notif = 'Enabled';

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();   // start empty
    _readStoredAvatar();                   // existing avatar loader
    _loadUsername();                       // ← NEW: fetch “username”
  }


  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  /* ───────── profile section ───────── */
  static const _dur = Duration(milliseconds: 300);
  static const _curve = Curves.easeInOut;

  Widget _profileSection() => Column(
    children: [
      const SizedBox(height: 20),
      GestureDetector(
        onTap: _pickAvatar,
        child: CircleAvatar(
          radius: 36,
          backgroundColor: Colors.grey.shade400,
          backgroundImage: _avatar != null ? FileImage(_avatar!) : null,
          child: _avatar == null
              ? const Icon(Icons.person, size: 36, color: Colors.white)
              : null,
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: AnimatedSwitcher(
          duration: _dur,
          switchInCurve: _curve,
          switchOutCurve: _curve,
          transitionBuilder: (child, anim) => SlideTransition(
            position:
            Tween<Offset>(begin: const Offset(0, .2), end: Offset.zero)
                .animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: _editing
              ? Container(
            key: const ValueKey('field'),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameCtrl,
                    maxLength: 40,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
                const Icon(Icons.edit, size: 18, color: Colors.grey),
              ],
            ),
          )
              : FittedBox(
            key: const ValueKey('label'),
            fit: BoxFit.scaleDown,
            child: Text(
              _nameCtrl.text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 8),
      AnimatedSwitcher(
        duration: _dur,
        switchInCurve: _curve,
        switchOutCurve: _curve,
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: anim,
          child: FadeTransition(opacity: anim, child: child),
        ),
        child: ElevatedButton.icon(
          key: ValueKey(_editing),
          onPressed: () => setState(() => _editing = !_editing),
          icon: Icon(_editing ? Icons.check : Icons.edit, size: 16),
          label: Text(_editing ? 'Save' : 'Edit profile'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary(context),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
      const SizedBox(height: 16),
    ],
  );

  /* ───────── reusable widgets ───────── */
  Widget _menu({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: _chipBg(context), shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      );

  Widget _dropdown(List<String> items, void Function(String) onSelect) => Container(
    width: 120,
    constraints: const BoxConstraints(maxHeight: 150),
    decoration: BoxDecoration(
      color: AppColors.background(context),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
    ),
    child: Scrollbar(
      thumbVisibility: true,
      child: ListView(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        children: items
            .map((e) => InkWell(
          onTap: () => onSelect(e),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(e,
                style: TextStyle(color: AppColors.textPrimary(context))),
          ),
        ))
            .toList(),
      ),
    ),
  );

  Widget _header(String txt) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        txt,
        style: TextStyle(
          color: AppColors.textSecondary(context),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );

  Widget _trail(String v, bool open) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
        child: Text(
          v,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.textSecondary(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Icon(open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
          color: Colors.grey),
    ],
  );

  /* ───────── build ───────── */
  @override
  Widget build(BuildContext context) {
    const themes = ['Light', 'Dark'];
    const langs = ['Deutsch', 'English', 'Français', 'Español'];
    const notifs = ['Enabled', 'Disabled'];

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _logout,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary(context),      // ← same orange
              foregroundColor: Colors.white,                    // ← white text
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),        // ← same pill-shape
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _profileSection(),
                const SizedBox(height: 16),
                _header('Preferences'),
                const SizedBox(height: 8),
                _menu(
                  icon: Icons.notifications_active_outlined,
                  title: 'Notifications',
                  onTap: () => setState(() {
                    _openNotif = !_openNotif;
                    _openTheme = _openLang = false;
                  }),
                  trailing: _trail(_notif, _openNotif),
                ),
                _menu(
                  icon: Icons.palette_outlined,
                  title: 'Theme',
                  onTap: () => setState(() {
                    _openTheme = !_openTheme;
                    _openLang = _openNotif = false;
                  }),
                  trailing: _trail(_theme, _openTheme),
                ),
                _menu(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  onTap: () => setState(() {
                    _openLang = !_openLang;
                    _openTheme = _openNotif = false;
                  }),
                  trailing: _trail(_lang, _openLang),
                ),
                const SizedBox(height: 24),
                _header('Support'),
                const SizedBox(height: 8),
                _menu(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const HelpSupportPage())),
                ),
                _menu(
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const AboutPage())),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // dropdowns
          if (_openTheme)
            Positioned(
              top: _dropdownTop(context, 325, themes.length),
              right: 20,
              child: _dropdown(themes, (v) => setState(() {
                _theme = v;
                _openTheme = false;
              })),
            ),
          if (_openLang)
            Positioned(
              top: _dropdownTop(context, 400, langs.length),
              right: 20,
              child: _dropdown(langs, (v) => setState(() {
                _lang = v;
                _openLang = false;
              })),
            ),
          if (_openNotif)
            Positioned(
              top: _dropdownTop(context, 250, notifs.length),
              right: 20,
              child: _dropdown(notifs, (v) => setState(() {
                _notif = v;
                _openNotif = false;
              })),
            ),
        ],
      ),
    );
  }
}

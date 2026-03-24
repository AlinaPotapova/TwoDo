import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:two_do/core/image_provider/local_file_image.dart';
import 'package:two_do/features/authentication/domain/model/custom_user.dart';
import 'package:two_do/features/authentication/presentation/login/login_screen.dart';
import 'package:two_do/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:two_do/features/settings/presentation/cubit/settings_state.dart';

const _bgColor = Color(0xFF0B1220);
const _cardColor = Color(0xFF111827);
const _primaryBlue = Color(0xFF136DEC);
const _borderColor = Color(0xFF1F2937);

// ---------------------------------------------------------------------------
// Root content widget
// ---------------------------------------------------------------------------

/// Main UI for the Settings screen.
class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsSignedOut) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        } else if (state is SettingsUpdateSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Profile updated')));
        } else if (state is SettingsFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final user = _userFrom(state);
        return Scaffold(
          backgroundColor: _bgColor,
          appBar: AppBar(
            backgroundColor: _bgColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(color: _borderColor, height: 1, thickness: 1),
            ),
          ),
          body:
              user == null
                  ? const Center(
                    child: CircularProgressIndicator(color: _primaryBlue),
                  )
                  : _SettingsBody(
                    user: user,
                    themeMode: _themeModeFrom(state),
                    isUploading: state is SettingsUploading,
                    localPhotoPath: _localPhotoPathFrom(state),
                  ),
        );
      },
    );
  }
}

CustomUser? _userFrom(SettingsState state) => switch (state) {
  SettingsLoaded(:final user) => user,
  SettingsUploading(:final user) => user,
  SettingsUpdateSuccess(:final user) => user,
  SettingsFailure(:final user) => user,
  _ => null,
};

ThemeMode _themeModeFrom(SettingsState state) => switch (state) {
  SettingsLoaded(:final themeMode) => themeMode,
  SettingsUploading(:final themeMode) => themeMode,
  SettingsUpdateSuccess(:final themeMode) => themeMode,
  SettingsFailure(:final themeMode) => themeMode ?? ThemeMode.system,
  _ => ThemeMode.system,
};

String? _localPhotoPathFrom(SettingsState state) => switch (state) {
  SettingsLoaded(:final localPhotoPath) => localPhotoPath,
  SettingsUploading(:final localPhotoPath) => localPhotoPath,
  SettingsUpdateSuccess(:final localPhotoPath) => localPhotoPath,
  SettingsFailure(:final localPhotoPath) => localPhotoPath,
  _ => null,
};

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({
    required this.user,
    required this.themeMode,
    required this.isUploading,
    required this.localPhotoPath,
  });

  final CustomUser user;
  final ThemeMode themeMode;
  final bool isUploading;
  final String? localPhotoPath;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _ProfileSection(
            user: user,
            isUploading: isUploading,
            localPhotoPath: localPhotoPath,
          ),
          //TODO: localisation
          const _SectionHeader('NOTIFICATIONS'),
          const _NotificationsCard(),
          const _SectionHeader('APP SETTINGS'),
          _AppSettingsCard(themeMode: themeMode),
          const _SectionHeader('ACCOUNT'),
          const _AccountCard(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile section
// ---------------------------------------------------------------------------

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.user,
    required this.isUploading,
    required this.localPhotoPath,
  });

  final CustomUser user;
  final bool isUploading;
  final String? localPhotoPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AvatarStack(isUploading: isUploading, localPhotoPath: localPhotoPath),
        const SizedBox(height: 16),
        Text(
          user.name.isEmpty ? 'User' : user.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => _showEditSheet(context),
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _showEditSheet(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => BlocProvider.value(
            value: cubit,
            child: _EditProfileSheet(currentName: user.name),
          ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.isUploading, required this.localPhotoPath});

  final bool isUploading;
  final String? localPhotoPath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildAvatar(),
        if (isUploading)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black45,
              ),
              child: const Center(
                child: CircularProgressIndicator(color: _primaryBlue),
              ),
            ),
          ),
        Positioned(bottom: 0, right: 0, child: _CameraBadge()),
      ],
    );
  }

  Widget _buildAvatar() {
    final localPath = localPhotoPath;
    if (localPath != null && localPath.isNotEmpty) {
      final localProvider = localFileImageProvider(localPath);
      if (localProvider != null) {
        return CircleAvatar(radius: 52, backgroundImage: localProvider);
      }
    }
    return const _DefaultAvatar();
  }
}

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 52,
      backgroundColor: Color(0xFF1F2937),
      child: Icon(Icons.person, size: 52, color: Colors.white60),
    );
  }
}

class _CameraBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: _primaryBlue,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.photo_camera, color: Colors.white, size: 18),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null && context.mounted) {
        context.read<SettingsCubit>().uploadPhoto(image.path);
      }
    } catch (e) {
      developer.log('Image pick failed', name: 'settings', error: e);
    }
  }
}

// ---------------------------------------------------------------------------
// Section helpers
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8, left: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(children: children),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, required this.color, required this.bg});

  final IconData icon;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

// ---------------------------------------------------------------------------
// Notifications card
// ---------------------------------------------------------------------------

class _NotificationsCard extends StatefulWidget {
  const _NotificationsCard();

  @override
  State<_NotificationsCard> createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<_NotificationsCard> {
  bool _taskReminders = true;
  bool _rewardAlerts = true;

  @override
  Widget build(BuildContext context) {
    return _Card(
      children: [
        _ToggleRow(
          icon: Icons.notifications_active,
          iconColor: _primaryBlue,
          iconBg: const Color(0x1A136DEC),
          title: 'Task Reminders',
          subtitle: 'Alerts for upcoming tasks',
          value: _taskReminders,
          onChanged: (v) => setState(() => _taskReminders = v),
          showDivider: true,
        ),
        _ToggleRow(
          icon: Icons.emoji_events,
          iconColor: Colors.amber,
          iconBg: const Color(0x1AFFC107),
          title: 'Reward Alerts',
          subtitle: 'When partner unlocks a reward',
          value: _rewardAlerts,
          onChanged: (v) => setState(() => _rewardAlerts = v),
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = false,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              _IconBox(icon: icon, color: iconColor, bg: iconBg),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: _primaryBlue,
                activeTrackColor: _primaryBlue.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(color: _borderColor, height: 1, thickness: 1),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// App settings card
// ---------------------------------------------------------------------------

class _AppSettingsCard extends StatelessWidget {
  const _AppSettingsCard({required this.themeMode});

  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return _Card(
      children: [
        _AppearanceRow(themeMode: themeMode, showDivider: true),
        const _LanguageRow(),
      ],
    );
  }
}

class _AppearanceRow extends StatelessWidget {
  const _AppearanceRow({required this.themeMode, this.showDivider = false});

  final ThemeMode themeMode;
  final bool showDivider;

  String get _label => switch (themeMode) {
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
    ThemeMode.system => 'System',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => _showThemeSheet(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const _IconBox(
                  icon: Icons.dark_mode,
                  color: Colors.white70,
                  bg: Color(0xFF1F2937),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Appearance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  _label,
                  style: const TextStyle(
                    color: _primaryBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(color: _borderColor, height: 1, thickness: 1),
      ],
    );
  }

  void _showThemeSheet(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (sheetContext) => _ThemePickerSheet(
            current: themeMode,
            onSelect: (mode) {
              cubit.setTheme(mode);
              Navigator.pop(sheetContext);
            },
          ),
    );
  }
}

class _ThemePickerSheet extends StatelessWidget {
  const _ThemePickerSheet({required this.current, required this.onSelect});

  final ThemeMode current;
  final ValueChanged<ThemeMode> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Appearance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Light'),
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('System'),
                icon: Icon(Icons.contrast),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode),
              ),
            ],
            selected: {current},
            onSelectionChanged: (modes) => onSelect(modes.first),
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: _primaryBlue,
              selectedForegroundColor: Colors.white,
              foregroundColor: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: const [
          _IconBox(
            icon: Icons.language,
            color: Colors.white70,
            bg: Color(0xFF1F2937),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Language',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            'English (US)',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Account card
// ---------------------------------------------------------------------------

class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      children: [
        InkWell(
          onTap: () => context.read<SettingsCubit>().signOut(),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                _IconBox(
                  icon: Icons.logout,
                  color: Colors.red.shade400,
                  bg: Colors.red.withValues(alpha: 0.1),
                ),
                const SizedBox(width: 16),
                Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Edit profile bottom sheet
// ---------------------------------------------------------------------------

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({required this.currentName});

  final String currentName;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Display Name',
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: _borderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: _primaryBlue),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _save(context),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _save(BuildContext context) {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    context.read<SettingsCubit>().updateDisplayName(name);
    Navigator.pop(context);
  }
}

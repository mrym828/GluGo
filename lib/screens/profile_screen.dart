import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/shared_components.dart';
import '../utils/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _animationController.forward();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusM),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusL),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppTheme.errorRed),
            const SizedBox(width: AppTheme.spacingM),
            const Text('Delete Account'),
          ],
        ),
        content: Text(
          'This action cannot be undone. All your data will be permanently deleted.',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Account deletion initiated');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserProfileCard(),
                const SizedBox(height: AppTheme.spacingXL),
                _buildAccountSection(),
                const SizedBox(height: AppTheme.spacingXL),
                _buildHealthSettingsSection(),
                const SizedBox(height: AppTheme.spacingXL),
                _buildLogoutSection(),
                const SizedBox(height: AppTheme.spacingXXL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return SharedAppBar(
      title: 'GluGo',
      showBackButton: false,
      showConnection: true,
      actions: [
        IconButton(
          onPressed: () => _showSnackBar('Settings coming soon'),
          icon: const Icon(Icons.settings_rounded, color: Colors.white),
          tooltip: 'Settings',
        ),
      ],
    );
  }

  Widget _buildUserProfileCard() {
    return BaseCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryBlue,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://i.pravatar.cc/150?img=47',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Malak Nasr',
                      style: AppTheme.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'aisha@example.com',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Row(
                      children: [
                        StatusBadge(
                          label: 'Type 2',
                          color: AppTheme.primaryBlue,
                          icon: Icons.favorite_rounded,
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        StatusBadge(
                          label: 'UAE',
                          color: AppTheme.successGreen,
                          icon: Icons.location_on_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _showSnackBar('Edit profile coming soon');
                },
                icon: Container(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: AppTheme.radiusS,
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: AppTheme.primaryBlue,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          Divider(
            color: AppTheme.borderLight,
            height: 1,
          ),
          const SizedBox(height: AppTheme.spacingL),
          Row(
            children: [
              Expanded(
                child: _ProfileStatItem(
                  label: 'Days Active',
                  value: '127',
                  icon: Icons.calendar_today_rounded,
                  color: AppTheme.primaryBlue,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppTheme.borderLight,
              ),
              Expanded(
                child: _ProfileStatItem(
                  label: 'Readings',
                  value: '1,847',
                  icon: Icons.bloodtype_rounded,
                  color: AppTheme.successGreen,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppTheme.borderLight,
              ),
              Expanded(
                child: _ProfileStatItem(
                  label: 'Avg Range',
                  value: '78%',
                  icon: Icons.timeline_rounded,
                  color: AppTheme.insightsColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Account',
        ),
        const SizedBox(height: AppTheme.spacingL),
        BaseCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _ProfileSettingTile(
                icon: Icons.lock_rounded,
                iconColor: AppTheme.primaryBlue,
                title: 'Privacy & Security',
                subtitle: 'Manage password, 2FA and sessions',
                trailing: StatusBadge(
                  label: '2FA On',
                  color: AppTheme.successGreen,
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showSnackBar('Privacy settings coming soon');
                },
              ),
              _ProfileSettingTile(
                icon: Icons.notifications_rounded,
                iconColor: AppTheme.warningOrange,
                title: 'Notifications',
                subtitle: 'Push, email, glucose alerts',
                trailing: StatusBadge(
                  label: 'Enabled',
                  color: AppTheme.successGreen,
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showSnackBar('Notification settings coming soon');
                },
              ),
              _ProfileSettingTile(
                icon: Icons.language_rounded,
                iconColor: AppTheme.insightsColor,
                title: 'Language',
                subtitle: 'English / العربية',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textTertiary,
                  size: 20,
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showSnackBar('Language selection coming soon');
                },
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Health Settings',
        ),
        const SizedBox(height: AppTheme.spacingL),
        BaseCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _ProfileSettingTile(
                icon: Icons.show_chart_rounded,
                iconColor: AppTheme.successGreen,
                title: 'Glucose Range',
                subtitle: 'Target and alerts',
                trailing: Text(
                  '70-180 mg/dL',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showSnackBar('Glucose range settings coming soon');
                },
              ),
              _ProfileSettingTile(
                icon: Icons.devices_rounded,
                iconColor: AppTheme.primaryBlue,
                title: 'Connected Devices',
                subtitle: 'Sensors and apps',
                trailing: StatusBadge(
                  label: 'CGM Linked',
                  color: AppTheme.primaryBlue,
                  icon: Icons.check_circle_rounded,
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/device');
                },
              ),
              _ProfileSettingTile(
                icon: Icons.restaurant_rounded,
                iconColor: AppTheme.mealColor,
                title: 'Meal Preferences',
                subtitle: 'Dietary filters and cuisines',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textTertiary,
                  size: 20,
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showSnackBar('Meal preferences coming soon');
                },
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutSection() {
    return Column(
      children: [
        BaseCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showSnackBar('Logout initiated');
                  },
                  borderRadius: AppTheme.radiusL,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacingS),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: AppTheme.radiusS,
                          ),
                          child: Icon(
                            Icons.logout_rounded,
                            color: AppTheme.primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingL),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Log Out',
                                style: AppTheme.titleSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Sign out from this device',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppTheme.textTertiary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.errorRed.withOpacity(0.05),
                AppTheme.errorRed.withOpacity(0.02),
              ],
            ),
            borderRadius: AppTheme.radiusL,
            border: Border.all(
              color: AppTheme.errorRed.withOpacity(0.2),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                _showDeleteAccountDialog();
              },
              borderRadius: AppTheme.radiusL,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_forever_rounded,
                      color: AppTheme.errorRed,
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Text(
                      'Delete Account',
                      style: AppTheme.titleSmall.copyWith(
                        color: AppTheme.errorRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Profile Stat Item Widget
class _ProfileStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ProfileStatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingS),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: AppTheme.radiusS,
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          value,
          style: AppTheme.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

// Profile Setting Tile Widget
class _ProfileSettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;
  final bool showDivider;

  const _ProfileSettingTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListItem(
      icon: icon,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      showDivider: showDivider,
    );
  }
}
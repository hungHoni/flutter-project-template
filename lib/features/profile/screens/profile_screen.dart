import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app/providers/auth_provider.dart';
import '../../../features/onboarding/models/onboarding_state.dart';
import '../../../shared/widgets/selectable_chip.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../providers/user_profile_provider.dart';
import '../repositories/user_profile_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final uid = ref.watch(authStateProvider).valueOrNull?.uid;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(
            child: Text(
              'Could not load profile.',
              style: AppTypography.body.copyWith(color: AppColors.textMeta),
            ),
          ),
          data: (profile) {
            // Show defaults if profile not yet created.
            final role = profile?.role ?? 'Software Engineer';
            final level = profile?.level ?? 'Intermediate';
            final skills = profile?.skills ?? <String>[];
            final feedSources = profile?.feedSources ??
                availableSources
                    .where((s) => s.defaultEnabled)
                    .map((s) => s.name)
                    .toList();

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              children: [
                const SizedBox(height: AppSpacing.md),
                Text('Profile', style: AppTypography.display),
                const SizedBox(height: AppSpacing.xs),
                Text('YOUR SETTINGS', style: AppTypography.meta),
                const SizedBox(height: AppSpacing.xl),

                // ── Role section ──
                const _SectionHeader(label: 'YOUR ROLE'),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: availableRoles.map((r) {
                    return SelectableChip(
                      label: r,
                      isSelected: role == r,
                      onTap: () => _updateField(ref, uid, 'role', r),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Experience section ──
                const _SectionHeader(label: 'EXPERIENCE LEVEL'),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: ['Beginner', 'Intermediate', 'Advanced'].map((l) {
                    return SelectableChip(
                      label: l,
                      isSelected: level == l,
                      onTap: () => _updateField(ref, uid, 'level', l),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Skills section ──
                _SectionHeader(
                  label: 'YOUR SKILLS',
                  trailing: '${skills.length} selected',
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: availableSkills.map((skill) {
                    final isSelected = skills.contains(skill);
                    return SelectableChip(
                      label: skill,
                      isSelected: isSelected,
                      onTap: () {
                        final updated = List<String>.from(skills);
                        if (isSelected) {
                          updated.remove(skill);
                        } else {
                          updated.add(skill);
                        }
                        _updateField(ref, uid, 'skills', updated);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Feed sources section ──
                const _SectionHeader(label: 'FEED SOURCES'),
                const SizedBox(height: AppSpacing.md),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < availableSources.length; i++) ...[
                        _SourceRow(
                          source: availableSources[i],
                          isEnabled: feedSources.contains(
                            availableSources[i].name,
                          ),
                          onToggle: () {
                            final updated = List<String>.from(feedSources);
                            final name = availableSources[i].name;
                            if (updated.contains(name)) {
                              updated.remove(name);
                            } else {
                              updated.add(name);
                            }
                            _updateField(ref, uid, 'feedSources', updated);
                          },
                        ),
                        if (i < availableSources.length - 1)
                          const Divider(
                            height: 1,
                            color: AppColors.border,
                            indent: AppSpacing.md,
                            endIndent: AppSpacing.md,
                          ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── About section ──
                const _SectionHeader(label: 'ABOUT'),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AboutRow(
                        label: 'App',
                        value: 'AI Skill Radar v0.1.0',
                      ),
                      SizedBox(height: AppSpacing.sm),
                      _AboutRow(
                        label: 'Data',
                        value: 'Stored locally + Firebase',
                      ),
                      SizedBox(height: AppSpacing.sm),
                      _AboutRow(
                        label: 'AI',
                        value: 'Claude API for summaries',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            );
          },
        ),
      ),
    );
  }

  void _updateField(WidgetRef ref, String? uid, String field, dynamic value) {
    if (uid == null) return;
    ref.read(userProfileRepositoryProvider).updateField(uid, field, value);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, this.trailing});
  final String label;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTypography.label.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        if (trailing != null) ...[
          const Spacer(),
          Text(
            trailing!,
            style: AppTypography.meta.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ],
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({
    required this.source,
    required this.isEnabled,
    required this.onToggle,
  });
  final FeedSource source;
  final bool isEnabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          PhosphorIcon(
            AppIcons.feed,
            size: AppIcons.sm,
            color: AppColors.textMeta,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(source.name, style: AppTypography.title),
                Text(
                  source.category.toUpperCase(),
                  style: AppTypography.meta,
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isEnabled,
            onChanged: (_) => onToggle(),
            activeTrackColor: AppColors.primary,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label.toUpperCase(),
            style: AppTypography.meta.copyWith(
              color: AppColors.textMeta,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: AppTypography.body),
        ),
      ],
    );
  }
}

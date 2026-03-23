import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../features/onboarding/models/onboarding_state.dart';
import '../../../shared/widgets/selectable_chip.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

/// Mock profile state — will be replaced by Firestore + Riverpod providers.
class _ProfileState {
  String role = 'Software Engineer';
  List<String> skills = ['Python', 'LLM APIs', 'Agents', 'RAG'];
  String experienceLevel = 'Intermediate';
  List<String> feedSources = [
    'r/MachineLearning',
    'r/LocalLLaMA',
    'Hacker News',
    'AI Blogs',
  ];
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _state = _ProfileState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: ListView(
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
              children: availableRoles.map((role) {
                return SelectableChip(
                  label: role,
                  isSelected: _state.role == role,
                  onTap: () => setState(() => _state.role = role),
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
              children: ['Beginner', 'Intermediate', 'Advanced'].map((level) {
                return SelectableChip(
                  label: level,
                  isSelected: _state.experienceLevel == level,
                  onTap: () => setState(() => _state.experienceLevel = level),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Skills section ──
            _SectionHeader(
              label: 'YOUR SKILLS',
              trailing: '${_state.skills.length} selected',
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: availableSkills.map((skill) {
                final isSelected = _state.skills.contains(skill);
                return SelectableChip(
                  label: skill,
                  isSelected: isSelected,
                  onTap: () => setState(() {
                    if (isSelected) {
                      _state.skills.remove(skill);
                    } else {
                      _state.skills.add(skill);
                    }
                  }),
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
                      isEnabled: _state.feedSources
                          .contains(availableSources[i].name),
                      onToggle: () => setState(() {
                        final name = availableSources[i].name;
                        if (_state.feedSources.contains(name)) {
                          _state.feedSources.remove(name);
                        } else {
                          _state.feedSources.add(name);
                        }
                      }),
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
                  _AboutRow(label: 'App', value: 'AI Skill Radar v0.1.0'),
                  SizedBox(height: AppSpacing.sm),
                  _AboutRow(label: 'Data', value: 'Stored locally + Firebase'),
                  SizedBox(height: AppSpacing.sm),
                  _AboutRow(label: 'AI', value: 'Claude API for summaries'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
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

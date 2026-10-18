import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';

const String kServerBaseUrl = 'http://stonemen.bsninfotech.org/';

/// Server returns image paths like "../Uploads/x.png" — make them absolute.
String? resolveImageUrl(String? url) {
  if (url == null || url.trim().isEmpty) return null;
  final u = url.trim();
  if (u.startsWith('http')) return u;
  return u.replaceAll('../', kServerBaseUrl);
}

/// Formats "2026-10-18T10:30:00" into ("18 Oct 2026", "10:30 AM").
/// Falls back to the raw text if parsing fails.
({String date, String time}) splitMeetingDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) return (date: '—', time: '');
  final parsed = DateTime.tryParse(raw.trim());
  if (parsed == null) {
    final parts = raw.split('T');
    return (date: parts.first, time: parts.length > 1 ? parts[1] : '');
  }
  return (
    date: DateFormat('dd MMM yyyy').format(parsed),
    time: DateFormat('hh:mm a').format(parsed),
  );
}

String initialsOf(String? name) {
  final n = (name ?? '').trim();
  if (n.isEmpty) return '?';
  final parts = n.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return (parts[0][0] + parts[1][0]).toUpperCase();
}

String valueOrDash(String? v) =>
    (v == null || v.trim().isEmpty || v == 'null') ? '—' : v.trim();

/// Circular avatar that shows a network image, falling back to initials.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 48,
    this.backgroundColor = AppColors.primarySoft,
    this.foregroundColor = AppColors.primary,
    this.borderColor,
  });

  final String? imageUrl;
  final String name;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final url = resolveImageUrl(imageUrl);
    final fallback = Center(
      child: Text(
        initialsOf(name),
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
        ),
      ),
    );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 2.5)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: url == null
          ? fallback
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => fallback,
            ),
    );
  }
}

/// Small rounded label, e.g. a status.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    required this.background,
    this.icon,
  });

  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// White rounded card used across the app.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: AppShadows.soft,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Icon + label + value row used in detail screens and cards.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.dense = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dense ? 6 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: dense ? 32 : 38,
            height: dense ? 32 : 38,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon,
                size: dense ? 16 : 18, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  valueOrDash(value),
                  style: TextStyle(
                    fontSize: dense ? 14 : 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Friendly empty / error placeholder.
class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.color = AppColors.primary,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 38, color: color),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(140, 46),
                ),
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Lightweight shimmer-free skeleton for list loading.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 4});
  final int count;

  @override
  Widget build(BuildContext context) {
    Widget bar(double w, double h) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: const Color(0xFFEDEFF4),
            borderRadius: BorderRadius.circular(6),
          ),
        );
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                    color: Color(0xFFEDEFF4), shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [bar(140, 14), const SizedBox(height: 8), bar(100, 10)],
              ),
            ]),
            const SizedBox(height: 16),
            bar(double.infinity, 10),
            const SizedBox(height: 8),
            bar(180, 10),
          ],
        ),
      ),
    );
  }
}

/// Visual style of a meeting category (used by lists and dashboard).
class MeetingTone {
  const MeetingTone(this.color, this.soft, this.icon, this.label);
  final Color color;
  final Color soft;
  final IconData icon;
  final String label;

  static const actionable = MeetingTone(AppColors.violet, Color(0xFFEEECFD),
      Icons.pending_actions_rounded, 'Action needed');
  static const ongoing = MeetingTone(AppColors.teal, Color(0xFFE3F6F9),
      Icons.groups_rounded, 'Ongoing');
  static const scheduled = MeetingTone(AppColors.orange, Color(0xFFFEF2E2),
      Icons.event_rounded, 'Scheduled');
  static const completed = MeetingTone(AppColors.green, Color(0xFFE4F7EC),
      Icons.task_alt_rounded, 'Completed');
}

/// Card summarising one visitor meeting.
class MeetingCard extends StatelessWidget {
  const MeetingCard({
    super.key,
    required this.visitorName,
    required this.email,
    required this.host,
    required this.meetingDate,
    required this.purpose,
    required this.tone,
    this.photoUrl,
    this.onTap,
  });

  final String visitorName;
  final String email;
  final String host;
  final String meetingDate;
  final String purpose;
  final MeetingTone tone;
  final String? photoUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dt = splitMeetingDate(meetingDate);
    return SurfaceCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                AppAvatar(
                  imageUrl: photoUrl,
                  name: visitorName,
                  size: 46,
                  backgroundColor: tone.soft,
                  foregroundColor: tone.color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        valueOrDash(visitorName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        valueOrDash(email),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusPill(
                  label: tone.label,
                  color: tone.color,
                  background: tone.soft,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              children: [
                _meta(Icons.person_outline_rounded, 'Meeting with', host),
                const SizedBox(height: 10),
                _meta(Icons.flag_outlined, 'Purpose', purpose),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 15, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(dt.date,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                      const Spacer(),
                      if (dt.time.isNotEmpty) ...[
                        const Icon(Icons.schedule_rounded,
                            size: 15, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(dt.time,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                      ],
                      if (onTap != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right_rounded,
                            size: 20, color: AppColors.textMuted),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _meta(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Text('$label  ',
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary)),
        Expanded(
          child: Text(
            valueOrDash(value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// From / To date filter with a search button.
class DateRangeBar extends StatelessWidget {
  const DateRangeBar({
    super.key,
    required this.from,
    required this.to,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSearch,
  });

  final String from;
  final String to;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(child: _dateTile('From', from, onPickFrom)),
          Container(
            width: 1,
            height: 36,
            color: AppColors.border,
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),
          Expanded(child: _dateTile('To', to, onPickTo)),
          const SizedBox(width: 8),
          SizedBox(
            height: 48,
            width: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(48, 48),
              ),
              onPressed: onSearch,
              child: const Icon(Icons.search_rounded, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateTile(String label, String value, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            const Icon(Icons.event_outlined,
                size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared scaffold for every meeting list screen: header, date filter,
/// loading / empty / error states and pull-to-refresh.
class MeetingListLayout extends StatelessWidget {
  const MeetingListLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tone,
    required this.fromDate,
    required this.toDate,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSearch,
    required this.isLoading,
    required this.hasError,
    required this.itemCount,
    required this.itemBuilder,
  });

  final String title;
  final String subtitle;
  final MeetingTone tone;
  final String fromDate;
  final String toDate;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final Future<void> Function() onSearch;
  final bool isLoading;
  final bool hasError;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (isLoading) {
      body = const SkeletonList();
    } else if (hasError) {
      body = StateMessage(
        icon: Icons.wifi_off_rounded,
        title: 'Couldn\'t load meetings',
        message: 'Check your internet connection and try again.',
        actionLabel: 'Try again',
        onAction: onSearch,
        color: AppColors.danger,
      );
    } else if (itemCount == 0) {
      body = StateMessage(
        icon: tone.icon,
        title: 'No meetings found',
        message: 'There are no records between $fromDate and $toDate.\n'
            'Try a different date range.',
        color: tone.color,
      );
    } else {
      body = RefreshIndicator(
        onRefresh: onSearch,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: itemCount + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(left: 4, top: 4),
                child: Text(
                  '$itemCount ${itemCount == 1 ? 'record' : 'records'}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            return itemBuilder(context, index - 1);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: DateRangeBar(
              from: fromDate,
              to: toDate,
              onPickFrom: onPickFrom,
              onPickTo: onPickTo,
              onSearch: onSearch,
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

/// Section title used on dashboard / details.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

void showAppSnack(BuildContext context, String message,
    {bool error = false, bool success = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: error
            ? AppColors.danger
            : success
                ? AppColors.success
                : AppColors.textPrimary,
        content: Row(
          children: [
            Icon(
              error
                  ? Icons.error_outline_rounded
                  : success
                      ? Icons.check_circle_outline_rounded
                      : Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}

/// App brand mark (replace the icon with your logo asset when available).
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 60});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: size * 0.4,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: ShaderMask(
        shaderCallback: (r) => AppColors.brandGradient.createShader(r),
        child: Icon(Icons.how_to_reg_rounded,
            size: size * 0.52, color: Colors.white),
      ),
    );
  }
}

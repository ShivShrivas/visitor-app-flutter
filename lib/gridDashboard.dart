import 'package:flutter/material.dart';
import 'package:visitor_app_flutter/ActionableList.dart';
import 'package:visitor_app_flutter/CompleteMeetList.dart';
import 'package:visitor_app_flutter/OnGoingMeetList.dart';
import 'package:visitor_app_flutter/ScheduleMeetList.dart';

import 'theme/app_theme.dart';
import 'widgets/app_widgets.dart';

/// Today's counts per category; null = still loading / unknown.
class DashboardCounts {
  const DashboardCounts({
    this.actionable,
    this.ongoing,
    this.scheduled,
    this.completed,
  });
  final int? actionable;
  final int? ongoing;
  final int? scheduled;
  final int? completed;
}

/// Colourful staggered status cards (Actionable / Ongoing / Scheduled /
/// Completed). Tapping a card opens its list; [onReturn] fires when the
/// user comes back so the dashboard can refresh.
class GridDashboard extends StatelessWidget {
  final int relationShipId;
  final int userId;
  final DashboardCounts counts;
  final VoidCallback? onReturn;

  const GridDashboard({
    Key? key,
    required this.relationShipId,
    required this.userId,
    this.counts = const DashboardCounts(),
    this.onReturn,
  }) : super(key: key);

  Future<void> _open(BuildContext context, WidgetBuilder builder) async {
    await Navigator.push(context, MaterialPageRoute(builder: builder));
    onReturn?.call();
  }

  @override
  Widget build(BuildContext context) {
    final actionable = _StatusCard(
      title: 'Actionable',
      count: counts.actionable,
      unit: 'awaiting you',
      tone: MeetingTone.actionable,
      height: 184,
      onTap: () => _open(
          context,
          (_) => ActionableList(
              relationShipId: relationShipId, userId: userId)),
    );
    final ongoing = _StatusCard(
      title: 'Ongoing',
      count: counts.ongoing,
      unit: 'in progress',
      tone: MeetingTone.ongoing,
      height: 150,
      onTap: () => _open(
          context,
          (_) => OnGoingMeetList(
              relationShipId: relationShipId, userId: userId)),
    );
    final scheduled = _StatusCard(
      title: 'Scheduled',
      count: counts.scheduled,
      unit: 'today',
      tone: MeetingTone.scheduled,
      height: 150,
      onTap: () => _open(
          context,
          (_) => ScheduleMeetList(
              relationShipId: relationShipId, userId: userId)),
    );
    final completed = _StatusCard(
      title: 'Completed',
      count: counts.completed,
      unit: 'done today',
      tone: MeetingTone.completed,
      height: 184,
      onTap: () => _open(
          context,
          (_) => ComplteteMeetList(
              relationShipId: relationShipId, userId: userId)),
    );

    const gap = 14.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(children: [actionable, const SizedBox(height: gap), scheduled]),
        ),
        const SizedBox(width: gap),
        Expanded(
          child: Column(children: [
            ongoing,
            const SizedBox(height: gap),
            completed,
          ]),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.count,
    required this.unit,
    required this.tone,
    required this.height,
    required this.onTap,
  });

  final String title;
  final int? count;
  final String unit;
  final MeetingTone tone;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = tone.color;
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg + 2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(c, Colors.white, 0.08)!, c],
        ),
        boxShadow: [
          BoxShadow(
            color: c.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg + 2),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              // decorative circle
              Positioned(
                right: -26,
                top: -26,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(tone.icon, color: Colors.white, size: 22),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: count == null
                              ? Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 70,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                )
                              : Text(
                                  '$count $unit',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                        const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitor_app_flutter/models/ActionableListResponse.dart';

import 'theme/app_theme.dart';
import 'widgets/app_widgets.dart';
import 'network/api_logger.dart';

class ActionableDetailsPage extends StatefulWidget {
  final ActionableListResponse listResponse;
  final int relationShipId;
  final int userId;
  const ActionableDetailsPage(
      {Key? key,
      required this.listResponse,
      required this.userId,
      required this.relationShipId})
      : super(key: key);

  @override
  State<ActionableDetailsPage> createState() => _ActionableDetailsPageState();
}

class _ActionableDetailsPageState extends State<ActionableDetailsPage> {
  final _formKeyRemark = GlobalKey<FormState>();
  final TextEditingController remarkController = TextEditingController();

  @override
  void dispose() {
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.listResponse;
    final dt = splitMeetingDate(v.meetingDate);

    return Scaffold(
      appBar: AppBar(title: const Text('Visitor details')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // Profile card
          SurfaceCard(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              children: [
                AppAvatar(
                  imageUrl: v.photo,
                  name: v.visitorName,
                  size: 96,
                  backgroundColor: MeetingTone.actionable.soft,
                  foregroundColor: MeetingTone.actionable.color,
                ),
                const SizedBox(height: 14),
                Text(
                  valueOrDash(v.visitorName),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                StatusPill(
                  label: valueOrDash(v.status) == '—'
                      ? MeetingTone.actionable.label
                      : v.status,
                  color: MeetingTone.actionable.color,
                  background: MeetingTone.actionable.soft,
                  icon: MeetingTone.actionable.icon,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _quickStat(
                          Icons.calendar_today_rounded, 'Date', dt.date),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _quickStat(Icons.schedule_rounded, 'Time',
                          dt.time.isEmpty ? '—' : dt.time),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionTitle('Contact'),
          const SizedBox(height: 10),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              children: [
                InfoRow(
                    icon: Icons.mail_outline_rounded,
                    label: 'Email',
                    value: v.emailId),
                const Divider(),
                InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Mobile',
                    value: v.mobileNo),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionTitle('Meeting'),
          const SizedBox(height: 10),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              children: [
                InfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Meeting with',
                    value: v.name),
                const Divider(),
                InfoRow(
                    icon: Icons.flag_outlined,
                    label: 'Purpose',
                    value: v.purposeName),
                const Divider(),
                InfoRow(
                    icon: Icons.badge_outlined,
                    label: 'Visitor pass',
                    value: v.physicalVisitorPassName),
                const Divider(),
                InfoRow(
                    icon: Icons.credit_card_rounded,
                    label: 'Government ID',
                    value: v.govermentName),
                const Divider(),
                InfoRow(
                    icon: Icons.work_outline_rounded,
                    label: 'Belongings',
                    value: v.belongingName),
                if (valueOrDash(v.remark) != '—') ...[
                  const Divider(),
                  InfoRow(
                      icon: Icons.notes_rounded,
                      label: 'Remarks',
                      value: v.remark),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                  ),
                  onPressed: () => openDialogForRemarks("Reject", 3),
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  onPressed: () => openDialogForRemarks("Allow", 6),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Allow'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickStat(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11.5, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Returns true on success.
  Future<bool> setStatus(String s, int i, String remark) async {
    final body = {
      "Action": 1,
      "RelationshipId": 8,
      "FYId": 1,
      "PTransId": widget.listResponse.transId,
      "SessionId": 1,
      "Status": i,
      "Remarks": remark,
      "isAction": i,
      "TransId": ""
    };
    try {
      final response = await apiClient.post(
        Uri.parse(
            'http://stonemen.bsninfotech.org/Api/VisitorTransactionApi/InsertVisitorNotificationGenerate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
        encoding: Encoding.getByName('utf-8'),
      );
      return response.body == '"1"';
    } catch (e) {
      appLogger.e('setStatus error', error: e);
      return false;
    }
  }

  Future openDialogForRemarks(String s, int i) {
    final isAllow = i == 6;
    final color = isAllow ? AppColors.success : AppColors.danger;
    bool saving = false;
    remarkController.clear();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 24),
            child: Form(
              key: _formKeyRemark,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isAllow ? Icons.check_rounded : Icons.close_rounded,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAllow ? 'Allow visitor' : 'Reject visitor',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              valueOrDash(widget.listResponse.visitorName),
                              style: const TextStyle(
                                  fontSize: 13.5,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: remarkController,
                    autofocus: true,
                    minLines: 3,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? "Please enter a remark"
                        : null,
                    decoration: const InputDecoration(
                      hintText: 'Add a remark for this decision',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: saving
                              ? null
                              : () => Navigator.pop(sheetContext),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          style:
                              FilledButton.styleFrom(backgroundColor: color),
                          onPressed: saving
                              ? null
                              : () async {
                                  if (!_formKeyRemark.currentState!
                                      .validate()) {
                                    return;
                                  }
                                  setSheetState(() => saving = true);
                                  final ok = await setStatus(
                                      s, i, remarkController.text.trim());
                                  if (!mounted) return;
                                  if (ok) {
                                    Navigator.pop(sheetContext);
                                    showAppSnack(
                                      this.context,
                                      isAllow
                                          ? 'Visitor allowed'
                                          : 'Visitor rejected',
                                      success: true,
                                    );
                                    Navigator.pop(this.context, true);
                                  } else {
                                    setSheetState(() => saving = false);
                                    showAppSnack(this.context,
                                        'Something went wrong. Please try again.',
                                        error: true);
                                  }
                                },
                          child: saving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.4, color: Colors.white),
                                )
                              : Text(isAllow ? 'Confirm allow' : 'Confirm reject'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

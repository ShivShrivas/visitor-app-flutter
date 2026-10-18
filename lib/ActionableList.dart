import 'package:flutter/material.dart';
import 'package:visitor_app_flutter/ActionableDetailsPage.dart';
import 'package:visitor_app_flutter/models/ActionableListResponse.dart';

import 'network/meeting_api.dart';
import 'widgets/app_widgets.dart';
import 'widgets/meeting_list_mixin.dart';

class ActionableList extends StatefulWidget {
  final int relationShipId;
  final int userId;
  const ActionableList(
      {Key? key, required this.relationShipId, required this.userId})
      : super(key: key);

  @override
  State<ActionableList> createState() => _ActionableListState();
}

class _ActionableListState extends State<ActionableList>
    with MeetingListMixin<ActionableList, ActionableListResponse> {
  @override
  Future<List<ActionableListResponse>> fetch(String fromDate, String toDate) =>
      MeetingApi.actionable(
          widget.relationShipId, widget.userId, fromDate, toDate);

  @override
  Widget build(BuildContext context) {
    return MeetingListLayout(
      title: 'Actionable',
      subtitle: 'Visitors awaiting your response',
      tone: MeetingTone.actionable,
      fromDate: fromDateGlobal,
      toDate: toDateGlobal,
      onPickFrom: pickFrom,
      onPickTo: pickTo,
      onSearch: load,
      isLoading: isLoading,
      hasError: hasError,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final m = items[index];
        return MeetingCard(
          visitorName: m.visitorName,
          email: m.emailId,
          host: m.authPersionName,
          meetingDate: m.meetingDate,
          purpose: m.purposeName,
          photoUrl: m.photo,
          tone: MeetingTone.actionable,
          onTap: () async {
            final changed = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (context) => ActionableDetailsPage(
                  listResponse: m,
                  userId: widget.userId,
                  relationShipId: widget.relationShipId,
                ),
              ),
            );
            if (changed == true) load();
          },
        );
      },
    );
  }
}

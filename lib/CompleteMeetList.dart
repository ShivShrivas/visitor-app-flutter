import 'package:flutter/material.dart';

import 'models/ScheduleMeetingResponse.dart';
import 'network/meeting_api.dart';
import 'widgets/app_widgets.dart';
import 'widgets/meeting_list_mixin.dart';

class ComplteteMeetList extends StatefulWidget {
  final int relationShipId;
  final int userId;
  const ComplteteMeetList(
      {Key? key, required this.relationShipId, required this.userId})
      : super(key: key);

  @override
  State<ComplteteMeetList> createState() => _ComplteteMeetListState();
}

class _ComplteteMeetListState extends State<ComplteteMeetList>
    with MeetingListMixin<ComplteteMeetList, ScheduleMeetingResponse> {

  @override
  Future<List<ScheduleMeetingResponse>> fetch(String fromDate, String toDate) =>
      MeetingApi.completed(
          widget.relationShipId, widget.userId, fromDate, toDate);

  @override
  Widget build(BuildContext context) {
    return MeetingListLayout(
      title: 'Completed',
      subtitle: 'Meeting history',
      tone: MeetingTone.completed,
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
          visitorName: m.visitorName ?? '',
          email: m.emailId ?? '',
          host: m.personName ?? '',
          meetingDate: m.meetingDate ?? '',
          purpose: m.purposeName ?? '',
          tone: MeetingTone.completed,
        );
      },
    );
  }
}

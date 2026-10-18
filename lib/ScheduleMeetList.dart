import 'package:flutter/material.dart';

import 'models/ScheduleMeetingResponse.dart';
import 'network/meeting_api.dart';
import 'widgets/app_widgets.dart';
import 'widgets/meeting_list_mixin.dart';

class ScheduleMeetList extends StatefulWidget {
  final int relationShipId;
  final int userId;
  const ScheduleMeetList(
      {Key? key, required this.relationShipId, required this.userId})
      : super(key: key);

  @override
  State<ScheduleMeetList> createState() => _ScheduleMeetListState();
}

class _ScheduleMeetListState extends State<ScheduleMeetList>
    with MeetingListMixin<ScheduleMeetList, ScheduleMeetingResponse> {
  @override
  bool get allowFutureDates => true;

  @override
  Future<List<ScheduleMeetingResponse>> fetch(String fromDate, String toDate) =>
      MeetingApi.scheduled(
          widget.relationShipId, widget.userId, fromDate, toDate);

  @override
  Widget build(BuildContext context) {
    return MeetingListLayout(
      title: 'Scheduled',
      subtitle: 'Upcoming appointments',
      tone: MeetingTone.scheduled,
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
          tone: MeetingTone.scheduled,
        );
      },
    );
  }
}

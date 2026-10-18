import 'package:flutter/material.dart';

import 'models/ScheduleMeetingResponse.dart';
import 'network/meeting_api.dart';
import 'widgets/app_widgets.dart';
import 'widgets/meeting_list_mixin.dart';

class OnGoingMeetList extends StatefulWidget {
  final int relationShipId;
  final int userId;
  const OnGoingMeetList(
      {Key? key, required this.relationShipId, required this.userId})
      : super(key: key);

  @override
  State<OnGoingMeetList> createState() => _OnGoingMeetListState();
}

class _OnGoingMeetListState extends State<OnGoingMeetList>
    with MeetingListMixin<OnGoingMeetList, ScheduleMeetingResponse> {

  @override
  Future<List<ScheduleMeetingResponse>> fetch(String fromDate, String toDate) =>
      MeetingApi.ongoing(
          widget.relationShipId, widget.userId, fromDate, toDate);

  @override
  Widget build(BuildContext context) {
    return MeetingListLayout(
      title: 'Ongoing',
      subtitle: 'Meetings in progress',
      tone: MeetingTone.ongoing,
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
          tone: MeetingTone.ongoing,
        );
      },
    );
  }
}

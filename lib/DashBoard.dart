import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor_app_flutter/SplashScreen.dart';
import 'package:visitor_app_flutter/NotificationPage.dart';
import 'package:visitor_app_flutter/ScheduleMeetList.dart';
import 'package:visitor_app_flutter/UserProfile.dart';
import 'package:visitor_app_flutter/models/LoginResponse.dart';
import 'package:visitor_app_flutter/models/MeetingWithResponse.dart';
import 'package:visitor_app_flutter/models/PurposeResponse.dart';
import 'package:visitor_app_flutter/models/ScheduleMeetingResponse.dart';
import 'package:visitor_app_flutter/network/meeting_api.dart';

import 'gridDashboard.dart';
import 'theme/app_theme.dart';
import 'widgets/app_widgets.dart';
import 'widgets/searchable_dropdown.dart';
import 'network/api_logger.dart';

class Dashboard extends StatefulWidget {
  final LoginResponse loginResponse;

  const Dashboard(
      {Key? key,
      required this.loginResponse,
      required LoginResponse LoginResponse})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<PurposeResponse> currencies = [];
  List<MeetingWithResponse> meetingWithResponseList = [];
  bool _lookupsLoading = true;

  final _formKey = GlobalKey<FormState>();
  String selectedPurpose = "";
  String selectedPerson = "";
  TimeOfDay? _selectedTime;
  bool _submitting = false;

  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  static const _base = 'http://stonemen.bsninfotech.org/Api/';
  static const _headers = {'Content-Type': 'application/json'};

  @override
  void initState() {
    super.initState();
    _loadLookups();
    _loadCounts();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSchedule());
  }

  @override
  void dispose() {
    _dayScroll.dispose();
    timeController.dispose();
    dateController.dispose();
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  Future<void> _loadLookups() async {
    setState(() => _lookupsLoading = true);
    await Future.wait([getPurposeResponse(), getMeetingWithResponse()]);
    if (mounted) setState(() => _lookupsLoading = false);
  }

  Future<void> getMeetingWithResponse() async {
    final body = {
      "Action": 7,
      "FYId": 1,
      "SessionId": 1,
      "RelationshipId": widget.loginResponse.relationshipId
    };
    try {
      final response = await apiClient.post(
        Uri.parse('${_base}VisitorTransactionApi/GetVisitor'),
        headers: _headers,
        body: json.encode(body),
        encoding: Encoding.getByName('utf-8'),
      );
      final list = (json.decode(response.body) as List)
          .map((i) => MeetingWithResponse.fromJson(i))
          .toList();
      if (mounted) setState(() => meetingWithResponseList = list);
    } catch (e) {
      appLogger.e('GetVisitor error', error: e);
    }
  }

  Future<void> getPurposeResponse() async {
    final body = {
      "Action": 5,
      "FYId": 1,
      "SessionId": 1,
      "RelationshipId": widget.loginResponse.relationshipId
    };
    try {
      final response = await apiClient.post(
        Uri.parse('${_base}VisitorTransactionApi/GetAppointment'),
        headers: _headers,
        body: json.encode(body),
        encoding: Encoding.getByName('utf-8'),
      );
      final list = (json.decode(response.body) as List)
          .map((i) => PurposeResponse.fromJson(i))
          .toList();
      if (mounted) setState(() => currencies = list);
    } catch (e) {
      appLogger.e('GetAppointment error', error: e);
    }
  }

  /// [time] is "HH:mm" in 24-hour format, [date] is "yyyy-MM-dd".
  Future<void> scheduleAmeeting(String name, String email, String mobile,
      String time, String date, BuildContext dialogContext) async {
    final body = {
      "TransID": "",
      "MeetingDate": "${date}T$time:00",
      "PVNo": "000005",
      "MobileNo": mobile,
      "EmailId": email,
      "VisitorName": name,
      "PurposeId": selectedPurpose,
      "AuthorizedOrOtherPersonCode": selectedPerson.split("|")[0],
      "StatusId": 1,
      "Showtime": "$time:00",
      "RelationshipId": widget.loginResponse.relationshipId,
      "SessionId": "1",
      "FYId": "1",
      "CreatedBy": widget.loginResponse.userId,
      "UpdatedBy": widget.loginResponse.userId,
      "Action": "1"
    };
    try {
      final response = await apiClient.post(
        Uri.parse(
            '${_base}VisitorTransactionApi/InsertUpdateDeleteAppointment'),
        headers: _headers,
        body: json.encode(body),
        encoding: Encoding.getByName('utf-8'),
      );

      if (!mounted) return;
      if (response.body == '"1"') {
        Navigator.pop(dialogContext);
        showAppSnack(context, 'Meeting scheduled successfully',
            success: true);
        SendNotificationToHost(name, selectedPurpose, mobile, selectedPerson);
        _resetForm();
        _refreshDashboard(); // show the new meeting right away
      } else {
        showAppSnack(context, 'Could not schedule the meeting. Please try again.',
            error: true);
      }
    } catch (e) {
      appLogger.e('schedule error', error: e);
      if (mounted) {
        showAppSnack(context, 'Network error. Please try again.', error: true);
      }
    }
  }

  void _resetForm() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    timeController.clear();
    dateController.clear();
    selectedPerson = "";
    selectedPurpose = "";
    _selectedTime = null;
  }

  Future<void> SendNotificationToHost(String name, String selectedPurpose,
      String mobile, String selectedPerson) async {
    String? GSMID = "";
    String? purpose = "";
    for (final m in meetingWithResponseList) {
      if (m.code == selectedPerson) GSMID = m.GSMId;
    }
    for (final c in currencies) {
      if (c.code.toString() == selectedPurpose) purpose = c.purposeName;
    }
    final body = {
      "deviceId": GSMID,
      "VisitorName": name,
      "PurposeId": purpose,
      "MobileNo": mobile
    };
    try {
      await apiClient.post(
        Uri.parse(
            '${_base}VisitorTransactionApi/SendVisitorNotificationtToMobile'),
        headers: _headers,
        body: json.encode(body),
        encoding: Encoding.getByName('utf-8'),
      );
    } catch (e) {
      appLogger.e('notification error', error: e);
    }
  }

  // ---------------------------------------------------------------- Data
  //
  // The schedule strip shows 14 days. Instead of one API call per tapped
  // day, we fetch the whole 14-day range in ONE call, group it by date and
  // cache it. Switching days is then instant, and today's "Scheduled" count
  // comes from the same response (no duplicate request).

  DashboardCounts _counts = const DashboardCounts();
  int? _scheduledToday;
  DateTime _selectedDay = _dateOnly(DateTime.now());

  /// Meetings per day. A day that is present here can be shown instantly.
  final Map<DateTime, List<ScheduleMeetingResponse>> _dayCache = {};
  bool _dayRefreshing = false;
  bool _dayError = false;
  int _scheduleRequestId = 0;
  Future<void>? _rangeInFlight;

  /// Set to false if the server's dates can't be read; we then fall back
  /// to loading one day at a time (still cached).
  bool _rangeMode = true;

  static const int _stripDaysBefore = 3;
  static const int _stripLength = 14;

  final ScrollController _dayScroll =
      ScrollController(initialScrollOffset: 2 * 64.0);

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  List<DateTime> get _stripDays {
    final today = _dateOnly(DateTime.now());
    return List.generate(
        _stripLength, (i) => today.add(Duration(days: i - _stripDaysBefore)));
  }

  List<ScheduleMeetingResponse> get _dayMeetings =>
      _dayCache[_selectedDay] ?? const [];

  /// Nothing cached for the selected day yet → show skeletons.
  bool get _dayLoading => !_dayCache.containsKey(_selectedDay) && !_dayError;

  Future<void> _refreshAll() async {
    await Future.wait([_loadLookups(), _loadCounts(), _loadSchedule()]);
  }

  /// Refreshes counts + schedule in the background, keeping what is on
  /// screen until new data arrives (no flashing skeletons).
  void _refreshDashboard() {
    _loadCounts();
    _loadSchedule();
  }

  Future<void> _loadCounts() async {
    final u = widget.loginResponse;
    final today = MeetingApi.apiDate.format(DateTime.now());
    Future<int?> count(Future<List<dynamic>> f) =>
        f.then<int?>((l) => l.length).catchError((_) => null);
    // "Scheduled" is filled in by _loadSchedule from the same data as the list.
    final r = await Future.wait<int?>([
      count(MeetingApi.actionable(u.relationshipId, u.userId, today, today)),
      count(MeetingApi.ongoing(u.relationshipId, u.userId, today, today)),
      count(MeetingApi.completed(u.relationshipId, u.userId, today, today)),
    ]);
    if (!mounted) return;
    setState(() => _counts = DashboardCounts(
          actionable: r[0],
          ongoing: r[1],
          completed: r[2],
        ));
  }

  /// Loads the schedule for every day in the strip with a single request.
  Future<void> _loadSchedule() {
    if (!_rangeMode) return _loadDay(_selectedDay);
    final future = _fetchRange();
    _rangeInFlight = future;
    return future.whenComplete(() {
      if (identical(_rangeInFlight, future)) _rangeInFlight = null;
    });
  }

  Future<void> _fetchRange() async {
    final requestId = ++_scheduleRequestId;
    final days = _stripDays;
    setState(() {
      _dayRefreshing = true;
      _dayError = false;
    });
    final u = widget.loginResponse;
    try {
      final list = await MeetingApi.scheduled(
        u.relationshipId,
        u.userId,
        MeetingApi.apiDate.format(days.first),
        MeetingApi.apiDate.format(days.last),
      );
      if (!mounted || requestId != _scheduleRequestId) return;

      final grouped = _groupByDay(list);
      if (grouped == null) {
        appLogger.w('MeetingDate format not recognised — '
            'falling back to per-day loading');
        _rangeMode = false;
        _dayRefreshing = false;
        return _loadDay(_selectedDay);
      }

      final today = _dateOnly(DateTime.now());
      setState(() {
        _dayCache.clear();
        for (final d in days) {
          _dayCache[d] = grouped[d] ?? [];
        }
        _scheduledToday = _dayCache[today]?.length;
        _dayRefreshing = false;
      });
    } catch (e) {
      appLogger.e('schedule range error', error: e);
      if (!mounted || requestId != _scheduleRequestId) return;
      setState(() {
        _dayRefreshing = false;
        // Keep showing cached data if we have it; only show the error
        // card when there is nothing to show.
        _dayError = !_dayCache.containsKey(_selectedDay);
      });
    }
  }

  /// Fallback: loads one day (used only if range grouping isn't possible).
  Future<void> _loadDay(DateTime day) async {
    final requestId = ++_scheduleRequestId;
    setState(() {
      _dayRefreshing = true;
      _dayError = false;
    });
    final u = widget.loginResponse;
    final d = MeetingApi.apiDate.format(day);
    try {
      final list =
          await MeetingApi.scheduled(u.relationshipId, u.userId, d, d);
      if (!mounted) return;
      setState(() {
        _dayCache[day] = list;
        if (day == _dateOnly(DateTime.now())) _scheduledToday = list.length;
        if (requestId == _scheduleRequestId) _dayRefreshing = false;
      });
    } catch (e) {
      appLogger.e('day meetings error', error: e);
      if (!mounted || requestId != _scheduleRequestId) return;
      setState(() {
        _dayRefreshing = false;
        _dayError = !_dayCache.containsKey(day);
      });
    }
  }

  void _selectDay(DateTime day) {
    if (day == _selectedDay) return;
    setState(() {
      _selectedDay = day;
      _dayError = false;
    });
    if (_dayCache.containsKey(day)) return; // instant
    if (_rangeInFlight != null) return; // range request will fill it
    _rangeMode ? _loadSchedule() : _loadDay(day);
  }

  /// Groups meetings by calendar day. Returns null if any date is unreadable.
  Map<DateTime, List<ScheduleMeetingResponse>>? _groupByDay(
      List<ScheduleMeetingResponse> list) {
    final map = <DateTime, List<ScheduleMeetingResponse>>{};
    for (final m in list) {
      final day = _parseMeetingDay(m.meetingDate) ?? _parseMeetingDay(m.vDate);
      if (day == null) return null;
      (map[day] ??= []).add(m);
    }
    return map;
  }

  static DateTime? _parseMeetingDay(String? raw) {
    final s = raw?.trim() ?? '';
    if (s.isEmpty) return null;
    final iso = DateTime.tryParse(s);
    if (iso != null) return _dateOnly(iso);
    try {
      return _dateOnly(DateFormat('dd-MM-yyyy').parseStrict(s.split(' ').first));
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------- UI

  Future<void> _confirmLogout() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
        title: const Text('Sign out?'),
        content: const Text(
          'You will need to sign in again to access your dashboard.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              minimumSize: const Size(120, 44),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (yes != true) return;
    final pref = await SharedPreferences.getInstance();
    await pref.setString('userData', "");
    await pref.setString("token", "");
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen(title: "")),
      (route) => false,
    );
  }

  void _push(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    if (mounted) _refreshDashboard();
  }

  void _openMenu() {
    final user = widget.loginResponse;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: AppAvatar(
                    imageUrl: user.branchLogo, name: user.userName, size: 44),
                title: Text(valueOrDash(user.userName),
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(valueOrDash(user.schoolName)),
              ),
              const Divider(),
              _menuTile(ctx, Icons.person_outline_rounded, 'My profile',
                  () => _push(const UserProfile())),
              _menuTile(ctx, Icons.notifications_none_rounded, 'Notifications',
                  () => _push(const NotificationPage())),
              _menuTile(ctx, Icons.logout_rounded, 'Sign out', _confirmLogout,
                  color: AppColors.danger),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuTile(BuildContext ctx, IconData icon, String label,
      VoidCallback onTap,
      {Color color = AppColors.textPrimary}) {
    return ListTile(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md)),
      leading: Icon(icon, color: color),
      title: Text(label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      onTap: () {
        Navigator.pop(ctx);
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.loginResponse;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: _refreshAll,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                _topBar(user),
                const SizedBox(height: 22),
                Text(
                  'Welcome back, ${_firstName(user.userName)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('d MMMM yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 24),
                const SectionTitle('My Meetings'),
                const SizedBox(height: 14),
                GridDashboard(
                  relationShipId: user.relationshipId,
                  userId: user.userId,
                  counts: DashboardCounts(
                    actionable: _counts.actionable,
                    ongoing: _counts.ongoing,
                    scheduled: _scheduledToday,
                    completed: _counts.completed,
                  ),
                  onReturn: _refreshDashboard,
                ),
                const SizedBox(height: 28),
                SectionTitle(
                  'Schedule',
                  trailing: TextButton(
                    onPressed: () => _push(ScheduleMeetList(
                        relationShipId: user.relationshipId,
                        userId: user.userId)),
                    child: const Text('See all'),
                  ),
                ),
                const SizedBox(height: 8),
                _dayStrip(),
                // Thin bar while refreshing in the background.
                SizedBox(
                  height: 16,
                  child: Center(
                    child: AnimatedOpacity(
                      opacity: _dayRefreshing && !_dayLoading ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const LinearProgressIndicator(minHeight: 2),
                    ),
                  ),
                ),
                ..._dayList(),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: _openScheduleSheet,
          elevation: 4,
          shape: const CircleBorder(),
          tooltip: 'New meeting',
          child: const Icon(Icons.add_rounded, size: 30),
        ),
        bottomNavigationBar: _bottomBar(user),
      ),
    );
  }

  String _firstName(String name) {
    final n = name.trim();
    if (n.isEmpty) return 'there';
    return n.split(RegExp(r'\s+')).first;
  }

  Widget _topBar(LoginResponse user) {
    return Row(
      children: [
        _roundIcon(Icons.menu_rounded, _openMenu, 'Menu'),
        const Expanded(
          child: Text(
            'Home',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _push(const UserProfile()),
          child: AppAvatar(
            imageUrl: user.branchLogo,
            name: user.userName,
            size: 44,
            borderColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _roundIcon(IconData icon, VoidCallback onTap, String tooltip) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      elevation: 0,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _dayStrip() {
    final today = _dateOnly(DateTime.now());
    final days = _stripDays;
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: EdgeInsets.only(bottom: 10),
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        controller: _dayScroll,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final d = days[i];
          final selected = d == _selectedDay;
          final isToday = d == today;
          return GestureDetector(
            onTap: () => _selectDay(d),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 3,
                          offset: const Offset(0, 6),
                        )
                      ]
                    : AppShadows.soft,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(d),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${d.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isToday
                          ? (selected ? Colors.white : AppColors.primary)
                          : Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _dayList() {
    if (_dayLoading) {
      return List.generate(
        2,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
        ),
      );
    }
    if (_dayError) {
      return [
        SurfaceCard(
          child: StateMessage(
            icon: Icons.wifi_off_rounded,
            title: "Couldn't load schedule",
            message: 'Check your connection and try again.',
            actionLabel: 'Retry',
            onAction: _loadSchedule,
            color: AppColors.danger,
          ),
        ),
      ];
    }
    if (_dayMeetings.isEmpty) {
      return [
        SurfaceCard(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: StateMessage(
            icon: Icons.event_available_rounded,
            title: 'Nothing scheduled',
            message:
                'No meetings on ${DateFormat('EEE, d MMM').format(_selectedDay)}. Tap + to add one.',
            color: AppColors.orange,
          ),
        ),
      ];
    }
    final tones = [
      MeetingTone.actionable,
      MeetingTone.ongoing,
      MeetingTone.scheduled,
      MeetingTone.completed,
    ];
    return [
      for (var i = 0; i < _dayMeetings.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _scheduleTile(_dayMeetings[i], tones[i % tones.length]),
        ),
    ];
  }

  Widget _scheduleTile(ScheduleMeetingResponse m, MeetingTone tone) {
    final dt = splitMeetingDate(m.meetingDate);
    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              margin: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: tone.color,
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(4)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
                child: Row(
                  children: [
                    AppAvatar(
                      name: m.visitorName ?? '',
                      size: 44,
                      backgroundColor: tone.soft,
                      foregroundColor: tone.color,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            valueOrDash(m.visitorName),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'with ${valueOrDash(m.personName)} · ${valueOrDash(m.purposeName)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    StatusPill(
                      label: dt.time.isEmpty ? dt.date : dt.time,
                      color: tone.color,
                      background: tone.soft,
                      icon: Icons.schedule_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar(LoginResponse user) {
    Widget item(IconData icon, String label, VoidCallback? onTap,
        {bool active = false}) {
      final color = active ? AppColors.primary : AppColors.textMuted;
      return Expanded(
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 3),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
            ],
          ),
        ),
      );
    }

    return BottomAppBar(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 12,
      shadowColor: Colors.black26,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          item(Icons.home_rounded, 'Home', null, active: true),
          item(
              Icons.calendar_month_rounded,
              'Calendar',
              () => _push(ScheduleMeetList(
                  relationShipId: user.relationshipId, userId: user.userId))),
          const SizedBox(width: 64),
          item(Icons.notifications_none_rounded, 'Alerts',
              () => _push(const NotificationPage())),
          item(Icons.person_outline_rounded, 'Profile',
              () => _push(const UserProfile())),
        ],
      ),
    );
  }

  // ------------------------------------------------ Schedule meeting sheet

  Future<void> _openScheduleSheet() async {
    appLogger.i('➕ New meeting tapped — hosts: ${meetingWithResponseList.length}, '
        'purposes: ${currencies.length}, loading: $_lookupsLoading');

    // If hosts or purposes are missing, try loading them once more.
    if (!_lookupsLoading &&
        (meetingWithResponseList.isEmpty || currencies.isEmpty)) {
      await _loadLookups();
      if (!mounted) return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Schedule a meeting',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'The host will get a notification once it is booked.',
                      style: TextStyle(
                          fontSize: 13.5, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 22),
                    _sheetLabel('Visitor details'),
                    TextFormField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Please enter the visitor name'
                          : null,
                      decoration: const InputDecoration(
                        hintText: 'Full name',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(v.trim())) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Email address',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => (v == null || v.length != 10)
                          ? 'Please enter a 10-digit mobile number'
                          : null,
                      decoration: const InputDecoration(
                        hintText: 'Mobile number',
                        counterText: '',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _sheetLabel('Meeting'),
                    if (_lookupsLoading)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: LinearProgressIndicator(minHeight: 3),
                      )
                    else if (meetingWithResponseList.isEmpty ||
                        currencies.isEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
                        decoration: BoxDecoration(
                          color: AppColors.warningSoft,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                size: 18, color: AppColors.warning),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                meetingWithResponseList.isEmpty
                                    ? 'No hosts found for your account.'
                                    : 'No meeting purposes found.',
                                style: const TextStyle(
                                    fontSize: 13, color: AppColors.textPrimary),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final loading = _loadLookups();
                                setSheetState(() {});
                                await loading;
                                if (sheetContext.mounted) setSheetState(() {});
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    Builder(builder: (_) {
                      final hosts = _uniqueBy(
                          meetingWithResponseList
                              .where((d) => (d.code ?? '').isNotEmpty),
                          (d) => d.code!);
                      return SearchableDropdownField<MeetingWithResponse>(
                        // Key forces a rebuild when the list reloads (Retry).
                        key: ValueKey('host-${hosts.length}'),
                        items: hosts,
                        initialValue: hosts
                            .where((h) => h.code == selectedPerson)
                            .firstOrNull,
                        isSame: (a, b) => a.code == b.code,
                        hintText: 'Meeting with',
                        sheetTitle: 'Select host',
                        searchHint: 'Search by name or department',
                        prefixIcon: Icons.badge_outlined,
                        itemLabel: (h) => valueOrDash(h.name),
                        itemSubtitle: (h) => h.departmentName,
                        itemLeading: (h) =>
                            AppAvatar(name: h.name ?? '', size: 38),
                        validator: (v) =>
                            v == null ? 'Please select a host' : null,
                        onChanged: (v) =>
                            setSheetState(() => selectedPerson = v?.code ?? ''),
                      );
                    }),
                    const SizedBox(height: 12),
                    Builder(builder: (_) {
                      final purposes = _uniqueBy(
                          currencies.where((d) => d.code != null),
                          (d) => d.code.toString());
                      return SearchableDropdownField<PurposeResponse>(
                        key: ValueKey('purpose-${purposes.length}'),
                        items: purposes,
                        initialValue: purposes
                            .where((p) => p.code.toString() == selectedPurpose)
                            .firstOrNull,
                        isSame: (a, b) => a.code == b.code,
                        hintText: 'Purpose of visit',
                        sheetTitle: 'Select purpose',
                        searchHint: 'Search purpose',
                        prefixIcon: Icons.flag_outlined,
                        itemLabel: (p) => valueOrDash(p.purposeName),
                        itemLeading: (_) => Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Icon(Icons.flag_outlined,
                              size: 20, color: AppColors.primary),
                        ),
                        validator: (v) =>
                            v == null ? 'Please select a purpose' : null,
                        onChanged: (v) => setSheetState(() =>
                            selectedPurpose = v?.code?.toString() ?? ''),
                      );
                    }),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: dateController,
                            readOnly: true,
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Select date'
                                : null,
                            onTap: () async {
                              final now = DateTime.now();
                              final date = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: DateTime(now.year, now.month, now.day),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                dateController.text =
                                    DateFormat('yyyy-MM-dd').format(date);
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Date',
                              prefixIcon: Icon(Icons.event_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: timeController,
                            readOnly: true,
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Select time'
                                : null,
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _selectedTime ?? TimeOfDay.now(),
                                helpText: 'Select meeting time',
                              );
                              if (time != null && context.mounted) {
                                _selectedTime = time;
                                timeController.text = time.format(context);
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Time',
                              prefixIcon: Icon(Icons.schedule_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _submitting
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              final t = _selectedTime!;
                              final hhmm =
                                  '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
                              setSheetState(() => _submitting = true);
                              await scheduleAmeeting(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                mobileController.text.trim(),
                                hhmm,
                                dateController.text,
                                sheetContext,
                              );
                              _submitting = false;
                              if (sheetContext.mounted) setSheetState(() {});
                            },
                      child: _submitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.4, color: Colors.white),
                            )
                          : const Text('Schedule meeting'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  /// Drops items with a duplicate key (dropdowns crash on duplicate values).
  List<T> _uniqueBy<T>(Iterable<T> items, String Function(T) key) {
    final seen = <String>{};
    return items.where((e) => seen.add(key(e))).toList();
  }

  Widget _sheetLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 11.5,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      );
}

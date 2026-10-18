import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../network/api_logger.dart';

/// Shared state + behaviour for the meeting list screens:
/// date range, loading / error flags and the POST helper.
mixin MeetingListMixin<W extends StatefulWidget, T> on State<W> {
  final DateFormat apiDateFormat = DateFormat('dd-MM-yyyy');

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  bool isLoading = true;
  bool hasError = false;
  List<T> items = [];

  /// Whether the user can pick dates in the future (e.g. scheduled meetings).
  bool get allowFutureDates => false;

  String get fromDateGlobal => apiDateFormat.format(fromDate);
  String get toDateGlobal => apiDateFormat.format(toDate);

  /// Implement with the screen's own API call.
  Future<List<T>> fetch(String fromDate, String toDate);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => load());
  }

  Future<void> load() async {
    if (toDate.isBefore(fromDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('"To" date cannot be before "From" date')),
      );
      return;
    }
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final result = await fetch(fromDateGlobal, toDateGlobal);
      if (!mounted) return;
      setState(() {
        items = result;
        isLoading = false;
      });
    } catch (e) {
      appLogger.e('list load error', error: e);
      if (!mounted) return;
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> pickFrom() async {
    final picked = await _pick(fromDate);
    if (picked != null) setState(() => fromDate = picked);
  }

  Future<void> pickTo() async {
    final picked = await _pick(toDate);
    if (picked != null) setState(() => toDate = picked);
  }

  Future<DateTime?> _pick(DateTime initial) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: allowFutureDates ? DateTime(2100) : DateTime.now(),
    );
  }
}

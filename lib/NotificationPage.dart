import 'package:flutter/material.dart';

import 'widgets/app_widgets.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const StateMessage(
        icon: Icons.notifications_none_rounded,
        title: "You're all caught up",
        message: 'New visitor and meeting alerts will appear here.',
      ),
    );
  }
}

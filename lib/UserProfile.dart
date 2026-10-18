import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor_app_flutter/models/LoginResponse.dart';

import 'theme/app_theme.dart';
import 'widgets/app_widgets.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  LoginResponse? user;

  @override
  void initState() {
    super.initState();
    getDataFromSP();
  }

  Future<void> getDataFromSP() async {
    final pref = await SharedPreferences.getInstance();
    final raw = pref.getString("userData");
    if (raw == null || raw.isEmpty) return;
    final parsed = LoginResponse.fromJson(jsonDecode(raw));
    if (mounted) setState(() => user = parsed);
  }

  @override
  Widget build(BuildContext context) {
    final u = user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: u == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                SurfaceCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      AppAvatar(
                          imageUrl: u.profilePic.isNotEmpty
                              ? u.profilePic
                              : u.branchLogo,
                          name: u.userName,
                          size: 88),
                      const SizedBox(height: 14),
                      Text(
                        valueOrDash(u.userName),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (u.designation.isNotEmpty || u.loginAs.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        StatusPill(
                          label: u.designation.isNotEmpty
                              ? u.designation
                              : u.loginAs,
                          color: AppColors.primary,
                          background: AppColors.primarySoft,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const SectionTitle('Account'),
                const SizedBox(height: 10),
                SurfaceCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Column(children: [
                    InfoRow(
                        icon: Icons.mail_outline_rounded,
                        label: 'Email',
                        value: u.emailId),
                    const Divider(),
                    InfoRow(
                        icon: Icons.phone_outlined,
                        label: 'Mobile',
                        value: u.mobileNo),
                    const Divider(),
                    InfoRow(
                        icon: Icons.history_rounded,
                        label: 'Last sign-in',
                        value: u.lastLogin),
                  ]),
                ),
                const SizedBox(height: 22),
                const SectionTitle('Organisation'),
                const SizedBox(height: 10),
                SurfaceCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Column(children: [
                    InfoRow(
                        icon: Icons.apartment_rounded,
                        label: 'Name',
                        value: u.schoolName),
                    const Divider(),
                    InfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'Address',
                        value: u.schoolAddress),
                    const Divider(),
                    InfoRow(
                        icon: Icons.date_range_rounded,
                        label: 'Academic year',
                        value: u.activeAcademicYear),
                  ]),
                ),
              ],
            ),
    );
  }
}

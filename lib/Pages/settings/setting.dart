import 'package:chat_app/FontSizeProvider.dart';
import 'package:chat_app/Pages/settings/AccessibilitySettings.dart';
import 'package:chat_app/Pages/settings/ConnectionsPage.dart';
import 'package:chat_app/Pages/settings/account.dart';
import 'package:chat_app/Pages/settings/appearence.dart';
import 'package:chat_app/Pages/settings/devices_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Friends.dart'; // Import the FriendsPage screen

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _navigateToAppearanceSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppearanceSettings()),
    );
  }

  void _navigateToAccessibilitySettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccessibilitySettings()),
    );
  }

  void _navigateToFriendsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FriendsPage()),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Add logic for signing out
                // You can call a sign-out method here

                // Close the dialog
                Navigator.pop(context);
              },
              child: const Text("Sign Out"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Provider.of<FontSizeProvider>(context).fontSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // This will navigate back
          },
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                title: "General",
                children: [
                  ListTile(
                    leading: const Icon(Icons.light),
                    title: const Text("Modes"),
                    subtitle: const Text("Light and Dark Mode"),
                    onTap: () {
                      // Provider.of<ThemeProvider>(context, listen: false)
                      //     .toggleTheme();
                    },
                  ),
                  _CustomListTile(
                    title: "Notifications",
                    icon: Icons.notifications_none_rounded,
                    fontSize: fontSize,
                  ),
                  _CustomListTile(
                    title: "Security Status",
                    icon: Icons.lock_clock_outlined,
                    fontSize: fontSize,
                  ),
                ],
              ),
              const Divider(),
              _SingleSection(
                title: "User Account",
                children: [
                  ListTile(
                    title: const Text("Account"),
                    leading: const Icon(Icons.account_circle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountPage()),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "Devices",
                    icon: Icons.devices,
                    onTapCallback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DevicesScreen()),
                      );
                    },
                    fontSize: fontSize,
                  ),
                  _CustomListTile(
                    title: "Connections",
                    icon: Icons.connect_without_contact_outlined,
                    onTapCallback: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConnectionsPage()),
                      );
                    },
                    fontSize: fontSize,
                  ),
                  _CustomListTile(
                    title: "Friends",
                    icon: Icons.info_outline,
                    onTapCallback: () => _navigateToFriendsPage(context),
                    fontSize: fontSize,
                  ),
                  _CustomListTile(
                    title: "Information",
                    icon: Icons.info_outline,
                    fontSize: fontSize,
                  ),
                ],
              ),
              const Divider(),
              _SingleSection(
                title: "App Settings",
                children: [
                  _CustomListTile(
                    title: "Appearance",
                    icon: Icons.app_registration,
                    onTapCallback: () => _navigateToAppearanceSettings(context),
                    fontSize: fontSize,
                  ),
                  _CustomListTile(
                    title: "Accessibility",
                    icon: Icons.accessibility_outlined,
                    onTapCallback: () => _navigateToAccessibilitySettings(context),
                    fontSize: fontSize,
                  ),
                  _CustomListTile(
                    title: "Notifications",
                    icon: Icons.notifications_outlined,
                    fontSize: fontSize,
                  ),
                ],
              ),
              const Divider(),
              _SingleSection(
                children: [
                  _CustomListTile(
                    title: "Help & Feedback",
                    icon: Icons.help_outline_rounded,
                    fontSize: fontSize,
                  ),
                  _CustomListTile(
                    title: "About",
                    icon: Icons.info_outline_rounded,
                    fontSize: fontSize,
                  ),
                  _CustomListTile(
                    title: "Sign out",
                    icon: Icons.exit_to_app_rounded,
                    onTapCallback: () => _showSignOutDialog(context),
                    fontSize: fontSize,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTapCallback;
  final double fontSize;

  const _CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.onTapCallback,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16 + fontSize), // Adjusting font size here
      ),
      leading: Icon(icon),
      onTap: onTapCallback,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}

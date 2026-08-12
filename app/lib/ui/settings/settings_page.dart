import 'package:flutter/material.dart';
import '../../utils/localization.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _nameController;
  final FocusNode _focusNodeName = FocusNode();
 
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _focusNodeName.addListener(() {
    if (!_focusNodeName.hasFocus) {
      // ToDo : Save the name to shared preferences or any other storage
    }
  });
  }

  @override
  void dispose() {
     _focusNodeName.dispose();
    // Always dispose the controller to avoid memory leaks
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: ListView(
          children: [
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: true, // ToDo: Replace with actual dark mode state
                onChanged: (value) {
                  // ToDo: Implement dark mode toggle
                },
              ),
            ),
            ListTile(
              title: Text(context.loc.settings_text_name),
              trailing: SizedBox(
                width: 150, // Set a fixed width for the TextField
                child: TextField(
                  controller: _nameController,
                  focusNode: _focusNodeName,
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    
                  ),
                ),
              ),
            ),
            const Spacer(),
            AboutListTile(
              icon: const Icon(Icons.info),
              applicationName: 'My Awesome App',
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(Icons.apps),
              aboutBoxChildren: <Widget>[
                const Text('This app is designed to provide great features.'),
              ],
            ),
          ],
        ),
      );
  }
}

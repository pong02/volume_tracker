// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/main.dart';

class ThemeToggle extends ConsumerStatefulWidget {
  const ThemeToggle({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends ConsumerState<ConsumerStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      title: const Text("Light Mode"),
      value: ref.watch(themeStateProvider),
      onChanged: (value) {
        ref.read(themeStateProvider.notifier).setValue(value);
      },
    );
  }
}

class LocationToggle extends ConsumerStatefulWidget {
  const LocationToggle({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationToggleState();
}

class _LocationToggleState extends ConsumerState<ConsumerStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      title: const Text("Location Services"),
      value: ref.watch(locationStateProvider),
      onChanged: (value) {
        ref.read(locationStateProvider.notifier).setValue(value);
      },
    );
  }
}

class NotificationToggle extends ConsumerStatefulWidget {
  const NotificationToggle({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationToggleState();
}

class _NotificationToggleState extends ConsumerState<ConsumerStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      title: const Text("Notification Banners"),
      value: ref.watch(notificationStateProvider),
      onChanged: (value) {
        ref.read(notificationStateProvider.notifier).setValue(value);
      },
    );
  }
}

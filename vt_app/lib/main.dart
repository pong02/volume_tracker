import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_tracker/repository/storage_repository.dart';
import 'package:volume_tracker/ui/auth_checker.dart';
import 'package:volume_tracker/ui/theme.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(storageProvider).initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.defTheme,
      home: const AuthChecker(),
    );
  }
}

//create localstorage provider to read/store settings
final storageProvider = Provider<StorageRepository>(
  (ref) => StorageRepository(),
);

//providers for toggle states
final notificationStateProvider =
    StateNotifierProvider<NotificationStateNotifier, bool>(
  (ref) {
    final storage = ref.watch(storageProvider);
    return NotificationStateNotifier(storage: storage);
  },
);

class NotificationStateNotifier extends StateNotifier<bool> {
  NotificationStateNotifier({
    required this.storage,
  }) : super(storage.getBool('notification') ?? false);

  final StorageRepository storage;

  Future<void> setValue(bool value) async {
    if (value != state) {
      state = value;
      await storage.setBool('notification', value);
    }
  }
}

final themeStateProvider = StateNotifierProvider<ThemeStateNotifier, bool>(
  (ref) {
    final storage = ref.watch(storageProvider);
    return ThemeStateNotifier(storage: storage);
  },
);

class ThemeStateNotifier extends StateNotifier<bool> {
  ThemeStateNotifier({
    required this.storage,
  }) : super(storage.getBool('theme') ?? false);

  final StorageRepository storage;

  Future<void> setValue(bool value) async {
    if (value != state) {
      state = value;
      await storage.setBool('theme', value);
    }
  }
}

final locationStateProvider =
    StateNotifierProvider<LocationStateNotifier, bool>(
  (ref) {
    final storage = ref.watch(storageProvider);
    return LocationStateNotifier(storage: storage);
  },
);

class LocationStateNotifier extends StateNotifier<bool> {
  LocationStateNotifier({
    required this.storage,
  }) : super(storage.getBool('location') ?? false);

  final StorageRepository storage;

  Future<void> setValue(bool value) async {
    if (value != state) {
      state = value;
      await storage.setBool('location', value);
    }
  }
}

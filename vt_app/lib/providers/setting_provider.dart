import 'normal_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<Item> items = [
  Item(key: "notification", value: false),
  Item(key: "location", value: false),
  Item(key: "nightmode", value: false),
];
SpTools localStorage = SpTools(items);

StateProvider<Future<bool>> notiStateProvider = StateProvider((ref) async =>
    await localStorage.getBoolValuesSF("notification")); //get from localstorage

// init StreamProvider for notification
AutoDisposeStreamProvider<bool> notiStreamProvider =
    StreamProvider.autoDispose<bool>((ref) async* {
  Stream<bool> stored =
      Stream<bool>.fromFuture(localStorage.getBoolValuesSF("notification"));

  // Parse the value received and emit the primitive value
  await for (final value in stored) {
    yield value;
  }
});

/// init stateProvider for location
StateProvider<Future<bool>> locStateProvider = StateProvider((ref) async =>
    await localStorage.getBoolValuesSF("location")); //get from localstorage

// init StreamProvider for location
AutoDisposeStreamProvider<bool> locStreamProvider =
    StreamProvider.autoDispose<bool>((ref) async* {
  Stream<bool> stored =
      Stream<bool>.fromFuture(localStorage.getBoolValuesSF("location"));

  // Parse the value received and emit the primitive value
  await for (final value in stored) {
    yield value;
  }
});

/// init stateProvider for nightmode
StateProvider<Future<bool>> nightStateProvider = StateProvider((ref) async =>
    await localStorage.getBoolValuesSF("nightmode")); //get from localstorage

// init StreamProvider for nightmode
AutoDisposeStreamProvider<bool> nightStreamProvider =
    StreamProvider.autoDispose<bool>((ref) async* {
  Stream<bool> stored =
      Stream<bool>.fromFuture(localStorage.getBoolValuesSF("nightmode"));

  // Parse the value received and emit the primitive value
  await for (final value in stored) {
    yield value;
  }
});

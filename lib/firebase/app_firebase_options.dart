import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Prefer the FlutterFire CLI generated options as a safe fallback when native
// build-time config isn't available. This file is committed in some workflows
// (after running `flutterfire configure`) but platform-native builds prefer
// secrets injected at build time so keys don't land in source control.
import '../firebase_options.dart' as generated;

class AppFirebaseOptions {
  AppFirebaseOptions._();

  static const MethodChannel _channel = MethodChannel('htmarevived/config');

  static Future<FirebaseOptions> fromPlatform() async {
    // If we're on web or an unsupported desktop platform, prefer the
    // FlutterFire-generated DefaultFirebaseOptions if present, otherwise
    // fall back to dart-define values.
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      try {
        return generated.DefaultFirebaseOptions.currentPlatform;
      } catch (_) {
        // Fall through to read from dart-define values if generation is
        // not available.
      }

      String readFromDefines(String key) {
        const Map<String, String> values = <String, String>{
          'apiKey': String.fromEnvironment('FIREBASE_API_KEY'),
          'appId': String.fromEnvironment('FIREBASE_APP_ID'),
          'messagingSenderId': String.fromEnvironment(
            'FIREBASE_MESSAGING_SENDER_ID',
          ),
          'projectId': String.fromEnvironment('FIREBASE_PROJECT_ID'),
          'authDomain': String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
          'storageBucket': String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
          'iosBundleId': String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID'),
        };

        final String value = values[key] ?? '';
        if (value.isEmpty) {
          throw StateError('Missing Firebase config for $key.');
        }
        return value;
      }

      return FirebaseOptions(
        apiKey: readFromDefines('apiKey'),
        appId: readFromDefines('appId'),
        messagingSenderId: readFromDefines('messagingSenderId'),
        projectId: readFromDefines('projectId'),
        authDomain: readFromDefines('authDomain'),
        storageBucket: readFromDefines('storageBucket'),
        iosBundleId: kIsWeb ? null : readFromDefines('iosBundleId'),
      );
    }

    // On Android/iOS prefer native build-time secrets injected into the
    // platform. If native config is missing or contains placeholder values,
    // fall back to the FlutterFire-generated options so developers who used
    // `flutterfire configure` get a working app without native secret files.
    try {
      final dynamic rawConfig = await _channel.invokeMethod<dynamic>(
        'getFirebaseConfig',
      );
      if (rawConfig is Map) {
        String read(String key) {
          final String value = (rawConfig[key] ?? '').toString().trim();
          if (value.isEmpty || value.startsWith(r'$(')) {
            throw StateError('Missing Firebase config value for $key.');
          }
          return value;
        }

        return FirebaseOptions(
          apiKey: read('apiKey'),
          appId: read('appId'),
          messagingSenderId: read('messagingSenderId'),
          projectId: read('projectId'),
          authDomain: read('authDomain'),
          storageBucket: read('storageBucket'),
          iosBundleId: defaultTargetPlatform == TargetPlatform.iOS
              ? read('iosBundleId')
              : null,
        );
      }
    } catch (_) {
      // ignore and fall through to generated options.
    }

    // Last-resort fallback: use FlutterFire CLI generated options. This keeps
    // local development simple for contributors who ran `flutterfire configure`.
    try {
      return generated.DefaultFirebaseOptions.currentPlatform;
    } catch (e) {
      throw StateError(
        'Native Firebase config is missing or invalid, and no FlutterFire-generated configuration is available.\n'
        'For native builds provide secrets via a local .env and run tool/sync_secrets.ps1 (or sync_secrets.sh), or run the FlutterFire CLI to generate firebase_options.dart.',
      );
    }
  }
}

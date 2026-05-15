import org.gradle.api.GradleException
import java.io.File

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

fun readEnvValue(envFile: File, key: String): String? {
    if (!envFile.exists()) return null
    return envFile.readLines()
        .asSequence()
        .map { it.trim() }
        .filter { it.isNotEmpty() && !it.startsWith("#") && it.contains("=") }
        .map {
            val idx = it.indexOf("=")
            it.substring(0, idx).trim() to it.substring(idx + 1).trim().trim('"', '\'')
        }
        .firstOrNull { it.first == key }
        ?.second
}

val envFile = rootProject.file("../.env")
fun requiredSecret(key: String): String {
    val value = readEnvValue(envFile, key)
        ?: System.getenv(key)
        ?: (project.findProperty(key) as String?)
        ?: ""
    if (value.isBlank()) {
        throw GradleException("Missing $key. Define it in .env (repo root) or environment variables.")
    }
    return value
}

fun optionalSecret(key: String): String {
    return readEnvValue(envFile, key)
        ?: System.getenv(key)
        ?: (project.findProperty(key) as String?)
        ?: ""
}

val googleMapsApiKeyAndroid = requiredSecret("GOOGLE_MAPS_API_KEY_ANDROID")
val firebaseApiKey = optionalSecret("FIREBASE_API_KEY")
val firebaseAppId = optionalSecret("FIREBASE_APP_ID")
val firebaseMessagingSenderId = optionalSecret("FIREBASE_MESSAGING_SENDER_ID")
val firebaseProjectId = optionalSecret("FIREBASE_PROJECT_ID")
val firebaseAuthDomain = optionalSecret("FIREBASE_AUTH_DOMAIN")
val firebaseStorageBucket = optionalSecret("FIREBASE_STORAGE_BUCKET")

android {
    namespace = "com.v3solutions.htmarevived"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.v3solutions.htmarevived"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Keep the API key in runtime-only config so it never lands in source control.
        manifestPlaceholders["GOOGLE_MAPS_API_KEY_ANDROID"] = googleMapsApiKeyAndroid
        buildConfigField("String", "FIREBASE_API_KEY", "\"$firebaseApiKey\"")
        buildConfigField("String", "FIREBASE_APP_ID", "\"$firebaseAppId\"")
        buildConfigField("String", "FIREBASE_MESSAGING_SENDER_ID", "\"$firebaseMessagingSenderId\"")
        buildConfigField("String", "FIREBASE_PROJECT_ID", "\"$firebaseProjectId\"")
        buildConfigField("String", "FIREBASE_AUTH_DOMAIN", "\"$firebaseAuthDomain\"")
        buildConfigField("String", "FIREBASE_STORAGE_BUCKET", "\"$firebaseStorageBucket\"")
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

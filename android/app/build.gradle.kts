import org.gradle.api.GradleException
import java.io.File

plugins {
    id("com.android.application")
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
val googleMapsApiKey = readEnvValue(envFile, "GOOGLE_MAPS_API_KEY")
    ?: System.getenv("GOOGLE_MAPS_API_KEY")
    ?: (project.findProperty("GOOGLE_MAPS_API_KEY") as String?)
    ?: ""

if (googleMapsApiKey.isBlank()) {
    throw GradleException(
        "Missing GOOGLE_MAPS_API_KEY. Define it in .env (repo root) or environment variables."
    )
}

android {
    namespace = "com.example.mapme"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.mapme"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Keep the API key in runtime-only config so it never lands in source control.
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = googleMapsApiKey
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

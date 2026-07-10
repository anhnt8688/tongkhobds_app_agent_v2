import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load release signing config from android/key.properties (kept out of VCS).
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        keystorePropertiesFile.inputStream().use { load(it) }
    }
}

android {
    namespace = "com.example.mobile_app_v2"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // Required by plugins relying on Java 8+ APIs (e.g. mobile_scanner).
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // Must match the v1 Play Store listing so this ships as an update, not a new app.
        applicationId = "app.bds.agent.android"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val storeFileName = keystoreProperties.getProperty("storeFile", "my-release-key.jks").trim().trim('"')
            storeFile = rootProject.file(storeFileName)
            storePassword = keystoreProperties.getProperty("storePassword")?.trim()?.trim('"')
            keyAlias = keystoreProperties.getProperty("keyAlias")?.trim()?.trim('"')
            keyPassword = keystoreProperties.getProperty("keyPassword")?.trim()?.trim('"')
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

// Kotlin 2.2+ replaced the `kotlinOptions { jvmTarget = ... }` DSL with the
// type-safe `compilerOptions` DSL.
kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
    }
}

flutter {
    source = "../.."
}

// mobile_scanner 5.2.3 pins com.google.mlkit:barcode-scanning:17.2.0, whose
// libbarhopper_v3.so is aligned to 4 KB and fails Google Play's 16 KB page-size
// requirement. 17.3.0 aligns the native lib to 16 KB. Force it without touching
// the Dart-side scanner API.
configurations.all {
    resolutionStrategy {
        force("com.google.mlkit:barcode-scanning:17.3.0")
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

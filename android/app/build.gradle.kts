import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing — read from android/key.properties (gitignored).
// `storeFile` is an absolute path so the keystore lives outside the repo
// (~/Prash_M4/awarself-creds/kpopchat/upload-keystore.jks per awarself convention).
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.awarself.kpopchat"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Required by flutter_local_notifications v21+ — backports newer
        // java.time / java.util classes to older minSdk targets.
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.awarself.kpopchat"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true

        // AdMob app id is injected from .env.json at build time so the real
        // value doesn't get committed via AndroidManifest.xml. Empty fallback
        // keeps dev builds working when .env.json is absent (the Mobile Ads
        // init provider will still crash on empty — fill .env.json before run).
        val envJson = rootProject.file("../.env.json")
        val admobAppId: String = if (envJson.exists()) {
            Regex("\"ADMOB_APP_ID_ANDROID\"\\s*:\\s*\"([^\"]*)\"")
                .find(envJson.readText())?.groupValues?.get(1) ?: ""
        } else ""
        manifestPlaceholders["admobAppIdAndroid"] = admobAppId
    }

    signingConfigs {
        create("release") {
            // Reads from android/key.properties (gitignored). If the file is
            // absent (e.g. on a fresh clone), the release build will fall
            // back below to debug signing so dev builds still work.
            keystoreProperties.getProperty("keyAlias")?.let { keyAlias = it }
            keystoreProperties.getProperty("keyPassword")?.let { keyPassword = it }
            keystoreProperties.getProperty("storePassword")?.let {
                storePassword = it
            }
            keystoreProperties.getProperty("storeFile")?.let {
                storeFile = file(it)
            }
        }
    }

    buildTypes {
        release {
            // Use the real release signing config when key.properties +
            // keystore exist; otherwise fall back to debug so a fresh clone
            // can still produce a runnable (un-shippable) release build.
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

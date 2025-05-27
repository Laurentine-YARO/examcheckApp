plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // FlutterFire Configuration
    //id("kotlin-android")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin
}

android {
    namespace = "com.example.examcheck_app"
    compileSdk = 35 // ou flutter.compileSdkVersion si défini ailleurs
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.examcheck_app"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}


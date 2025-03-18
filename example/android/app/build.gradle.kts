plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "br.com.jclan.alphaxStonePayment.flutter_getnet_payment_example"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    signingConfigs {
        create("config") {
            enableV1Signing = true
            enableV2Signing = true
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "br.com.jclan.alphaxStonePayment.flutter_getnet_payment_example"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 21
        targetSdk = 33
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        debug {
            isDebuggable = true
            enableAndroidTestCoverage = true
            signingConfig = signingConfigs.getByName("config")
            isCrunchPngs = false
        }
        release {
            isMinifyEnabled = false
            isDebuggable = false
            signingConfig = signingConfigs.getByName("config")
            proguardFiles(
                getDefaultProguardFile("proguard-android.txt"),
                file("proguard-rules.pro")
            )
            isCrunchPngs = true
        }
    }
}

flutter {
    source = "../.."
}

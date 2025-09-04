plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment_example"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "br.com.jclan.alphaxGetnetPayment.flutter_getnet_payment_example"
        minSdk = 22           
        targetSdk = 33        
        versionCode = 1       
        versionName = "1.0.0" 
    }
}

flutter {
    source = "../.."
}

import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keyPropsFileInAndroid = rootProject.file("android/key.properties")
val keyPropsFileInRoot = rootProject.file("key.properties")

if (keyPropsFileInAndroid.exists()) {
    keystoreProperties.load(FileInputStream(keyPropsFileInAndroid))
} else if (keyPropsFileInRoot.exists()) {
    keystoreProperties.load(FileInputStream(keyPropsFileInRoot))
}

android {
    // এখানে namespace এবং applicationId দুটোই এক করা হয়েছে
    namespace = "com.example.flowfix_game"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }

   signingConfigs {
    create("release") {
        val keystorePropertiesFile = rootProject.file("key.properties")
        if (keystorePropertiesFile.exists()) {
            val properties = java.util.Properties()
            properties.load(java.io.FileInputStream(keystorePropertiesFile))
            
            keyAlias = properties.getProperty("keyAlias")
            keyPassword = properties.getProperty("keyPassword")
            storePassword = properties.getProperty("storePassword")
            
            val storeFileName = properties.getProperty("storeFile")
            if (storeFileName != null) {
                // এটি প্রজেক্টের বিভিন্ন সম্ভাব্য লোকেশনে কি-স্টোর ফাইলটি খুঁজে নেবে
                val fileInApp = file(storeFileName)
                val fileInAndroidDir = java.io.File(rootProject.projectDir, "app/$storeFileName")
                val fileInAndroidRoot = java.io.File(rootProject.projectDir, "$storeFileName")
                
                if (fileInApp.exists()) {
                    storeFile = fileInApp
                } else if (fileInAndroidDir.exists()) {
                    storeFile = fileInAndroidDir
                } else if (fileInAndroidRoot.exists()) {
                    storeFile = fileInAndroidRoot
                }
            }
        }
    }
}

    defaultConfig {
        applicationId = "com.example.flowfix_game"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
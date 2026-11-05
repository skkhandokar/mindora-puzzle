import java.io.FileInputStream
import java.io.File
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
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
            val keystorePropertiesFile = rootProject.file("app/key.properties")
            val altKeystoreFile = rootProject.file("key.properties")
            
            val propFile = if (keystorePropertiesFile.exists()) keystorePropertiesFile else altKeystoreFile
            
            if (propFile.exists()) {
                // সরাসরি Properties ক্লাস ব্যবহার করা হলো (java.util. লেখা লাগবে না)
                val properties = Properties()
                properties.load(FileInputStream(propFile))
                
                keyAlias = properties.getProperty("keyAlias")
                keyPassword = properties.getProperty("keyPassword")
                storePassword = properties.getProperty("storePassword")
                
                val storeFileName = properties.getProperty("storeFile") ?: "mindora-release-key.jks"
                
                // সরাসরি File ক্লাস ব্যবহার করা হলো (java.io. লেখা লাগবে না)
                val fileInApp = file(storeFileName)
                val fileInAndroidApp = File(rootProject.projectDir, "app/$storeFileName")
                
                if (fileInApp.exists()) {
                    storeFile = fileInApp
                } else if (fileInAndroidApp.exists()) {
                    storeFile = fileInAndroidApp
                }
            }
        }
    }

flutter {
    source = "../.."
}
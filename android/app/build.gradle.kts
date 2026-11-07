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
    namespace = "com.skkhandokar.mindoraa"
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
                val properties = Properties()
                properties.load(FileInputStream(propFile))
                
                keyAlias = properties.getProperty("keyAlias")
                keyPassword = properties.getProperty("keyPassword")
                storePassword = properties.getProperty("storePassword")
                
                val storeFileName = properties.getProperty("storeFile") ?: "mindora-release-key.jks"
                
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

    defaultConfig {
        applicationId = "com.skkhandokar.mindoraa"
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
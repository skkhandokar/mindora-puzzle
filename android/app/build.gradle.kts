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

val keystoreProperties = Properties()
val keyPropsFileInAndroid = rootProject.file("android/key.properties")
val keyPropsFileInRoot = rootProject.file("key.properties")

if (keyPropsFileInAndroid.exists()) {
    keystoreProperties.load(FileInputStream(keyPropsFileInAndroid))
} else if (keyPropsFileInRoot.exists()) {
    keystoreProperties.load(FileInputStream(keyPropsFileInRoot))
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
            val keystorePropertiesFile = rootProject.file("android/app/key.properties")
            val altKeystorePropertiesFile = rootProject.file("key.properties")
            
            val propFile = if (keystorePropertiesFile.exists()) keystorePropertiesFile else altKeystorePropertiesFile
            
            if (propFile.exists()) {
                val properties = Properties()
                properties.load(FileInputStream(propFile))
                
                keyAlias = properties.getProperty("keyAlias")
                keyPassword = properties.getProperty("keyPassword")
                storePassword = properties.getProperty("storePassword")
                
                val storeFileName = properties.getProperty("storeFile")
                if (storeFileName != null) {
                    val jksFileInApp = File(rootProject.projectDir, "app/$storeFileName")
                    val jksFileInAndroid = File(rootProject.projectDir, storeFileName)
                    
                    if (jksFileInApp.exists()) {
                        storeFile = jksFileInApp
                    } else if (jksFileInAndroid.exists()) {
                        storeFile = jksFileInAndroid
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
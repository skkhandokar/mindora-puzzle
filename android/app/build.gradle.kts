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
    namespace = "com.example.flowfix_game"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // পুরনো kotlinOptions এর বদলে এই নতুন ব্লকটি দিন
    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            
            storeFile = keystoreProperties.getProperty("storeFile")?.let { fileName ->
                val fileInAndroid = rootProject.file("android/$fileName")
                val fileInRoot = rootProject.file(fileName)
                if (fileInAndroid.exists()) fileInAndroid else fileInRoot
            }
            
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    defaultConfig {
        applicationId = "com.skkhandokar.mindora"
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
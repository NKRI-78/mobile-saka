import java.util.Properties
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProps = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) {
        f.inputStream().use { load(it) }
    }
}

android {
    namespace = "com.inovasi78.saka"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }

    defaultConfig {
        applicationId = "com.inovasi78.saka"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        val hasReleaseKeystore =
            keystoreProps.getProperty("storeFile")?.isNotBlank() == true &&
            keystoreProps.getProperty("storePassword")?.isNotBlank() == true &&
            keystoreProps.getProperty("keyAlias")?.isNotBlank() == true &&
            keystoreProps.getProperty("keyPassword")?.isNotBlank() == true

        if (hasReleaseKeystore) {
            create("release") {
                val storeFilePath = keystoreProps.getProperty("storeFile")!!.trim()

                storeFile = rootProject.file(storeFilePath)
                storePassword = keystoreProps.getProperty("storePassword")!!.trim()
                keyAlias = keystoreProps.getProperty("keyAlias")!!.trim()
                keyPassword = keystoreProps.getProperty("keyPassword")!!.trim()
            }
        }
    }

    buildTypes {
        release {
            isDebuggable = false
            isMinifyEnabled = true
            isShrinkResources = true

            signingConfig = signingConfigs.findByName("release")
                ?: error("Release keystore not found. Check android/key.properties")

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

        debug {
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    // Play Core modern replacement for Flutter deferred components / SDK 34+ compatible
    implementation("com.google.android.play:feature-delivery:2.1.0")

    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.12.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
}
import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProps = Properties().apply {
    val f = file("key.properties")
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

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
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
                storeFile = file(storeFilePath)
                storePassword = keystoreProps.getProperty("storePassword")!!.trim()
                keyAlias = keystoreProps.getProperty("keyAlias")!!.trim()
                keyPassword = keystoreProps.getProperty("keyPassword")!!.trim()
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true

            signingConfig = signingConfigs.findByName("release")
                ?: signingConfigs.getByName("debug")

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
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
    
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.12.0")
    implementation("com.google.android.play:core:1.10.3")    
    implementation("com.squareup.okhttp3:okhttp:4.12.0") 
}



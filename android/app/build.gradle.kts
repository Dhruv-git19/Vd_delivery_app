import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}
val envFile = rootProject.file("../.env")

val keystoreProperties = Properties()
val flutterRootDir = rootProject.projectDir.parentFile
val keystorePropertiesFile = rootProject.file("../key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
var googleMapsApiKey = ""
if (envFile.exists()) {
    envFile.forEachLine { line ->
        val trimmedLine = line.trim()
        if (trimmedLine.startsWith("GOOGLE_MAPS_API_KEY=") && !trimmedLine.startsWith("#")) {
            googleMapsApiKey = trimmedLine.substring("GOOGLE_MAPS_API_KEY=".length).trim()
        }
    }
}
if (googleMapsApiKey.isEmpty()) {
    println("WARNING: Google Maps API Key is empty!")
}

android {
    namespace = "com.veedasip.delivery_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.veedasip.delivery_app"
        targetSdk = flutter.targetSdkVersion
        minSdk = flutter.minSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["googleMapsApiKey"] = googleMapsApiKey
    }

    signingConfigs {
        create("release") {
            keyAlias = (keystoreProperties["keyAlias"] as String?) ?: ""
            keyPassword = (keystoreProperties["keyPassword"] as String?) ?: ""
            val storeFilePath = (keystoreProperties["storeFile"] as String?)?.trim()
            val resolvedStoreFile = when {
                storeFilePath.isNullOrEmpty() -> flutterRootDir.resolve("veedasip-delivery-key.jks")
                storeFilePath.startsWith("/") -> File(storeFilePath)
                else -> flutterRootDir.resolve(storeFilePath)
            }
            val defaultStoreFile = flutterRootDir.resolve("veedasip-delivery-key.jks")
            storeFile = if (resolvedStoreFile.exists()) resolvedStoreFile else defaultStoreFile
            storePassword = (keystoreProperties["storePassword"] as String?) ?: ""
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

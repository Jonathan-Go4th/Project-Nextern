import java.io.FileInputStream
import java.nio.charset.StandardCharsets
import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseSigning = keystorePropertiesFile.exists()

if (hasReleaseSigning) {
    FileInputStream(keystorePropertiesFile).use {
        keystoreProperties.load(it)
    }
}

fun requiredSigningProperty(name: String): String {
    return keystoreProperties.getProperty(name)
        ?: throw org.gradle.api.GradleException(
            "Missing $name in android/key.properties."
        )
}

fun decodeSigningPassword(name: String): String {
    val encoded = requiredSigningProperty(name)

    return String(
        Base64.getDecoder().decode(encoded),
        StandardCharsets.UTF_8
    )
}

val releaseTaskRequested = gradle.startParameter.taskNames.any {
    it.contains("release", ignoreCase = true)
}

if (releaseTaskRequested && !hasReleaseSigning) {
    throw org.gradle.api.GradleException(
        "Release signing requires android/key.properties."
    )
}

android {
    namespace = "com.team18.nextern"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.team18.nextern"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                keyAlias =
                    requiredSigningProperty("keyAlias")

                keyPassword =
                    decodeSigningPassword("keyPasswordBase64")

                storeFile = file(
                    requiredSigningProperty("storeFile")
                )

                storePassword =
                    decodeSigningPassword("storePasswordBase64")
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseSigning) {
                signingConfig =
                    signingConfigs.getByName("release")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget =
            org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

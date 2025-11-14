// Root-level build.gradle.kts

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Google Services plugin
        classpath("com.google.gms:google-services:4.4.4")
        // Add other classpath dependencies if needed (e.g., Kotlin Gradle plugin)
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: redirect build folders (if you had this setup)
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

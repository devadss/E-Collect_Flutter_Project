buildscript {
    repositories {
        google()       // required for Firebase / Google services
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.15") // Google services plugin
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Configure build directories
val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}


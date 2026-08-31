allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    afterEvaluate {
        val androidExt = project.extensions.findByName("android")
        when (androidExt) {
            is com.android.build.gradle.AppExtension -> {
                androidExt.compileSdk = 35
                androidExt.defaultConfig {
                    minSdk = 21
                    targetSdk = 35
                }
            }
            is com.android.build.gradle.LibraryExtension -> {
                androidExt.compileSdk = 35
                androidExt.defaultConfig {
                    minSdk = 21
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}


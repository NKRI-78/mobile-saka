# OkHttp (dipakai uCrop)
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**
-keep class okio.** { *; }
-dontwarn okio.**

# Kotlin metadata & annotations
-keep class kotlin.Metadata { *; }
-keepattributes *Annotation*

#keep ffmpeg-kit classes
-keep class com.antonkarpenko.ffmpegkit.** { *; }
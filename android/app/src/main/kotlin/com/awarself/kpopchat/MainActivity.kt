package com.awarself.kpopchat

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Declares the window will draw behind system bars — pairs with
        // Flutter's SystemChrome.setEnabledSystemUIMode(SystemUiMode
        // .edgeToEdge) in main.dart. Required-style call for targetSdk 35
        // (Android 15) where every app is implicitly edge-to-edge; this
        // backports the same intent to Android 14 and below so Play's pre-
        // launch report stops flagging the warning.
        //
        // androidx.activity.enableEdgeToEdge() would be the newer
        // shorthand, but it needs androidx.activity:activity-ktx 1.8.0+
        // which isn't in the current Flutter dep tree. WindowCompat is in
        // androidx.core which Flutter already pulls — same net effect.
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}

# Whelp Flutter SDK for native Android applications

This document is in progress. Be aware that some part of the documentation may be missing or incomplete.

```kotlin
package com.example.whelpnative

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

private const val FLUTTER_ENGINE_ID = "flutter_engine"

class MainActivity : AppCompatActivity() {

    private lateinit var startBtn: Button

    private lateinit var flutterEngine : FlutterEngine
    private lateinit var methodChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        initWhelp()

        startBtn = findViewById(R.id.start)
        startBtn.setOnClickListener {
            configureWhelp()
            startActivity(
                FlutterActivity
                    .withCachedEngine(FLUTTER_ENGINE_ID)
                    .build(this))
        }
    }

    private fun initWhelp() {
        flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "whelp")

        FlutterEngineCache
            .getInstance()
            .put(FLUTTER_ENGINE_ID, flutterEngine)
    }

    // Identifiers can be either "email" or "phoneNumber"

    private fun configureWhelp() {
        val json: Map<String, Any> = mapOf(
            // Replace the placeholders with your APP_ID and API_KEY
            "appId" to "{appId}",
            "apiKey" to "{apiKey}",

            // Title displayed under the header
            "headerTitle" to "How can we help you?",

            // Status messages displayed on the header
            "activeStatus" to "We are here to help you!",
            "awayStatus" to "We are away at the moment",
            
            // User information for authentication.
            "fullName" to "Alan Watts",
            "email": "alan@watts.zen"
            "phoneNumber" to "+994501234567",
            "language" to "EN",

            // Identifier is based on which the identity and uniquness of the user is determined: 
            // if matched: previous chats of the user will be loaded, 
            // Else: a new chat will be created.
            "identifier" to "email",

            // Can be Firebase Cloud Messaging token or any other unique identifier.
            "deviceId" to "{fcm_token}"
        )

        methodChannel.invokeMethod("start", json)
    }
}
```
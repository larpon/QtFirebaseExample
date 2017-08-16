package com.blackgrain.android.firebasetest;

import org.qtproject.qt5.android.bindings.QtApplication;
import org.qtproject.qt5.android.bindings.QtActivity;

import android.util.Log;
import android.support.v7.app.AppCompatActivity;

import android.view.WindowManager;

// Messaging support
import android.os.Bundle;
import android.content.Intent;
import com.google.firebase.messaging.MessageForwardingService;

public class Main extends QtActivity {

    /** Called when the activity is first created. */

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

    }


    /**
       * Messaging example
       */
    // The key in the intent's extras that maps to the incoming message's message ID. Only sent by
    // the server, GmsCore sends EXTRA_MESSAGE_ID_KEY below. Server can't send that as it would get
    // stripped by the client.
    private static final String EXTRA_MESSAGE_ID_KEY_SERVER = "message_id";

    // An alternate key value in the intent's extras that also maps to the incoming message's message
    // ID. Used by upstream, and set by GmsCore.
    private static final String EXTRA_MESSAGE_ID_KEY = "google.message_id";

    // The key in the intent's extras that maps to the incoming message's sender value.
    private static final String EXTRA_FROM = "google.message_id";

    /**
       * Workaround for when a message is sent containing both a Data and Notification payload.
       *
       * When the app is in the foreground all data payloads are sent to the method
       * `::firebase::messaging::Listener::OnMessage`. However, when the app is in the background, if a
       * message with both a data and notification payload is receieved the data payload is stored on
       * the notification Intent. NativeActivity does not provide native callbacks for onNewIntent, so
       * it cannot route the data payload that is stored in the Intent to the C++ function OnMessage. As
       * a workaround, we override onNewIntent so that it forwards the intent to the C++ library's
       * service which in turn forwards the data to the native C++ messaging library.
       */
    @Override
    protected void onNewIntent(Intent intent) {
        // If we do not have a 'from' field this intent was not a message and should not be handled. It
        // probably means this intent was fired by tapping on the app icon.

        // TODO
        Bundle extras = intent.getExtras();
        String from = extras.getString(EXTRA_FROM);
        String messageId = extras.getString(EXTRA_MESSAGE_ID_KEY);

        if (messageId == null) {
            messageId = extras.getString(EXTRA_MESSAGE_ID_KEY_SERVER);
        }

        if (from != null && messageId != null) {
            Intent message = new Intent(this, MessageForwardingService.class);
            message.setAction(MessageForwardingService.ACTION_REMOTE_INTENT);
            message.putExtras(intent);
            startService(message);
        }
        setIntent(intent);

    }

}

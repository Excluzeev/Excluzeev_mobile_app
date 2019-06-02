package plugin.stripe.stripeelements;

import android.app.Activity;
import android.content.Intent;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** StripeelementsPlugin */
public class StripeelementsPlugin implements MethodCallHandler, EventChannel.StreamHandler {

  private static final String STREAM_CHANNEL_NAME = "stripeelements_stream";
  private static final int STRIPE_CARD_RESULT = 111223;

  Activity activity;
  static EventChannel.EventSink events;

  StripeelementsPlugin(Activity act) {
    activity = act;
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "stripeelements");
    channel.setMethodCallHandler(new StripeelementsPlugin(registrar.activity()));
    registrar.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
      @Override
      public boolean onActivityResult(int i, int i1, Intent intent) {
        if(i == STRIPE_CARD_RESULT) {
          if(intent != null) {
            if(intent.getBooleanExtra("done", false)) {
              String token = intent.getStringExtra("token");
              if (!token.isEmpty()) {
                if (events != null) {
                  System.out.println(token);
                  events.success(token);
                }
              } else {
                events.success("");
              }
            } else {
              events.success("");
            }
          }
        }
        return false;
      }
    });

    final EventChannel eventChannel = new EventChannel(registrar.messenger(), STREAM_CHANNEL_NAME);
    StripeelementsPlugin stripeWithEventChannel = new StripeelementsPlugin(registrar.activity());
    eventChannel.setStreamHandler(stripeWithEventChannel);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    if (call.method.equals("card")) {
      String key = call.argument("key");

      Intent playerIntent = new Intent(activity, StripeCardActivity.class);
      playerIntent.putExtra("key", key);
      activity.startActivityForResult(playerIntent, STRIPE_CARD_RESULT);

    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onListen(Object o, EventChannel.EventSink eventSink) {
    events = eventSink;
  }

  @Override
  public void onCancel(Object o) {
    events = null;
  }

}

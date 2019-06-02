package plugin.stripe.stripeelements;

import android.content.Intent;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.stripe.android.Stripe;
import com.stripe.android.TokenCallback;
import com.stripe.android.model.Card;
import com.stripe.android.model.Token;
import com.stripe.android.view.CardMultilineWidget;

public class StripeCardActivity extends AppCompatActivity {

    Button cardSubmit;
    CardMultilineWidget cardInputWidget;
    ProgressBar loading;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.stripe_card);

        if(getSupportActionBar() != null)
            getSupportActionBar().hide();


        cardSubmit = findViewById(R.id.cardSubmit);
        cardInputWidget = findViewById(R.id.card_input_widget);
        loading = findViewById(R.id.loading);

        cardSubmit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startPreCheck();
            }
        });
    }

    @Override
    public void onBackPressed() {
//        super.onBackPressed();

        Intent intent = new Intent();
        intent.putExtra("done", false);
        setResult(RESULT_OK, intent);
        finish();
    }

    private void hideSubmit() {
        cardSubmit.setVisibility(View.GONE);
        loading.setVisibility(View.VISIBLE);
    }

    private void showSubmit() {
        loading.setVisibility(View.GONE);
        cardSubmit.setVisibility(View.VISIBLE);
    }

    private void startPreCheck() {
        final Card card = cardInputWidget.getCard();
        if (card == null) {
            // Do not continue token creation.
            Toast.makeText(this, "Invalid card details.", Toast.LENGTH_SHORT).show();
            return;
        }

        hideSubmit();

        Stripe stripe = new Stripe(this, getIntent().getStringExtra("key"));
        stripe.createToken(
                card,
                new TokenCallback() {
                    public void onSuccess(Token token) {
                        // Send token to your server
                        Intent intent = new Intent();
                        intent.putExtra("token", token.getId());
                        intent.putExtra("done", true);
                        setResult(RESULT_OK, intent);
                        finish();
                    }
                    public void onError(Exception error) {
                        // Show localized error message
                        Toast.makeText(StripeCardActivity.this,
                                error.getLocalizedMessage(),
                                Toast.LENGTH_LONG
                        ).show();
                        cardInputWidget.clear();
                        showSubmit();
                    }
                }
        );

    }

}

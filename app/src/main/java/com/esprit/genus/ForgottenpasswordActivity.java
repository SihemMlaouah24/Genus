package com.esprit.genus;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.esprit.genus.Retrofit.INodeJS;
import com.esprit.genus.Retrofit.RetrofitClient;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Retrofit;

public class ForgottenpasswordActivity extends AppCompatActivity {

    INodeJS myAPI;
    CompositeDisposable compositeDisposable = new CompositeDisposable();
    EditText email;
    Button retrievepassword_button;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.forgottenpassword_layout);
        //getSupportActionBar().hide();

        //Init API
        Retrofit retrofit = RetrofitClient.getInstance();
        myAPI = retrofit.create((INodeJS.class));
        email = (EditText) findViewById(R.id.email);
        retrievepassword_button = (Button) findViewById(R.id.retrievepassword_button);

        //Event
        retrievepassword_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (email.getText().toString().equals("")) {
                    Toast.makeText(ForgottenpasswordActivity.this, "Please give an email", Toast.LENGTH_SHORT).show();

                } else if (!email.getText().toString().contains("@")) {
                    Toast.makeText(ForgottenpasswordActivity.this, "Please give a correct email", Toast.LENGTH_SHORT).show();
                } else {
                    getForgottenPassword(email.getText().toString());
                }
            }
        });
         }
        private void getForgottenPassword (String email) {
            compositeDisposable.add(myAPI.getForgottenPassword(email)
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(new Consumer<String>() {
                        @Override
                        public void accept(String s) throws Exception {
                        Toast.makeText(ForgottenpasswordActivity.this, ""+s, Toast.LENGTH_SHORT).show();
                            Intent intent = new Intent(ForgottenpasswordActivity.this, LoginActivity.class);
                            ForgottenpasswordActivity.this.startActivity(intent);
                        }
                    })
            );
        }



}
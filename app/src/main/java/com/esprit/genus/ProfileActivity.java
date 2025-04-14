package com.esprit.genus;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;


import android.content.Intent;
import android.os.Bundle;

import android.view.View;

import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.esprit.genus.Model.Game;
import com.esprit.genus.Retrofit.INodeJS;
import com.esprit.genus.Retrofit.RetrofitClient;

import java.util.List;


import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class ProfileActivity extends AppCompatActivity {

    private TextView account, nightmode, languages, signOut, gamesNbr, favNbr, wishesNbr, username;
    private String idUser="";
    private ImageView userPic;
    CompositeDisposable compositeDisposable = new CompositeDisposable();
    private Button editProfile;
    INodeJS myAPI;
    INodeJS myAPI1;
    AlertDialog dialog;
    AlertDialog.Builder builder;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.profile_layout);


        signOut = (TextView) findViewById(R.id.signout);
        gamesNbr = (TextView) findViewById(R.id.gamesNbr);
        favNbr = (TextView) findViewById(R.id.favNbr);
        wishesNbr = (TextView) findViewById(R.id.wishesNbr);
        username = (TextView) findViewById(R.id.username);
        editProfile=(Button) findViewById(R.id.editProfile);
        userPic=(ImageView) findViewById(R.id.profilePic);
        account = (TextView) findViewById(R.id.account);
        nightmode = (TextView) findViewById(R.id.nightmode);
        languages = (TextView) findViewById(R.id.language);

        //Recuperer les données de homepage
        Intent intent = getIntent();
        if (intent != null) {

            if (intent.hasExtra("idUser")) {
                idUser = intent.getStringExtra("idUser");
            }
            if (intent.hasExtra("username")) {
                username.setText(intent.getStringExtra("username"));
            }
            if (intent.hasExtra("userPicture")) {

                Glide.with(ProfileActivity.this)
                        .load("http://10.0.2.2:3000/image/"+intent.getStringExtra("userPicture"))
                        .into(userPic);

            }

        }
        //Init API
        Retrofit retrofit = RetrofitClient.getInstance();
        myAPI1 = retrofit.create((INodeJS.class));

        //this one i used for the gamenumber , wishnumber , favnumber  because i'm using Gson okay ?
        Retrofit retrofit1 = new Retrofit.Builder()
                .baseUrl("http://10.0.2.2:3000/")
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        myAPI = retrofit1.create((INodeJS.class));

        Call<List<Game>> listWishGames = myAPI.GetWishList(Integer.parseInt(idUser));
        Call<List<Game>> listFavGames = myAPI.GetFavList(Integer.parseInt(idUser));
        Call<List<Game>> listGames = myAPI.GetGameListForNumber(Integer.parseInt(idUser));
        Call <String> getProfilePic = myAPI.GetProfilePic(Integer.parseInt(idUser));


        //dislay user number of games
        listGames.enqueue(new Callback<List<Game>>() {
            @Override
            public void onResponse(Call<List<Game>> call, Response<List<Game>> response) {
                if (!response.isSuccessful()) {

                    return;
                }
                List<Game> Games = response.body();
                int cpt=0;
                for(Game g:Games)
                {

                    cpt++;
                }
                gamesNbr.setText(cpt+"");
            }

            @Override
            public void onFailure(Call<List<Game>> call, Throwable t) {

            }
        });


        //display user number of fav games
        listFavGames.enqueue(new Callback<List<Game>>() {
            @Override
            public void onResponse(Call<List<Game>> call, Response<List<Game>> response) {
                if (!response.isSuccessful()) {

                    return;
                }
                List<Game> FavGames = response.body();
                int cpt=0;
                for(Game g:FavGames)
                {

                    cpt++;
                }
                favNbr.setText(cpt+"");
            }

            @Override
            public void onFailure(Call<List<Game>> call, Throwable t) {

            }
        });

        //display user number of wishlist games
        listWishGames.enqueue(new Callback<List<Game>>() {
            @Override
            public void onResponse(Call<List<Game>> call, Response<List<Game>> response) {
                if (!response.isSuccessful()) {

                    return;
                }
                List<Game> wishGames = response.body();
                int cpt=0;
                for(Game g:wishGames)
                {

                    cpt++;
                }
                wishesNbr.setText(cpt+"");



            }

            @Override
            public void onFailure(Call<List<Game>> call, Throwable t) {

            }
        });

        //display user profile picture
        getProfilePic.enqueue(new Callback<String>() {
            @Override
            public void onResponse(Call<String> call, Response<String> response) {
                if (!response.isSuccessful()) {
                    return;
                }
                String pic=response.body();
                Glide.with(ProfileActivity.this).load("http://10.0.2.2:3000/image/"+pic).into(userPic);
            }
            @Override
            public void onFailure(Call<String> call, Throwable t) {

            }
        });

        //Sign out
        signOut.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfileActivity.this, LoginActivity.class);
                ProfileActivity.this.startActivity(intent);
                finish();
                startActivity(intent);
            }
        });

        //edit profile
        editProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
              /* Intent intent = new Intent(ProfileActivity.this, PopupActivity.class);
                intent.putExtra("idUser",idUser);
                ProfileActivity.this.startActivity(intent);*/
                View vpop=getLayoutInflater().inflate(R.layout.popupwindow_layout,null);
                final EditText username;
                final EditText password;
                final EditText cPassword;
                final EditText oldPassword;
                ImageButton editUsername;
                Button updatePassword;
                Button dismiss;
                username = (EditText) vpop.findViewById(R.id.editusername);
                password = (EditText) vpop.findViewById(R.id.editpassword);
                cPassword = (EditText) vpop.findViewById(R.id.editcpassword);
                oldPassword = (EditText) vpop.findViewById(R.id.editOldpassword);

                editUsername = (ImageButton) vpop.findViewById(R.id.editUsername);
                updatePassword= (Button) vpop.findViewById(R.id.updatePassword);
                dismiss = vpop.findViewById(R.id.dismiss);
                dismiss.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        dialog.dismiss();
                        finish();
                        startActivity(getIntent());
                    }
                });
                editUsername.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (username.getText().toString().equals(""))
                        {
                            Toast.makeText(ProfileActivity.this, "Please give a new username", Toast.LENGTH_SHORT).show();
                        }

                        else {
                            editUsername(idUser, username.getText().toString());
                            Intent intent = getIntent();
                            intent.putExtra("username",username.getText().toString());

                        }

                    }
                });

                updatePassword.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (oldPassword.getText().toString().equals("") || password.getText().toString().equals("")||
                                cPassword.getText().toString().equals(("")))
                        {
                            Toast.makeText(ProfileActivity.this, "Please fill in all fields", Toast.LENGTH_SHORT).show();
                        }
                        else if(!password.getText().toString().equals(cPassword.getText().toString()))
                        {
                            Toast.makeText(ProfileActivity.this, "the two password fields should be same", Toast.LENGTH_SHORT).show();
                        }
                        else {
                            editPassword(idUser, oldPassword.getText().toString(), password.getText()
                                    .toString());

                        }

                    }
                });

              builder=new AlertDialog.Builder(ProfileActivity.this);
              builder.setView(vpop);
              dialog=builder.create();
              dialog.show();
            }
        });

        //activate nightmode
        nightmode.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(ProfileActivity.this, "Coming Soon", Toast.LENGTH_SHORT).show();
            }
        });

        //edit language
        languages.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(ProfileActivity.this, "Coming Soon", Toast.LENGTH_SHORT).show();
            }
        });

    }

    private void editUsername(String idUser,String username) {


        compositeDisposable.add(myAPI1.editUsername(Integer.parseInt(idUser),username)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        Toast.makeText(ProfileActivity.this, "" + s, Toast.LENGTH_SHORT).show();
                    }


                }));

    }


    private void editPassword(String idUser,String oldPassword,String newPassword) {


        compositeDisposable.add(myAPI1.editPassword(Integer.parseInt(idUser),oldPassword,newPassword)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        Toast.makeText(ProfileActivity.this, "" + s, Toast.LENGTH_SHORT).show();
                    }


                }));

    }
}

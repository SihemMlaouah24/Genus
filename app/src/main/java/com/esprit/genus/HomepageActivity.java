package com.esprit.genus;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;

import com.esprit.genus.Retrofit.INodeJS;
import com.esprit.genus.Retrofit.RetrofitClient;

import io.reactivex.disposables.CompositeDisposable;
import retrofit2.Retrofit;


public class HomepageActivity extends AppCompatActivity {

    INodeJS myAPI;
    CompositeDisposable compositeDisposable = new CompositeDisposable();

    private ImageView profileIcon, libIcon, loopIcon, heartIcon, chatIcon;
    private TextView profileTitle, libTitle, loopTitle, heartTitle, chatTitle;
    public Fragment selectedFragment = null;
    private String idUser = "";
    private String username = "";
    private String userPicture = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.homepage_layout);

        //Recuperer les données envoyé par login on oncreate
        Intent intent = getIntent();
        if (intent != null) {

            if (intent.hasExtra("idUser")) {
                idUser = intent.getStringExtra("idUser");
            }
            if (intent.hasExtra("username")) {
                username = intent.getStringExtra("username");
            }
            if (intent.hasExtra("userPicture")) {
                userPicture = intent.getStringExtra("userPicture");
            }

        }

        //this is to send data from activity to fragments
        final Bundle bundle = new Bundle();
        bundle.putString("idUser", idUser);
        bundle.putString("username",username);
        bundle.putString("userPicture",userPicture);

        //Init API
        Retrofit retrofit = RetrofitClient.getInstance();
        myAPI = retrofit.create((INodeJS.class));

        profileIcon = (ImageView) findViewById(R.id.userIcon);
        profileTitle = (TextView) findViewById(R.id.profile);
        libIcon = (ImageView) findViewById(R.id.libIcon);
        libTitle = (TextView) findViewById(R.id.lib);
        loopIcon = (ImageView) findViewById(R.id.loopIcon);
        loopTitle = (TextView) findViewById(R.id.loop);
        heartIcon = (ImageView) findViewById(R.id.heartIcon);
        heartTitle = (TextView) findViewById(R.id.wishlist);
        chatIcon = (ImageView) findViewById(R.id.chatIcon);
        chatTitle = (TextView) findViewById(R.id.chat);
        selectedFragment = new HomeFragmentActivity();
        selectedFragment.setArguments(bundle);
        getSupportFragmentManager().beginTransaction().replace(R.id.fragmentContainer, selectedFragment).commit();
        loopIcon.setImageResource(R.drawable.loop);
        loopTitle.setTextColor(getResources().getColor(R.color.colorPrimary));

        profileIcon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                //Fragment display
                Intent intent = new Intent(HomepageActivity.this, ProfileActivity.class);
                intent.putExtra("idUser", idUser);
                intent.putExtra("username", username);
                intent.putExtra("userPicture", userPicture);
                HomepageActivity.this.startActivity(intent);

                //Fragments navigation coloring
                profileIcon.setImageResource(R.drawable.user3);
                profileTitle.setTextColor(getResources().getColor(R.color.colorPrimary));

                loopIcon.setImageResource(R.drawable.loop2);
                loopTitle.setTextColor(getResources().getColor(R.color.hintColor));
                libIcon.setImageResource(R.drawable.library2);
                libTitle.setTextColor(getResources().getColor(R.color.hintColor));
                heartIcon.setImageResource(R.drawable.heart2);
                heartTitle.setTextColor(getResources().getColor(R.color.hintColor));
                chatIcon.setImageResource(R.drawable.chat2);
                chatTitle.setTextColor(getResources().getColor(R.color.hintColor));
            }
        });

        libIcon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Fragments navigation coloring
                libIcon.setImageResource(R.drawable.library);
                libTitle.setTextColor(getResources().getColor(R.color.colorPrimary));

                profileIcon.setImageResource(R.drawable.user2);
                profileTitle.setTextColor(getResources().getColor(R.color.hintColor));
                loopIcon.setImageResource(R.drawable.loop2);
                loopTitle.setTextColor(getResources().getColor(R.color.hintColor));
                heartIcon.setImageResource(R.drawable.heart2);
                heartTitle.setTextColor(getResources().getColor(R.color.hintColor));
                chatIcon.setImageResource(R.drawable.chat2);
                chatTitle.setTextColor(getResources().getColor(R.color.hintColor));

                //Fragment display
                selectedFragment = new GamelistActivity();
                selectedFragment.setArguments(bundle);
                getSupportFragmentManager().beginTransaction().replace(R.id.fragmentContainer, selectedFragment).commit();


            }
        });

        loopIcon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Fragments navigation coloring
                loopIcon.setImageResource(R.drawable.loop);
                loopTitle.setTextColor(getResources().getColor(R.color.colorPrimary));

                profileIcon.setImageResource(R.drawable.user2);
                profileTitle.setTextColor(getResources().getColor(R.color.hintColor));
                libIcon.setImageResource(R.drawable.library2);
                libTitle.setTextColor(getResources().getColor(R.color.hintColor));
                heartIcon.setImageResource(R.drawable.heart2);
                heartTitle.setTextColor(getResources().getColor(R.color.hintColor));
                chatIcon.setImageResource(R.drawable.chat2);
                chatTitle.setTextColor(getResources().getColor(R.color.hintColor));

                selectedFragment = new HomeFragmentActivity();
                selectedFragment.setArguments(bundle);
                getSupportFragmentManager().beginTransaction().replace(R.id.fragmentContainer, selectedFragment).commit();
            }
        });

        heartIcon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Fragments navigation coloring
                heartIcon.setImageResource(R.drawable.heart);
                heartTitle.setTextColor(getResources().getColor(R.color.colorPrimary));

                profileIcon.setImageResource(R.drawable.user2);
                profileTitle.setTextColor(getResources().getColor(R.color.hintColor));
                libIcon.setImageResource(R.drawable.library2);
                libTitle.setTextColor(getResources().getColor(R.color.hintColor));
                loopIcon.setImageResource(R.drawable.loop2);
                loopTitle.setTextColor(getResources().getColor(R.color.hintColor));
                chatIcon.setImageResource(R.drawable.chat2);
                chatTitle.setTextColor(getResources().getColor(R.color.hintColor));

                //Fragment display
                selectedFragment = new WishlistActivity();
                selectedFragment.setArguments(bundle);
                getSupportFragmentManager().beginTransaction().replace(R.id.fragmentContainer, selectedFragment).commit();
            }
        });

        chatIcon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Fragments navigation coloring
                chatIcon.setImageResource(R.drawable.chat);
                chatTitle.setTextColor(getResources().getColor(R.color.colorPrimary));

                profileIcon.setImageResource(R.drawable.user2);
                profileTitle.setTextColor(getResources().getColor(R.color.hintColor));
                libIcon.setImageResource(R.drawable.library2);
                libTitle.setTextColor(getResources().getColor(R.color.hintColor));
                heartIcon.setImageResource(R.drawable.heart2);
                heartTitle.setTextColor(getResources().getColor(R.color.hintColor));
                loopIcon.setImageResource(R.drawable.loop2);
                loopTitle.setTextColor(getResources().getColor(R.color.hintColor));

                //Fragment display
                selectedFragment = new TopicsActivity();
                selectedFragment.setArguments(bundle);
                getSupportFragmentManager().beginTransaction().replace(R.id.fragmentContainer, selectedFragment).commit();
            }
        });

    }


    @Override
    protected void onStop() {
        compositeDisposable.clear();
        super.onStop();

    }

    @Override
    protected void onDestroy() {
        compositeDisposable.clear();
        super.onDestroy();
    }

}
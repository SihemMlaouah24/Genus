package com.esprit.genus;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.ButtonBarLayout;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.esprit.genus.Adapter.CommentAdapter;
import com.esprit.genus.Model.Comment;
import com.esprit.genus.Model.Game;
import com.esprit.genus.Retrofit.INodeJS;
import com.esprit.genus.Retrofit.RetrofitClient;
import com.jgabrielfreitas.core.BlurImageView;

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

public class GamescreenActivity extends AppCompatActivity {

    INodeJS myAPI, myAPI1;
    CompositeDisposable compositeDisposable = new CompositeDisposable();

    private int idGame, idUser;
    private ImageView gameImg, star1, star2, star3, star4, star5;
    BlurImageView gameBg;
    private TextView gameName, studioName, favNbr, cmtNbr, gameDesc, favCount, cmCount;
    private Button addGame, addWishlist, addFav, removeWishlist, removeFav, removeGame;
    private ImageButton comment;
    private EditText commentText;

    RecyclerView recycler_comments;
    LinearLayoutManager layoutManager;
    CommentAdapter adapter;


    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.gamescreen_layout);

        //Get gameId
        Intent intent = getIntent();
        if (intent != null) {

            if (intent.hasExtra("idGame")) {
                idGame = Integer.parseInt(intent.getStringExtra("idGame"));
            }
        }

        //Get userId
        Intent intent2 = getIntent();
        if (intent2 != null) {
            if (intent2.hasExtra("idUser")) {
                idUser = Integer.parseInt(intent2.getStringExtra("idUser"));
            }
        }

        //verify that we got the game ID
        //Toast.makeText(this, "idGame: " + idGame, Toast.LENGTH_SHORT).show();
        //verify that we got the user ID
        //Toast.makeText(this, "idUser: " + idUser, Toast.LENGTH_SHORT).show();

        //Init API
        Retrofit retrofit = RetrofitClient.getInstance();
        myAPI = retrofit.create((INodeJS.class));

        Retrofit retrofit1 = new Retrofit.Builder()
                .baseUrl("http://10.0.2.2:3000/")
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        myAPI1 = retrofit1.create((INodeJS.class));
        final Call<List<Game>> myGame = myAPI1.GetGameDetails(idGame);
        final Call<List<Comment>> listComments = myAPI1.GetComments(idGame);
        final Call<String> nbFav = myAPI1.GetFavoriteNbr(idGame);
        final Call<String> nbComments = myAPI1.GetCommentNbr(idGame);

        //our views
        gameImg = (ImageView) findViewById(R.id.gameImg);
        gameBg = (BlurImageView) findViewById(R.id.gameBg);
        gameName = (TextView) findViewById(R.id.gameName);
        studioName = (TextView) findViewById(R.id.gameStudio);
        favNbr = (TextView) findViewById(R.id.favCount);
        cmtNbr = (TextView) findViewById(R.id.cmCount);
        gameDesc = (TextView) findViewById(R.id.gameDesc);
        favCount = (TextView) findViewById(R.id.favCount);
        cmCount = (TextView) findViewById(R.id.cmCount);
        star1 = (ImageView) findViewById(R.id.star_empty1);
        star2 = (ImageView) findViewById(R.id.star_empty2);
        star3 = (ImageView) findViewById(R.id.star_empty3);
        star4 = (ImageView) findViewById(R.id.star_empty4);
        star5 = (ImageView) findViewById(R.id.star_empty5);


        //view for the comment section
        recycler_comments = (RecyclerView) findViewById(R.id.recyclerViewComments);
        recycler_comments.setHasFixedSize(true);
        layoutManager = new LinearLayoutManager(this);
        recycler_comments.setLayoutManager(layoutManager);
        recycler_comments.addItemDecoration(new DividerItemDecoration(this, layoutManager.getOrientation()));
        commentText = (EditText) findViewById(R.id.commentField);

        //our buttons
        addGame = (Button) findViewById(R.id.addButton);
        addWishlist = (Button) findViewById(R.id.addWishlist);
        addFav = (Button) findViewById(R.id.addFavorite);
        comment = (ImageButton) findViewById(R.id.sendComment);
        removeFav = (Button) findViewById(R.id.removeFavorite);
        removeWishlist = (Button) findViewById(R.id.removeWishlist);
        removeGame = (Button) findViewById(R.id.removeButton);

        removeFav.setVisibility(View.GONE);
        removeWishlist.setVisibility(View.GONE);
        removeGame.setVisibility(View.GONE);

        //add to the gamelist
        addGame.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Call<String> verif = myAPI1.VerifyGamelist(idUser, idGame);
                verif.enqueue(new Callback<String>() {
                    @Override
                    public void onResponse(Call<String> call, Response<String> response) {
                        if (!response.isSuccessful()) {
                            return;
                        }
                        String result = response.body();
                        if (result.contains("false")) {
                            addToGameList(idUser, idGame);
                            removeGame.setVisibility(View.VISIBLE);
                        } else {
                           addGame.setVisibility(View.GONE);
                        }
                    }

                    @Override
                    public void onFailure(Call<String> call, Throwable t) {

                    }
                });
            }
        });

        //add to wishlist
        addWishlist.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Call<String> verif = myAPI1.VerifyWishlist(idUser, idGame);
                verif.enqueue(new Callback<String>() {
                    @Override
                    public void onResponse(Call<String> call, Response<String> response) {
                        if (!response.isSuccessful()) {
                            return;
                        }
                        String result = response.body();
                        if (result.contains("false")) {
                            addToWishList(idUser, idGame);
                            removeWishlist.setVisibility(View.VISIBLE);
                        } else {
                           addWishlist.setVisibility(View.GONE);
                        }

                    }

                    @Override
                    public void onFailure(Call<String> call, Throwable t) {

                    }
                });
            }
        });

        //add to favlist
        addFav.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final Call<String> verif = myAPI1.VerifyFavlist(idUser, idGame);
                verif.enqueue(new Callback<String>() {
                    @Override
                    public void onResponse(Call<String> call, Response<String> response) {
                        if (!response.isSuccessful()) {
                            return;
                        }
                        String result = response.body();
                        if (result.contains("false")) {
                            addToFavList(idUser, idGame);
                            removeFav.setVisibility(View.VISIBLE);
                        } else {
                           addFav.setVisibility(View.GONE);
                        }
                    }

                    @Override
                    public void onFailure(Call<String> call, Throwable t) {

                    }
                });
            }
        });

        //remove from list
        removeGame.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                removeFromGameList(idGame, idUser);
                removeGame.setVisibility(View.GONE);
                addGame.setVisibility(View.VISIBLE);
            }
        });

        //remove from favlist
        removeFav.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                removeFromFavList(idGame, idUser);
                removeFav.setVisibility(View.GONE);
                addFav.setVisibility(View.VISIBLE);
            }
        });

        //remove from wishlist
        removeWishlist.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                removeFromWishList(idGame, idUser);
                removeWishlist.setVisibility(View.GONE);
                addWishlist.setVisibility(View.VISIBLE);
            }
        });


        //add comment
        comment.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                addComment(commentText.getText().toString(), idUser, idGame);
                finish();
                startActivity(getIntent());
            }
        });



        //display our game informations
        myGame.enqueue(new Callback<List<Game>>() {
            @Override
            public void onResponse(Call<List<Game>> call, Response<List<Game>> response) {
                if (!response.isSuccessful()) {
                    return;
                }

                List<Game> gameDetails = response.body();
                Call<String> verifGame = myAPI1.VerifyGamelist(idUser, idGame);
                Call<String> verifFav = myAPI1.VerifyFavlist(idUser, idGame);
                Call<String> verifWish = myAPI1.VerifyWishlist(idUser, idGame);

                int cpt = 0;
                for (Game g : gameDetails) {
                    gameName.setText(g.getName());
                    studioName.setText("by " + g.getCompanyName());
                    gameDesc.setText(g.getDescription());
                    Glide.with(GamescreenActivity.this)
                            .load("http://10.0.2.2:3000/image/" + g.getGamePicture())
                            .into(gameImg);
                    Glide.with(GamescreenActivity.this)
                            .load("http://10.0.2.2:3000/image/" + g.getGamePicture())
                            .into(gameBg);

                    switch (g.getRating()) {
                        case 5:
                            star1.setImageResource(R.drawable.ic_star_full);
                            star2.setImageResource(R.drawable.ic_star_full);
                            star3.setImageResource(R.drawable.ic_star_full);
                            star4.setImageResource(R.drawable.ic_star_full);
                            star5.setImageResource(R.drawable.ic_star_full);
                            break;

                        case 4:
                            star1.setImageResource(R.drawable.ic_star_full);
                            star2.setImageResource(R.drawable.ic_star_full);
                            star3.setImageResource(R.drawable.ic_star_full);
                            star4.setImageResource(R.drawable.ic_star_full);
                            break;

                        case 3:
                            star1.setImageResource(R.drawable.ic_star_full);
                            star2.setImageResource(R.drawable.ic_star_full);
                            star3.setImageResource(R.drawable.ic_star_full);
                            break;

                        case 2:
                            star1.setImageResource(R.drawable.ic_star_full);
                            star2.setImageResource(R.drawable.ic_star_full);
                            break;

                        case 1:
                            star1.setImageResource(R.drawable.ic_star_full);
                            break;
                    }

                    verifGame.enqueue(new Callback<String>() {
                        @Override
                        public void onResponse(Call<String> call, Response<String> response) {
                            if (!response.isSuccessful()) {
                                return;
                            }
                            String result = response.body();
                            if (result.contains("true")) {
                                addGame.setVisibility(View.INVISIBLE);
                                removeGame.setVisibility(View.VISIBLE);
                            }
                        }

                        @Override
                        public void onFailure(Call<String> call, Throwable t) {
                        }
                    });

                    verifFav.enqueue(new Callback<String>() {
                        @Override
                        public void onResponse(Call<String> call, Response<String> response) {
                            if (!response.isSuccessful()) {
                                return;
                            }
                            String result = response.body();
                            if (result.contains("true")) {
                                removeFav.setVisibility(View.VISIBLE);
                            }
                        }

                        @Override
                        public void onFailure(Call<String> call, Throwable t) {
                        }
                    });

                    verifWish.enqueue(new Callback<String>() {
                        @Override
                        public void onResponse(Call<String> call, Response<String> response) {
                            if (!response.isSuccessful()) {
                                return;
                            }
                            String result = response.body();
                            if (result.contains("true")) {
                                removeWishlist.setVisibility(View.VISIBLE);
                            }
                        }

                        @Override
                        public void onFailure(Call<String> call, Throwable t) {
                        }
                    });
                }
            }

            @Override
            public void onFailure(Call<List<Game>> call, Throwable t) {
                Toast.makeText(GamescreenActivity.this, "Not found", Toast.LENGTH_SHORT).show();
            }
        });

        //display our comment section
        listComments.enqueue(new Callback<List<Comment>>() {
            @Override
            public void onResponse(Call<List<Comment>> call, Response<List<Comment>> response) {
                if (!response.isSuccessful()) {
                    return;
                }
                List<Comment> comments = response.body();
                adapter = new CommentAdapter(GamescreenActivity.this, idUser,comments);
                recycler_comments.setAdapter(adapter);
            }

            @Override
            public void onFailure(Call<List<Comment>> call, Throwable t) {
                Toast.makeText(GamescreenActivity.this, "Not found", Toast.LENGTH_SHORT).show();
            }
        });

        //display number of favorites
        nbFav.enqueue(new Callback<String>() {
            @Override
            public void onResponse(Call<String> call, Response<String> response) {
                if (!response.isSuccessful()) {
                    return;
                }
                String result = response.body();
                favCount.setText(result);
            }

            @Override
            public void onFailure(Call<String> call, Throwable t) {

            }
        });

        //display number of comments
        nbComments.enqueue(new Callback<String>() {
            @Override
            public void onResponse(Call<String> call, Response<String> response) {
                if (!response.isSuccessful()) {
                    return;
                }
                String result = response.body();
                cmCount.setText(result);
            }

            @Override
            public void onFailure(Call<String> call, Throwable t) {

            }
        });

    }

    private void addToGameList(int idUser, int idGame) {

        compositeDisposable.add(myAPI.AddToGameList(idUser, idGame)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        Toast.makeText(GamescreenActivity.this, "Game Added", Toast.LENGTH_SHORT).show();
                    }
                })
        );
    }

    private void addToWishList(int idUser, int idGame) {

        compositeDisposable.add(myAPI.AddToWishList(idUser, idGame)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        Toast.makeText(GamescreenActivity.this, "Game Added to wishlist", Toast.LENGTH_SHORT).show();
                    }
                })
        );
    }

    private void addToFavList(int idUser, int idGame) {

        compositeDisposable.add(myAPI.AddToFavList(idUser, idGame)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        Toast.makeText(GamescreenActivity.this, "Game Added to favorite list", Toast.LENGTH_SHORT).show();
                    }
                })
        );
    }

    private void addComment(String commentText, int idUser, int idGame) {

        compositeDisposable.add(myAPI.AddComment(commentText, idUser, idGame)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        Toast.makeText(GamescreenActivity.this, "Comment Added", Toast.LENGTH_SHORT).show();
                    }
                })
        );
    }

    private void removeFromGameList (int idGame, int idUser) {

        compositeDisposable.add(myAPI.deleteFromList(idGame, idUser)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        Toast.makeText(GamescreenActivity.this, "Game Removed", Toast.LENGTH_SHORT).show();
                    }
                })
        );
    }

    private void removeFromWishList (int idGame, int idUser) {

        compositeDisposable.add(myAPI.deleteFromWishList(idGame, idUser)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        Toast.makeText(GamescreenActivity.this, "Game Removed from wishlist", Toast.LENGTH_SHORT).show();
                    }
                })
        );
    }

    private void removeFromFavList (int idGame, int idUser) {

        compositeDisposable.add(myAPI.deleteFromFavList(idGame, idUser)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        Toast.makeText(GamescreenActivity.this, "Game Removed from favorite list", Toast.LENGTH_SHORT).show();
                    }
                })
        );
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
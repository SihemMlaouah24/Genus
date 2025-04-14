package com.esprit.genus;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.esprit.genus.Adapter.GameAdapter;
import com.esprit.genus.Adapter.GameVerticalAdapter;
import com.esprit.genus.Model.Game;
import com.esprit.genus.Retrofit.INodeJS;
import com.esprit.genus.Retrofit.RetrofitClient;
import com.mancj.materialsearchbar.MaterialSearchBar;

import java.util.ArrayList;
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

public class GamelistActivity extends Fragment {

    INodeJS myAPI, myAPI1;
    CompositeDisposable compositeDisposable = new CompositeDisposable();

    RecyclerView recycler_games, recycler_fav;
    LinearLayoutManager layoutManager, layoutManagerFav;
    GameAdapter adapter;
    GameVerticalAdapter vAdapter;
    MaterialSearchBar materialSearchBar;
    List<String> suggestList = new ArrayList<>();
    protected View mView;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_gamelist, container, false);
        this.mView = view;

        //Get userID
        String getidUser = this.getArguments().getString("idUser");
        int idUser = 0;
        try {
            idUser=Integer.parseInt(getidUser);
        } catch (NumberFormatException e) {
            Toast.makeText(getContext(), "No user logged in", Toast.LENGTH_SHORT).show();
        }

        //Init API
        Retrofit retrofit = RetrofitClient.getInstance();
        myAPI = retrofit.create((INodeJS.class));

        Retrofit retrofit1 = new Retrofit.Builder()
                .baseUrl("http://10.0.2.2:3000/")
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        myAPI1 = retrofit1.create((INodeJS.class));
        final Call<List<Game>> listGames = myAPI1.GetGameList(idUser);
        final Call<List<Game>> listFavGames = myAPI1.GetFavList(idUser);


        //View for gameList
        recycler_games = (RecyclerView) mView.findViewById(R.id.recyclerViewGames);
        recycler_games.setHasFixedSize(true);
        layoutManager = new LinearLayoutManager(getContext());
        recycler_games.setLayoutManager(layoutManager);
        recycler_games.addItemDecoration(new DividerItemDecoration(getContext(), layoutManager.getOrientation()));

        //View for favList
        recycler_fav = (RecyclerView) mView.findViewById(R.id.recyclerViewFav);
        recycler_fav.setHasFixedSize(true);
        layoutManagerFav = new LinearLayoutManager(getContext(),LinearLayoutManager.HORIZONTAL, false);
        recycler_fav.setLayoutManager(layoutManagerFav);
        recycler_fav.addItemDecoration(new DividerItemDecoration(getContext(), layoutManagerFav.getOrientation()));

        materialSearchBar = (MaterialSearchBar) mView.findViewById(R.id.search_bar);
        materialSearchBar.setCardViewElevation(10);

        //Add Suggest List
        addSuggestList();

        //Display elements on suggest list
        materialSearchBar.addTextChangeListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                List<String> suggest = new ArrayList<>();
                for (String search_term:suggestList) {
                    if (search_term.toLowerCase().contains(materialSearchBar.getText().toLowerCase())) {
                        suggest.add(search_term);
                    }
                }
                materialSearchBar.setLastSuggestions(suggest);

            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });

        //Display search result
        //final int finalIdUser = idUser;
/*        materialSearchBar.setOnSearchActionListener(new MaterialSearchBar.OnSearchActionListener() {
            @Override
            public void onSearchStateChanged(boolean enabled) {
                if (!enabled) {
                    //getAllGames(finalIdUser);

                    listGames.enqueue(new Callback<List<Game>>() {
                        @Override
                        public void onResponse(Call<List<Game>> call, Response<List<Game>> response) {
                            if (!response.isSuccessful()) {
                                return;
                            }
                            List<Game> games = response.body();
                            adapter = new GameAdapter(getContext(),games,Integer.parseInt(getidUser));
                            recycler_games.setAdapter(adapter);
                        }
                        @Override
                        public void onFailure(Call<List<Game>> call, Throwable t) {
                            Toast.makeText(getContext(), "Not found", Toast.LENGTH_SHORT).show();
                        }
                    });
                }
            }

            @Override
            public void onSearchConfirmed(CharSequence text) {
                startSearch(text.toString());
            }

            @Override
            public void onButtonClicked(int buttonCode) {

            }
        });*/


        //Method to call games list
        listGames.enqueue(new Callback<List<Game>>() {
            @Override
            public void onResponse(Call<List<Game>> call, Response<List<Game>> response) {
                if (!response.isSuccessful()) {
                    return;
                }
                List<Game> games = response.body();
                adapter = new GameAdapter(getContext(),games,Integer.parseInt(getidUser));
                recycler_games.setAdapter(adapter);
            }
            @Override
            public void onFailure(Call<List<Game>> call, Throwable t) {
                Toast.makeText(getContext(), "Not found", Toast.LENGTH_SHORT).show();
            }
        });

        //Method to call fav games list
        listFavGames.enqueue(new Callback<List<Game>>() {
            @Override
            public void onResponse(Call<List<Game>> call, Response<List<Game>> response) {
                if (!response.isSuccessful()) {
                    return;
                }
                List<Game> games = response.body();
                vAdapter = new GameVerticalAdapter(getContext(),games, Integer.parseInt(getidUser));
                recycler_fav.setAdapter(vAdapter);
            }
            @Override
            public void onFailure(Call<List<Game>> call, Throwable t) {
                Toast.makeText(getContext(), "Not found", Toast.LENGTH_SHORT).show();
            }
        });


        return view;
    }

/*    private void startSearch(String query) {
        compositeDisposable.add(myAPI.searchGames(query)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<List<Game>>() {
                    @Override
                    public void accept(List<Game> games) throws Exception {
                      adapter = new GameAdapter(getContext(),games,Integer.parseInt(getidUser));
                        recycler_games.setAdapter(adapter);

                    }
                }, new Consumer<Throwable>() {
                    @Override
                    public void accept(Throwable throwable) throws Exception {
                        Toast.makeText(getContext(), "Not found", Toast.LENGTH_SHORT).show();
                    }
                }));
    }*/


    private void addSuggestList() {
        //load items manually for suggest list
        suggestList.add("League of legends");
        suggestList.add("World of warcraft");
        suggestList.add("Dota 2");
        suggestList.add("Counter Strike");
        suggestList.add("GTA");

        materialSearchBar.setLastSuggestions(suggestList);
    }
}
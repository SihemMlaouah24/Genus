package com.esprit.genus.Adapter;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;
import androidx.core.app.ActivityCompat;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;
import androidx.recyclerview.widget.RecyclerView;


import com.esprit.genus.ChatActivitySocket;
import com.esprit.genus.GamePictureShape.RoundRectCornerImageView;
import com.esprit.genus.Interfaces.ITopicClickListener;
import com.esprit.genus.Model.Chat;
import com.esprit.genus.R;
import com.esprit.genus.Retrofit.INodeJS;
import com.esprit.genus.Retrofit.RetrofitClient;
import com.esprit.genus.TopicsActivity;


import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class TopicAdapter extends RecyclerView.Adapter<TopicAdapter.MyViewHolder> {

    List<Chat> chatList;
    Context mContext;
    String name;
    String idUser;

    String userPicture;
    INodeJS myAPI,myAPI1;
    Retrofit retrofit = RetrofitClient.getInstance();
    Retrofit retrofit1 = new Retrofit.Builder()
            .baseUrl("http://10.0.2.2:3000/")
                .addConverterFactory(GsonConverterFactory.create())
            .build();

    CompositeDisposable compositeDisposable = new CompositeDisposable();


    List<String> idLists=new List<String>() {
        @Override
        public int size() {
            return 0;
        }

        @Override
        public boolean isEmpty() {
            return false;
        }

        @Override
        public boolean contains(@Nullable Object o) {
            return false;
        }

        @NonNull
        @Override
        public Iterator<String> iterator() {
            return null;
        }

        @NonNull
        @Override
        public Object[] toArray() {
            return new Object[0];
        }

        @NonNull
        @Override
        public <T> T[] toArray(@NonNull T[] a) {
            return null;
        }

        @Override
        public boolean add(String s) {
            return false;
        }

        @Override
        public boolean remove(@Nullable Object o) {
            return false;
        }

        @Override
        public boolean containsAll(@NonNull Collection<?> c) {
            return false;
        }

        @Override
        public boolean addAll(@NonNull Collection<? extends String> c) {
            return false;
        }

        @Override
        public boolean addAll(int index, @NonNull Collection<? extends String> c) {
            return false;
        }

        @Override
        public boolean removeAll(@NonNull Collection<?> c) {
            return false;
        }

        @Override
        public boolean retainAll(@NonNull Collection<?> c) {
            return false;
        }

        @Override
        public void clear() {

        }

        @Override
        public String get(int index) {
            return null;
        }

        @Override
        public String set(int index, String element) {
            return null;
        }

        @Override
        public void add(int index, String element) {

        }

        @Override
        public String remove(int index) {
            return null;
        }

        @Override
        public int indexOf(@Nullable Object o) {
            return 0;
        }

        @Override
        public int lastIndexOf(@Nullable Object o) {
            return 0;
        }

        @NonNull
        @Override
        public ListIterator<String> listIterator() {
            return null;
        }

        @NonNull
        @Override
        public ListIterator<String> listIterator(int index) {
            return null;
        }

        @NonNull
        @Override
        public List<String> subList(int fromIndex, int toIndex) {
            return null;
        }
    };

    public TopicAdapter(Context mContext, List<Chat> chatList, String name,String idUser,String userPicture) {
        this.chatList = chatList;
        this.mContext= mContext;
        this.name=name;
        this.idUser=idUser;
        this.userPicture=userPicture;
    }


    @NonNull
    @Override
    public TopicAdapter.MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext()).inflate(R.layout.gametopicitem_layout, parent, false);
        return new TopicAdapter.MyViewHolder(itemView);
    }


    @Override
    public void onBindViewHolder(@NonNull TopicAdapter.MyViewHolder holder, int position) {
        String part1 = chatList.get(position).getDate().toString().substring(0,10);
        String part2 = chatList.get(position).getDate().toString().substring(30,34);
        holder.topicDate.setText(part1+" "+part2);
        holder.topic.setText(chatList.get(position).getTopic());
        //holder.membersNumber
        holder.username.setText(chatList.get(position).getUsername());




        holder.setTopicClickListener(new ITopicClickListener() {
            @Override
            public void onTopicClick(View view, int position) {
                Toast.makeText(mContext, ""+chatList.get(position).getTopic(), Toast.LENGTH_SHORT).show();
            }
        });
        myAPI1 = retrofit1.create((INodeJS.class));
        final Call<String> cpt = myAPI1.GetMembersNbr(chatList.get(position).getIdChat());
        //display number of favorites
        cpt.enqueue(new Callback<String>() {
            @Override
            public void onResponse(Call<String> call, Response<String> response) {
                if (!response.isSuccessful()) {
                    return;
                }
                String result = response.body();
                holder.membersNumber.setText("Members : "+result);
            }

            @Override
            public void onFailure(Call<String> call, Throwable t) {

            }
        });

        holder.delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                myAPI = retrofit.create((INodeJS.class));
                myAPI1 = retrofit1.create((INodeJS.class));
                final Call<String> existe = myAPI1.VerifyTopicCreator(Integer.parseInt(idUser),chatList.get(position).getIdChat());
                existe.enqueue(new Callback<String>() {
                    @Override
                    public void onResponse(Call<String> call, Response<String> response) {
                        if (!response.isSuccessful()) {
                            return;
                        }
                        String existe = response.body();
                        if(existe.contains("true"))
                        {

                            deleteTopic(Integer.parseInt(idUser),chatList.get(position).getIdChat());
                            chatList.remove(position);
                            notifyDataSetChanged();
                        }
                        else
                        {
                            Toast.makeText(mContext, "You can't delete this topic !  you're not the creator", Toast.LENGTH_SHORT).show();
                        }
                    }
                    @Override
                    public void onFailure(Call<String> call, Throwable t) {

                    }
                });
            }
        });
    }

    @Override
    public int getItemCount() {
        return chatList.size();
    }

    public class MyViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        CardView root_view;
        TextView topic,membersNumber,topicDate,username;
        RoundRectCornerImageView topicPic;
        Button btnJoin;
        Button delete;

        ITopicClickListener topicClickListener;

        public void setTopicClickListener(ITopicClickListener topicClickListener) {
            this.topicClickListener = topicClickListener;
        }

        public MyViewHolder(@NonNull View itemView) {
            super(itemView);
            mContext = itemView.getContext();

            root_view = (CardView) itemView.findViewById(R.id.root_view);
            topicPic = (RoundRectCornerImageView) itemView.findViewById(R.id.topicPic);
            topic = (TextView) itemView.findViewById(R.id.topic);
            membersNumber = (TextView) itemView.findViewById(R.id.membersNumber);
            topicDate = (TextView) itemView.findViewById(R.id.topicDate);
            username = (TextView) itemView.findViewById(R.id.username);
            btnJoin = (Button) itemView.findViewById(R.id.btnJoin);
            delete = (Button) itemView.findViewById(R.id.btnDelete);

            itemView.setOnClickListener(this);

        }

        @Override
        public void onClick(final View v) {
           topicClickListener.onTopicClick(v, getAdapterPosition());
            myAPI = retrofit.create((INodeJS.class));
            myAPI1 = retrofit1.create((INodeJS.class));
            final Call<String> existe = myAPI1.verifyParticipation(Integer.parseInt(idUser),chatList.get(getAdapterPosition()).getIdChat());
            existe.enqueue(new Callback<String>() {
                @Override
                public void onResponse(Call<String> call, Response<String> response) {
                    if (!response.isSuccessful()) {
                        return;
                    }
                    String existe = response.body();
                    if(existe.contains("false"))
                    {
                        addParticipation(Integer.parseInt(idUser),chatList.get(getAdapterPosition()).getIdChat());
                        Toast.makeText(mContext, "Welcome to party !", Toast.LENGTH_SHORT).show();
                    }


                   Intent intent;
                    intent = new Intent(mContext, ChatActivitySocket.class);


                    intent.putExtra("username",name);
                    intent.putExtra("idUser",idUser);
                    intent.putExtra("userPicture",userPicture);
                    intent.putExtra("idChat",chatList.get(getAdapterPosition()).getIdChat()+"");
                    mContext.startActivity(intent);
                }
                @Override
                public void onFailure(Call<String> call, Throwable t) {

                }
            });



        }


    }

    private void addParticipation(final int idUser, final int idChat)
    {
        compositeDisposable.add(myAPI.addParticipation(idUser,idChat)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                       // System.out.println(s);

                    }
                })
        );
    }

    private void deleteTopic(final int idUser, final int idChat)
    {
        compositeDisposable.add(myAPI.deleteTopic(idChat,idUser)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        // System.out.println(s);

                    }
                })
        );
    }
}


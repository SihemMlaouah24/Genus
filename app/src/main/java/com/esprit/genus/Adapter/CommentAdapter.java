package com.esprit.genus.Adapter;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.esprit.genus.GamescreenActivity;
import com.esprit.genus.Model.Comment;
import com.esprit.genus.R;
import com.esprit.genus.Retrofit.INodeJS;
import com.esprit.genus.Retrofit.RetrofitClient;


import java.util.List;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class CommentAdapter extends RecyclerView.Adapter<CommentAdapter.MyViewHolder> {

    List<Comment> commentList;
    int idUser;
    Context mContext;
    INodeJS myAPI;
    Retrofit retrofit = RetrofitClient.getInstance();

    CompositeDisposable compositeDisposable = new CompositeDisposable();


    public CommentAdapter(Context mContext, int idUser,List<Comment> gameList) {
        this.commentList = gameList;
        this.idUser = idUser;
    }
    public CommentAdapter(Context mContext, List<Comment> commentList) {
        this.commentList = commentList;

        this.mContext = mContext;
    }

    @NonNull
    @Override
    public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext()).inflate(R.layout.comment_layout, parent, false);
        return new MyViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull MyViewHolder holder, int position) {
        Glide.with(mContext).load("http://10.0.2.2:3000/image/"+commentList.get(position).getUserPicture()).into(holder.userPic);
        holder.userName.setText(commentList.get(position).getUsername());
        holder.comment.setText(commentList.get(position).getCommentText());
        holder.likesNbr.setText(commentList.get(position).getLikesNbr()+"");
        holder.like.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                likeComment(commentList.get(position).getIdComment());
                Intent intent =new Intent(mContext,GamescreenActivity.class);
                intent.putExtra("idGame",commentList.get(position).getIdGame()+"");
                intent.putExtra("idUser",idUser+"");
                mContext.startActivity(intent);
            }
        });
    }

    @Override
    public int getItemCount() { return commentList.size(); }


    public class MyViewHolder extends RecyclerView.ViewHolder{

        CardView root_view;
        TextView userName, comment, likesNbr;
        ImageView userPic;
        ImageButton like;

        public MyViewHolder(@NonNull View itemView) {
            super(itemView);
            mContext = itemView.getContext();

            root_view = (CardView) itemView.findViewById(R.id.root_view);
            userName = (TextView) itemView.findViewById(R.id.txt_name);
            userPic = (ImageView) itemView.findViewById(R.id.userPic);
            comment = (TextView) itemView.findViewById(R.id.txt_comment);
            likesNbr = (TextView) itemView.findViewById(R.id.txt_likes);
            like = (ImageButton) itemView.findViewById(R.id.btn_like);
        }
    }

    public void likeComment(int idComment)
    {
        System.out.println(idComment);
        myAPI = retrofit.create((INodeJS.class));
        compositeDisposable.add(myAPI.LikeComment(idComment)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        System.out.println("like");
                    }
                })
        );
    }
}

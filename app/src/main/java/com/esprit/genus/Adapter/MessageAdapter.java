package com.esprit.genus.Adapter;



import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.esprit.genus.Model.Message;
import com.esprit.genus.R;
import com.esprit.genus.Retrofit.INodeJS;
import com.esprit.genus.Utils;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class MessageAdapter extends RecyclerView.Adapter {

    private static final int TYPE_MESSAGE_SENT = 0;
    private static final int TYPE_MESSAGE_RECEIVED = 1;
    private static final int TYPE_IMAGE_SENT = 2;
    private static final int TYPE_IMAGE_RECEIVED = 3;

    private LayoutInflater inflater;
    private Context mContext;
    private int idChat;
    private int idUser;
    private List<JSONObject> messages = new ArrayList<>();
    INodeJS myAPI;

    public MessageAdapter (int idUser,int idChat,LayoutInflater inflater, Context mContext) {
        this.idChat=idChat;
        this.inflater = inflater;
        this.mContext=mContext;
        this.idUser=idUser;
    }

    private class SentMessageHolder extends RecyclerView.ViewHolder {

        TextView messageTxt;
        TextView time;


        public SentMessageHolder(@NonNull View itemView) {
            super(itemView);

            messageTxt = itemView.findViewById(R.id.sentTxt);
            time = itemView.findViewById(R.id.text_message_time);
        }
    }

    private class SentImageHolder extends RecyclerView.ViewHolder {

        ImageView imageView;

        public SentImageHolder(@NonNull View itemView) {
            super(itemView);

            imageView = itemView.findViewById(R.id.imageView);
        }
    }

    private class ReceivedMessageHolder extends RecyclerView.ViewHolder {

        TextView nameTxt, messageTxt;
        TextView time;
        ImageView pic;

        public ReceivedMessageHolder(@NonNull View itemView) {
            super(itemView);

            nameTxt = itemView.findViewById(R.id.nameTxt);
            messageTxt = itemView.findViewById(R.id.receivedTxt);
            pic = itemView.findViewById(R.id.image_message_profile);
            time = itemView.findViewById(R.id.text_message_time);

        }
    }

    private class ReceivedImageHolder extends RecyclerView.ViewHolder {

        ImageView imageView;
        TextView nameTxt;

        public ReceivedImageHolder(@NonNull View itemView) {
            super(itemView);

            imageView = itemView.findViewById(R.id.imageView);
            nameTxt = itemView.findViewById(R.id.nameTxt);

        }
    }

    @Override
    public int getItemViewType(int position) {

        JSONObject message = messages.get(position);

        try {
            if (message.getBoolean("isSent")) {

                if (message.has("message"))
                    return TYPE_MESSAGE_SENT;
                else
                    return TYPE_IMAGE_SENT;

            } else {

                if (message.has("message"))
                    return TYPE_MESSAGE_RECEIVED;
                else
                    return TYPE_IMAGE_RECEIVED;

            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return -1;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        View view;

        switch (viewType) {
            case TYPE_MESSAGE_SENT:
                view = inflater.inflate(R.layout.item_sent_message, parent, false);
                return new SentMessageHolder(view);
            case TYPE_MESSAGE_RECEIVED:

                view = inflater.inflate(R.layout.item_received_message, parent, false);
                return new ReceivedMessageHolder(view);

            case TYPE_IMAGE_SENT:

                view = inflater.inflate(R.layout.item_sent_image, parent, false);
                return new SentImageHolder(view);

            case TYPE_IMAGE_RECEIVED:

                view = inflater.inflate(R.layout.item_received_photo, parent, false);
                return new ReceivedImageHolder(view);

        }

        return null;
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {

        JSONObject message = messages.get(position);

        try {
            if (message.getBoolean("isSent")) {

                if (message.has("message")) {

                    SentMessageHolder messageHolder = (SentMessageHolder) holder;
                    messageHolder.messageTxt.setText(message.getString("message"));
                    messageHolder.time.setText(message.getString("time"));

                } else {

                    SentImageHolder imageHolder = (SentImageHolder) holder;
                    Bitmap bitmap = getBitmapFromString(message.getString("image"));

                    imageHolder.imageView.setImageBitmap(bitmap);

                }

            } else {

                if (message.has("message")) {

                    ReceivedMessageHolder messageHolder = (ReceivedMessageHolder) holder;
                    messageHolder.nameTxt.setText(message.getString("name"));
                    messageHolder.messageTxt.setText(message.getString("message"));
                    Utils.displayRoundImageFromUrl(mContext,
                            "http://10.0.2.2:3000/image/"+message.getString("userPicture"),messageHolder.pic);
                    messageHolder.time.setText(message.getString("time"));


                } else {

                    ReceivedImageHolder imageHolder = (ReceivedImageHolder) holder;
                    imageHolder.nameTxt.setText(message.getString("name"));

                    Bitmap bitmap = getBitmapFromString(message.getString("image"));
                    imageHolder.imageView.setImageBitmap(bitmap);

                }

            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

    private Bitmap getBitmapFromString(String image) {

        byte[] bytes = Base64.decode(image, Base64.DEFAULT);
        return BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
    }

    @Override
    public int getItemCount() {
        return messages.size();
    }

    public void addItem (JSONObject jsonObject) {
        messages.add(jsonObject);
        notifyDataSetChanged();
    }



   public void loadPreviousMessages(int idChat) {
       Retrofit retrofit = new Retrofit.Builder()
               .baseUrl("http://10.0.2.2:3000/")
               .addConverterFactory(GsonConverterFactory.create())
               .build();
       myAPI = retrofit.create((INodeJS.class));
        final Call<List<Message>> listMessages = myAPI.GetMsgList(idChat);
        listMessages.enqueue(new Callback<List<Message>>() {
            @Override
            public void onResponse(Call<List<Message>> call, Response<List<Message>> response) {
                if (!response.isSuccessful()) {
                    return;
                }
                List<Message> msg = response.body();
                for(Message m:msg) {

                    JSONObject jsonObject = new JSONObject();
                    try {
                        jsonObject.put("name", m.getUsername());
                        jsonObject.put("userPicture", m.getUserPicture());
                        jsonObject.put("message", m.getContentMsg());
                        jsonObject.put("time",m.getDate());

                        if(m.getIdUser()==idUser)
                        {
                            jsonObject.put("isSent", true);
                        }
                        else {
                            jsonObject.put("isSent", false);
                        }
                        messages.add(jsonObject);


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
                notifyDataSetChanged();
            }
            @Override
            public void onFailure(Call<List<Message>> call, Throwable t) {
                //  System.out.println("error");
            }
        });

    }

}
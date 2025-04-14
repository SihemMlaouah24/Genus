package com.esprit.genus.Retrofit;

import com.esprit.genus.Model.Chat;
import com.esprit.genus.Model.Comment;
import com.esprit.genus.Model.Game;
import com.esprit.genus.Model.Message;

import java.util.Date;
import java.util.List;

import io.reactivex.Observable;
import retrofit2.Call;
import retrofit2.http.DELETE;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;

public interface INodeJS {

    @POST("register")
    @FormUrlEncoded
    Observable<String> registerUser(@Field("email") String email,
                                    @Field("username") String username,
                                    @Field("password") String password);
    @POST("addTopic")
    @FormUrlEncoded
    Observable<String> addTopic(@Field("topic") String topic,
                                    @Field("idUser") int idUser);


    @POST("addMsg")
    @FormUrlEncoded
    Observable<String> addMsg(@Field("contentMsg") String contentMsg,
                                @Field("idUser") int idUser,
                                @Field("idChat") int idChat);






    @POST("addParticipation")
    @FormUrlEncoded
    Observable<String> addParticipation(@Field("idUser") int idUser,
                              @Field("idChat") int idChat);

    @POST("AddToGameList")
    @FormUrlEncoded
    Observable<String> AddToGameList(@Field("idUser") int idUser,
                                     @Field("idGame") int idGame);

    @POST("AddToWishList")
    @FormUrlEncoded
    Observable<String> AddToWishList(@Field("idUser") int idUser,
                                     @Field("idGame") int idGame);

    @POST("AddToFavList")
    @FormUrlEncoded
    Observable<String> AddToFavList(@Field("idUser") int idUser,
                                     @Field("idGame") int idGame);

    @POST("AddComment")
    @FormUrlEncoded
    Observable<String> AddComment (@Field("commentText") String commentText,
                                   @Field("idUser") int idUser,
                                   @Field("idGame") int idGame);

    @POST("LikeComment")
    @FormUrlEncoded
    Observable<String> LikeComment (@Field("idComment") int idComment);


    @POST("login")
    @FormUrlEncoded
    Observable<String> loginUser(@Field("email") String email,
                                 @Field("password") String password);


    @PUT("getForgottenPassword")
    @FormUrlEncoded
    Observable<String> getForgottenPassword(@Field("email") String email);

    @PUT("/editUsername")
    @FormUrlEncoded
    Observable<String> editUsername(@Field ("idUser") int idUser,@Field("username") String username);

    @PUT("/editPassword")
    @FormUrlEncoded
    Observable<String> editPassword(@Field ("idUser") int idUser,@Field("old_password") String old_password,
                                   @Field("new_password") String new_password);

    @DELETE("/deleteFromFavList/{idGame}/{idUser}")
    Observable<String> deleteFromFavList(@Path ("idGame") int idGame,
                                         @Path ("idUser") int idUser);

    @DELETE("/deleteFromWishList/{idGame}/{idUser}")
    Observable<String> deleteFromWishList(@Path ("idGame") int idGame,
                                          @Path ("idUser") int idUser);

    @DELETE("/deleteFromList/{idGame}/{idUser}")
    Observable<String> deleteFromList(@Path ("idGame") int idGame,
                                      @Path ("idUser") int idUser);

    @DELETE("/deleteTopic/{idChat}/{idUser}")
    Observable<String> deleteTopic(@Path ("idChat") int idChat,
                                      @Path ("idUser") int idUser);

    @GET("GetGameList/{idUser}")
    Call<List<Game>> GetGameList(@Path("idUser") int idUser);

    @GET("GetChatList")
    Call<List<Chat>> GetChatList();


    @GET("ListMessages/{idChat}")
    Call<List<Message>> GetMsgList(@Path("idChat") int idChat);


    @GET("verifyParticipation/{idUser}/{idChat}")
    Call <String> verifyParticipation (@Path("idUser") int idUser,@Path("idChat") int idChat);


    @GET("VerifyGamelist/{idUser}/{idGame}")
    Call <String> VerifyGamelist (@Path("idUser") int idUser,
                                  @Path("idGame") int idGame);

    @GET("VerifyWishlist/{idUser}/{idGame}")
    Call <String> VerifyWishlist (@Path("idUser") int idUser,
                                  @Path("idGame") int idGame);

    @GET("VerifyFavlist/{idUser}/{idGame}")
    Call <String> VerifyFavlist (@Path("idUser") int idUser,
                                 @Path("idGame") int idGame);

    @GET("VerifyTopicCreator/{idUser}/{idChat}")
    Call <String> VerifyTopicCreator (@Path("idUser") int idUser,
                                 @Path("idChat") int idChat);


    @POST("search")
    @FormUrlEncoded
    Observable<List<Chat>> searchChats (@Field("search") String searchQuery);

    @POST("search")
    @FormUrlEncoded
    Observable<List<Game>> searchGames (@Field("search") String searchQuery);

    @GET("GetGameList/{idUser}")
    Call<List<Game>> GetGameListForNumber(@Path("idUser") int idUser);
    //this one for gamesNumber okay ?

    @GET("GetWishList/{idUser}")
    Call<List<Game>> GetWishList(@Path("idUser") int idUser);

    @GET("GetFavList/{idUser}")
    Call<List<Game>> GetFavList(@Path("idUser") int idUser);

    @GET("GetTrendingGames")
    Call<List<Game>> GetTrendingGames();


    @GET("GetGames")
    Call<List<Game>> GetGames();

    @GET("GetTopPicksGames")
    Call<List<Game>> GetTopPicksGames();

    @GET("GetBestRateGames")
    Call<List<Game>> GetBestRateGames();

    @GET("GetGameDetails/{idGame}")
    Call <List<Game>> GetGameDetails (@Path("idGame") int idGame);

    @GET("GetComments/{idGame}")
    Call <List<Comment>> GetComments (@Path("idGame") int idGame);

    @GET("GetProfilePic/{idUser}")
    Call <String> GetProfilePic (@Path("idUser") int idUser);

    @GET("GetCommentNbr/{idGame}")
    Call <String> GetCommentNbr (@Path("idGame") int idGame);

    @GET("GetMembersNbr/{idChat}")
    Call <String> GetMembersNbr (@Path("idChat") int idChat);

    @GET("GetFavoriteNbr/{idGame}")
    Call <String> GetFavoriteNbr (@Path("idGame") int idGame);

}

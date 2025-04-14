package com.esprit.genus.Model;

import java.util.Date;

public class Message {

  private  int idMessage;
  private String contentMsg;
  private String date;
  private int idUser;
  private int idChat;
  private String username;
  private String userPicture;

    public Message() {
    }

    public Message(String contentMsg, String date, int idUser, int idChat,String username,String userPicture) {
        this.contentMsg = contentMsg;
        this.date = date;
        this.idUser = idUser;
        this.idChat = idChat;
        this.username=username;
        this.userPicture=userPicture;
    }


    public int getIdMessage() {
        return idMessage;
    }

    public void setIdMessage(int idMessage) {
        this.idMessage = idMessage;
    }

    public String getContentMsg() {
        return contentMsg;
    }

    public void setContentMsg(String contentMsg) {
        this.contentMsg = contentMsg;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    public int getIdChat() {
        return idChat;
    }

    public void setIdChat(int idChat) {
        this.idChat = idChat;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getUserPicture() {
        return userPicture;
    }

    public void setUserPicture(String userPicture) {
        this.userPicture = userPicture;
    }

    @Override
    public String toString() {
        return "Message{" +
                "idMessage=" + idMessage +
                ", contentMsg='" + contentMsg + '\'' +
                ", date=" + date +
                ", idUser=" + idUser +
                ", idChat=" + idChat +
                '}';
    }
}

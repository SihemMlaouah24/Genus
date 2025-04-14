package com.esprit.genus.Model;

public class Comment {

    private int idComment, likesNbr, idUser, idGame;
    private String commentText, username, userPicture;

    public Comment() {
    }

    public Comment(int idComment, int likesNbr, int idUser, int idGame, String commentText, String username, String userPicture) {
        this.idComment = idComment;
        this.likesNbr = likesNbr;
        this.idUser = idUser;
        this.idGame = idGame;
        this.commentText = commentText;
        this.username = username;
        this.userPicture = userPicture;
    }

    /*public Comment(int idComment, int likesNbr, int idUser, int idGame, String commentText) {
        this.idComment = idComment;
        this.likesNbr = likesNbr;
        this.idUser = idUser;
        this.idGame = idGame;
        this.commentText = commentText;
    }*/

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

    public int getIdComment() {
        return idComment;
    }

    public void setIdComment(int idComment) {
        this.idComment = idComment;
    }

    public int getLikesNbr() {
        return likesNbr;
    }

    public void setLikesNbr(int likesNbr) {
        this.likesNbr = likesNbr;
    }

    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    public int getIdGame() {
        return idGame;
    }

    public void setIdGame(int idGame) {
        this.idGame = idGame;
    }

    public String getCommentText() {
        return commentText;
    }

    public void setCommentText(String commentText) {
        this.commentText = commentText;
    }

    @Override
    public String toString() {
        return "Comment{" +
                "idComment=" + idComment +
                ", likesNbr=" + likesNbr +
                ", idUser=" + idUser +
                ", idGame=" + idGame +
                ", commentText='" + commentText + '\'' +
                '}';
    }
}

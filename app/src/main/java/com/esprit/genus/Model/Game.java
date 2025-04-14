package com.esprit.genus.Model;

import java.util.Date;

public class Game {

    private int idGame, rating;
    private String name, companyName, description, gamePicture, type;
    private Date releaseDate;

    public Game() {
    }

    public Game(int idGame, int rating, String name, String companyName, String description, String gamePicture, String type, Date releaseDate) {

        this.idGame = idGame;
        this.rating = rating;
        this.name = name;
        this.companyName = companyName;
        this.description = description;
        this.gamePicture = gamePicture;
        this.type = type;
        this.releaseDate = releaseDate;
    }

    public int getIdGame() {
        return idGame;
    }

    public void setIdGame(int idGame) {
        this.idGame = idGame;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getGamePicture() {
        return gamePicture;
    }

    public void setGamePicture(String gamePicture) {
        this.gamePicture = gamePicture;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getReleaseDate() {

        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    @Override
    public String toString() {
        return "Game{" +
                "idGame=" + idGame +
                ", rating=" + rating +
                ", name='" + name + '\'' +
                ", companyName='" + companyName + '\'' +
                ", description='" + description + '\'' +
                ", gamePicture='" + gamePicture + '\'' +
                ", type='" + type + '\'' +
                ", releaseDate=" + releaseDate +
                '}';
    }
}

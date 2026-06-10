package dto;

public class ChampionStatsDTO {
    private String championName;

    private int games;
    private int wins;
    private int losses;

    private int totalKills;
    private int totalDeaths;
    private int totalAssists;
    private int totalCs;

    public String getChampionName() {
        return championName;
    }

    public void setChampionName(String championName) {
        this.championName = championName;
    }

    public int getGames() {
        return games;
    }

    public void setGames(int games) {
        this.games = games;
    }

    public int getWins() {
        return wins;
    }

    public void setWins(int wins) {
        this.wins = wins;
    }

    public int getLosses() {
        return losses;
    }

    public void setLosses(int losses) {
        this.losses = losses;
    }

    public int getTotalKills() {
        return totalKills;
    }

    public void setTotalKills(int totalKills) {
        this.totalKills = totalKills;
    }

    public int getTotalDeaths() {
        return totalDeaths;
    }

    public void setTotalDeaths(int totalDeaths) {
        this.totalDeaths = totalDeaths;
    }

    public int getTotalAssists() {
        return totalAssists;
    }

    public void setTotalAssists(int totalAssists) {
        this.totalAssists = totalAssists;
    }

    public int getTotalCs() {
        return totalCs;
    }

    public void setTotalCs(int totalCs) {
        this.totalCs = totalCs;
    }

    public int getWinRate() {
        if (games == 0) return 0;
        return wins * 100 / games;
    }

    public double getAverageKills() {
        if (games == 0) return 0;
        return (double) totalKills / games;
    }

    public double getAverageDeaths() {
        if (games == 0) return 0;
        return (double) totalDeaths / games;
    }

    public double getAverageAssists() {
        if (games == 0) return 0;
        return (double) totalAssists / games;
    }

    public double getAverageCs() {
        if (games == 0) return 0;
        return (double) totalCs / games;
    }

    public double getKdaRatio() {
        if (totalDeaths == 0) {
            return totalKills + totalAssists;
        }
        return (double)(totalKills + totalAssists) / totalDeaths;
    }
}
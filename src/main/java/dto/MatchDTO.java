package dto;

public class MatchDTO {
    private String championName;
    private int kills;
    private int deaths;
    private int assists;
    private boolean win;

    private int totalMinionsKilled;
    private int neutralMinionsKilled;

    private int queueId;
    private String gameMode;

    private int item0, item1, item2, item3, item4, item5, item6;

    private int summoner1Id;
    private int summoner2Id;

    private int mainPerk;
    private int perkSubStyle;
    
    private long gameCreation;
    private long gameDuration;
    
    private int killParticipation;

    public long getGameCreation() {
        return gameCreation;
    }

    public void setGameCreation(long gameCreation) {
        this.gameCreation = gameCreation;
    }

    public long getGameDuration() {
        return gameDuration;
    }

    public void setGameDuration(long gameDuration) {
        this.gameDuration = gameDuration;
    }

    public String getChampionName() { return championName; }
    public void setChampionName(String championName) { this.championName = championName; }

    public int getKills() { return kills; }
    public void setKills(int kills) { this.kills = kills; }

    public int getDeaths() { return deaths; }
    public void setDeaths(int deaths) { this.deaths = deaths; }

    public int getAssists() { return assists; }
    public void setAssists(int assists) { this.assists = assists; }

    public boolean isWin() { return win; }
    public void setWin(boolean win) { this.win = win; }

    public int getTotalMinionsKilled() { return totalMinionsKilled; }
    public void setTotalMinionsKilled(int totalMinionsKilled) {
        this.totalMinionsKilled = totalMinionsKilled;
    }

    public int getNeutralMinionsKilled() { return neutralMinionsKilled; }
    public void setNeutralMinionsKilled(int neutralMinionsKilled) {
        this.neutralMinionsKilled = neutralMinionsKilled;
    }

    public int getQueueId() { return queueId; }
    public void setQueueId(int queueId) { this.queueId = queueId; }

    public String getGameMode() { return gameMode; }
    public void setGameMode(String gameMode) { this.gameMode = gameMode; }

    public int getCs() {
        return totalMinionsKilled + neutralMinionsKilled;
    }

    public double getKdaRatio() {
        if (deaths == 0) return kills + assists;
        return (double)(kills + assists) / deaths;
    }

    public int getItem0() { return item0; }
    public void setItem0(int item0) { this.item0 = item0; }

    public int getItem1() { return item1; }
    public void setItem1(int item1) { this.item1 = item1; }

    public int getItem2() { return item2; }
    public void setItem2(int item2) { this.item2 = item2; }

    public int getItem3() { return item3; }
    public void setItem3(int item3) { this.item3 = item3; }

    public int getItem4() { return item4; }
    public void setItem4(int item4) { this.item4 = item4; }

    public int getItem5() { return item5; }
    public void setItem5(int item5) { this.item5 = item5; }

    public int getItem6() { return item6; }
    public void setItem6(int item6) { this.item6 = item6; }

    public int getSummoner1Id() { return summoner1Id; }
    public void setSummoner1Id(int summoner1Id) {
        this.summoner1Id = summoner1Id;
    }

    public int getSummoner2Id() { return summoner2Id; }
    public void setSummoner2Id(int summoner2Id) {
        this.summoner2Id = summoner2Id;
    }

    public int getMainPerk() { return mainPerk; }
    public void setMainPerk(int mainPerk) {
        this.mainPerk = mainPerk;
    }

    public int getPerkSubStyle() { return perkSubStyle; }
    public void setPerkSubStyle(int perkSubStyle) {
        this.perkSubStyle = perkSubStyle;
    }
    
    public int getKillParticipation() {
        return killParticipation;
    }

    public void setKillParticipation(int killParticipation) {
        this.killParticipation = killParticipation;
    }
}
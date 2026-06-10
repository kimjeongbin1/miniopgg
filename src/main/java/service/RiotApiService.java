package service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import dto.MatchDTO;
import dto.ParticipantDTO;
import dto.ChampionStatsDTO;
import dto.ChampionMasteryDTO;

public class RiotApiService {

    private static final String API_KEY = "RGAPI-e082c565-af2b-47cb-8b52-b9b2d4eb5cb1";
    private static final String ASIA_HOST = "asia.api.riotgames.com";
    private static final String KR_HOST = "kr.api.riotgames.com";

    public String[] getSummonerInfo(String gameName, String tagLine) throws Exception {
        String accountPath = "/riot/account/v1/accounts/by-riot-id/" + gameName + "/" + tagLine;
        URI accountUri = new URI("https", ASIA_HOST, accountPath, null);
        String accountJson = sendGet(accountUri.toASCIIString());

        String puuid = extractValue(accountJson, "puuid");
        String responseGameName = extractValue(accountJson, "gameName");
        String responseTagLine = extractValue(accountJson, "tagLine");

        String summonerPath = "/lol/summoner/v4/summoners/by-puuid/" + puuid;
        URI summonerUri = new URI("https", KR_HOST, summonerPath, null);
        String summonerJson = sendGet(summonerUri.toASCIIString());

        String profileIconId = extractNumberValue(summonerJson, "profileIconId");
        String summonerLevel = extractNumberValue(summonerJson, "summonerLevel");

        String leaguePath = "/lol/league/v4/entries/by-puuid/" + puuid;
        URI leagueUri = new URI("https", KR_HOST, leaguePath, null);
        String leagueJson = sendGet(leagueUri.toASCIIString());

        String soloRank = extractRankInfo(leagueJson, "RANKED_SOLO_5x5");
        String flexRank = extractRankInfo(leagueJson, "RANKED_FLEX_SR");

        return new String[] {
            responseGameName, responseTagLine, puuid,
            profileIconId, summonerLevel, soloRank, flexRank
        };
    }

    public List<MatchDTO> getRecentMatches(String puuid, int count) throws Exception {
        List<MatchDTO> matchList = new ArrayList<>();

        String matchIdsPath = "/lol/match/v5/matches/by-puuid/" + puuid + "/ids";
        String matchIdsQuery = "start=0&count=" + count;

        URI matchIdsUri = new URI("https", ASIA_HOST, matchIdsPath, matchIdsQuery, null);
        String matchIdsJson = sendGet(matchIdsUri.toASCIIString());

        List<String> matchIds = parseMatchIds(matchIdsJson);

        for (String matchId : matchIds) {
            String matchDetailPath = "/lol/match/v5/matches/" + matchId;
            URI matchDetailUri = new URI("https", ASIA_HOST, matchDetailPath, null);

            String matchJson = sendGet(matchDetailUri.toASCIIString());
            String participantJson = findParticipantObject(matchJson, puuid);

            if (participantJson == null || participantJson.equals("")) {
                continue;
            }

            MatchDTO match = new MatchDTO();
            
            List<ParticipantDTO> blueTeam = new ArrayList<>();
            List<ParticipantDTO> redTeam = new ArrayList<>();

            List<String> participantObjects = extractParticipantObjects(matchJson);

            for (String pJson : participantObjects) {
                ParticipantDTO p = new ParticipantDTO();

                p.setSummonerName(extractValue(pJson, "riotIdGameName"));

                if (p.getSummonerName().equals("")) {
                    p.setSummonerName(extractValue(pJson, "summonerName"));
                }

                p.setChampionName(extractValue(pJson, "championName"));
                p.setTeamId(parseInt(extractNumberValue(pJson, "teamId")));

                p.setKills(parseInt(extractNumberValue(pJson, "kills")));
                p.setDeaths(parseInt(extractNumberValue(pJson, "deaths")));
                p.setAssists(parseInt(extractNumberValue(pJson, "assists")));

                p.setTotalDamageDealtToChampions(
                    parseInt(extractNumberValue(pJson, "totalDamageDealtToChampions"))
                );

                p.setTotalDamageTaken(
                    parseInt(extractNumberValue(pJson, "totalDamageTaken"))
                );

                p.setVisionScore(parseInt(extractNumberValue(pJson, "visionScore")));
                p.setWardsPlaced(parseInt(extractNumberValue(pJson, "wardsPlaced")));
                p.setWardsKilled(parseInt(extractNumberValue(pJson, "wardsKilled")));

                p.setTotalMinionsKilled(parseInt(extractNumberValue(pJson, "totalMinionsKilled")));
                p.setNeutralMinionsKilled(parseInt(extractNumberValue(pJson, "neutralMinionsKilled")));

                p.setItem0(parseInt(extractNumberValue(pJson, "item0")));
                p.setItem1(parseInt(extractNumberValue(pJson, "item1")));
                p.setItem2(parseInt(extractNumberValue(pJson, "item2")));
                p.setItem3(parseInt(extractNumberValue(pJson, "item3")));
                p.setItem4(parseInt(extractNumberValue(pJson, "item4")));
                p.setItem5(parseInt(extractNumberValue(pJson, "item5")));
                p.setItem6(parseInt(extractNumberValue(pJson, "item6")));

                if (p.getTeamId() == 100) {
                    blueTeam.add(p);
                } else if (p.getTeamId() == 200) {
                    redTeam.add(p);
                }
            }

            match.setBlueTeam(blueTeam);
            match.setRedTeam(redTeam);

            match.setChampionName(extractValue(participantJson, "championName"));
            match.setKills(parseInt(extractNumberValue(participantJson, "kills")));
            match.setDeaths(parseInt(extractNumberValue(participantJson, "deaths")));
            match.setAssists(parseInt(extractNumberValue(participantJson, "assists")));
            match.setWin(parseBoolean(extractBooleanValue(participantJson, "win")));

            
            System.out.println(
            	    "participants 개수 = "
            	    + extractParticipantObjects(matchJson).size()
            	);            
            
            int teamKills = getTeamKills(matchJson, participantJson);
            
            System.out.println(
            	    match.getChampionName()
            	    + " 팀킬 = "
            	    + teamKills
            	);
            int killParticipation = 0;

            if (teamKills > 0) {
                killParticipation = (match.getKills() + match.getAssists()) * 100 / teamKills;
            }

            match.setKillParticipation(killParticipation);

            match.setTotalMinionsKilled(parseInt(extractNumberValue(participantJson, "totalMinionsKilled")));
            match.setNeutralMinionsKilled(parseInt(extractNumberValue(participantJson, "neutralMinionsKilled")));

            match.setItem0(parseInt(extractNumberValue(participantJson, "item0")));
            match.setItem1(parseInt(extractNumberValue(participantJson, "item1")));
            match.setItem2(parseInt(extractNumberValue(participantJson, "item2")));
            match.setItem3(parseInt(extractNumberValue(participantJson, "item3")));
            match.setItem4(parseInt(extractNumberValue(participantJson, "item4")));
            match.setItem5(parseInt(extractNumberValue(participantJson, "item5")));
            match.setItem6(parseInt(extractNumberValue(participantJson, "item6")));

            match.setSummoner1Id(parseInt(extractNumberValue(participantJson, "summoner1Id")));
            match.setSummoner2Id(parseInt(extractNumberValue(participantJson, "summoner2Id")));

            match.setMainPerk(extractMainPerk(participantJson));
            match.setPerkSubStyle(extractSubRuneStyle(participantJson));

            int queueId = parseInt(extractNumberValue(matchJson, "queueId"));
            match.setQueueId(queueId);
            match.setGameMode(getQueueType(queueId));

            match.setGameCreation(parseLong(extractNumberValue(matchJson, "gameCreation")));
            match.setGameDuration(parseLong(extractNumberValue(matchJson, "gameDuration")));

            matchList.add(match);
        }

        return matchList;
    }

    private String sendGet(String apiUrl) throws Exception {
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("GET");
        conn.setRequestProperty("User-Agent", "Mozilla/5.0");
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestProperty("X-Riot-Token", API_KEY);

        int responseCode = conn.getResponseCode();

        BufferedReader br;

        if (responseCode >= 200 && responseCode < 300) {
            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        } else {
            br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
        }

        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = br.readLine()) != null) {
            sb.append(line);
        }

        br.close();

        if (responseCode < 200 || responseCode >= 300) {
            throw new RuntimeException(
                "Riot API 오류: " + responseCode +
                " / URL: " + apiUrl +
                " / " + sb.toString()
            );
        }

        return sb.toString();
    }

    private List<String> parseMatchIds(String json) {
        List<String> matchIds = new ArrayList<>();

        json = json.replace("[", "").replace("]", "").replace("\"", "");

        if (json.trim().equals("")) {
            return matchIds;
        }

        String[] ids = json.split(",");

        for (String id : ids) {
            matchIds.add(id.trim());
        }

        return matchIds;
    }

    private String findParticipantObject(String json, String puuid) {
        String target = "\"puuid\":\"" + puuid + "\"";
        int puuidIndex = json.indexOf(target);

        if (puuidIndex == -1) {
            return "";
        }

        int start = -1;
        int balance = 0;

        for (int i = puuidIndex; i >= 0; i--) {
            char c = json.charAt(i);

            if (c == '}') {
                balance++;
            } else if (c == '{') {
                if (balance == 0) {
                    start = i;
                    break;
                } else {
                    balance--;
                }
            }
        }

        if (start == -1) {
            return "";
        }

        int braceCount = 0;

        for (int i = start; i < json.length(); i++) {
            char c = json.charAt(i);

            if (c == '{') {
                braceCount++;
            } else if (c == '}') {
                braceCount--;

                if (braceCount == 0) {
                    return json.substring(start, i + 1);
                }
            }
        }

        return "";
    }

    private List<String> extractParticipantObjects(String matchJson) {
        List<String> participants = new ArrayList<>();

        Pattern pattern = Pattern.compile("\"puuid\"\\s*:\\s*\"([^\"]+)\"");
        Matcher matcher = pattern.matcher(matchJson);

        while (matcher.find()) {
            String puuid = matcher.group(1);

            String participantJson = findParticipantObject(matchJson, puuid);

            if (participantJson != null
                    && !participantJson.equals("")
                    && participantJson.contains("\"championName\"")
                    && participantJson.contains("\"teamId\"")) {

                participants.add(participantJson);
            }

            if (participants.size() >= 10) {
                break;
            }
        }

        return participants;
    }

    private int getTeamKills(String matchJson, String participantJson) {
        int myTeamId = parseInt(extractNumberValue(participantJson, "teamId"));

        if (myTeamId == 0) {
            return 0;
        }

        Pattern pattern = Pattern.compile(
            "\"kills\"\\s*:\\s*(\\d+).*?\"teamId\"\\s*:\\s*" + myTeamId,
            Pattern.DOTALL
        );

        Matcher matcher = pattern.matcher(matchJson);

        int teamKills = 0;

        while (matcher.find()) {
            teamKills += parseInt(matcher.group(1));
        }

        return teamKills;
    }
    private int extractMainPerk(String participantJson) {
        Pattern pattern = Pattern.compile(
            "\"description\"\\s*:\\s*\"primaryStyle\".*?\"selections\"\\s*:\\s*\\[\\s*\\{\\s*\"perk\"\\s*:\\s*(\\d+)",
            Pattern.DOTALL
        );

        Matcher matcher = pattern.matcher(participantJson);

        if (matcher.find()) {
            return parseInt(matcher.group(1));
        }

        return 0;
    }

    private int extractSubRuneStyle(String participantJson) {
        Pattern pattern = Pattern.compile(
            "\"description\"\\s*:\\s*\"subStyle\".*?\"style\"\\s*:\\s*(\\d+)",
            Pattern.DOTALL
        );

        Matcher matcher = pattern.matcher(participantJson);

        if (matcher.find()) {
            return parseInt(matcher.group(1));
        }

        return 0;
    }

    private String extractValue(String json, String key) {
        String target = "\"" + key + "\":\"";
        int start = json.indexOf(target);

        if (start == -1) return "";

        start += target.length();
        int end = json.indexOf("\"", start);

        return json.substring(start, end);
    }

    private String extractNumberValue(String json, String key) {
        String target = "\"" + key + "\":";
        int start = json.indexOf(target);

        if (start == -1) return "";

        start += target.length();

        int end = json.indexOf(",", start);

        if (end == -1) {
            end = json.indexOf("}", start);
        }

        return json.substring(start, end).trim();
    }

    private String extractBooleanValue(String json, String key) {
        String target = "\"" + key + "\":";
        int start = json.indexOf(target);

        if (start == -1) return "false";

        start += target.length();

        int end = json.indexOf(",", start);

        if (end == -1) {
            end = json.indexOf("}", start);
        }

        return json.substring(start, end).trim();
    }

    private String extractRankInfo(String json, String queueType) {
        int queueIndex = json.indexOf("\"queueType\":\"" + queueType + "\"");

        if (queueIndex == -1) {
            return "Unranked";
        }

        int objectStart = json.lastIndexOf("{", queueIndex);
        int objectEnd = json.indexOf("}", queueIndex);

        if (objectStart == -1 || objectEnd == -1) {
            return "Unranked";
        }

        String rankObject = json.substring(objectStart, objectEnd + 1);

        String tier = extractValue(rankObject, "tier");
        String rank = extractValue(rankObject, "rank");
        String leaguePoints = extractNumberValue(rankObject, "leaguePoints");
        String wins = extractNumberValue(rankObject, "wins");
        String losses = extractNumberValue(rankObject, "losses");

        if (tier.equals("")) {
            return "Unranked";
        }

        return tier + " " + rank + " / " + leaguePoints + "LP / " + wins + "승 " + losses + "패";
    }

    private String getQueueType(int queueId) {
        switch (queueId) {
            case 420:
                return "솔로랭크";
            case 440:
                return "자유랭크";
            case 450:
                return "칼바람";
            case 430:
                return "일반게임";
            case 400:
                return "일반교차";
            case 900:
                return "URF";
            default:
                return "기타";
        }
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }

    private long parseLong(String value) {
        try {
            return Long.parseLong(value);
        } catch (Exception e) {
            return 0;
        }
    }

    private boolean parseBoolean(String value) {
        return "true".equals(value);
    }
    
    public List<ChampionMasteryDTO> getChampionMasteries(String puuid) throws Exception {
        List<ChampionMasteryDTO> masteryList = new ArrayList<>();

        String masteryPath = "/lol/champion-mastery/v4/champion-masteries/by-puuid/" + puuid;
        URI masteryUri = new URI("https", KR_HOST, masteryPath, null);

        String masteryJson = sendGet(masteryUri.toASCIIString());

        Pattern pattern = Pattern.compile(
            "\"championId\"\\s*:\\s*(\\d+).*?"
          + "\"championLevel\"\\s*:\\s*(\\d+).*?"
          + "\"championPoints\"\\s*:\\s*(\\d+)",
            Pattern.DOTALL
        );

        Matcher matcher = pattern.matcher(masteryJson);

        while (matcher.find()) {
            ChampionMasteryDTO mastery = new ChampionMasteryDTO();

            int championId = parseInt(matcher.group(1));
            int championLevel = parseInt(matcher.group(2));
            int championPoints = parseInt(matcher.group(3));

            mastery.setChampionId(championId);
            mastery.setChampionLevel(championLevel);
            mastery.setChampionPoints(championPoints);
            mastery.setChampionName(getChampionNameById(championId));

            masteryList.add(mastery);

            if (masteryList.size() >= 30) {
                break;
            }
        }

        System.out.println("숙련도 개수 = " + masteryList.size());

        return masteryList;
    }
    
    private String getChampionNameById(int championId) {
        switch (championId) {
            case 1: return "Annie";
            case 2: return "Olaf";
            case 3: return "Galio";
            case 4: return "TwistedFate";
            case 5: return "XinZhao";
            case 6: return "Urgot";
            case 7: return "Leblanc";
            case 8: return "Vladimir";
            case 9: return "Fiddlesticks";
            case 10: return "Kayle";
            case 11: return "MasterYi";
            case 12: return "Alistar";
            case 13: return "Ryze";
            case 14: return "Sion";
            case 15: return "Sivir";
            case 16: return "Soraka";
            case 17: return "Teemo";
            case 18: return "Tristana";
            case 19: return "Warwick";
            case 20: return "Nunu";
            case 21: return "MissFortune";
            case 22: return "Ashe";
            case 23: return "Tryndamere";
            case 24: return "Jax";
            case 25: return "Morgana";
            case 26: return "Zilean";
            case 27: return "Singed";
            case 28: return "Evelynn";
            case 29: return "Twitch";
            case 30: return "Karthus";
            case 31: return "Chogath";
            case 32: return "Amumu";
            case 33: return "Rammus";
            case 34: return "Anivia";
            case 35: return "Shaco";
            case 36: return "DrMundo";
            case 37: return "Sona";
            case 38: return "Kassadin";
            case 39: return "Irelia";
            case 40: return "Janna";
            case 41: return "Gangplank";
            case 42: return "Corki";
            case 43: return "Karma";
            case 44: return "Taric";
            case 45: return "Veigar";
            case 48: return "Trundle";
            case 50: return "Swain";
            case 51: return "Caitlyn";
            case 53: return "Blitzcrank";
            case 54: return "Malphite";
            case 55: return "Katarina";
            case 56: return "Nocturne";
            case 57: return "Maokai";
            case 58: return "Renekton";
            case 59: return "JarvanIV";
            case 60: return "Elise";
            case 61: return "Orianna";
            case 62: return "MonkeyKing";
            case 63: return "Brand";
            case 64: return "LeeSin";
            case 67: return "Vayne";
            case 68: return "Rumble";
            case 69: return "Cassiopeia";
            case 72: return "Skarner";
            case 74: return "Heimerdinger";
            case 75: return "Nasus";
            case 76: return "Nidalee";
            case 77: return "Udyr";
            case 78: return "Poppy";
            case 79: return "Gragas";
            case 80: return "Pantheon";
            case 81: return "Ezreal";
            case 82: return "Mordekaiser";
            case 83: return "Yorick";
            case 84: return "Akali";
            case 85: return "Kennen";
            case 86: return "Garen";
            case 89: return "Leona";
            case 90: return "Malzahar";
            case 91: return "Talon";
            case 92: return "Riven";
            case 96: return "KogMaw";
            case 98: return "Shen";
            case 99: return "Lux";
            case 101: return "Xerath";
            case 102: return "Shyvana";
            case 103: return "Ahri";
            case 104: return "Graves";
            case 105: return "Fizz";
            case 106: return "Volibear";
            case 107: return "Rengar";
            case 110: return "Varus";
            case 111: return "Nautilus";
            case 112: return "Viktor";
            case 113: return "Sejuani";
            case 114: return "Fiora";
            case 115: return "Ziggs";
            case 117: return "Lulu";
            case 119: return "Draven";
            case 120: return "Hecarim";
            case 121: return "Khazix";
            case 122: return "Darius";
            case 126: return "Jayce";
            case 127: return "Lissandra";
            case 131: return "Diana";
            case 133: return "Quinn";
            case 134: return "Syndra";
            case 136: return "AurelionSol";
            case 141: return "Kayn";
            case 142: return "Zoe";
            case 143: return "Zyra";
            case 145: return "Kaisa";
            case 147: return "Seraphine";
            case 150: return "Gnar";
            case 154: return "Zac";
            case 157: return "Yasuo";
            case 161: return "Velkoz";
            case 163: return "Taliyah";
            case 164: return "Camille";
            case 166: return "Akshan";
            case 200: return "Belveth";
            case 201: return "Braum";
            case 202: return "Jhin";
            case 203: return "Kindred";
            case 221: return "Zeri";
            case 222: return "Jinx";
            case 223: return "TahmKench";
            case 234: return "Viego";
            case 235: return "Senna";
            case 236: return "Lucian";
            case 238: return "Zed";
            case 240: return "Kled";
            case 245: return "Ekko";
            case 246: return "Qiyana";
            case 254: return "Vi";
            case 266: return "Aatrox";
            case 267: return "Nami";
            case 268: return "Azir";
            case 350: return "Yuumi";
            case 360: return "Samira";
            case 412: return "Thresh";
            case 420: return "Illaoi";
            case 421: return "RekSai";
            case 427: return "Ivern";
            case 429: return "Kalista";
            case 432: return "Bard";
            case 497: return "Rakan";
            case 498: return "Xayah";
            case 516: return "Ornn";
            case 517: return "Sylas";
            case 518: return "Neeko";
            case 523: return "Aphelios";
            case 526: return "Rell";
            case 555: return "Pyke";
            case 711: return "Vex";
            case 777: return "Yone";
            case 875: return "Sett";
            case 876: return "Lillia";
            case 887: return "Gwen";
            case 888: return "Renata";
            case 895: return "Nilah";
            case 897: return "KSante";
            case 901: return "Smolder";
            case 902: return "Milio";
            case 910: return "Hwei";
            case 950: return "Naafiri";
            default: return "";
        }
    }
    
    public List<ChampionStatsDTO> getChampionStats(String puuid) throws Exception {

        List<MatchDTO> matches = getRecentMatches(puuid, 50);

        List<ChampionStatsDTO> statsList = new ArrayList<>();

        for (MatchDTO match : matches) {

            ChampionStatsDTO stats = null;

            for (ChampionStatsDTO s : statsList) {
                if (s.getChampionName().equals(match.getChampionName())) {
                    stats = s;
                    break;
                }
            }

            if (stats == null) {
                stats = new ChampionStatsDTO();
                stats.setChampionName(match.getChampionName());

                statsList.add(stats);
            }

            stats.setGames(stats.getGames() + 1);

            if (match.isWin()) {
                stats.setWins(stats.getWins() + 1);
            } else {
                stats.setLosses(stats.getLosses() + 1);
            }

            stats.setTotalKills(
                stats.getTotalKills() + match.getKills()
            );

            stats.setTotalDeaths(
                stats.getTotalDeaths() + match.getDeaths()
            );

            stats.setTotalAssists(
                stats.getTotalAssists() + match.getAssists()
            );

            stats.setTotalCs(
                stats.getTotalCs() + match.getCs()
            );
        }

        return statsList;
    }
}
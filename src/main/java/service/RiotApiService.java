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

public class RiotApiService {

    private static final String API_KEY = "RGAPI-ac473a64-bc8c-4be7-9504-33ae4f7c45f3";
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

        int participantsIndex = matchJson.indexOf("\"participants\"");
        if (participantsIndex == -1) {
            return participants;
        }

        int arrayStart = matchJson.indexOf("[", participantsIndex);
        if (arrayStart == -1) {
            return participants;
        }

        int bracketCount = 0;
        int arrayEnd = -1;

        for (int i = arrayStart; i < matchJson.length(); i++) {
            char c = matchJson.charAt(i);

            if (c == '[') {
                bracketCount++;
            } else if (c == ']') {
                bracketCount--;

                if (bracketCount == 0) {
                    arrayEnd = i;
                    break;
                }
            }
        }

        if (arrayEnd == -1) {
            return participants;
        }

        String participantsArray = matchJson.substring(arrayStart + 1, arrayEnd);

        int index = 0;

        while (index < participantsArray.length()) {
            int objectStart = participantsArray.indexOf("{", index);

            if (objectStart == -1) {
                break;
            }

            int braceCount = 0;
            int objectEnd = -1;

            for (int i = objectStart; i < participantsArray.length(); i++) {
                char c = participantsArray.charAt(i);

                if (c == '{') {
                    braceCount++;
                } else if (c == '}') {
                    braceCount--;

                    if (braceCount == 0) {
                        objectEnd = i;
                        break;
                    }
                }
            }

            if (objectEnd == -1) {
                break;
            }

            participants.add(participantsArray.substring(objectStart, objectEnd + 1));
            index = objectEnd + 1;

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
}
package service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import dto.MatchDTO;

public class RiotApiService {

    private static final String API_KEY = "RGAPI-ec76a796-beae-4519-a053-0d06832f9866";
    private static final String ASIA_HOST = "asia.api.riotgames.com";
    private static final String KR_HOST = "kr.api.riotgames.com";

    public String[] getSummonerInfo(String gameName, String tagLine) throws Exception {

        String accountPath = "/riot/account/v1/accounts/by-riot-id/" + gameName + "/" + tagLine;
        URI accountUri = new URI("https", ASIA_HOST, accountPath, null);
        String accountJson = sendGet(accountUri.toASCIIString());

        String puuid = extractValue(accountJson, "puuid");
        String responseGameName = extractValue(accountJson, "gameName");
        String responseTagLine = extractValue(accountJson, "tagLine");

        if (puuid == null || puuid.equals("")) {
            throw new RuntimeException("PUUID를 가져오지 못했습니다.");
        }

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
                responseGameName,
                responseTagLine,
                puuid,
                profileIconId,
                summonerLevel,
                soloRank,
                flexRank
        };
    }

    public List<MatchDTO> getRecentMatches(String puuid, int count) throws Exception {
        List<MatchDTO> matchList = new ArrayList<>();

        String matchIdsPath = "/lol/match/v5/matches/by-puuid/" + puuid + "/ids";
        String matchIdsQuery = "start=0&count=" + count;

        URI matchIdsUri = new URI("https", ASIA_HOST, matchIdsPath, matchIdsQuery, null);

        System.out.println("===== MATCH IDS URL =====");
        System.out.println(matchIdsUri.toASCIIString());

        String matchIdsJson = sendGet(matchIdsUri.toASCIIString());

        System.out.println("===== MATCH IDS JSON =====");
        System.out.println(matchIdsJson);

        List<String> matchIds = parseMatchIds(matchIdsJson);

        for (String matchId : matchIds) {
            String matchDetailPath = "/lol/match/v5/matches/" + matchId;
            URI matchDetailUri = new URI("https", ASIA_HOST, matchDetailPath, null);

            String matchJson = sendGet(matchDetailUri.toASCIIString());

            System.out.println("===== MATCH JSON =====");
            System.out.println(matchJson);

            String participantJson = findParticipantObject(matchJson, puuid);

            System.out.println("===== PARTICIPANT JSON =====");
            System.out.println(participantJson);

            if (participantJson == null || participantJson.equals("")) {
                continue;
            }

            MatchDTO match = new MatchDTO();

            match.setChampionName(extractValue(participantJson, "championName"));
            match.setKills(parseInt(extractNumberValue(participantJson, "kills")));
            match.setDeaths(parseInt(extractNumberValue(participantJson, "deaths")));
            match.setAssists(parseInt(extractNumberValue(participantJson, "assists")));
            match.setWin(parseBoolean(extractBooleanValue(participantJson, "win")));

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
                    "Riot API 오류: "
                    + responseCode
                    + " / URL: "
                    + apiUrl
                    + " / "
                    + sb.toString()
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

        // puuid 위치에서 뒤로 가면서 참가자 객체의 시작 { 찾기
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

        // 찾은 { 부터 참가자 객체의 끝 } 찾기
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

    private String extractValue(String json, String key) {
        String target = "\"" + key + "\":\"";
        int start = json.indexOf(target);

        if (start == -1) {
            return "";
        }

        start += target.length();
        int end = json.indexOf("\"", start);

        return json.substring(start, end);
    }

    private String extractNumberValue(String json, String key) {
        String target = "\"" + key + "\":";
        int start = json.indexOf(target);

        if (start == -1) {
            return "";
        }

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

        if (start == -1) {
            return "false";
        }

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

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }

    private boolean parseBoolean(String value) {
        return "true".equals(value);
    }
}
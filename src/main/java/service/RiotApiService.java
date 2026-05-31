package service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;

public class RiotApiService {

    private static final String API_KEY = "RGAPI-f7dc40a4-dc51-49aa-b289-f8f535b77bf0";
    private static final String ASIA_HOST = "asia.api.riotgames.com";
    private static final String KR_HOST = "kr.api.riotgames.com";

    public String[] getSummonerInfo(String gameName, String tagLine) throws Exception {

        String accountPath =
                "/riot/account/v1/accounts/by-riot-id/"
                + gameName
                + "/"
                + tagLine;

        URI accountUri = new URI(
                "https",
                ASIA_HOST,
                accountPath,
                null
        );

        String accountUrl = accountUri.toASCIIString();

        System.out.println("Account API URL: " + accountUrl);

        String accountJson = sendGet(accountUrl);

        System.out.println("Account Response: " + accountJson);

        String puuid = extractValue(accountJson, "puuid");
        String responseGameName = extractValue(accountJson, "gameName");
        String responseTagLine = extractValue(accountJson, "tagLine");

        if (puuid == null || puuid.equals("")) {
            throw new RuntimeException("PUUID를 가져오지 못했습니다.");
        }

        String summonerPath =
                "/lol/summoner/v4/summoners/by-puuid/"
                + puuid;

        URI summonerUri = new URI(
                "https",
                KR_HOST,
                summonerPath,
                null
        );

        String summonerUrl = summonerUri.toASCIIString();

        System.out.println("Summoner API URL: " + summonerUrl);

        String summonerJson = sendGet(summonerUrl);

        System.out.println("Summoner Response: " + summonerJson);

        String profileIconId = extractNumberValue(summonerJson, "profileIconId");
        String summonerLevel = extractNumberValue(summonerJson, "summonerLevel");

        return new String[] {
                responseGameName,
                responseTagLine,
                puuid,
                profileIconId,
                summonerLevel
        };
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
            br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8")
            );
        } else {
            br = new BufferedReader(
                    new InputStreamReader(conn.getErrorStream(), "UTF-8")
            );
        }

        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = br.readLine()) != null) {
            sb.append(line);
        }

        br.close();

        if (responseCode < 200 || responseCode >= 300) {
            throw new RuntimeException(
                    "Riot API 오류: " + responseCode + " / " + sb.toString()
            );
        }

        return sb.toString();
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
}
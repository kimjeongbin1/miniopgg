<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.MatchDTO" %>
<%@ page import="dto.ParticipantDTO" %>
<%@ page import="dto.ChampionStatsDTO" %>
<%@ page import="dto.ChampionMasteryDTO" %>
<%@ page import="java.text.DecimalFormat" %>

<%!
    public String getSpellImageName(int spellId) {
        switch (spellId) {
            case 1: return "SummonerBoost";
            case 3: return "SummonerExhaust";
            case 4: return "SummonerFlash";
            case 6: return "SummonerHaste";
            case 7: return "SummonerHeal";
            case 11: return "SummonerSmite";
            case 12: return "SummonerTeleport";
            case 13: return "SummonerMana";
            case 14: return "SummonerDot";
            case 21: return "SummonerBarrier";
            case 32: return "SummonerSnowball";
            default: return "";
        }
    }

    public String getTimeAgo(long gameCreation) {
        if (gameCreation == 0) return "";
        long diff = System.currentTimeMillis() - gameCreation;
        long minutes = diff / (1000 * 60);
        if (minutes < 60) return minutes + "분 전";
        long hours = minutes / 60;
        if (hours < 24) return hours + "시간 전";
        return (hours / 24) + "일 전";
    }

    public String getGameDuration(long gameDuration) {
        if (gameDuration == 0) return "";
        return (gameDuration / 60) + "분 " + (gameDuration % 60) + "초";
    }

    public String getRuneImageUrl(int styleId) {
        switch (styleId) {
            case 8000: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/7201_Precision.png";
            case 8100: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/7200_Domination.png";
            case 8200: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/7202_Sorcery.png";
            case 8300: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/7203_Whimsy.png";
            case 8400: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/7204_Resolve.png";
            default: return "";
        }
    }

    public String getMainRuneImageUrl(int perkId) {
        switch (perkId) {
            case 8005: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Precision/PressTheAttack/PressTheAttack.png";
            case 8008: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Precision/LethalTempo/LethalTempoTemp.png";
            case 8021: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Precision/FleetFootwork/FleetFootwork.png";
            case 8010: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Precision/Conqueror/Conqueror.png";
            case 8112: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Domination/Electrocute/Electrocute.png";
            case 8128: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Domination/DarkHarvest/DarkHarvest.png";
            case 9923: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Domination/HailOfBlades/HailOfBlades.png";
            case 8214: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Sorcery/SummonAery/SummonAery.png";
            case 8229: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Sorcery/ArcaneComet/ArcaneComet.png";
            case 8230: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Sorcery/PhaseRush/PhaseRush.png";
            case 8437: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Resolve/GraspOfTheUndying/GraspOfTheUndying.png";
            case 8439: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Resolve/VeteranAftershock/VeteranAftershock.png";
            case 8465: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Resolve/Guardian/Guardian.png";
            case 8351: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Inspiration/GlacialAugment/GlacialAugment.png";
            case 8360: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Inspiration/UnsealedSpellbook/UnsealedSpellbook.png";
            case 8369: return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/Inspiration/FirstStrike/FirstStrike.png";
            default: return "";
        }
    }
%>

<%
    String nickname = (String) session.getAttribute("nickname");

    if (nickname == null) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }

    String error = (String) request.getAttribute("error");
    String gameName = (String) request.getAttribute("gameName");
    String tagLine = (String) request.getAttribute("tagLine");
    String puuid = (String) request.getAttribute("puuid");
    String profileIconId = (String) request.getAttribute("profileIconId");
    String summonerLevel = (String) request.getAttribute("summonerLevel");
    String soloRank = (String) request.getAttribute("soloRank");
    String flexRank = (String) request.getAttribute("flexRank");

    List<MatchDTO> matchList = (List<MatchDTO>) request.getAttribute("matchList");
    List<ChampionStatsDTO> championStatsList =
            (List<ChampionStatsDTO>) request.getAttribute("championStatsList");
    
    List<ChampionMasteryDTO> championMasteryList =
            (List<ChampionMasteryDTO>) request.getAttribute("championMasteryList");

    DecimalFormat df = new DecimalFormat("0.00");
    String version = "16.11.1";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전적 검색 결과</title>

<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: var(--bg);
    color: var(--text);
}

.container {
    width: 1350px;
    margin: 60px auto;
    text-align: center;
}

.search-box {
    margin: 30px auto;
    width: 600px;
    display: flex;
}

.search-box input {
    flex: 1;
    height: 55px;
    font-size: 18px;
    padding: 0 15px;
    border: 1px solid var(--line);
    background-color: var(--input);
    color: var(--text);
    outline: none;
}

.search-box input:focus {
    border: 2px solid var(--accent);
}

.search-box button {
    width: 110px;
    border: none;
    background-color: var(--accent);
    color: white;
    font-size: 18px;
    cursor: pointer;
}

.result-card {
    background-color: var(--card);
    border: 1px solid var(--line);
    border-radius: 15px;
    padding: 35px;
    margin-top: 30px;
    display: inline-block;
    min-width: 600px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.profile-icon {
    width: 120px;
    height: 120px;
    border-radius: 20px;
    margin-bottom: 20px;
}

.riot-id {
    font-size: 30px;
    font-weight: bold;
    color: var(--accent);
    margin-bottom: 10px;
}

.level {
    font-size: 20px;
    margin-bottom: 25px;
    color: var(--text);
}

.rank-box {
    background-color: var(--input);
    border: 1px solid var(--line);
    border-radius: 12px;
    padding: 20px;
    margin-top: 15px;
    text-align: left;
}

.rank-title {
    color: var(--accent);
    font-weight: bold;
    margin-bottom: 8px;
}

.rank-info {
    font-size: 16px;
    color: var(--text);
}

.puuid {
    font-size: 12px;
    color: var(--subtext);
    word-break: break-all;
    margin-top: 20px;
}

.tab-menu {
    display: flex;
    justify-content: center;
    gap: 8px;
    margin: 35px 0 20px;
}

.tab-btn {
    padding: 12px 35px;
    border: none;
    border-radius: 8px;
    background-color: var(--menu);
    color: var(--text);
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
}

.tab-btn.active {
    background-color: #4f8cff;
    color: white;
}

.tab-content {
    display: none;
}

.tab-content.active {
    display: block;
}

.match-section {
    margin-top: 30px;
    text-align: left;
}

.match-section h2 {
    color: var(--accent);
    text-align: center;
    font-size: 30px;
}

.champion-stats-table {
    width: 100%;
    border-collapse: collapse;
    background-color: var(--card);
    border-radius: 12px;
    overflow: hidden;
    font-size: 15px;
    border: 1px solid var(--line);
}

.champion-stats-table th,
.champion-stats-table td {
    padding: 14px;
    border-bottom: 1px solid var(--line);
    text-align: center;
    color: var(--text);
}

.champion-stats-table th {
    color: var(--subtext);
    background-color: var(--menu);
}

.champion-cell {
    display: flex;
    align-items: center;
    gap: 10px;
    font-weight: bold;
    text-align: left;
}

.champion-small {
    width: 38px;
    height: 38px;
    border-radius: 50%;
}

.win-rate-good {
    color: var(--accent);
    font-weight: bold;
}

.win-rate-bad {
    color: #f87171;
    font-weight: bold;
}

.match-wrapper {
    margin-bottom: 15px;
}

.match-card {
    display: grid;
    grid-template-columns: 80px 80px 70px 150px 140px 100px 230px 260px 50px;
    align-items: center;
    background-color: var(--card);
    border-radius: 12px 12px 0 0;
    padding: 18px 25px;
    border-left: 8px solid #4f8cff;
    border-top: 1px solid var(--line);
    border-right: 1px solid var(--line);
    border-bottom: 1px solid var(--line);
    gap: 15px;
}

.match-card.lose {
    border-left-color: #ef4444;
}

.champion-icon {
    width: 64px;
    height: 64px;
    border-radius: 12px;
}

.spell-rune-box {
    display: flex;
    gap: 5px;
}

.spell-box, .rune-box {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.spell-img {
    width: 28px;
    height: 28px;
    border-radius: 5px;
    background-color: var(--menu);
}

.rune-img {
    width: 28px;
    height: 28px;
    border-radius: 50%;
    background-color: var(--input);
    padding: 2px;
}

.champion-name {
    font-size: 20px;
    font-weight: bold;
    color: var(--text);
}

.kda {
    font-size: 20px;
    font-weight: bold;
    color: var(--text);
}

.kda-ratio {
    color: var(--accent);
    font-size: 14px;
    margin-top: 5px;
}

.sub-info {
    color: var(--subtext);
    font-size: 14px;
}

.item-list {
    display: flex;
    flex-wrap: wrap;
    gap: 4px;
}

.item-img {
    width: 30px;
    height: 30px;
    border-radius: 5px;
    background-color: var(--menu);
}

.match-info-left {
    font-size: 14px;
    font-weight: bold;
    line-height: 1.6;
}

.queue-text {
    color: #60a5fa;
}

.time-ago {
    color: var(--subtext);
    font-weight: normal;
}

.result-line {
    width: 55px;
    height: 1px;
    background-color: var(--line);
    margin: 8px 0;
}

.duration-text {
    color: var(--subtext);
    font-weight: normal;
}

.win-text {
    color: #60a5fa;
}

.lose-text {
    color: #f87171;
}

.team-list {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 8px;
    font-size: 12px;
    color: var(--subtext);
}

.team-column {
    display: flex;
    flex-direction: column;
    gap: 4px;
    min-width: 0;
}

.player-row {
    display: flex;
    align-items: center;
    gap: 5px;
    white-space: nowrap;
    overflow: hidden;
}

.player-row img {
    width: 18px;
    height: 18px;
    border-radius: 4px;
    flex-shrink: 0;
}

.player-name {
    overflow: hidden;
    text-overflow: ellipsis;
    color: var(--text);
}

.toggle-btn {
    width: 42px;
    height: 42px;
    border: none;
    border-radius: 8px;
    background-color: var(--menu);
    color: #60a5fa;
    font-size: 22px;
    cursor: pointer;
}

.toggle-btn:hover {
    background-color: var(--hover);
}

.match-detail {
    display: none;
    background-color: var(--card);
    border-left: 8px solid #4f8cff;
    border-right: 1px solid var(--line);
    border-bottom: 1px solid var(--line);
    border-radius: 0 0 12px 12px;
    padding: 15px 20px;
}

.match-detail.lose {
    border-left-color: #ef4444;
}

.detail-title {
    font-size: 18px;
    font-weight: bold;
    margin: 10px 0;
    color: var(--accent);
}

.detail-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 13px;
    text-align: center;
}

.detail-table th {
    color: var(--subtext);
    padding: 8px;
    border-bottom: 1px solid var(--line);
}

.detail-table td {
    padding: 7px;
    border-bottom: 1px solid var(--line);
    color: var(--text);
}

.detail-player {
    display: flex;
    align-items: center;
    gap: 7px;
    text-align: left;
}

.detail-player img {
    width: 28px;
    height: 28px;
    border-radius: 6px;
}

.detail-items {
    display: flex;
    gap: 3px;
    justify-content: center;
    flex-wrap: wrap;
}

.detail-item-img {
    width: 24px;
    height: 24px;
    border-radius: 4px;
    background-color: var(--menu);
}

.blue-row {
    background-color: rgba(59, 130, 246, 0.08);
}

.red-row {
    background-color: rgba(239, 68, 68, 0.08);
}

.error-box {
    background-color: #7f1d1d;
    color: white;
    padding: 20px;
    border-radius: 10px;
    margin-top: 30px;
}

.mastery-grid {
    display: grid;
    grid-template-columns: repeat(6, 1fr);
    gap: 25px;
    background-color: var(--card);
    border: 1px solid var(--line);
    padding: 30px;
    border-radius: 12px;
}

.mastery-card {
    text-align: center;
    color: var(--text);
    background-color: var(--input);
    border: 1px solid var(--line);
    border-radius: 12px;
    padding: 16px 10px;
}

.mastery-card img {
    width: 72px;
    height: 72px;
    border-radius: 14px;
    margin-bottom: 8px;
}

.mastery-name {
    font-weight: bold;
    margin-bottom: 5px;
    color: var(--text);
}

.mastery-level {
    color: #facc15;
    font-weight: bold;
    font-size: 14px;
}

.mastery-point {
    color: var(--subtext);
    font-size: 13px;
}

a {
    color: var(--accent);
    text-decoration: none;
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<div class="container">
    <h1>전적 검색 결과</h1>

    <form class="search-box" action="${pageContext.request.contextPath}/record" method="get">
        <input type="text" name="riotId" placeholder="소환사명을 입력하세요 예: Hide on bush#KR1" required>
        <button type="submit">검색</button>
    </form>

    <% if (error != null) { %>

        <div class="error-box"><%= error %></div>

    <% } else if (gameName != null) { %>

        <div class="result-card">
            <img class="profile-icon"
                 src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/profileicon/<%= profileIconId %>.png">

            <div class="riot-id"><%= gameName %>#<%= tagLine %></div>
            <div class="level">소환사 레벨: <%= summonerLevel %></div>

            <div class="rank-box">
                <div class="rank-title">솔로랭크</div>
                <div class="rank-info"><%= soloRank %></div>
            </div>

            <div class="rank-box">
                <div class="rank-title">자유랭크</div>
                <div class="rank-info"><%= flexRank %></div>
            </div>

            <div class="puuid">PUUID: <%= puuid %></div>
        </div>

        <div class="tab-menu">
            <button type="button" class="tab-btn active" onclick="showTab('recentTab', this)">
                최근 경기
            </button>
            <button type="button" class="tab-btn" onclick="showTab('championTab', this)">
                챔피언 통계
            </button>
            <button type="button" class="tab-btn" onclick="showTab('masteryTab', this)">
						    숙련도
						</button>
        </div>

        <div id="recentTab" class="tab-content active">
            <div class="match-section">
                <h2>최근 경기</h2>

                <% if (matchList == null || matchList.size() == 0) { %>
                    <p style="text-align:center;">최근 경기 정보가 없습니다.</p>
                <% } else { %>

                    <% for (MatchDTO match : matchList) { %>

                        <div class="match-wrapper">

                            <div class="match-card <%= match.isWin() ? "" : "lose" %>">

                                <div class="match-info-left">
                                    <div class="queue-text"><%= match.getGameMode() %></div>
                                    <div class="time-ago"><%= getTimeAgo(match.getGameCreation()) %></div>
                                    <div class="result-line"></div>
                                    <div class="<%= match.isWin() ? "win-text" : "lose-text" %>">
                                        <%= match.isWin() ? "승리" : "패배" %>
                                    </div>
                                    <div class="duration-text"><%= getGameDuration(match.getGameDuration()) %></div>
                                </div>

                                <div>
                                    <img class="champion-icon"
                                         src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/champion/<%= match.getChampionName() %>.png">
                                </div>

                                <div class="spell-rune-box">
                                    <div class="spell-box">
                                        <%
                                            String spell1 = getSpellImageName(match.getSummoner1Id());
                                            String spell2 = getSpellImageName(match.getSummoner2Id());
                                        %>

                                        <% if (!spell1.equals("")) { %>
                                            <img class="spell-img"
                                                 src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/spell/<%= spell1 %>.png">
                                        <% } %>

                                        <% if (!spell2.equals("")) { %>
                                            <img class="spell-img"
                                                 src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/spell/<%= spell2 %>.png">
                                        <% } %>
                                    </div>

                                    <div class="rune-box">
                                        <%
                                            String primaryRune = getMainRuneImageUrl(match.getMainPerk());
                                            String subRune = getRuneImageUrl(match.getPerkSubStyle());
                                        %>

                                        <% if (!primaryRune.equals("")) { %>
                                            <img class="rune-img" src="<%= primaryRune %>">
                                        <% } %>

                                        <% if (!subRune.equals("")) { %>
                                            <img class="rune-img" src="<%= subRune %>">
                                        <% } %>
                                    </div>
                                </div>

                                <div class="champion-name">
                                    <span class="champion-name-text" data-champion="<%= match.getChampionName() %>">
                                        <%= match.getChampionName() %>
                                    </span>
                                </div>

                                <div class="kda">
                                    <%= match.getKills() %> /
                                    <%= match.getDeaths() %> /
                                    <%= match.getAssists() %>
                                    <div class="kda-ratio">평점 <%= df.format(match.getKdaRatio()) %></div>
                                    <div class="sub-info">킬관여 <%= match.getKillParticipation() %>%</div>
                                </div>

                                <div class="sub-info">
                                    CS <%= match.getCs() %>
                                </div>

                                <div class="item-list">
                                    <% int[] items = {
                                        match.getItem0(), match.getItem1(), match.getItem2(),
                                        match.getItem3(), match.getItem4(), match.getItem5(),
                                        match.getItem6()
                                    }; %>

                                    <% for (int item : items) { %>
                                        <% if (item != 0) { %>
                                            <img class="item-img"
                                                 src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/item/<%= item %>.png">
                                        <% } else { %>
                                            <div class="item-img"></div>
                                        <% } %>
                                    <% } %>
                                </div>

                                <div class="team-list">
                                    <div class="team-column">
                                        <% if (match.getBlueTeam() != null) { %>
                                            <% for (ParticipantDTO p : match.getBlueTeam()) { %>
                                                <div class="player-row">
                                                    <img src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/champion/<%= p.getChampionName() %>.png">
                                                    <span class="player-name"><%= p.getSummonerName() %></span>
                                                </div>
                                            <% } %>
                                        <% } %>
                                    </div>

                                    <div class="team-column">
                                        <% if (match.getRedTeam() != null) { %>
                                            <% for (ParticipantDTO p : match.getRedTeam()) { %>
                                                <div class="player-row">
                                                    <img src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/champion/<%= p.getChampionName() %>.png">
                                                    <span class="player-name"><%= p.getSummonerName() %></span>
                                                </div>
                                            <% } %>
                                        <% } %>
                                    </div>
                                </div>

                                <button type="button" class="toggle-btn" onclick="toggleDetail(this)">▼</button>
                            </div>

                            <div class="match-detail <%= match.isWin() ? "" : "lose" %>">
                                <div class="detail-title">상세 팀 분석</div>

                                <table class="detail-table">
                                    <tr>
                                        <th>소환사</th>
                                        <th>KDA</th>
                                        <th>평점</th>
                                        <th>피해량</th>
                                        <th>받은 피해</th>
                                        <th>와드</th>
                                        <th>CS</th>
                                        <th>아이템</th>
                                    </tr>

                                    <% if (match.getBlueTeam() != null) { %>
                                        <% for (ParticipantDTO p : match.getBlueTeam()) { %>
                                            <tr class="blue-row">
                                                <td>
                                                    <div class="detail-player">
                                                        <img src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/champion/<%= p.getChampionName() %>.png">
                                                        <span><%= p.getSummonerName() %></span>
                                                    </div>
                                                </td>
                                                <td><%= p.getKills() %> / <%= p.getDeaths() %> / <%= p.getAssists() %></td>
                                                <td><%= df.format(p.getKdaRatio()) %></td>
                                                <td><%= p.getTotalDamageDealtToChampions() %></td>
                                                <td><%= p.getTotalDamageTaken() %></td>
                                                <td><%= p.getVisionScore() %> / <%= p.getWardsPlaced() %> / <%= p.getWardsKilled() %></td>
                                                <td><%= p.getCs() %></td>
                                                <td>
                                                    <div class="detail-items">
                                                        <% int[] pItems = {
                                                            p.getItem0(), p.getItem1(), p.getItem2(),
                                                            p.getItem3(), p.getItem4(), p.getItem5(),
                                                            p.getItem6()
                                                        }; %>

                                                        <% for (int item : pItems) { %>
                                                            <% if (item != 0) { %>
                                                                <img class="detail-item-img"
                                                                     src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/item/<%= item %>.png">
                                                            <% } else { %>
                                                                <div class="detail-item-img"></div>
                                                            <% } %>
                                                        <% } %>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    <% } %>

                                    <% if (match.getRedTeam() != null) { %>
                                        <% for (ParticipantDTO p : match.getRedTeam()) { %>
                                            <tr class="red-row">
                                                <td>
                                                    <div class="detail-player">
                                                        <img src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/champion/<%= p.getChampionName() %>.png">
                                                        <span><%= p.getSummonerName() %></span>
                                                    </div>
                                                </td>
                                                <td><%= p.getKills() %> / <%= p.getDeaths() %> / <%= p.getAssists() %></td>
                                                <td><%= df.format(p.getKdaRatio()) %></td>
                                                <td><%= p.getTotalDamageDealtToChampions() %></td>
                                                <td><%= p.getTotalDamageTaken() %></td>
                                                <td><%= p.getVisionScore() %> / <%= p.getWardsPlaced() %> / <%= p.getWardsKilled() %></td>
                                                <td><%= p.getCs() %></td>
                                                <td>
                                                    <div class="detail-items">
                                                        <% int[] pItems = {
                                                            p.getItem0(), p.getItem1(), p.getItem2(),
                                                            p.getItem3(), p.getItem4(), p.getItem5(),
                                                            p.getItem6()
                                                        }; %>

                                                        <% for (int item : pItems) { %>
                                                            <% if (item != 0) { %>
                                                                <img class="detail-item-img"
                                                                     src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/item/<%= item %>.png">
                                                            <% } else { %>
                                                                <div class="detail-item-img"></div>
                                                            <% } %>
                                                        <% } %>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    <% } %>
                                </table>
                            </div>

                        </div>

                    <% } %>

                <% } %>
            </div>
        </div>

        <div id="championTab" class="tab-content">
            <div class="match-section">
                <h2>챔피언 통계</h2>

                <table class="champion-stats-table">
                    <tr>
                        <th>챔피언</th>
                        <th>게임</th>
                        <th>승/패</th>
                        <th>승률</th>
                        <th>KDA</th>
                        <th>평균 KDA</th>
                        <th>평균 CS</th>
                    </tr>

                    <% if (championStatsList == null || championStatsList.size() == 0) { %>
                        <tr>
                            <td colspan="7">챔피언 통계가 없습니다.</td>
                        </tr>
                    <% } else { %>
                        <% for (ChampionStatsDTO stat : championStatsList) { %>
                            <tr>
                                <td>
                                    <div class="champion-cell">
                                        <img class="champion-small"
                                             src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/champion/<%= stat.getChampionName() %>.png">
                                        <span class="champion-name-text" data-champion="<%= stat.getChampionName() %>">
                                            <%= stat.getChampionName() %>
                                        </span>
                                    </div>
                                </td>
                                <td><%= stat.getGames() %></td>
                                <td><%= stat.getWins() %>승 <%= stat.getLosses() %>패</td>
                                <td class="<%= stat.getWinRate() >= 50 ? "win-rate-good" : "win-rate-bad" %>">
                                    <%= stat.getWinRate() %>%
                                </td>
                                <td><%= df.format(stat.getKdaRatio()) %>:1</td>
                                <td>
                                    <%= df.format(stat.getAverageKills()) %> /
                                    <%= df.format(stat.getAverageDeaths()) %> /
                                    <%= df.format(stat.getAverageAssists()) %>
                                </td>
                                <td><%= df.format(stat.getAverageCs()) %></td>
                            </tr>
                        <% } %>
                    <% } %>
                </table>
            </div>
        </div>
        
        <div id="masteryTab" class="tab-content">
				    <div class="match-section">
				        <h2>챔피언 숙련도</h2>
				
				        <% if (championMasteryList == null || championMasteryList.size() == 0) { %>
				            <p style="text-align:center;">숙련도 정보가 없습니다.</p>
				        <% } else { %>
				
				            <div class="mastery-grid">
				                <% for (ChampionMasteryDTO mastery : championMasteryList) { %>
				                    <% if (!mastery.getChampionName().equals("")) { %>
				                        <div class="mastery-card">
				                            <img src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/champion/<%= mastery.getChampionName() %>.png">
				
				                            <div class="mastery-name champion-name-text"
				                                 data-champion="<%= mastery.getChampionName() %>">
				                                <%= mastery.getChampionName() %>
				                            </div>
				
				                            <div class="mastery-level">
				                                Lv. <%= mastery.getChampionLevel() %>
				                            </div>
				
				                            <div class="mastery-point">
				                                <%= mastery.getChampionPoints() %>점
				                            </div>
				                        </div>
				                    <% } %>
				                <% } %>
				            </div>
				
				        <% } %>
				    </div>
				</div>

    <% } %>

    <p style="margin-top: 30px;">
        <a href="${pageContext.request.contextPath}/main.jsp">메인으로 돌아가기</a>
    </p>
</div>

<script>
function showTab(tabId, button) {
    var contents = document.querySelectorAll(".tab-content");
    var buttons = document.querySelectorAll(".tab-btn");

    contents.forEach(function(content) {
        content.classList.remove("active");
    });

    buttons.forEach(function(btn) {
        btn.classList.remove("active");
    });

    document.getElementById(tabId).classList.add("active");
    button.classList.add("active");
}

function toggleDetail(button) {
    var wrapper = button.closest(".match-wrapper");
    var detail = wrapper.querySelector(".match-detail");

    if (detail.style.display === "block") {
        detail.style.display = "none";
        button.innerText = "▼";
    } else {
        detail.style.display = "block";
        button.innerText = "▲";
    }
}

var version = "<%= version %>";
var championUrl = "https://ddragon.leagueoflegends.com/cdn/"
                + version
                + "/data/ko_KR/champion.json";

fetch(championUrl)
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        var championData = data.data;
        var championNames = document.querySelectorAll(".champion-name-text");

        championNames.forEach(function(element) {
            var championId = element.getAttribute("data-champion");

            if (championData[championId]) {
                element.innerText = championData[championId].name;
            }
        });
    })
    .catch(function(error) {
        console.log("챔피언 한글 이름 불러오기 실패:", error);
    });
</script>

</body>
</html>
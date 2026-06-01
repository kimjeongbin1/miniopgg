<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.MatchDTO" %>
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

		public String getRuneImageUrl(int styleId) {
		    switch (styleId) {
		        case 8000:
		            return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/7201_Precision.png";
		        case 8100:
		            return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/7200_Domination.png";
		        case 8200:
		            return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/7202_Sorcery.png";
		        case 8300:
		            return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/7203_Whimsy.png";
		        case 8400:
		            return "https://ddragon.leagueoflegends.com/cdn/img/perk-images/Styles/7204_Resolve.png";
		        default:
		            return "";
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
        background-color: #111827;
        color: white;
    }

    .container {
        width: 1150px;
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
        border: none;
    }

    .search-box button {
        width: 110px;
        border: none;
        background-color: #42d8b1;
        color: white;
        font-size: 18px;
        cursor: pointer;
    }

    .result-card {
        background-color: #202632;
        border-radius: 15px;
        padding: 35px;
        margin-top: 30px;
        display: inline-block;
        min-width: 600px;
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
        color: #42d8b1;
        margin-bottom: 10px;
    }

    .level {
        font-size: 20px;
        margin-bottom: 25px;
    }

    .rank-box {
        background-color: #111827;
        border-radius: 12px;
        padding: 20px;
        margin-top: 15px;
        text-align: left;
    }

    .rank-title {
        color: #42d8b1;
        font-weight: bold;
        margin-bottom: 8px;
    }

    .rank-info {
        font-size: 16px;
        color: #e5e7eb;
    }

    .puuid {
        font-size: 12px;
        color: #9ca3af;
        word-break: break-all;
        margin-top: 20px;
    }

    .match-section {
        margin-top: 50px;
        text-align: left;
    }

    .match-section h2 {
        color: #42d8b1;
        text-align: center;
        font-size: 30px;
    }

    .match-card {
        display: grid;
        grid-template-columns: 80px 80px 70px 150px 140px 100px 230px;
        align-items: center;
        background-color: #202632;
        border-radius: 12px;
        padding: 18px 25px;
        margin-bottom: 15px;
        border-left: 8px solid #4f8cff;
        gap: 15px;
    }

    .match-card.lose {
        border-left-color: #ef4444;
    }

    .match-result {
        font-weight: bold;
        font-size: 18px;
    }

    .win-text {
        color: #60a5fa;
    }

    .lose-text {
        color: #f87171;
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

    .spell-img, .rune-img {
        width: 28px;
        height: 28px;
        border-radius: 5px;
        background-color: #374151;
    }

    .champion-name {
        font-size: 20px;
        font-weight: bold;
    }

    .kda {
        font-size: 20px;
        font-weight: bold;
    }

    .kda-ratio {
        color: #42d8b1;
        font-size: 14px;
        margin-top: 5px;
    }

    .sub-info {
        color: #cbd5e1;
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
        background-color: #374151;
    }

    .error-box {
        background-color: #7f1d1d;
        color: white;
        padding: 20px;
        border-radius: 10px;
        margin-top: 30px;
    }

    a {
        color: #42d8b1;
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

        <div class="error-box">
            <%= error %>
        </div>

    <% } else if (gameName != null) { %>

        <div class="result-card">
            <img class="profile-icon"
                 src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/profileicon/<%= profileIconId %>.png"
                 alt="프로필 아이콘">

            <div class="riot-id">
                <%= gameName %>#<%= tagLine %>
            </div>

            <div class="level">
                소환사 레벨: <%= summonerLevel %>
            </div>

            <div class="rank-box">
                <div class="rank-title">솔로랭크</div>
                <div class="rank-info"><%= soloRank %></div>
            </div>

            <div class="rank-box">
                <div class="rank-title">자유랭크</div>
                <div class="rank-info"><%= flexRank %></div>
            </div>

            <div class="puuid">
                PUUID: <%= puuid %>
            </div>
        </div>

        <div class="match-section">
            <h2>최근 경기</h2>

            <% if (matchList == null || matchList.size() == 0) { %>
                <p style="text-align:center;">최근 경기 정보가 없습니다.</p>
            <% } else { %>

                <% for (MatchDTO match : matchList) { %>
                    <div class="match-card <%= match.isWin() ? "" : "lose" %>">

                        <div class="match-result <%= match.isWin() ? "win-text" : "lose-text" %>">
                            <%= match.isWin() ? "승리" : "패배" %>
                        </div>

                        <div>
                            <img class="champion-icon"
                                 src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/champion/<%= match.getChampionName() %>.png"
                                 alt="챔피언">
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
                                    String primaryRune = getRuneImageUrl(match.getPerkPrimaryStyle());
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
                            <div class="sub-info"><%= match.getGameMode() %></div>
                        </div>

                        <div class="kda">
                            <%= match.getKills() %> /
                            <%= match.getDeaths() %> /
                            <%= match.getAssists() %>
                            <div class="kda-ratio">
                                평점 <%= df.format(match.getKdaRatio()) %>
                            </div>
                        </div>

                        <div class="sub-info">
                            CS <%= match.getCs() %>
                        </div>

                        <div class="item-list">
                            <% int[] items = {
                                match.getItem0(),
                                match.getItem1(),
                                match.getItem2(),
                                match.getItem3(),
                                match.getItem4(),
                                match.getItem5(),
                                match.getItem6()
                            }; %>

                            <% for (int item : items) { %>
                                <% if (item != 0) { %>
                                    <img class="item-img"
                                         src="https://ddragon.leagueoflegends.com/cdn/<%= version %>/img/item/<%= item %>.png"
                                         alt="item">
                                <% } else { %>
                                    <div class="item-img"></div>
                                <% } %>
                            <% } %>
                        </div>

                    </div>
                <% } %>

            <% } %>
        </div>

    <% } %>

    <p style="margin-top: 30px;">
        <a href="${pageContext.request.contextPath}/main.jsp">메인으로 돌아가기</a>
    </p>
</div>

<script>
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
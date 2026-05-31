<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
        width: 900px;
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
        min-width: 420px;
    }

    .profile-icon {
        width: 120px;
        height: 120px;
        border-radius: 20px;
        margin-bottom: 20px;
    }

    .riot-id {
        font-size: 28px;
        font-weight: bold;
        color: #42d8b1;
        margin-bottom: 10px;
    }

    .level {
        font-size: 20px;
        margin-bottom: 20px;
    }

    .puuid {
        font-size: 12px;
        color: #9ca3af;
        word-break: break-all;
        margin-top: 20px;
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
                 src="https://ddragon.leagueoflegends.com/cdn/15.10.1/img/profileicon/<%= profileIconId %>.png"
                 alt="프로필 아이콘">

            <div class="riot-id">
                <%= gameName %>#<%= tagLine %>
            </div>

            <div class="level">
                소환사 레벨: <%= summonerLevel %>
            </div>

            <div class="puuid">
                PUUID: <%= puuid %>
            </div>
        </div>

    <% } %>

    <p style="margin-top: 30px;">
        <a href="${pageContext.request.contextPath}/main.jsp">메인으로 돌아가기</a>
    </p>
</div>

</body>
</html>
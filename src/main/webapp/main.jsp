<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String nickname = (String) session.getAttribute("nickname");

    if (nickname == null) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Mini OP.GG 메인 오빠 바보</title>


<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background-color: #111827;
        color: white;
    }

    .header {
        background-color: #202632;
        padding: 20px 60px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .logo {
        font-size: 28px;
        font-weight: bold;
        color: #42d8b1;
    }

    .nav a {
        color: white;
        text-decoration: none;
        margin-left: 20px;
    }

    .nav a:hover {
        color: #42d8b1;
    }

    .main {
        padding: 60px;
        text-align: center;
    }

    .search-box {
        margin: 40px auto;
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

    .cards {
        display: flex;
        justify-content: center;
        gap: 25px;
        margin-top: 50px;
    }

    .card {
        width: 240px;
        height: 150px;
        background-color: #202632;
        border-radius: 12px;
        padding: 25px;
        text-align: left;
    }

    .card h3 {
        margin-top: 0;
        color: #42d8b1;
    }

    .card a {
        color: white;
        text-decoration: none;
    }
</style>
</head>

<body>

<div class="header">
    <div class="logo">Mini OP.GG</div>

    <div class="nav">
        <span><%= nickname %>님</span>
        <a href="${pageContext.request.contextPath}/board/board.jsp">게시판</a>
        <a href="${pageContext.request.contextPath}/user/mypage.jsp">마이페이지</a>
        <a href="${pageContext.request.contextPath}/logout">로그아웃</a>
    </div>
</div>

<div class="main">
    <h1>소환사 전적 검색</h1>
    <p>Mini OP.GG에 오신 것을 환영합니다.</p>

    <div class="search-box">
        <input type="text" placeholder="소환사명을 입력하세요">
        <button>검색</button>
    </div>

    <div class="cards">
        <div class="card">
            <h3>게시판</h3>
            <p>유저들과 자유롭게 이야기를 나눠보세요.</p>
            <a href="${pageContext.request.contextPath}/board/board.jsp">게시판 이동</a>
        </div>

        <div class="card">
            <h3>마이페이지</h3>
            <p>내 정보와 작성한 글을 확인하세요.</p>
            <a href="${pageContext.request.contextPath}/user/mypage.jsp">마이페이지 이동</a>
        </div>

        <div class="card">
            <h3>전적 검색</h3>
            <p>추후 Riot API 기능을 연결할 수 있습니다.</p>
            <a href="#">준비 중</a>
        </div>
    </div>
</div>

</body>
</html>
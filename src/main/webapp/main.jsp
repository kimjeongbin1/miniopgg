<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>

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
<title>Mini OP.GG 메인</title>

<style>
:root {
    --bg: #111827;
    --card: #202632;
    --input: #111827;
    --text: white;
    --subtext: #cbd5e1;
    --line: #374151;
    --hover: rgba(66, 216, 177, 0.08);
}

body.light-theme {
    --bg: #f4f6fb;
    --card: #ffffff;
    --input: #ffffff;
    --text: #111827;
    --subtext: #374151;
    --line: #cbd5e1;
    --hover: rgba(66, 216, 177, 0.12);
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: var(--bg);
    color: var(--text);
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
    border: 1px solid var(--line);
    background-color: var(--input);
    color: var(--text);
}

.search-box input::placeholder {
    color: var(--subtext);
}

.search-box button {
    width: 110px;
    border: none;
    background-color: #42d8b1;
    color: white;
    font-size: 18px;
    cursor: pointer;
}

.popular-section {
    width: 900px;
    margin: 40px auto;
    background-color: var(--card);
    border-radius: 12px;
    padding: 30px;
    text-align: left;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.popular-section h2 {
    color: #42d8b1;
    margin-top: 0;
    margin-bottom: 20px;
}

table {
    width: 100%;
    border-collapse: collapse;
    color: var(--text);
}

th, td {
    padding: 12px;
    border-bottom: 1px solid var(--line);
    text-align: center;
    color: var(--text);
}

th {
    color: #42d8b1;
}

tr {
    transition: background-color 0.2s;
}

tr:hover td {
    background-color: var(--hover) !important;
}

.title {
    text-align: left;
}

.title a {
    color: var(--text);
    text-decoration: none;
}

.title a:hover {
    color: #42d8b1;
}

.more-link {
    display: block;
    margin-top: 20px;
    text-align: right;
    color: #42d8b1;
    text-decoration: none;
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<div class="main">
    <h1>소환사 전적 검색</h1>
    <p>Riot ID를 입력하세요. 예: Hide on bush#KR1</p>

    <form class="search-box" action="${pageContext.request.contextPath}/record" method="get">
        <input type="text" name="riotId" placeholder="소환사명을 입력하세요 예: Hide on bush#KR1" required>
        <button type="submit">검색</button>
    </form>

    <div class="popular-section">
        <h2>인기글</h2>

        <table>
            <tr>
                <th>번호</th>
                <th>좋아요</th>
                <th>카테고리</th>
                <th>제목</th>
                <th>작성자</th>
                <th>조회수</th>
            </tr>

            <%
                String sql =
                    "SELECT " +
                    "b.post_id, " +
                    "b.title, " +
                    "b.writer, " +
                    "b.category, " +
                    "b.view_count, " +
                    "COUNT(l.like_id) AS like_count " +
                    "FROM board b " +
                    "LEFT JOIN likes l ON b.post_id = l.post_id " +
                    "GROUP BY b.post_id, b.title, b.writer, b.category, b.view_count, b.created_at " +
                    "ORDER BY like_count DESC, b.view_count DESC, b.created_at DESC " +
                    "LIMIT 5";

                try (
                    Connection conn = DBUtil.getConnection();
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();
                ) {
                    while (rs.next()) {
                        String category = rs.getString("category");

                        if (category == null || category.trim().equals("")) {
                            category = "자유";
                        }
            %>

            <tr>
                <td><%= rs.getInt("post_id") %></td>
                <td>좋아요 <%= rs.getInt("like_count") %></td>
                <td><%= category %></td>
                <td class="title">
                    <a href="<%= request.getContextPath() %>/board/detail.jsp?post_id=<%= rs.getInt("post_id") %>">
                        <%= rs.getString("title") %>
                    </a>
                </td>
                <td><%= rs.getString("writer") %></td>
                <td><%= rs.getInt("view_count") %></td>
            </tr>

            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>

            <tr>
                <td colspan="6">인기글을 불러오지 못했습니다.</td>
            </tr>

            <%
                }
            %>
        </table>

        <a class="more-link" href="${pageContext.request.contextPath}/board/board.jsp?sort=popular">
            인기글 더보기 →
        </a>
    </div>
</div>

</body>
</html>
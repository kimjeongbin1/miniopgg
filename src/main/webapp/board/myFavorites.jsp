<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>

<%
Integer userId = (Integer) session.getAttribute("user_id");

if (userId == null) {
    response.sendRedirect(request.getContextPath() + "/user/login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 즐겨찾기</title>


<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: var(--bg);
    color: var(--text);
}

.page-container {
    width: 1050px;
    margin: 45px auto;
}

.page-title {
    color: var(--accent);
    font-size: 34px;
    margin-bottom: 28px;
}

.card {
    background-color: var(--card);
    border: 1px solid var(--line);
    border-radius: 18px;
    padding: 32px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.favorite-table {
    width: 100%;
    border-collapse: collapse;
}

.favorite-table th {
    color: var(--accent);
    padding: 14px 10px;
    border-bottom: 1px solid var(--line);
}

.favorite-table td {
    padding: 15px 10px;
    border-bottom: 1px solid var(--line);
    text-align: center;
    color: var(--text);
}

.favorite-table tr:hover td {
    background-color: var(--hover) !important;
}

.title {
    text-align: left !important;
}

.title a {
    color: var(--text);
    text-decoration: none;
    font-weight: bold;
}

.title a:hover {
    color: var(--accent);
}

.category-badge {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 999px;
    background-color: var(--menu);
    color: #60a5fa;
    font-size: 13px;
    font-weight: bold;
}

.empty-row {
    color: var(--subtext);
    padding: 28px;
}

.bottom-menu {
    margin-top: 24px;
}

.back-btn {
    display: inline-block;
    padding: 12px 18px;
    border-radius: 10px;
    background-color: var(--accent);
    color: white;
    text-decoration: none;
    font-weight: bold;
}

.back-btn:hover {
    opacity: 0.9;
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<div class="page-container">
    <h1 class="page-title">내 즐겨찾기</h1>

    <div class="card">
        <table class="favorite-table">
            <tr>
                <th>번호</th>
                <th>카테고리</th>
                <th>제목</th>
                <th>작성자</th>
                <th>조회수</th>
                <th>저장된 시간</th>
            </tr>

<%
String sql =
    "SELECT b.*, f.created_at AS favorite_date " +
    "FROM favorites f " +
    "JOIN board b ON f.post_id = b.post_id " +
    "WHERE f.user_id = ? " +
    "ORDER BY f.created_at DESC";

try (
    Connection conn = DBUtil.getConnection();
    PreparedStatement ps = conn.prepareStatement(sql)
) {
    ps.setInt(1, userId);

    ResultSet rs = ps.executeQuery();

    boolean hasData = false;

    while (rs.next()) {
        hasData = true;

        String category = rs.getString("category");
        if (category == null || category.trim().equals("")) {
            category = "자유";
        }
%>

            <tr>
                <td><%= rs.getInt("post_id") %></td>
                <td><span class="category-badge"><%= category %></span></td>
                <td class="title">
                    <a href="<%= request.getContextPath() %>/board/detail.jsp?post_id=<%= rs.getInt("post_id") %>">
                        <%= rs.getString("title") %>
                    </a>
                </td>
                <td><%= rs.getString("writer") %></td>
                <td><%= rs.getInt("view_count") %></td>
                <td><%= rs.getTimestamp("favorite_date") %></td>
            </tr>

<%
    }

    if (!hasData) {
%>
            <tr>
                <td class="empty-row" colspan="6">즐겨찾기한 게시글이 없습니다.</td>
            </tr>
<%
    }

} catch (Exception e) {
    e.printStackTrace();
%>
            <tr>
                <td class="empty-row" colspan="6">즐겨찾기 목록을 불러오지 못했습니다.</td>
            </tr>
<%
}
%>

        </table>

        <div class="bottom-menu">
            <a class="back-btn" href="<%= request.getContextPath() %>/board/board.jsp">게시판으로 돌아가기</a>
        </div>
    </div>
</div>

</body>
</html>
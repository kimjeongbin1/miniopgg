<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="util.DBUtil"%>

<%
Integer loginUserId = (Integer) session.getAttribute("user_id");

if (loginUserId == null) {
    response.sendRedirect(request.getContextPath() + "/user/login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내가 쓴 글</title>


<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: #111827;
    color: white;
}

.page-container {
    width: 1050px;
    margin: 45px auto;
}

.page-title {
    color: #42d8b1;
    font-size: 34px;
    margin-bottom: 28px;
}

.card {
    background-color: #202632;
    border-radius: 18px;
    padding: 32px;
}

.post-table {
    width: 100%;
    border-collapse: collapse;
}

.post-table th {
    color: #42d8b1;
    padding: 14px 10px;
    border-bottom: 1px solid #374151;
}

.post-table td {
    padding: 15px 10px;
    border-bottom: 1px solid #374151;
    text-align: center;
    color: #e5e7eb;
}

.post-table tr:hover td {
    background-color: #263142;
}

.title {
    text-align: left !important;
}

.title a {
    color: white;
    text-decoration: none;
    font-weight: bold;
}

.title a:hover {
    color: #42d8b1;
}

.category-badge {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 999px;
    background-color: #2b3444;
    color: #60a5fa;
    font-size: 13px;
    font-weight: bold;
}

.empty-row {
    color: #cbd5e1;
    padding: 28px;
}

.bottom-menu {
    margin-top: 24px;
}

.back-btn {
    display: inline-block;
    padding: 12px 18px;
    border-radius: 10px;
    background-color: #42d8b1;
    color: white;
    text-decoration: none;
    font-weight: bold;
}

.back-btn:hover {
    background-color: #2fc6a0;
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<div class="page-container">
    <h1 class="page-title">내가 쓴 글</h1>

    <div class="card">
        <table class="post-table">
            <tr>
                <th>번호</th>
                <th>카테고리</th>
                <th>제목</th>
                <th>조회수</th>
                <th>작성일</th>
            </tr>

<%
String sql = "SELECT * FROM board WHERE user_id = ? ORDER BY post_id DESC";

try (
    Connection conn = DBUtil.getConnection();
    PreparedStatement ps = conn.prepareStatement(sql)
) {
    ps.setInt(1, loginUserId);

    ResultSet rs = ps.executeQuery();

    boolean hasPost = false;

    while (rs.next()) {
        hasPost = true;

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
                <td><%= rs.getInt("view_count") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
            </tr>

<%
    }

    if (!hasPost) {
%>
            <tr>
                <td class="empty-row" colspan="5">작성한 글이 없습니다.</td>
            </tr>
<%
    }

} catch (Exception e) {
    e.printStackTrace();
%>

            <tr>
                <td class="empty-row" colspan="5">내가 쓴 글을 불러오지 못했습니다.</td>
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
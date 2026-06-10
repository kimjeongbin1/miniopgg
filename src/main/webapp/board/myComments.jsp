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
<title>내 댓글</title>


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

.comment-table {
    width: 100%;
    border-collapse: collapse;
}

.comment-table th {
    color: var(--accent);
    padding: 14px 10px;
    border-bottom: 1px solid var(--line);
}

.comment-table td {
    padding: 15px 10px;
    border-bottom: 1px solid var(--line);
    text-align: center;
    color: var(--text);
}

.comment-table tr:hover td {
    background-color: var(--hover) !important;
}

.content {
    text-align: left !important;
    line-height: 1.6;
}

.post-title {
    text-align: left !important;
}

.post-title a {
    color: var(--text);
    text-decoration: none;
    font-weight: bold;
}

.post-title a:hover {
    color: var(--accent);
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
    <h1 class="page-title">내 댓글</h1>

    <div class="card">
        <table class="comment-table">
            <tr>
                <th>댓글 번호</th>
                <th>댓글 내용</th>
                <th>게시글</th>
                <th>작성일</th>
            </tr>

<%
String sql =
    "SELECT c.comment_id, c.content, c.created_at, " +
    "b.post_id, b.title " +
    "FROM comments c " +
    "JOIN board b ON c.post_id = b.post_id " +
    "WHERE c.user_id = ? " +
    "ORDER BY c.comment_id DESC";

try (
    Connection conn = DBUtil.getConnection();
    PreparedStatement ps = conn.prepareStatement(sql)
) {
    ps.setInt(1, loginUserId);

    ResultSet rs = ps.executeQuery();

    boolean hasComment = false;

    while (rs.next()) {
        hasComment = true;
%>

            <tr>
                <td><%= rs.getInt("comment_id") %></td>

                <td class="content">
                    <%= rs.getString("content").replace("\n", "<br>") %>
                </td>

                <td class="post-title">
                    <a href="<%= request.getContextPath() %>/board/detail.jsp?post_id=<%= rs.getInt("post_id") %>">
                        <%= rs.getString("title") %>
                    </a>
                </td>

                <td><%= rs.getTimestamp("created_at") %></td>
            </tr>

<%
    }

    if (!hasComment) {
%>
            <tr>
                <td class="empty-row" colspan="4">작성한 댓글이 없습니다.</td>
            </tr>
<%
    }

} catch (Exception e) {
    e.printStackTrace();
%>

            <tr>
                <td class="empty-row" colspan="4">내 댓글을 불러오지 못했습니다.</td>
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
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
    width: 900px;
    margin: auto;
    font-family: Arial;
    padding-top: 60px;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th, td {
    padding: 12px;
    border-bottom: 1px solid #ddd;
    text-align: center;
}

.content {
    text-align: left;
}

.post-title {
    text-align: left;
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<h1>내 댓글</h1>

<table>
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

    while (rs.next()) {
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
} catch (Exception e) {
    e.printStackTrace();
%>

<tr>
    <td colspan="4">내 댓글을 불러오지 못했습니다.</td>
</tr>

<%
}
%>

</table>

<br>
<a href="<%= request.getContextPath() %>/board/board.jsp">게시판으로 돌아가기</a>

</body>
</html>
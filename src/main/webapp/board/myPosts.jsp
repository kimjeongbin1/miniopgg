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

.title {
    text-align: left;
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<h1>내가 쓴 글</h1>

<table>
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

    while (rs.next()) {
%>

<tr>
    <td><%= rs.getInt("post_id") %></td>
    <td><%= rs.getString("category") == null ? "자유" : rs.getString("category") %></td>
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
} catch (Exception e) {
    e.printStackTrace();
%>

<tr>
    <td colspan="5">내가 쓴 글을 불러오지 못했습니다.</td>
</tr>

<%
}
%>

</table>

<br>
<a href="<%= request.getContextPath() %>/board/board.jsp">게시판으로 돌아가기</a>

</body>
</html>
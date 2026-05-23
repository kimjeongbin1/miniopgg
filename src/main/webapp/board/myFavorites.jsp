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
</head>
<body>

<jsp:include page="/common/header.jsp"/>

<h1>내 즐겨찾기</h1>

<a href="<%= request.getContextPath() %>/board/board.jsp">게시판으로</a>

<hr>

<table border="1" width="900">
    <tr>
        <th>번호</th>
        <th>카테고리</th>
        <th>제목</th>
        <th>작성자</th>
        <th>조회수</th>
        <th>즐겨찾기일</th>
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
%>

    <tr>
        <td><%= rs.getInt("post_id") %></td>
        <td><%= rs.getString("category") %></td>
        <td>
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
        <td colspan="6">즐겨찾기한 게시글이 없습니다.</td>
    </tr>
<%
    }

} catch (Exception e) {
    e.printStackTrace();
%>
    <tr>
        <td colspan="6">즐겨찾기 목록을 불러오지 못했습니다.</td>
    </tr>
<%
}
%>

</table>

</body>
</html>
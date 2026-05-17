<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>

<%
    String nickname = (String) session.getAttribute("nickname");

    if (nickname == null) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }

    String searchType = request.getParameter("searchType");
    String keyword = request.getParameter("keyword");

    if (searchType == null) searchType = "title_content";
    if (keyword == null) keyword = "";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
</head>
<body>

<h1>게시판</h1>

<p><%= nickname %>님 환영합니다.</p>

<a href="<%= request.getContextPath() %>/board/write.jsp">글쓰기</a>
<a href="<%= request.getContextPath() %>/main.jsp">메인으로</a>
<a href="<%= request.getContextPath() %>/logout">로그아웃</a>

<hr>

<form action="<%= request.getContextPath() %>/board/board.jsp" method="get">
    <select name="searchType">
        <option value="title_content" <%= searchType.equals("title_content") ? "selected" : "" %>>제목+내용</option>
        <option value="title" <%= searchType.equals("title") ? "selected" : "" %>>제목</option>
        <option value="writer" <%= searchType.equals("writer") ? "selected" : "" %>>작성자</option>
        <option value="category" <%= searchType.equals("category") ? "selected" : "" %>>카테고리</option>
    </select>

    <input type="text" name="keyword" value="<%= keyword %>" placeholder="검색어 입력">
    <button type="submit">검색</button>
    <a href="<%= request.getContextPath() %>/board/board.jsp">전체보기</a>
</form>

<hr>

<table border="1" width="900">
    <tr>
        <th>번호</th>
        <th>카테고리</th>
        <th>제목</th>
        <th>작성자</th>
        <th>작성일</th>
        <th>조회수</th>
    </tr>

<%
    String sql = "SELECT * FROM board";

    if (!keyword.trim().equals("")) {
        if (searchType.equals("title")) {
            sql += " WHERE title LIKE ?";
        } else if (searchType.equals("writer")) {
            sql += " WHERE writer LIKE ?";
        } else if (searchType.equals("category")) {
            sql += " WHERE category LIKE ?";
        } else {
            sql += " WHERE title LIKE ? OR content LIKE ?";
        }
    }

    sql += " ORDER BY post_id DESC";

    try (
        Connection conn = DBUtil.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)
    ) {
        if (!keyword.trim().equals("")) {
            if (searchType.equals("title_content")) {
                ps.setString(1, "%" + keyword + "%");
                ps.setString(2, "%" + keyword + "%");
            } else {
                ps.setString(1, "%" + keyword + "%");
            }
        }

        ResultSet rs = ps.executeQuery();

        boolean hasPost = false;

        while (rs.next()) {
            hasPost = true;
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
        <td><%= rs.getTimestamp("created_at") %></td>
        <td><%= rs.getInt("view_count") %></td>
    </tr>
<%
        }

        if (!hasPost) {
%>
    <tr>
        <td colspan="6">게시글이 없습니다.</td>
    </tr>
<%
        }

        rs.close();

    } catch (Exception e) {
        e.printStackTrace();
%>
    <tr>
        <td colspan="6">게시글을 불러오지 못했습니다.</td>
    </tr>
<%
    }
%>

</table>

</body>
</html>
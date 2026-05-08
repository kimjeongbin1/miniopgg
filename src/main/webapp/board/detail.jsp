<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>

<%
    Integer loginUserId = (Integer) session.getAttribute("user_id");
    String nickname = (String) session.getAttribute("nickname");

    if (loginUserId == null) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }

    int postId = Integer.parseInt(request.getParameter("post_id"));

    String updateSql = "UPDATE board SET view_count = view_count + 1 WHERE post_id = ?";
    String selectSql = "SELECT * FROM board WHERE post_id = ?";

    String title = "";
    String content = "";
    String writer = "";
    Timestamp createdAt = null;
    int viewCount = 0;
    int writerUserId = 0;

    try (Connection conn = DBUtil.getConnection()) {
        PreparedStatement updatePs = conn.prepareStatement(updateSql);
        updatePs.setInt(1, postId);
        updatePs.executeUpdate();

        PreparedStatement selectPs = conn.prepareStatement(selectSql);
        selectPs.setInt(1, postId);
        ResultSet rs = selectPs.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            content = rs.getString("content");
            writer = rs.getString("writer");
            createdAt = rs.getTimestamp("created_at");
            viewCount = rs.getInt("view_count");
            writerUserId = rs.getInt("user_id");
        } else {
            out.println("존재하지 않는 게시글입니다.");
            return;
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("오류 발생");
        return;
    }

    boolean isOwner = loginUserId == writerUserId;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세</title>
</head>
<body>

<h1><%= title %></h1>

<p>작성자: <%= writer %></p>
<p>작성일: <%= createdAt %></p>
<p>조회수: <%= viewCount %></p>

<hr>

<div>
    <%= content.replace("\n", "<br>") %>
</div>

<hr>

<a href="<%= request.getContextPath() %>/board/board.jsp">목록으로</a>

<% if (isOwner) { %>
    <a href="<%= request.getContextPath() %>/board/edit.jsp?post_id=<%= postId %>">수정</a>

    <form action="<%= request.getContextPath() %>/deletePost" method="post" style="display:inline;">
        <input type="hidden" name="post_id" value="<%= postId %>">
        <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
    </form>
<% } %>

</body>
</html>
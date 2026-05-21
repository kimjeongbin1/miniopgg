<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>

<%
Integer loginUserId = (Integer) session.getAttribute("user_id");

if (loginUserId == null) {
    response.sendRedirect(request.getContextPath() + "/user/login.jsp");
    return;
}

int postId = Integer.parseInt(request.getParameter("post_id"));

String title = "";
String content = "";
int writerUserId = 0;

String sql = "SELECT * FROM board WHERE post_id = ?";

try (
    Connection conn = DBUtil.getConnection();
    PreparedStatement ps = conn.prepareStatement(sql)
) {
    ps.setInt(1, postId);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        title = rs.getString("title");
        content = rs.getString("content");
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

if (loginUserId != writerUserId) {
    out.println("수정 권한이 없습니다.");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>

<style>
body {
    width: 800px;
    margin: auto;
    font-family: Arial;
    padding-top: 60px;
}

input, textarea {
    width: 100%;
    padding: 10px;
    margin-bottom: 15px;
}

button {
    padding: 10px 20px;
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<h1>게시글 수정</h1>

<form action="<%= request.getContextPath() %>/updatePost" method="post">
    <input type="hidden" name="post_id" value="<%= postId %>">

    <p>
        제목<br>
        <input type="text" name="title" value="<%= title %>" required>
    </p>

    <p>
        내용<br>
        <textarea name="content" rows="12" required><%= content %></textarea>
    </p>

    <button type="submit">수정 완료</button>
    <a href="<%= request.getContextPath() %>/board/detail.jsp?post_id=<%= postId %>">취소</a>
</form>

</body>
</html>
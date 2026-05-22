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
String writer = "";
String imagePath = null;

Timestamp createdAt = null;

int viewCount = 0;
int writerUserId = 0;

int likeCount = 0;
boolean likedByMe = false;

try (
    Connection conn = DBUtil.getConnection()
) {
    PreparedStatement updatePs =
        conn.prepareStatement(
            "UPDATE board SET view_count = view_count + 1 WHERE post_id = ?"
        );

    updatePs.setInt(1, postId);
    updatePs.executeUpdate();

    PreparedStatement selectPs =
        conn.prepareStatement(
            "SELECT * FROM board WHERE post_id = ?"
        );

    selectPs.setInt(1, postId);

    ResultSet rs = selectPs.executeQuery();

    if (rs.next()) {
        title = rs.getString("title");
        content = rs.getString("content");
        writer = rs.getString("writer");
        imagePath = rs.getString("image_path");

        createdAt = rs.getTimestamp("created_at");
        viewCount = rs.getInt("view_count");
        writerUserId = rs.getInt("user_id");
    } else {
        out.println("게시글 없음");
        return;
    }

    PreparedStatement likePs =
        conn.prepareStatement(
            "SELECT COUNT(*) FROM likes WHERE post_id = ?"
        );

    likePs.setInt(1, postId);

    ResultSet likeRs = likePs.executeQuery();

    if (likeRs.next()) {
        likeCount = likeRs.getInt(1);
    }

    PreparedStatement myLikePs =
        conn.prepareStatement(
            "SELECT * FROM likes WHERE post_id = ? AND user_id = ?"
        );

    myLikePs.setInt(1, postId);
    myLikePs.setInt(2, loginUserId);

    ResultSet myLikeRs = myLikePs.executeQuery();

    likedByMe = myLikeRs.next();

} catch (Exception e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세</title>

<style>
body {
    width: 900px;
    margin: auto;
    font-family: Arial;
    padding-top: 60px;
}

.content-box {
    border: 1px solid #ddd;
    padding: 20px;
    margin: 20px 0;
    min-height: 200px;
}

.post-image {
    margin-top: 20px;
    max-width: 100%;
    height: auto;
    border-radius: 8px;
}

.like-area {
    text-align: center;
    margin: 20px;
}

.like-btn {
    padding: 12px 25px;
    font-size: 18px;
    border-radius: 8px;
    border: 1px solid #ccc;
    background: white;
    color: #666;
    cursor: pointer;
    transition: 0.3s;
}

.like-btn:hover {
    transform: scale(1.05);
}

.liked {
    background: #4f8cff;
    border-color: #4f8cff;
    color: white;
}

.comment-box {
    border: 1px solid #ddd;
    padding: 10px;
    margin-bottom: 10px;
}

.report-form {
    display: inline;
    margin-left: 10px;
}

.report-form select {
    padding: 5px;
}

.report-form button {
    padding: 5px 10px;
}
</style>

</head>
<body>

<jsp:include page="/common/header.jsp"/>

<h1><%= title %></h1>

<p>작성자 : <%= writer %></p>
<p>작성일 : <%= createdAt %></p>
<p>조회수 : <%= viewCount %></p>

<hr>

<div class="content-box">

    <%= content.replace("\n", "<br>") %>

    <% if (imagePath != null && !imagePath.isEmpty()) { %>
        <div>
            <img class="post-image"
                 src="<%= request.getContextPath() + "/" + imagePath %>">
        </div>
    <% } %>

</div>

<div class="like-area">

<form action="<%= request.getContextPath() %>/like" method="post">

<input type="hidden" name="post_id" value="<%= postId %>">

<button class="like-btn <%= likedByMe ? "liked" : "" %>" type="submit">
    좋아요 <%= likeCount %>
</button>

</form>

</div>

<hr>

<a href="<%= request.getContextPath() %>/board/board.jsp">
목록
</a>

<%
boolean isOwner = (loginUserId == writerUserId);

if (isOwner) {
%>

<a href="<%= request.getContextPath() %>/board/edit.jsp?post_id=<%= postId %>">
수정
</a>

<form action="<%= request.getContextPath() %>/deletePost"
      method="post"
      style="display:inline;">

<input type="hidden" name="post_id" value="<%= postId %>">

<button type="submit">삭제</button>

</form>

<%
}
%>

<% if (!isOwner) { %>

<form class="report-form"
      action="<%= request.getContextPath() %>/report"
      method="post">

<input type="hidden" name="post_id" value="<%= postId %>">
<input type="hidden" name="reported_user_id" value="<%= writerUserId %>">

<select name="reason" required>
    <option value="">신고 사유 선택</option>
    <option value="욕설/비방">욕설/비방</option>
    <option value="도배">도배</option>
    <option value="부적절한 내용">부적절한 내용</option>
    <option value="기타">기타</option>
</select>

<button type="submit"
        onclick="return confirm('이 게시글을 신고하시겠습니까?');">
신고
</button>

</form>

<% } %>

<hr>

<h2>댓글</h2>

<form action="<%= request.getContextPath() %>/addComment" method="post">

<input type="hidden" name="post_id" value="<%= postId %>">

<textarea name="content" rows="3" cols="70" required></textarea>

<br>

<button type="submit">댓글 등록</button>

</form>

<hr>

<%
try (
    Connection conn = DBUtil.getConnection();

    PreparedStatement ps =
        conn.prepareStatement(
            "SELECT * FROM comments WHERE post_id = ? ORDER BY comment_id DESC"
        )
) {
    ps.setInt(1, postId);

    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
%>

<div class="comment-box">

<b><%= rs.getString("writer") %></b>
(<%= rs.getTimestamp("created_at") %>)

<p>
<%= rs.getString("content").replace("\n", "<br>") %>
</p>

</div>

<%
    }

} catch (Exception e) {
    e.printStackTrace();
}
%>

</body>
</html>
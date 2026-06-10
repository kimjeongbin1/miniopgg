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
String category = "";
String imagePath = null;

Timestamp createdAt = null;

int viewCount = 0;
int writerUserId = 0;

int likeCount = 0;
boolean likedByMe = false;
boolean favoritedByMe = false;

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
        category = rs.getString("category");
        imagePath = rs.getString("image_path");

        if (category == null || category.trim().equals("")) {
            category = "자유";
        }

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

    PreparedStatement myFavoritePs =
        conn.prepareStatement(
            "SELECT * FROM favorites WHERE post_id = ? AND user_id = ?"
        );

    myFavoritePs.setInt(1, postId);
    myFavoritePs.setInt(2, loginUserId);

    ResultSet myFavoriteRs = myFavoritePs.executeQuery();

    favoritedByMe = myFavoriteRs.next();

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
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: var(--bg);
    color: var(--text);
}

.detail-container {
    width: 900px;
    margin: 45px auto;
}

.post-header {
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 16px;
    padding: 28px;
    margin-bottom: 20px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.post-category {
    display: inline-block;
    padding: 7px 13px;
    border-radius: 999px;
    background: #4f8cff;
    color: white;
    font-size: 13px;
    font-weight: bold;
    margin-bottom: 16px;
}

.post-title-main {
    margin: 0 0 16px 0;
    color: var(--text);
    font-size: 34px;
}

.post-meta {
    display: flex;
    gap: 20px;
    color: var(--subtext);
    font-size: 14px;
    flex-wrap: wrap;
}

.content-box {
    background-color: var(--card);
    border: 1px solid var(--line);
    border-radius: 16px;
    padding: 28px;
    margin: 20px 0;
    min-height: 220px;
    color: var(--text);
    line-height: 1.8;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.post-image {
    margin-top: 20px;
    max-width: 100%;
    height: auto;
    border-radius: 10px;
}

.like-area {
    text-align: center;
    margin: 28px 0;
}

.like-btn {
    padding: 13px 28px;
    font-size: 17px;
    border-radius: 12px;
    border: 1px solid var(--line);
    background: var(--input);
    color: var(--text);
    cursor: pointer;
    transition: all 0.2s;
    font-weight: bold;
}

.like-btn:hover {
    transform: scale(1.04);
    background: var(--hover);
}

.liked {
    background: #4f8cff !important;
    border-color: #4f8cff !important;
    color: white !important;
}

.action-area {
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 14px;
    padding: 18px;
    margin: 20px 0;
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
}

.action-link,
.action-btn {
    padding: 10px 14px;
    border-radius: 10px;
    background: var(--menu);
    color: var(--text);
    text-decoration: none;
    font-weight: bold;
    border: none;
    cursor: pointer;
    font-size: 14px;
}

.action-link:hover,
.action-btn:hover {
    background: var(--hover);
    color: var(--accent);
}

.delete-btn {
    background: #ef4444;
    color: white;
}

.report-form {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    margin-left: auto;
}

.report-form select {
    padding: 10px;
    border-radius: 8px;
    border: 1px solid var(--line);
    background: var(--input);
    color: var(--text);
}

.report-form button {
    padding: 10px 14px;
    border: none;
    border-radius: 8px;
    background: #ef4444;
    color: white;
    cursor: pointer;
    font-weight: bold;
}

.comment-section {
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 16px;
    padding: 24px;
    margin-top: 22px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.comment-title {
    color: var(--accent);
    margin-top: 0;
    margin-bottom: 18px;
}

.comment-form textarea {
    width: 100%;
    min-height: 90px;
    border: 1px solid var(--line);
    border-radius: 12px;
    background: var(--input);
    color: var(--text);
    padding: 14px;
    box-sizing: border-box;
    resize: vertical;
    font-size: 15px;
    outline: none;
}

.comment-form textarea:focus {
    border: 2px solid var(--accent);
}

.comment-form button {
    margin-top: 10px;
    padding: 11px 18px;
    border: none;
    border-radius: 10px;
    background: var(--accent);
    color: white;
    font-weight: bold;
    cursor: pointer;
}

.comment-box {
    background-color: var(--input);
    border: 1px solid var(--line);
    border-radius: 12px;
    padding: 16px;
    margin-top: 14px;
    color: var(--text);
}

.comment-meta {
    color: var(--subtext);
    font-size: 13px;
    margin-bottom: 8px;
}

.comment-writer {
    color: var(--accent);
    font-weight: bold;
}
</style>

</head>
<body>

<jsp:include page="/common/header.jsp"/>

<div class="detail-container">

    <div class="post-header">
        <div class="post-category"><%= category %></div>

        <h1 class="post-title-main"><%= title %></h1>

        <div class="post-meta">
            <span>작성자 : <%= writer %></span>
            <span>작성일 : <%= createdAt %></span>
            <span>조회수 : <%= viewCount %></span>
        </div>
    </div>

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
        <form action="<%= request.getContextPath() %>/like"
              method="post"
              style="display:inline;">

            <input type="hidden" name="post_id" value="<%= postId %>">

            <button class="like-btn <%= likedByMe ? "liked" : "" %>"
                    type="submit">
                👍 좋아요 <%= likeCount %>
            </button>
        </form>

        <form action="<%= request.getContextPath() %>/favorite"
              method="post"
              style="display:inline; margin-left:10px;">

            <input type="hidden" name="post_id" value="<%= postId %>">

            <button class="like-btn <%= favoritedByMe ? "liked" : "" %>"
                    type="submit">
                ⭐ 즐겨찾기
            </button>
        </form>
    </div>

    <div class="action-area">
        <a class="action-link" href="<%= request.getContextPath() %>/board/board.jsp">
            목록
        </a>

        <%
        boolean isOwner = (loginUserId == writerUserId);

        if (isOwner) {
        %>

        <a class="action-link"
           href="<%= request.getContextPath() %>/board/edit.jsp?post_id=<%= postId %>">
            수정
        </a>

        <form action="<%= request.getContextPath() %>/deletePost"
              method="post"
              style="display:inline;">

            <input type="hidden" name="post_id" value="<%= postId %>">

            <button class="action-btn delete-btn" type="submit">
                삭제
            </button>
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
    </div>

    <div class="comment-section">
        <h2 class="comment-title">댓글</h2>

        <form class="comment-form"
              action="<%= request.getContextPath() %>/addComment"
              method="post">

            <input type="hidden" name="post_id" value="<%= postId %>">

            <textarea name="content" placeholder="댓글을 입력하세요" required></textarea>

            <br>

            <button type="submit">댓글 등록</button>
        </form>

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
            <div class="comment-meta">
                <span class="comment-writer"><%= rs.getString("writer") %></span>
                · <%= rs.getTimestamp("created_at") %>
            </div>

            <div>
                <%= rs.getString("content").replace("\n", "<br>") %>
            </div>
        </div>

        <%
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        %>

    </div>

</div>

</body>
</html>
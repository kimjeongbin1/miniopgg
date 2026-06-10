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
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: var(--bg);
    color: var(--text);
}

.edit-container {
    width: 900px;
    margin: 45px auto;
}

.edit-card {
    background-color: var(--card);
    border: 1px solid var(--line);
    border-radius: 18px;
    padding: 36px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.edit-title {
    color: var(--accent);
    font-size: 34px;
    margin: 0 0 28px 0;
}

.input-group {
    margin-bottom: 22px;
}

.input-group label {
    display: block;
    color: var(--subtext);
    font-weight: bold;
    margin-bottom: 8px;
}

.input-group input,
.input-group textarea {
    width: 100%;
    border: 1px solid var(--line);
    border-radius: 12px;
    background-color: var(--input);
    color: var(--text);
    padding: 14px;
    font-size: 16px;
    box-sizing: border-box;
    outline: none;
}

.input-group textarea {
    min-height: 260px;
    resize: vertical;
    line-height: 1.6;
}

.input-group input:focus,
.input-group textarea:focus {
    border: 2px solid var(--accent);
}

.button-row {
    display: flex;
    gap: 10px;
    margin-top: 28px;
}

.submit-btn {
    flex: 1;
    height: 52px;
    border: none;
    border-radius: 12px;
    background-color: var(--accent);
    color: white;
    font-size: 17px;
    font-weight: bold;
    cursor: pointer;
}

.cancel-btn {
    flex: 1;
    height: 52px;
    border-radius: 12px;
    background-color: var(--menu);
    color: var(--text);
    text-decoration: none;
    font-size: 17px;
    font-weight: bold;
    display: flex;
    justify-content: center;
    align-items: center;
}

.submit-btn:hover {
    opacity: 0.9;
}

.cancel-btn:hover {
    background-color: var(--hover);
    color: var(--accent);
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<div class="edit-container">
    <div class="edit-card">
        <h1 class="edit-title">게시글 수정</h1>

        <form action="<%= request.getContextPath() %>/updatePost" method="post">
            <input type="hidden" name="post_id" value="<%= postId %>">

            <div class="input-group">
                <label>제목</label>
                <input type="text" name="title" value="<%= title %>" required>
            </div>

            <div class="input-group">
                <label>내용</label>
                <textarea name="content" required><%= content %></textarea>
            </div>

            <div class="button-row">
                <button class="submit-btn" type="submit">수정 완료</button>

                <a class="cancel-btn"
                   href="<%= request.getContextPath() %>/board/detail.jsp?post_id=<%= postId %>">
                    취소
                </a>
            </div>
        </form>
    </div>
</div>

</body>
</html>
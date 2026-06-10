<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>

<%
Integer userId = (Integer) session.getAttribute("user_id");

if (userId == null) {
    response.sendRedirect(request.getContextPath() + "/user/login.jsp");
    return;
}

String loginId = "";
String nickname = "";
String email = "";
String name = "";
String phone = "";
Date birthdate = null;
String gender = "";

String userSql = "SELECT * FROM users WHERE user_id = ?";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>

<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: var(--bg);
    color: var(--text);
}

.page-container {
    width: 1100px;
    margin: 45px auto;
}

.page-title {
    color: var(--accent);
    font-size: 34px;
    margin-bottom: 28px;
}

.profile-card,
.section-card {
    background-color: var(--card);
    border-radius: 18px;
    padding: 32px;
    margin-bottom: 30px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.profile-header {
    display: flex;
    align-items: center;
    gap: 18px;
    margin-bottom: 28px;
}

.profile-avatar {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    background-color: var(--accent);
    display: flex;
    justify-content: center;
    align-items: center;
    color: #111827;
    font-size: 30px;
    font-weight: bold;
}

.profile-name {
    font-size: 26px;
    font-weight: bold;
    color: var(--text);
}

.profile-sub {
    color: var(--subtext);
    margin-top: 6px;
}

.info-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 14px;
}

.info-box {
    background-color: var(--input);
    border: 1px solid var(--line);
    border-radius: 12px;
    padding: 18px;
}

.info-label {
    color: var(--accent);
    font-size: 14px;
    font-weight: bold;
    margin-bottom: 8px;
}

.info-value {
    color: var(--text);
    font-size: 17px;
}

.menu {
    display: flex;
    gap: 10px;
    margin-top: 28px;
    flex-wrap: wrap;
}

.menu a {
    padding: 12px 18px;
    border-radius: 10px;
    background-color: var(--menu);
    color: var(--text);
    text-decoration: none;
    font-weight: bold;
}

.menu a:hover {
    background-color: var(--hover);
    color: var(--accent);
}

.menu a.primary {
    background-color: var(--accent);
    color: white;
}

.section-title {
    color: var(--accent);
    font-size: 26px;
    margin-top: 0;
    margin-bottom: 20px;
}

.post-table {
    width: 100%;
    border-collapse: collapse;
}

.post-table th {
    color: var(--accent);
    padding: 14px 10px;
    border-bottom: 1px solid var(--line);
}

.post-table td {
    padding: 15px 10px;
    border-bottom: 1px solid var(--line);
    text-align: center;
    color: var(--text);
}

.post-table tr:hover td {
    background-color: var(--hover) !important;
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
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<div class="page-container">

<%
try (
    Connection conn = DBUtil.getConnection();
    PreparedStatement ps = conn.prepareStatement(userSql)
) {
    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        loginId = rs.getString("login_id");
        nickname = rs.getString("nickname");
        email = rs.getString("email");
        name = rs.getString("name");
        phone = rs.getString("phone");
        birthdate = rs.getDate("birthdate");
        gender = rs.getString("gender");
    }
} catch (Exception e) {
    e.printStackTrace();
    out.println("<div class='profile-card'>회원정보를 불러오지 못했습니다.</div>");
}
%>

    <h1 class="page-title">마이페이지</h1>

    <div class="profile-card">
        <div class="profile-header">
            <div class="profile-avatar">
                <%= nickname != null && nickname.length() > 0 ? nickname.substring(0, 1) : "U" %>
            </div>

            <div>
                <div class="profile-name"><%= nickname %></div>
                <div class="profile-sub"><%= loginId %>님의 회원정보</div>
            </div>
        </div>

        <div class="info-grid">
            <div class="info-box">
                <div class="info-label">아이디</div>
                <div class="info-value"><%= loginId %></div>
            </div>

            <div class="info-box">
                <div class="info-label">닉네임</div>
                <div class="info-value"><%= nickname %></div>
            </div>

            <div class="info-box">
                <div class="info-label">이메일</div>
                <div class="info-value"><%= email == null ? "" : email %></div>
            </div>

            <div class="info-box">
                <div class="info-label">이름</div>
                <div class="info-value"><%= name == null ? "" : name %></div>
            </div>

            <div class="info-box">
                <div class="info-label">생년월일</div>
                <div class="info-value"><%= birthdate == null ? "" : birthdate %></div>
            </div>

            <div class="info-box">
                <div class="info-label">성별</div>
                <div class="info-value"><%= gender == null ? "" : gender %></div>
            </div>

            <div class="info-box">
                <div class="info-label">전화번호</div>
                <div class="info-value"><%= phone == null ? "" : phone %></div>
            </div>
        </div>

        <div class="menu">
            <a class="primary" href="<%= request.getContextPath() %>/user/editNickname.jsp">닉네임 변경</a>
            <a href="<%= request.getContextPath() %>/user/changePassword.jsp">비밀번호 변경</a>
            <a href="<%= request.getContextPath() %>/main.jsp">메인으로</a>
            <a href="<%= request.getContextPath() %>/board/board.jsp">게시판으로</a>
        </div>
    </div>

    <div class="section-card">
        <h2 class="section-title">내가 쓴 글 목록</h2>

        <table class="post-table">
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성일</th>
                <th>조회수</th>
            </tr>

<%
String postSql = "SELECT * FROM board WHERE user_id = ? ORDER BY post_id DESC";

try (
    Connection conn = DBUtil.getConnection();
    PreparedStatement ps = conn.prepareStatement(postSql)
) {
    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();

    boolean hasPost = false;

    while (rs.next()) {
        hasPost = true;
%>
            <tr>
                <td><%= rs.getInt("post_id") %></td>
                <td class="post-title">
                    <a href="<%= request.getContextPath() %>/board/detail.jsp?post_id=<%= rs.getInt("post_id") %>">
                        <%= rs.getString("title") %>
                    </a>
                </td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getInt("view_count") %></td>
            </tr>
<%
    }

    if (!hasPost) {
%>
            <tr>
                <td class="empty-row" colspan="4">작성한 글이 없습니다.</td>
            </tr>
<%
    }

} catch (Exception e) {
    e.printStackTrace();
%>
            <tr>
                <td class="empty-row" colspan="4">내가 쓴 글을 불러오지 못했습니다.</td>
            </tr>
<%
}
%>

        </table>
    </div>

</div>

</body>
</html>
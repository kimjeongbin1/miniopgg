<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String nickname = (String) session.getAttribute("nickname");
String role = (String) session.getAttribute("role");
%>

<style>
.common-header {
    background-color: #202632;
    padding: 20px 60px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.common-logo {
    font-size: 28px;
    font-weight: bold;
    color: #42d8b1;
    text-decoration: none;
}

.common-nav {
    display: flex;
    align-items: center;
    gap: 22px;
}

.common-nav a {
    color: white;
    text-decoration: none;
    font-size: 16px;
}

.common-nav a:hover {
    color: #42d8b1;
}

.nickname-btn {
    background: #42d8b1;
    color: white;
    border: none;
    padding: 10px 18px;
    border-radius: 22px;
    cursor: pointer;
    font-weight: bold;
}

.sidebar {
    position: fixed;
    top: 0;
    right: -320px;
    width: 280px;
    height: 100%;
    background: white;
    box-shadow: -3px 0 10px rgba(0,0,0,0.2);
    transition: right 0.3s;
    padding: 20px;
    box-sizing: border-box;
    z-index: 1000;
    color: black;
}

.sidebar.active {
    right: 0;
}

.close-btn {
    float: right;
    border: none;
    background: none;
    font-size: 24px;
    cursor: pointer;
}

.sidebar h3 {
    margin-top: 50px;
    color: black;
}

.sidebar a {
    display: block;
    padding: 12px 0;
    color: black;
    text-decoration: none;
    border-bottom: 1px solid #eee;
}

.sidebar a:hover {
    color: #42d8b1;
}
</style>

<div class="common-header">
    <a class="common-logo" href="<%= request.getContextPath() %>/main.jsp">
        Mini OP.GG
    </a>

    <div class="common-nav">
        <a href="<%= request.getContextPath() %>/board/board.jsp">게시판</a>
        <a href="<%= request.getContextPath() %>/champion/championList.jsp">챔피언 분석</a>

        <button class="nickname-btn" onclick="toggleSidebar()">
            <%= nickname %>님
        </button>
    </div>
</div>

<div id="mySidebar" class="sidebar">
    <button class="close-btn" onclick="closeSidebar()">X</button>

    <h3><%= nickname %>님</h3>

    <a href="<%= request.getContextPath() %>/user/mypage.jsp">마이페이지</a>
    <a href="<%= request.getContextPath() %>/board/myPosts.jsp">내가 쓴 글</a>
    <a href="<%= request.getContextPath() %>/board/myComments.jsp">내 댓글</a>
    <a href="<%= request.getContextPath() %>/board/myFavorites.jsp">즐겨찾기</a>

    <% if ("ADMIN".equals(role)) { %>
        <a href="<%= request.getContextPath() %>/admin/adminPage.jsp">관리자용</a>
    <% } %>

    <a href="<%= request.getContextPath() %>/logout">로그아웃</a>
</div>

<script>
function toggleSidebar() {
    const sidebar = document.getElementById("mySidebar");
    sidebar.classList.toggle("active");
}

function closeSidebar() {
    document.getElementById("mySidebar").classList.remove("active");
}
</script>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String nickname = (String) session.getAttribute("nickname");
%>

<style>
.nickname-btn {
    position: fixed;
    top: 15px;
    right: 20px;
    background: #4f8cff;
    color: white;
    border: none;
    padding: 10px 18px;
    border-radius: 22px;
    cursor: pointer;
    font-weight: bold;
    z-index: 1001;
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
}

.sidebar a {
    display: block;
    padding: 12px 0;
    color: black;
    text-decoration: none;
    border-bottom: 1px solid #eee;
}
</style>

<button class="nickname-btn" onclick="openSidebar()">
    <%= nickname %>님
</button>

<div id="mySidebar" class="sidebar">
    <button class="close-btn" onclick="closeSidebar()">X</button>

    <h3><%= nickname %>님</h3>

    <a href="<%= request.getContextPath() %>/user/mypage.jsp">마이페이지</a>
    <a href="<%= request.getContextPath() %>/user/editNickname.jsp">닉네임 변경</a>
    <a href="<%= request.getContextPath() %>/user/changePassword.jsp">비밀번호 변경</a>
    <a href="<%= request.getContextPath() %>/board/myPosts.jsp">내가 쓴 글</a>
    <a href="<%= request.getContextPath() %>/board/myComments.jsp">내 댓글</a>
    <a href="<%= request.getContextPath() %>/logout">로그아웃</a>
</div>

<script>
function openSidebar() {
    document.getElementById("mySidebar").classList.add("active");
}

function closeSidebar() {
    document.getElementById("mySidebar").classList.remove("active");
}
</script>
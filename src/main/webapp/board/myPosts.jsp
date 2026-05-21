<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
Integer loginUserId = (Integer) session.getAttribute("user_id");

if (loginUserId == null) {
    response.sendRedirect(request.getContextPath() + "/user/login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내가 쓴 글</title>

<style>
body {
    width: 900px;
    margin: auto;
    font-family: Arial;
    padding-top: 60px;
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<h1>내가 쓴 글</h1>

<p>아직 내가 쓴 글 목록 기능은 구현 전입니다.</p>

<a href="<%= request.getContextPath() %>/board/board.jsp">게시판으로 돌아가기</a>

</body>
</html>
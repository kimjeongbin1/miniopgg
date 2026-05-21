<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
Integer userId = (Integer) session.getAttribute("user_id");

if (userId == null) {
    response.sendRedirect(request.getContextPath() + "/user/login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>

<style>
body {
    width: 800px;
    margin: auto;
    font-family: Arial;
    padding-top: 60px;
}

input {
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

<h1>비밀번호 변경</h1>

<form action="<%= request.getContextPath() %>/changePassword" method="post">
    <p>
        현재 비밀번호
        <input type="password" name="currentPassword" required>
    </p>

    <p>
        새 비밀번호
        <input type="password" name="newPassword" required>
    </p>

    <p>
        새 비밀번호 확인
        <input type="password" name="newPasswordCheck" required>
    </p>

    <button type="submit">변경하기</button>
    <a href="<%= request.getContextPath() %>/user/mypage.jsp">취소</a>
</form>

</body>
</html>
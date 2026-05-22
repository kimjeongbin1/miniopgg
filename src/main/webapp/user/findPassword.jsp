<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
</head>
<body>

<h1>비밀번호 찾기</h1>

<form action="<%= request.getContextPath() %>/findPassword" method="post">
    아이디<br>
    <input type="text" name="loginId" required><br><br>

    이름<br>
    <input type="text" name="name" required><br><br>

    이메일<br>
    <input type="email" name="email" required><br><br>

    새 비밀번호<br>
    <input type="password" name="newPassword" required><br><br>

    새 비밀번호 확인<br>
    <input type="password" name="newPasswordCheck" required><br><br>

    <button type="submit">비밀번호 재설정</button>
</form>

<br>
<a href="<%= request.getContextPath() %>/user/login.jsp">로그인으로</a>

</body>
</html>
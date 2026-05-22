<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
</head>
<body>

<h1>아이디 찾기</h1>

<form action="<%= request.getContextPath() %>/findId" method="post">
    이름<br>
    <input type="text" name="name" required><br><br>

    이메일<br>
    <input type="email" name="email" required><br><br>

    <button type="submit">아이디 찾기</button>
</form>

<br>
<a href="<%= request.getContextPath() %>/user/login.jsp">로그인으로</a>

</body>
</html>
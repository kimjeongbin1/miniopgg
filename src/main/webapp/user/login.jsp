<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>

<h2>로그인</h2>

<form action="${pageContext.request.contextPath}/login" method="post">
    아이디: <input type="text" name="login_id"><br><br>
    비밀번호: <input type="password" name="password"><br><br>

    <button type="submit">로그인</button>
</form>

<br>
<a href="${pageContext.request.contextPath}/user/signup.jsp">회원가입</a>
<a href="<%= request.getContextPath() %>/user/findId.jsp">아이디 찾기</a>
<a href="<%= request.getContextPath() %>/user/findPassword.jsp">비밀번호 찾기</a>
</body>
</html>
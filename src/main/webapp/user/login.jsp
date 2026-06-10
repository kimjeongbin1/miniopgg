<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>

<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background-color: #111827;
        color: white;
    }

    .header {
        height: 90px;
        background-color: #202632;
        display: flex;
        align-items: center;
        padding: 0 70px;
        box-sizing: border-box;
    }

    .logo {
        color: #42d8b1;
        font-size: 32px;
        font-weight: bold;
        text-decoration: none;
    }

    .login-container {
        min-height: calc(100vh - 90px);
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .login-card {
        width: 420px;
        background-color: #202632;
        border-radius: 18px;
        padding: 45px 40px;
        box-sizing: border-box;
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.25);
    }

    .login-title {
        text-align: center;
        color: #42d8b1;
        font-size: 32px;
        font-weight: bold;
        margin-bottom: 35px;
    }

    .input-group {
        margin-bottom: 22px;
        text-align: left;
    }

    .input-group label {
        display: block;
        margin-bottom: 8px;
        color: #cbd5e1;
        font-weight: bold;
        font-size: 15px;
    }

    .input-group input {
        width: 100%;
        height: 48px;
        border: none;
        border-radius: 10px;
        padding: 0 15px;
        font-size: 16px;
        box-sizing: border-box;
        background-color: #111827;
        color: white;
        outline: none;
    }

    .input-group input:focus {
        border: 2px solid #42d8b1;
    }

    .login-btn {
        width: 100%;
        height: 52px;
        border: none;
        border-radius: 12px;
        background-color: #42d8b1;
        color: white;
        font-size: 18px;
        font-weight: bold;
        cursor: pointer;
        margin-top: 10px;
    }

    .login-btn:hover {
        background-color: #2fc6a0;
    }

    .link-box {
        margin-top: 25px;
        display: flex;
        justify-content: center;
        gap: 14px;
        font-size: 14px;
    }

    .link-box a {
        color: #cbd5e1;
        text-decoration: none;
    }

    .link-box a:hover {
        color: #42d8b1;
    }
</style>
</head>

<body>

<div class="header">
    <a class="logo" href="${pageContext.request.contextPath}/main.jsp">Mini OP.GG</a>
</div>

<div class="login-container">
    <div class="login-card">
        <div class="login-title">로그인</div>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="input-group">
                <label>아이디</label>
                <input type="text" name="login_id" placeholder="아이디를 입력하세요" required>
            </div>

            <div class="input-group">
                <label>비밀번호</label>
                <input type="password" name="password" placeholder="비밀번호를 입력하세요" required>
            </div>

            <button class="login-btn" type="submit">로그인</button>
        </form>

        <div class="link-box">
            <a href="${pageContext.request.contextPath}/user/signup.jsp">회원가입</a>
            <a href="${pageContext.request.contextPath}/user/findId.jsp">아이디 찾기</a>
            <a href="${pageContext.request.contextPath}/user/findPassword.jsp">비밀번호 찾기</a>
        </div>
    </div>
</div>

</body>
</html>
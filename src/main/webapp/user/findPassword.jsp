<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>

<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: #111827;
    color: white;
}

.find-container {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 45px 0;
    box-sizing: border-box;
}

.find-card {
    width: 480px;
    background-color: #202632;
    border-radius: 18px;
    padding: 40px;
    box-sizing: border-box;
}

.find-title {
    text-align: center;
    color: #42d8b1;
    font-size: 32px;
    font-weight: bold;
    margin-bottom: 30px;
}

.input-group {
    margin-bottom: 18px;
}

.input-group label {
    display: block;
    margin-bottom: 8px;
    color: #cbd5e1;
    font-weight: bold;
}

.input-group input {
    width: 100%;
    height: 50px;
    border: none;
    border-radius: 10px;
    background-color: #111827;
    color: white;
    padding: 0 15px;
    box-sizing: border-box;
    font-size: 15px;
    outline: none;
}

.input-group input:focus {
    border: 2px solid #42d8b1;
}

.find-btn {
    width: 100%;
    height: 52px;
    border: none;
    border-radius: 12px;
    background-color: #42d8b1;
    color: white;
    font-size: 17px;
    font-weight: bold;
    cursor: pointer;
    margin-top: 8px;
}

.find-btn:hover {
    background-color: #2fc6a0;
}

.bottom-link {
    text-align: center;
    margin-top: 20px;
}

.bottom-link a {
    color: #cbd5e1;
    text-decoration: none;
    font-weight: bold;
}

.bottom-link a:hover {
    color: #42d8b1;
}
</style>
</head>

<body>

<div class="find-container">
    <div class="find-card">

        <div class="find-title">비밀번호 찾기</div>

        <form action="<%= request.getContextPath() %>/findPassword" method="post">

            <div class="input-group">
                <label>아이디</label>
                <input type="text" name="loginId" placeholder="아이디를 입력하세요" required>
            </div>

            <div class="input-group">
                <label>이름</label>
                <input type="text" name="name" placeholder="이름을 입력하세요" required>
            </div>

            <div class="input-group">
                <label>이메일</label>
                <input type="email" name="email" placeholder="이메일을 입력하세요" required>
            </div>

            <div class="input-group">
                <label>새 비밀번호</label>
                <input type="password" name="newPassword" placeholder="새 비밀번호를 입력하세요" required>
            </div>

            <div class="input-group">
                <label>새 비밀번호 확인</label>
                <input type="password" name="newPasswordCheck" placeholder="새 비밀번호를 다시 입력하세요" required>
            </div>

            <button class="find-btn" type="submit">비밀번호 재설정</button>

        </form>

        <div class="bottom-link">
            <a href="<%= request.getContextPath() %>/user/login.jsp">로그인으로 돌아가기</a>
        </div>

    </div>
</div>

</body>
</html>
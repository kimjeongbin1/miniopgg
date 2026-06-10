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
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: var(--bg);
    color: var(--text);
}

.page-container {
    min-height: calc(100vh - 90px);
    display: flex;
    justify-content: center;
    align-items: center;
}

.password-card {
    width: 480px;
    background-color: var(--card);
    border: 1px solid var(--line);
    border-radius: 18px;
    padding: 42px 38px;
    box-sizing: border-box;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.password-title {
    color: var(--accent);
    font-size: 30px;
    text-align: center;
    margin-bottom: 30px;
    font-weight: bold;
}

.input-group {
    margin-bottom: 22px;
}

.input-group label {
    display: block;
    color: var(--subtext);
    font-weight: bold;
    margin-bottom: 8px;
}

.input-group input {
    width: 100%;
    height: 50px;
    border: 1px solid var(--line);
    border-radius: 10px;
    background-color: var(--input);
    color: var(--text);
    padding: 0 15px;
    font-size: 16px;
    box-sizing: border-box;
    outline: none;
}

.input-group input:focus {
    border: 2px solid var(--accent);
}

.button-row {
    display: flex;
    gap: 10px;
    margin-top: 28px;
}

.submit-btn {
    flex: 1;
    height: 50px;
    border: none;
    border-radius: 10px;
    background-color: var(--accent);
    color: white;
    font-weight: bold;
    font-size: 16px;
    cursor: pointer;
}

.cancel-btn {
    flex: 1;
    height: 50px;
    border-radius: 10px;
    background-color: var(--menu);
    color: var(--text);
    text-decoration: none;
    font-weight: bold;
    display: flex;
    justify-content: center;
    align-items: center;
}

.submit-btn:hover {
    opacity: 0.9;
}

.cancel-btn:hover {
    background-color: var(--hover);
    color: var(--accent);
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<div class="page-container">
    <div class="password-card">
        <div class="password-title">비밀번호 변경</div>

        <form action="<%= request.getContextPath() %>/changePassword" method="post">
            <div class="input-group">
                <label>현재 비밀번호</label>
                <input type="password" name="currentPassword" placeholder="현재 비밀번호를 입력하세요" required>
            </div>

            <div class="input-group">
                <label>새 비밀번호</label>
                <input type="password" name="newPassword" placeholder="새 비밀번호를 입력하세요" required>
            </div>

            <div class="input-group">
                <label>새 비밀번호 확인</label>
                <input type="password" name="newPasswordCheck" placeholder="새 비밀번호를 다시 입력하세요" required>
            </div>

            <div class="button-row">
                <button class="submit-btn" type="submit">변경하기</button>
                <a class="cancel-btn" href="<%= request.getContextPath() %>/user/mypage.jsp">취소</a>
            </div>
        </form>
    </div>
</div>

</body>
</html>
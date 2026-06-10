<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
Integer userId = (Integer) session.getAttribute("user_id");
String nickname = (String) session.getAttribute("nickname");

if (userId == null) {
    response.sendRedirect(request.getContextPath() + "/user/login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>닉네임 변경</title>

<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: #111827;
    color: white;
}

.page-container {
    min-height: calc(100vh - 90px);
    display: flex;
    justify-content: center;
    align-items: center;
}

.edit-card {
    width: 460px;
    background-color: #202632;
    border-radius: 18px;
    padding: 42px 38px;
    box-sizing: border-box;
}

.edit-title {
    color: #42d8b1;
    font-size: 30px;
    text-align: center;
    margin-bottom: 30px;
    font-weight: bold;
}

.current-box {
    background-color: #111827;
    border-radius: 12px;
    padding: 18px;
    margin-bottom: 22px;
}

.current-label {
    color: #42d8b1;
    font-size: 14px;
    font-weight: bold;
    margin-bottom: 8px;
}

.current-value {
    font-size: 20px;
    font-weight: bold;
}

.input-group {
    margin-bottom: 24px;
}

.input-group label {
    display: block;
    color: #cbd5e1;
    font-weight: bold;
    margin-bottom: 8px;
}

.input-group input {
    width: 100%;
    height: 50px;
    border: none;
    border-radius: 10px;
    background-color: #111827;
    color: white;
    padding: 0 15px;
    font-size: 16px;
    box-sizing: border-box;
    outline: none;
}

.input-group input:focus {
    border: 2px solid #42d8b1;
}

.button-row {
    display: flex;
    gap: 10px;
}

.submit-btn {
    flex: 1;
    height: 50px;
    border: none;
    border-radius: 10px;
    background-color: #42d8b1;
    color: white;
    font-weight: bold;
    font-size: 16px;
    cursor: pointer;
}

.cancel-btn {
    flex: 1;
    height: 50px;
    border-radius: 10px;
    background-color: #2b3444;
    color: #cbd5e1;
    text-decoration: none;
    font-weight: bold;
    display: flex;
    justify-content: center;
    align-items: center;
}

.submit-btn:hover {
    background-color: #2fc6a0;
}

.cancel-btn:hover {
    background-color: #374151;
    color: white;
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<div class="page-container">
    <div class="edit-card">
        <div class="edit-title">닉네임 변경</div>

        <form action="<%= request.getContextPath() %>/editNickname" method="post">
            <div class="current-box">
                <div class="current-label">현재 닉네임</div>
                <div class="current-value"><%= nickname %></div>
            </div>

            <div class="input-group">
                <label>새 닉네임</label>
                <input type="text" name="nickname" placeholder="새 닉네임을 입력하세요" required>
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
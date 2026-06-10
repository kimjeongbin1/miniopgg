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
    background-color: var(--bg);
    color: var(--text);
}

.page-container {
    min-height: calc(100vh - 90px);
    display: flex;
    justify-content: center;
    align-items: center;
}

.edit-card {
    width: 460px;
    background-color: var(--card);
    border: 1px solid var(--line);
    border-radius: 18px;
    padding: 42px 38px;
    box-sizing: border-box;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.edit-title {
    color: var(--accent);
    font-size: 30px;
    text-align: center;
    margin-bottom: 30px;
    font-weight: bold;
}

.current-box {
    background-color: var(--input);
    border: 1px solid var(--line);
    border-radius: 12px;
    padding: 18px;
    margin-bottom: 22px;
}

.current-label {
    color: var(--accent);
    font-size: 14px;
    font-weight: bold;
    margin-bottom: 8px;
}

.current-value {
    color: var(--text);
    font-size: 20px;
    font-weight: bold;
}

.input-group {
    margin-bottom: 24px;
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
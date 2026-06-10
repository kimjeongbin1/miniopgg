<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>

<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: #111827;
    color: white;
}

.signup-container {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 45px 0;
    box-sizing: border-box;
}

.signup-card {
    width: 520px;
    background-color: #202632;
    border-radius: 18px;
    padding: 42px 38px;
    box-sizing: border-box;
}

.signup-title {
    color: #42d8b1;
    font-size: 32px;
    text-align: center;
    margin-bottom: 30px;
    font-weight: bold;
}

.input-group {
    margin-bottom: 18px;
}

.input-group label {
    display: block;
    color: #cbd5e1;
    font-weight: bold;
    margin-bottom: 8px;
}

.input-row {
    display: flex;
    gap: 8px;
}

.input-group input,
.input-group select {
    width: 100%;
    height: 48px;
    border: none;
    border-radius: 10px;
    background-color: #111827;
    color: white;
    padding: 0 14px;
    font-size: 15px;
    box-sizing: border-box;
    outline: none;
}

.input-group input:focus,
.input-group select:focus {
    border: 2px solid #42d8b1;
}

.view-btn {
    width: 70px;
    border: none;
    border-radius: 10px;
    background-color: #2b3444;
    color: #cbd5e1;
    font-weight: bold;
    cursor: pointer;
}

.view-btn:hover {
    background-color: #374151;
    color: white;
}

.ok {
    display: block;
    color: #42d8b1;
    font-size: 13px;
    margin-top: 6px;
}

.error {
    display: block;
    color: #f87171;
    font-size: 13px;
    margin-top: 6px;
}

.signup-btn {
    width: 100%;
    height: 52px;
    border: none;
    border-radius: 12px;
    background-color: #42d8b1;
    color: white;
    font-size: 18px;
    font-weight: bold;
    cursor: pointer;
    margin-top: 12px;
}

.signup-btn:hover {
    background-color: #2fc6a0;
}

.login-link {
    margin-top: 24px;
    text-align: center;
}

.login-link a {
    color: #cbd5e1;
    text-decoration: none;
    font-weight: bold;
}

.login-link a:hover {
    color: #42d8b1;
}
</style>

<script>
function checkId() {
    let id = document.getElementById("login_id").value;
    let msg = document.getElementById("idMsg");

    if (id.length < 4) {
        msg.innerText = "아이디는 4자 이상 입력해주세요.";
        msg.className = "error";
        return;
    }

    fetch("${pageContext.request.contextPath}/checkId?login_id=" + id)
        .then(res => res.text())
        .then(data => {
            if (data === "ok") {
                msg.innerText = "사용 가능한 아이디입니다.";
                msg.className = "ok";
            } else {
                msg.innerText = "이미 사용중인 아이디입니다.";
                msg.className = "error";
            }
        });
}

function checkPw() {
    let pw = document.getElementById("password").value;
    let msg = document.getElementById("pwMsg");

    let regex = /^(?=.*[A-Za-z])(?=.*[!@#$%^&*]).{8,}$/;

    if (regex.test(pw)) {
        msg.innerText = "사용 가능한 비밀번호입니다.";
        msg.className = "ok";
    } else {
        msg.innerText = "영문+특수문자 포함 8자 이상 입력해주세요.";
        msg.className = "error";
    }
}

function checkPw2() {
    let pw = document.getElementById("password").value;
    let pw2 = document.getElementById("password2").value;
    let msg = document.getElementById("pw2Msg");

    if (pw2.length === 0) {
        msg.innerText = "";
        return;
    }

    if (pw === pw2) {
        msg.innerText = "비밀번호가 일치합니다.";
        msg.className = "ok";
    } else {
        msg.innerText = "비밀번호가 일치하지 않습니다.";
        msg.className = "error";
    }
}

function togglePassword(id) {
    let input = document.getElementById(id);

    if (input.type === "password") {
        input.type = "text";
    } else {
        input.type = "password";
    }
}
</script>
</head>

<body>



<div class="signup-container">
    <div class="signup-card">
        <div class="signup-title">회원가입</div>

        <form action="${pageContext.request.contextPath}/signup" method="post">

            <div class="input-group">
                <label>아이디</label>
                <input type="text" name="login_id" id="login_id" onkeyup="checkId()" placeholder="아이디를 입력하세요" required>
                <span id="idMsg"></span>
            </div>

            <div class="input-group">
                <label>비밀번호</label>
                <div class="input-row">
                    <input type="password" name="password" id="password" onkeyup="checkPw(); checkPw2();" placeholder="비밀번호를 입력하세요" required>
                    <button class="view-btn" type="button" onclick="togglePassword('password')">보기</button>
                </div>
                <span id="pwMsg"></span>
            </div>

            <div class="input-group">
                <label>비밀번호 확인</label>
                <div class="input-row">
                    <input type="password" id="password2" onkeyup="checkPw2()" placeholder="비밀번호를 다시 입력하세요" required>
                    <button class="view-btn" type="button" onclick="togglePassword('password2')">보기</button>
                </div>
                <span id="pw2Msg"></span>
            </div>

            <div class="input-group">
                <label>닉네임</label>
                <input type="text" name="nickname" placeholder="닉네임을 입력하세요" required>
            </div>

            <div class="input-group">
                <label>이메일</label>
                <input type="email" name="email" placeholder="example@email.com">
            </div>

            <div class="input-group">
                <label>이름</label>
                <input type="text" name="name" placeholder="이름을 입력하세요">
            </div>

            <div class="input-group">
                <label>생년월일</label>
                <input type="date" name="birthdate">
            </div>

            <div class="input-group">
                <label>성별</label>
                <select name="gender">
                    <option value="">선택</option>
                    <option value="남">남</option>
                    <option value="여">여</option>
                </select>
            </div>

            <div class="input-group">
                <label>전화번호</label>
                <input type="text" name="phone" placeholder="010-0000-0000">
            </div>

            <button class="signup-btn" type="submit">회원가입</button>
        </form>

        <div class="login-link">
            <a href="${pageContext.request.contextPath}/user/login.jsp">로그인으로 이동</a>
        </div>
    </div>
</div>

</body>
</html>
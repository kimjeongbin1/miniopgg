<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
<title>글쓰기</title>


<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: var(--bg);
    color: var(--text);
}

.write-container {
    width: 900px;
    margin: 45px auto;
}

.write-card {
    background-color: var(--card);
    border: 1px solid var(--line);
    border-radius: 18px;
    padding: 36px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.write-title {
    color: var(--accent);
    font-size: 34px;
    margin: 0 0 28px 0;
}

.writer-box {
    background-color: var(--input);
    border: 1px solid var(--line);
    border-radius: 12px;
    padding: 16px 18px;
    margin-bottom: 22px;
    color: var(--subtext);
}

.writer-box b {
    color: var(--accent);
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

.input-group input,
.input-group select,
.input-group textarea {
    width: 100%;
    border: 1px solid var(--line);
    border-radius: 10px;
    background-color: var(--input);
    color: var(--text);
    padding: 14px;
    font-size: 16px;
    box-sizing: border-box;
    outline: none;
}

.input-group select {
    height: 50px;
}

.input-group textarea {
    min-height: 220px;
    resize: vertical;
    line-height: 1.6;
}

.input-group input:focus,
.input-group select:focus,
.input-group textarea:focus {
    border: 2px solid var(--accent);
}

.input-group input::placeholder,
.input-group textarea::placeholder {
    color: var(--subtext);
}

.file-input {
    padding: 12px !important;
    cursor: pointer;
}

.button-row {
    display: flex;
    gap: 10px;
    margin-top: 28px;
}

.submit-btn {
    flex: 1;
    height: 52px;
    border: none;
    border-radius: 12px;
    background-color: var(--accent);
    color: white;
    font-size: 17px;
    font-weight: bold;
    cursor: pointer;
}

.cancel-btn {
    flex: 1;
    height: 52px;
    border: none;
    border-radius: 12px;
    background-color: var(--menu);
    color: var(--text);
    font-size: 17px;
    font-weight: bold;
    cursor: pointer;
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

<div class="write-container">
    <div class="write-card">
        <h1 class="write-title">글쓰기</h1>

        <form action="<%= request.getContextPath() %>/write"
              method="post"
              enctype="multipart/form-data">

            <div class="writer-box">
                작성자 : <b><%= nickname %></b>
            </div>

            <div class="input-group">
                <label>게시판 종류</label>
                <select name="category">
                    <option value="자유">자유 게시판</option>
                    <option value="질문">질문 게시판</option>
                    <option value="비밀">비밀 게시판</option>
                </select>
            </div>

            <div class="input-group">
                <label>제목</label>
                <input type="text" name="title" placeholder="제목을 입력하세요" required>
            </div>

            <div class="input-group">
                <label>내용</label>
                <textarea name="content" rows="10" placeholder="내용을 입력하세요" required></textarea>
            </div>

            <div class="input-group">
                <label>사진 첨부</label>
                <input class="file-input" type="file" name="image" accept="image/*">
            </div>

            <div class="button-row">
                <button class="submit-btn" type="submit">등록</button>

                <button class="cancel-btn" type="button"
                        onclick="location.href='<%= request.getContextPath() %>/board/board.jsp'">
                    취소
                </button>
            </div>

        </form>
    </div>
</div>

</body>
</html>
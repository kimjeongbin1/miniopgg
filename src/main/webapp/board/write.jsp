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
    font-family: Arial;
    width: 800px;
    margin: auto;
    padding-top: 60px;
}

input, select, textarea {
    width: 100%;
    margin-bottom: 15px;
    padding: 10px;
}

button {
    padding: 10px 20px;
}
</style>

</head>
<body>

<jsp:include page="/common/header.jsp"/>

<h1>글쓰기</h1>

<form action="<%= request.getContextPath() %>/write" 
      method="post"
      enctype="multipart/form-data">

    <p>
        작성자 :
        <b><%= nickname %></b>
    </p>

    <p>
        게시판 종류
        <select name="category">
            <option value="자유">자유 게시판</option>
            <option value="질문">질문 게시판</option>
            <option value="비밀">비밀 게시판</option>
        </select>
    </p>

    <p>
        제목
        <input type="text" name="title" placeholder="제목 입력" required>
    </p>

    <p>
        내용
        <textarea name="content" rows="10" placeholder="내용 입력" required></textarea>
    </p>

    <p>
        사진 첨부
        <input type="file" name="image" accept="image/*">
    </p>

    <button type="submit">등록</button>

    <button type="button"
            onclick="location.href='<%= request.getContextPath() %>/board/board.jsp'">
        취소
    </button>

</form>

</body>
</html>
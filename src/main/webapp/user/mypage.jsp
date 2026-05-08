<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>

<%
    Integer userId = (Integer) session.getAttribute("user_id");

    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }

    String loginId = "";
    String nickname = "";
    String email = "";
    String name = "";
    String phone = "";
    Date birthdate = null;
    String gender = "";

    String userSql = "SELECT * FROM users WHERE user_id = ?";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
</head>
<body>

<h1>마이페이지</h1>

<%
    try (
        Connection conn = DBUtil.getConnection();
        PreparedStatement ps = conn.prepareStatement(userSql)
    ) {
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            loginId = rs.getString("login_id");
            nickname = rs.getString("nickname");
            email = rs.getString("email");
            name = rs.getString("name");
            phone = rs.getString("phone");
            birthdate = rs.getDate("birthdate");
            gender = rs.getString("gender");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("회원정보를 불러오지 못했습니다.");
    }
%>

<h2>내 회원정보</h2>

<table border="1">
    <tr>
        <th>아이디</th>
        <td><%= loginId %></td>
    </tr>
    <tr>
        <th>닉네임</th>
        <td><%= nickname %></td>
    </tr>
    <tr>
        <th>이메일</th>
        <td><%= email == null ? "" : email %></td>
    </tr>
    <tr>
        <th>이름</th>
        <td><%= name == null ? "" : name %></td>
    </tr>
    <tr>
        <th>생년월일</th>
        <td><%= birthdate == null ? "" : birthdate %></td>
    </tr>
    <tr>
        <th>성별</th>
        <td><%= gender == null ? "" : gender %></td>
    </tr>
    <tr>
        <th>전화번호</th>
        <td><%= phone == null ? "" : phone %></td>
    </tr>
</table>

<br>

<a href="<%= request.getContextPath() %>/main.jsp">메인으로</a>
<a href="<%= request.getContextPath() %>/board/board.jsp">게시판으로</a>

<hr>

<h2>내가 쓴 글 목록</h2>

<table border="1" width="800">
    <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성일</th>
        <th>조회수</th>
    </tr>

<%
    String postSql = "SELECT * FROM board WHERE user_id = ? ORDER BY post_id DESC";

    try (
        Connection conn = DBUtil.getConnection();
        PreparedStatement ps = conn.prepareStatement(postSql)
    ) {
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("post_id") %></td>
        <td>
            <a href="<%= request.getContextPath() %>/board/detail.jsp?post_id=<%= rs.getInt("post_id") %>">
                <%= rs.getString("title") %>
            </a>
        </td>
        <td><%= rs.getTimestamp("created_at") %></td>
        <td><%= rs.getInt("view_count") %></td>
    </tr>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
%>
    <tr>
        <td colspan="4">내가 쓴 글을 불러오지 못했습니다.</td>
    </tr>
<%
    }
%>

</table>

</body>
</html>
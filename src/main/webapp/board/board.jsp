<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="util.DBUtil"%>

<%
String nickname = (String) session.getAttribute("nickname");

if (nickname == null) {
    response.sendRedirect(request.getContextPath() + "/user/login.jsp");
    return;
}

String sort = request.getParameter("sort");
if (sort == null) {
    sort = "popular";
}

String keyword = request.getParameter("keyword");
if (keyword == null) {
    keyword = "";
}

String searchType = request.getParameter("searchType");
if (searchType == null) {
    searchType = "all";
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>

<style>
body {
    width: 1000px;
    margin: auto;
    font-family: Arial;
}

.top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.tab {
    margin-bottom: 20px;
}

.tab a {
    padding: 10px 15px;
    text-decoration: none;
    border: 1px solid #ddd;
    color: black;
    margin-right: 5px;
    border-radius: 8px;
}

.active {
    background: #4f8cff;
    color: white !important;
}

.search-box {
    margin-bottom: 15px;
}

.search-box select,
.search-box input,
.search-box button {
    padding: 8px;
    font-size: 14px;
}

.search-box input {
    width: 250px;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th, td {
    padding: 12px;
    border-bottom: 1px solid #ddd;
    text-align: center;
}

.title {
    text-align: left;
}
</style>
</head>

<body>

<div class="top">
    <h1>게시판</h1>

    <div>
        <%= nickname %>님 환영합니다

        <a href="<%= request.getContextPath() %>/user/mypage.jsp">👤 마이페이지</a>
        <a href="<%= request.getContextPath() %>/logout">로그아웃</a>
    </div>
</div>

<div class="tab">
    <a class="<%= sort.equals("popular") ? "active" : "" %>"
       href="<%= request.getContextPath() %>/board/board.jsp?sort=popular">🔥 인기</a>

    <a class="<%= sort.equals("latest") ? "active" : "" %>"
       href="<%= request.getContextPath() %>/board/board.jsp?sort=latest">🕒 최신</a>

    <a class="<%= sort.equals("views") ? "active" : "" %>"
       href="<%= request.getContextPath() %>/board/board.jsp?sort=views">👁 조회수</a>

    <a href="<%= request.getContextPath() %>/board/write.jsp">✏ 글쓰기</a>
</div>

<form class="search-box" method="get" action="<%= request.getContextPath() %>/board/board.jsp">
    <input type="hidden" name="sort" value="<%= sort %>">

    <select name="searchType">
        <option value="all" <%= searchType.equals("all") ? "selected" : "" %>>
            게시글내용+작성자
        </option>
        <option value="writer" <%= searchType.equals("writer") ? "selected" : "" %>>
            작성자
        </option>
        <option value="content" <%= searchType.equals("content") ? "selected" : "" %>>
            게시글 내용
        </option>
    </select>

    <input type="text" name="keyword" value="<%= keyword %>" placeholder="검색">
    <button type="submit">검색</button>
</form>

<table>
<tr>
    <th>번호</th>
    <th>좋아요</th>
    <th>카테고리</th>
    <th>제목</th>
    <th>작성자</th>
    <th>조회수</th>
    <th>작성일</th>
</tr>

<%
String sql =
    "SELECT " +
    "b.post_id, " +
    "b.user_id, " +
    "b.title, " +
    "b.content, " +
    "b.writer, " +
    "b.category, " +
    "b.view_count, " +
    "b.created_at, " +
    "COUNT(l.like_id) AS like_count " +
    "FROM board b " +
    "LEFT JOIN likes l ON b.post_id = l.post_id ";

if (!keyword.trim().equals("")) {
    if (searchType.equals("writer")) {
        sql += "WHERE b.writer LIKE ? ";
    } else if (searchType.equals("content")) {
        sql += "WHERE b.content LIKE ? ";
    } else {
        sql += "WHERE (b.content LIKE ? OR b.writer LIKE ?) ";
    }
}

sql +=
    "GROUP BY " +
    "b.post_id, b.user_id, b.title, b.content, b.writer, " +
    "b.category, b.view_count, b.created_at ";

if (sort.equals("latest")) {
    sql += "ORDER BY b.created_at DESC";
} else if (sort.equals("views")) {
    sql += "ORDER BY b.view_count DESC";
} else {
    sql += "ORDER BY like_count DESC, b.view_count DESC, b.created_at DESC";
}

try (
    Connection conn = DBUtil.getConnection();
    PreparedStatement ps = conn.prepareStatement(sql)
) {
    if (!keyword.trim().equals("")) {
        String searchKeyword = "%" + keyword + "%";

        if (searchType.equals("all")) {
            ps.setString(1, searchKeyword);
            ps.setString(2, searchKeyword);
        } else {
            ps.setString(1, searchKeyword);
        }
    }

    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
%>

<tr>
    <td><%= rs.getInt("post_id") %></td>

    <td>👍 <%= rs.getInt("like_count") %></td>

    <td>
        <%= rs.getString("category") == null ? "자유" : rs.getString("category") %>
    </td>

    <td class="title">
        <a href="<%= request.getContextPath() %>/board/detail.jsp?post_id=<%= rs.getInt("post_id") %>">
            <%= rs.getString("title") %>
        </a>
    </td>

    <td><%= rs.getString("writer") %></td>

    <td><%= rs.getInt("view_count") %></td>

    <td><%= rs.getTimestamp("created_at") %></td>
</tr>

<%
    }
} catch (Exception e) {
    e.printStackTrace();
%>
<tr>
    <td colspan="7">게시글을 불러오지 못했습니다.</td>
</tr>
<%
}
%>

</table>

</body>
</html>
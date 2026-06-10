<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="util.DBUtil"%>

<%
String nickname = (String) session.getAttribute("nickname");
String role = (String) session.getAttribute("role");

if (nickname == null) {
    response.sendRedirect(request.getContextPath() + "/user/login.jsp");
    return;
}

String sort = request.getParameter("sort");
if (sort == null) sort = "popular";

String keyword = request.getParameter("keyword");
if (keyword == null) keyword = "";

String searchType = request.getParameter("searchType");
if (searchType == null) searchType = "titleContent";

String category = request.getParameter("category");
if (category == null) category = "";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>


<style>
:root {
    --bg: #111827;
    --card: #202632;
    --input: #111827;
    --text: white;
    --subtext: #cbd5e1;
    --line: #374151;
    --hover: rgba(66, 216, 177, 0.08);
    --menu: #2b3444;
}

body.light-theme {
    --bg: #f4f6fb;
    --card: #ffffff;
    --input: #ffffff;
    --text: #111827;
    --subtext: #374151;
    --line: #cbd5e1;
    --hover: rgba(66, 216, 177, 0.12);
    --menu: #eef2f7;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: var(--bg);
    color: var(--text);
}

.board-layout {
    display: flex;
    gap: 30px;
    width: 1250px;
    margin: 45px auto 0 auto;
}

.category-sidebar {
    width: 220px;
    background-color: var(--card);
    padding: 24px;
    border-radius: 16px;
    height: fit-content;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.category-sidebar h3 {
    color: var(--text);
    font-size: 24px;
    margin-top: 0;
    margin-bottom: 22px;
}

.category-sidebar a {
    display: block;
    color: var(--subtext);
    text-decoration: none;
    padding: 14px 16px;
    border-radius: 10px;
    margin-bottom: 8px;
    font-size: 16px;
    font-weight: bold;
}

.category-sidebar a:hover,
.category-sidebar a.active {
    background-color: var(--menu);
    color: #42d8b1 !important;
}

.board-content {
    flex: 1;
    background-color: var(--card);
    border-radius: 16px;
    padding: 32px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 26px;
}

.top h1 {
    margin: 0;
    font-size: 34px;
    color: #42d8b1;
}

.tab {
    display: flex;
    gap: 10px;
    margin-bottom: 18px;
}

.tab a {
    padding: 11px 18px;
    text-decoration: none;
    background-color: var(--menu);
    color: var(--text);
    border-radius: 10px;
    font-weight: bold;
}

.tab a:hover {
    background-color: var(--hover);
    color: #42d8b1;
}

.tab a.active {
    background-color: #4f8cff;
    color: white !important;
}

.tab a.write-btn {
    margin-left: auto;
    background-color: #42d8b1;
    color: white;
}

.search-box {
    display: flex;
    gap: 8px;
    margin-bottom: 18px;
}

.search-box select,
.search-box input,
.search-box button {
    height: 42px;
    border-radius: 8px;
    font-size: 15px;
    box-sizing: border-box;
}

.search-box select {
    width: 130px;
    padding: 0 10px;
    background-color: var(--input);
    color: var(--text);
    border: 1px solid var(--line);
}

.search-box input {
    width: 310px;
    padding: 0 14px;
    background-color: var(--input);
    color: var(--text);
    border: 1px solid var(--line);
}

.search-box input::placeholder {
    color: var(--subtext);
}

.search-box button {
    width: 75px;
    border: none;
    background-color: #42d8b1;
    color: white;
    font-weight: bold;
    cursor: pointer;
}

.category-filter {
    margin: 12px 0 18px 0;
    color: var(--subtext);
    font-size: 14px;
}

.category-filter b {
    color: #42d8b1;
}

.category-link {
    color: #60a5fa;
    text-decoration: none;
    font-weight: bold;
}

.category-link:hover {
    text-decoration: underline;
}

.clear-category {
    margin-left: 10px;
    color: #f87171;
    text-decoration: none;
    font-weight: bold;
}

.board-table {
    width: 100%;
    border-collapse: collapse;
    overflow: hidden;
}

.board-table th {
    padding: 14px 10px;
    color: var(--text);
    border-bottom: 1px solid var(--line);
    font-size: 15px;
}

.board-table td {
    padding: 15px 10px;
    border-bottom: 1px solid var(--line);
    text-align: center;
    color: var(--text);
}

.board-table tr:hover td {
    background-color: var(--hover) !important;
}

.title {
    text-align: left !important;
}

.title a {
    color: var(--text);
    font-weight: bold;
    text-decoration: none;
}

.title a:hover {
    color: #42d8b1;
}

.like-text {
    color: #f87171;
    font-weight: bold;
}

.empty-row {
    color: var(--subtext);
    padding: 30px;
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp"/>

<div class="board-layout">

    <div class="category-sidebar">
        <h3>커뮤니티</h3>

        <a class="<%= category.equals("") ? "active" : "" %>"
           href="<%= request.getContextPath() %>/board/board.jsp?sort=<%= sort %>&searchType=<%= searchType %>&keyword=<%= keyword %>">
            전체
        </a>

        <a class="<%= category.equals("자유") ? "active" : "" %>"
           href="<%= request.getContextPath() %>/board/board.jsp?sort=<%= sort %>&searchType=<%= searchType %>&keyword=<%= keyword %>&category=자유">
            자유
        </a>

        <a class="<%= category.equals("질문") ? "active" : "" %>"
           href="<%= request.getContextPath() %>/board/board.jsp?sort=<%= sort %>&searchType=<%= searchType %>&keyword=<%= keyword %>&category=질문">
            질문
        </a>

        <a class="<%= category.equals("비밀") ? "active" : "" %>"
           href="<%= request.getContextPath() %>/board/board.jsp?sort=<%= sort %>&searchType=<%= searchType %>&keyword=<%= keyword %>&category=비밀">
            비밀
        </a>
    </div>

    <div class="board-content">

        <div class="top">
            <h1>게시판</h1>
        </div>

        <div class="tab">
            <a class="<%= sort.equals("popular") ? "active" : "" %>"
               href="<%= request.getContextPath() %>/board/board.jsp?sort=popular&searchType=<%= searchType %>&keyword=<%= keyword %>&category=<%= category %>">인기</a>

            <a class="<%= sort.equals("latest") ? "active" : "" %>"
               href="<%= request.getContextPath() %>/board/board.jsp?sort=latest&searchType=<%= searchType %>&keyword=<%= keyword %>&category=<%= category %>">최신</a>

            <a class="<%= sort.equals("views") ? "active" : "" %>"
               href="<%= request.getContextPath() %>/board/board.jsp?sort=views&searchType=<%= searchType %>&keyword=<%= keyword %>&category=<%= category %>">조회수</a>

            <a class="write-btn" href="<%= request.getContextPath() %>/board/write.jsp">글쓰기</a>
        </div>

        <form class="search-box" method="get" action="<%= request.getContextPath() %>/board/board.jsp">
            <input type="hidden" name="sort" value="<%= sort %>">
            <input type="hidden" name="category" value="<%= category %>">

            <select name="searchType">
                <option value="titleContent" <%= searchType.equals("titleContent") ? "selected" : "" %>>제목+내용</option>
                <option value="title" <%= searchType.equals("title") ? "selected" : "" %>>제목</option>
                <option value="content" <%= searchType.equals("content") ? "selected" : "" %>>내용</option>
                <option value="writer" <%= searchType.equals("writer") ? "selected" : "" %>>작성자</option>
            </select>

            <input type="text" name="keyword" value="<%= keyword %>" placeholder="검색어를 입력하세요">
            <button type="submit">검색</button>
        </form>

        <% if (!category.trim().equals("")) { %>
        <div class="category-filter">
            현재 카테고리: <b><%= category %></b>
            <a class="clear-category" href="<%= request.getContextPath() %>/board/board.jsp?sort=<%= sort %>&searchType=<%= searchType %>&keyword=<%= keyword %>">
                전체보기
            </a>
        </div>
        <% } %>

        <table class="board-table">
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

boolean hasWhere = false;

if (!keyword.trim().equals("")) {
    if (!hasWhere) {
        sql += "WHERE ";
        hasWhere = true;
    }

    if (searchType.equals("title")) {
        sql += "b.title LIKE ? ";
    } else if (searchType.equals("content")) {
        sql += "b.content LIKE ? ";
    } else if (searchType.equals("writer")) {
        sql += "b.writer LIKE ? ";
    } else {
        sql += "(b.title LIKE ? OR b.content LIKE ?) ";
    }
}

if (!category.trim().equals("")) {
    if (!hasWhere) {
        sql += "WHERE ";
        hasWhere = true;
    } else {
        sql += "AND ";
    }

    sql += "b.category = ? ";
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
    int index = 1;

    if (!keyword.trim().equals("")) {
        String searchKeyword = "%" + keyword + "%";

        if (searchType.equals("titleContent")) {
            ps.setString(index++, searchKeyword);
            ps.setString(index++, searchKeyword);
        } else {
            ps.setString(index++, searchKeyword);
        }
    }

    if (!category.trim().equals("")) {
        ps.setString(index++, category);
    }

    ResultSet rs = ps.executeQuery();

    boolean hasPost = false;

    while (rs.next()) {
        hasPost = true;

        String postCategory = rs.getString("category");
        if (postCategory == null || postCategory.trim().equals("")) {
            postCategory = "자유";
        }
%>

            <tr>
                <td><%= rs.getInt("post_id") %></td>

                <td class="like-text">♥ <%= rs.getInt("like_count") %></td>

                <td>
                    <a class="category-link"
                       href="<%= request.getContextPath() %>/board/board.jsp?sort=<%= sort %>&searchType=<%= searchType %>&keyword=<%= keyword %>&category=<%= postCategory %>">
                        <%= postCategory %>
                    </a>
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

    if (!hasPost) {
%>
            <tr>
                <td class="empty-row" colspan="7">게시글이 없습니다.</td>
            </tr>
<%
    }

} catch (Exception e) {
    e.printStackTrace();
%>
            <tr>
                <td class="empty-row" colspan="7">게시글을 불러오지 못했습니다.</td>
            </tr>
<%
}
%>

        </table>

    </div>
</div>

</body>
</html>
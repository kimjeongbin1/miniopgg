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
body {
    margin: 0;
    font-family: Arial;
}

.board-layout {
    display: flex;
    gap: 30px;
    width: 1200px;
    margin: 30px auto 0 auto;
}

.category-sidebar {
    width: 200px;
    background: #1f2430;
    padding: 20px;
    border-radius: 8px;
    height: fit-content;
}

.category-sidebar h3 {
    color: white;
    margin-top: 0;
    margin-bottom: 20px;
}

.category-sidebar a {
    display: block;
    color: #ddd;
    text-decoration: none;
    padding: 12px;
    border-radius: 6px;
    margin-bottom: 6px;
}

.category-sidebar a:hover {
    background: #2d3440;
}

.category-sidebar a.active {
    background: #2d3440;
    color: #4fffd1 !important;
    font-weight: bold;
}

.board-content {
    flex: 1;
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

.tab a.active {
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

.category-filter {
    margin-bottom: 15px;
    font-size: 14px;
}

.category-link {
    color: #4f8cff;
    text-decoration: none;
    font-weight: bold;
}

.category-link:hover {
    text-decoration: underline;
}

.clear-category {
    margin-left: 10px;
    color: red;
    text-decoration: none;
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

            <a href="<%= request.getContextPath() %>/board/write.jsp">글쓰기</a>
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

            <input type="text" name="keyword" value="<%= keyword %>" placeholder="검색">
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

    while (rs.next()) {
        String postCategory = rs.getString("category");
        if (postCategory == null || postCategory.trim().equals("")) {
            postCategory = "자유";
        }
%>

            <tr>
                <td><%= rs.getInt("post_id") %></td>

                <td>좋아요 <%= rs.getInt("like_count") %></td>

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

    </div>
</div>

</body>
</html>
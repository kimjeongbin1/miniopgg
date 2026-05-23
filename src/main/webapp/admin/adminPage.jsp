<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>

<%
    String role = (String) session.getAttribute("role");

    if (role == null || !"ADMIN".equals(role)) {
        out.println("<script>");
        out.println("alert('관리자만 접근 가능합니다.');");
        out.println("location.href='" + request.getContextPath() + "/main.jsp';");
        out.println("</script>");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>

<style>
    body {
        width: 1100px;
        margin: 40px auto;
        font-family: Arial, sans-serif;
    }

    h1 {
        margin-bottom: 20px;
    }

    h2 {
        margin-top: 40px;
        border-bottom: 2px solid #333;
        padding-bottom: 8px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
    }

    th, td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: center;
    }

    th {
        background-color: #f5f5f5;
    }

    a {
        color: #3366cc;
        text-decoration: none;
    }

    button {
        padding: 6px 12px;
        cursor: pointer;
    }

    .danger {
        background-color: #ff5555;
        color: white;
        border: none;
    }

    .block {
        background-color: #444;
        color: white;
        border: none;
    }
</style>
</head>

<body>

<h1>관리자 페이지</h1>

<a href="<%= request.getContextPath() %>/main.jsp">메인으로</a>
&nbsp;
<a href="<%= request.getContextPath() %>/board/board.jsp">게시판으로</a>

<hr>

<h2>1. 신고 관리</h2>

<table>
    <tr>
        <th>신고번호</th>
        <th>게시글</th>
        <th>신고자</th>
        <th>신고당한 사용자</th>
        <th>사유</th>
        <th>상태</th>
        <th>신고일</th>
        <th>관리</th>
    </tr>

<%
    String reportSql =
        "SELECT r.*, b.title, " +
        "u1.nickname AS reporter_nickname, " +
        "u2.nickname AS reported_nickname " +
        "FROM reports r " +
        "JOIN board b ON r.post_id = b.post_id " +
        "JOIN users u1 ON r.reporter_id = u1.user_id " +
        "JOIN users u2 ON r.reported_user_id = u2.user_id " +
        "ORDER BY r.report_id DESC";

    try (
        Connection conn = DBUtil.getConnection();
        PreparedStatement ps = conn.prepareStatement(reportSql);
        ResultSet rs = ps.executeQuery()
    ) {
        boolean hasReport = false;

        while (rs.next()) {
            hasReport = true;
%>
    <tr>
        <td><%= rs.getInt("report_id") %></td>

        <td>
            <a href="<%= request.getContextPath() %>/board/detail.jsp?post_id=<%= rs.getInt("post_id") %>">
                <%= rs.getString("title") %>
            </a>
        </td>

        <td><%= rs.getString("reporter_nickname") %></td>
        <td><%= rs.getString("reported_nickname") %></td>
        <td><%= rs.getString("reason") %></td>
        <td><%= rs.getString("status") %></td>
        <td><%= rs.getTimestamp("created_at") %></td>

        <td>
            <form action="<%= request.getContextPath() %>/blockUser" method="post" style="display:inline;">
                <input type="hidden" name="user_id" value="<%= rs.getInt("reported_user_id") %>">
                <button type="submit" class="block"
                        onclick="return confirm('이 사용자를 차단하시겠습니까?');">
                    사용자 차단
                </button>
            </form>
        </td>
    </tr>
<%
        }

        if (!hasReport) {
%>
    <tr>
        <td colspan="8">신고 내역이 없습니다.</td>
    </tr>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
%>
    <tr>
        <td colspan="8">신고 목록을 불러오지 못했습니다.</td>
    </tr>
<%
    }
%>
</table>

<h2>2. 게시글 관리</h2>

<table>
    <tr>
        <th>번호</th>
        <th>카테고리</th>
        <th>제목</th>
        <th>작성자</th>
        <th>조회수</th>
        <th>작성일</th>
        <th>관리</th>
    </tr>

<%
    String postSql = "SELECT * FROM board ORDER BY post_id DESC";

    try (
        Connection conn = DBUtil.getConnection();
        PreparedStatement ps = conn.prepareStatement(postSql);
        ResultSet rs = ps.executeQuery()
    ) {
        boolean hasPost = false;

        while (rs.next()) {
            hasPost = true;
%>
    <tr>
        <td><%= rs.getInt("post_id") %></td>
        <td><%= rs.getString("category") %></td>
        <td>
            <a href="<%= request.getContextPath() %>/board/detail.jsp?post_id=<%= rs.getInt("post_id") %>">
                <%= rs.getString("title") %>
            </a>
        </td>
        <td><%= rs.getString("writer") %></td>
        <td><%= rs.getInt("view_count") %></td>
        <td><%= rs.getTimestamp("created_at") %></td>

        <td>
            <form action="<%= request.getContextPath() %>/deletePost" method="post" style="display:inline;">
                <input type="hidden" name="post_id" value="<%= rs.getInt("post_id") %>">
                <button type="submit" class="danger"
                        onclick="return confirm('관리자 권한으로 이 게시글을 삭제하시겠습니까?');">
                    삭제
                </button>
            </form>
        </td>
    </tr>
<%
        }

        if (!hasPost) {
%>
    <tr>
        <td colspan="7">게시글이 없습니다.</td>
    </tr>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
%>
    <tr>
        <td colspan="7">게시글 목록을 불러오지 못했습니다.</td>
    </tr>
<%
    }
%>
</table>

<h2>3. 댓글 관리</h2>

<table>
    <tr>
        <th>댓글번호</th>
        <th>게시글번호</th>
        <th>작성자</th>
        <th>내용</th>
        <th>작성일</th>
        <th>관리</th>
    </tr>

<%
    String commentSql = "SELECT * FROM comments ORDER BY comment_id DESC";

    try (
        Connection conn = DBUtil.getConnection();
        PreparedStatement ps = conn.prepareStatement(commentSql);
        ResultSet rs = ps.executeQuery()
    ) {
        boolean hasComment = false;

        while (rs.next()) {
            hasComment = true;
%>
    <tr>
        <td><%= rs.getInt("comment_id") %></td>
        <td>
            <a href="<%= request.getContextPath() %>/board/detail.jsp?post_id=<%= rs.getInt("post_id") %>">
                <%= rs.getInt("post_id") %>
            </a>
        </td>
        <td><%= rs.getString("writer") %></td>
        <td><%= rs.getString("content") %></td>
        <td><%= rs.getTimestamp("created_at") %></td>

        <td>
            <form action="<%= request.getContextPath() %>/deleteComment" method="post" style="display:inline;">
                <input type="hidden" name="comment_id" value="<%= rs.getInt("comment_id") %>">
                <input type="hidden" name="post_id" value="<%= rs.getInt("post_id") %>">
                <button type="submit" class="danger"
                        onclick="return confirm('관리자 권한으로 이 댓글을 삭제하시겠습니까?');">
                    삭제
                </button>
            </form>
        </td>
    </tr>
<%
        }

        if (!hasComment) {
%>
    <tr>
        <td colspan="6">댓글이 없습니다.</td>
    </tr>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
%>
    <tr>
        <td colspan="6">댓글 목록을 불러오지 못했습니다.</td>
    </tr>
<%
    }
%>
</table>

</body>
</html>
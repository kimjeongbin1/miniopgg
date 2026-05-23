package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import util.DBUtil;

@WebServlet("/deleteComment")
public class DeleteCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        Integer userId = (Integer) session.getAttribute("user_id");
        String role = (String) session.getAttribute("role");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        int commentId = Integer.parseInt(request.getParameter("comment_id"));
        int postId = Integer.parseInt(request.getParameter("post_id"));

        boolean isAdmin = "ADMIN".equals(role);

        String sql;

        if (isAdmin) {
            sql = "DELETE FROM comments WHERE comment_id = ?";
        } else {
            sql = "DELETE FROM comments WHERE comment_id = ? AND user_id = ?";
        }

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, commentId);

            if (!isAdmin) {
                ps.setInt(2, userId);
            }

            ps.executeUpdate();

            if (isAdmin) {
                response.sendRedirect(request.getContextPath() + "/admin/adminPage.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/board/detail.jsp?post_id=" + postId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("댓글 삭제 중 오류 발생");
        }
    }
}
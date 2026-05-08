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

@WebServlet("/updatePost")
public class UpdatePostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Integer loginUserId = (Integer) session.getAttribute("user_id");

        if (loginUserId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        int postId = Integer.parseInt(request.getParameter("post_id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        String sql = "UPDATE board SET title = ?, content = ? WHERE post_id = ? AND user_id = ?";

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setInt(3, postId);
            ps.setInt(4, loginUserId);

            int result = ps.executeUpdate();

            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/board/detail.jsp?post_id=" + postId);
            } else {
                response.getWriter().println("수정 권한이 없거나 게시글이 없습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("수정 중 오류 발생");
        }
    }
}
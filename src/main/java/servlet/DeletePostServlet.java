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

@WebServlet("/deletePost")
public class DeletePostServlet extends HttpServlet {
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

        String sql = "DELETE FROM board WHERE post_id = ? AND user_id = ?";

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, postId);
            ps.setInt(2, loginUserId);

            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/board/board.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("삭제 중 오류 발생");
        }
    }
}

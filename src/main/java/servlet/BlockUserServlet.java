package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import util.DBUtil;

@WebServlet("/blockUser")
public class BlockUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("role") == null
                || !session.getAttribute("role").equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/main.jsp");
            return;
        }

        int userId = Integer.parseInt(request.getParameter("user_id"));

        String sql = "UPDATE users SET is_blocked = 1 WHERE user_id = ?";

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, userId);
            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/admin/reportList.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("차단 처리 중 오류 발생");
        }
    }
}
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

@WebServlet("/editNickname")
public class EditNicknameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        String nickname = request.getParameter("nickname");

        if (nickname == null || nickname.trim().equals("")) {
            response.sendRedirect(request.getContextPath() + "/user/editNickname.jsp");
            return;
        }

        String sql = "UPDATE users SET nickname = ? WHERE user_id = ?";

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, nickname);
            ps.setInt(2, userId);

            ps.executeUpdate();

            session.setAttribute("nickname", nickname);

            response.sendRedirect(request.getContextPath() + "/user/mypage.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/editNickname.jsp");
        }
    }
}
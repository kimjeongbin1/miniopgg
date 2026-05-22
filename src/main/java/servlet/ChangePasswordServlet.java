package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import util.DBUtil;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {
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

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String newPasswordCheck = request.getParameter("newPasswordCheck");

        if (currentPassword == null || newPassword == null || newPasswordCheck == null ||
            currentPassword.trim().equals("") || newPassword.trim().equals("") || newPasswordCheck.trim().equals("")) {

            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp");
            return;
        }

        if (!newPassword.equals(newPasswordCheck)) {
            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp");
            return;
        }

        String selectSql = "SELECT password FROM users WHERE user_id = ?";
        String updateSql = "UPDATE users SET password = ? WHERE user_id = ?";

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement selectPs = conn.prepareStatement(selectSql)
        ) {
            selectPs.setInt(1, userId);

            ResultSet rs = selectPs.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("password");

                if (!currentPassword.equals(dbPassword)) {
                    response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp");
                    return;
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/user/login.jsp");
                return;
            }

            try (
                PreparedStatement updatePs = conn.prepareStatement(updateSql)
            ) {
                updatePs.setString(1, newPassword);
                updatePs.setInt(2, userId);

                updatePs.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/user/mypage.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/changePassword.jsp");
        }
    }
}
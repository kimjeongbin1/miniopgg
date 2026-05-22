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

import util.DBUtil;

@WebServlet("/findPassword")
public class FindPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String loginId = request.getParameter("loginId");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String newPasswordCheck = request.getParameter("newPasswordCheck");

        if (!newPassword.equals(newPasswordCheck)) {
            response.getWriter().println("<script>");
            response.getWriter().println("alert('새 비밀번호가 일치하지 않습니다.');");
            response.getWriter().println("history.back();");
            response.getWriter().println("</script>");
            return;
        }

        String selectSql =
            "SELECT user_id FROM users WHERE login_id = ? AND name = ? AND email = ?";

        String updateSql =
            "UPDATE users SET password = ? WHERE user_id = ?";

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement selectPs = conn.prepareStatement(selectSql)
        ) {
            selectPs.setString(1, loginId);
            selectPs.setString(2, name);
            selectPs.setString(3, email);

            ResultSet rs = selectPs.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("user_id");

                try (
                    PreparedStatement updatePs = conn.prepareStatement(updateSql)
                ) {
                    updatePs.setString(1, newPassword);
                    updatePs.setInt(2, userId);
                    updatePs.executeUpdate();
                }

                response.getWriter().println("<script>");
                response.getWriter().println("alert('비밀번호가 변경되었습니다. 다시 로그인해주세요.');");
                response.getWriter().println("location.href='" + request.getContextPath() + "/user/login.jsp';");
                response.getWriter().println("</script>");

            } else {
                response.getWriter().println("<script>");
                response.getWriter().println("alert('일치하는 회원정보가 없습니다.');");
                response.getWriter().println("history.back();");
                response.getWriter().println("</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();

            response.getWriter().println("<script>");
            response.getWriter().println("alert('비밀번호 찾기 중 오류가 발생했습니다.');");
            response.getWriter().println("history.back();");
            response.getWriter().println("</script>");
        }
    }
}
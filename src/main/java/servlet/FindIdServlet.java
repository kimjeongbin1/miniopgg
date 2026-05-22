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

@WebServlet("/findId")
public class FindIdServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");

        String sql = "SELECT login_id FROM users WHERE name = ? AND email = ?";

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, name);
            ps.setString(2, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String loginId = rs.getString("login_id");

                response.getWriter().println("<script>");
                response.getWriter().println("alert('회원님의 아이디는 " + loginId + " 입니다.');");
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
            response.getWriter().println("alert('아이디 찾기 중 오류가 발생했습니다.');");
            response.getWriter().println("history.back();");
            response.getWriter().println("</script>");
        }
    }
}
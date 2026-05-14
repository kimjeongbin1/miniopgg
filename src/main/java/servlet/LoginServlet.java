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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String loginId = request.getParameter("login_id");
        String password = request.getParameter("password");

        System.out.println("입력 아이디: " + loginId);
        System.out.println("입력 비밀번호: " + password);

        String sql = "SELECT * FROM users WHERE login_id = ? AND password = ?";

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            System.out.println("DB 연결 성공");

            ps.setString(1, loginId);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                System.out.println("로그인 성공");

                HttpSession session = request.getSession();

                session.setAttribute("user_id", rs.getInt("user_id"));
                session.setAttribute("login_id", rs.getString("login_id"));
                session.setAttribute("nickname", rs.getString("nickname"));

                response.sendRedirect(request.getContextPath() + "/main.jsp");

            } else {
                System.out.println("로그인 실패: 일치하는 회원 없음");

                response.getWriter().println("<h2>로그인 실패</h2>");
                response.getWriter().println("<p>아이디 또는 비밀번호가 틀렸습니다.</p>");
                response.getWriter().println("<p>입력 아이디: " + loginId + "</p>");
                response.getWriter().println("<p>입력 비밀번호: " + password + "</p>");
                response.getWriter().println("<a href='" + request.getContextPath() + "/user/login.jsp'>다시 로그인</a>");
            }

        } catch (Exception e) {
            e.printStackTrace();

            response.getWriter().println("<h2>오류 발생</h2>");
            response.getWriter().println("<pre>");
            e.printStackTrace(response.getWriter());
            response.getWriter().println("</pre>");
            response.getWriter().println("<a href='" + request.getContextPath() + "/user/login.jsp'>다시 로그인</a>");
        }
    }
}	
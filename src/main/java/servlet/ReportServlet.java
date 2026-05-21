package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import util.DBUtil;

@WebServlet("/report")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        int reporterId = (Integer) session.getAttribute("user_id");
        int postId = Integer.parseInt(request.getParameter("post_id"));
        int reportedUserId = Integer.parseInt(request.getParameter("reported_user_id"));
        String reason = request.getParameter("reason");

        if (reporterId == reportedUserId) {
            response.getWriter().println("<script>");
            response.getWriter().println("alert('자신의 게시글은 신고할 수 없습니다.');");
            response.getWriter().println("history.back();");
            response.getWriter().println("</script>");
            return;
        }

        String sql = "INSERT INTO reports(post_id, reporter_id, reported_user_id, reason) VALUES (?, ?, ?, ?)";

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, postId);
            ps.setInt(2, reporterId);
            ps.setInt(3, reportedUserId);
            ps.setString(4, reason);

            ps.executeUpdate();

            response.getWriter().println("<script>");
            response.getWriter().println("alert('신고가 접수되었습니다.');");
            response.getWriter().println("location.href='" + request.getContextPath() + "/board/detail.jsp?post_id=" + postId + "';");
            response.getWriter().println("</script>");

        } catch (Exception e) {
            e.printStackTrace();

            response.getWriter().println("<script>");
            response.getWriter().println("alert('신고 처리 중 오류가 발생했습니다.');");
            response.getWriter().println("history.back();");
            response.getWriter().println("</script>");
        }
    }
}
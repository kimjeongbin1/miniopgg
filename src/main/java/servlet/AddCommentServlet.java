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

@WebServlet("/addComment")
public class AddCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        Integer userId = (Integer) session.getAttribute("user_id");
        String nickname = (String) session.getAttribute("nickname");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        int postId = Integer.parseInt(request.getParameter("post_id"));
        String content = request.getParameter("content");

        String sql = "INSERT INTO comments(post_id, user_id, writer, content) VALUES (?, ?, ?, ?)";

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, postId);
            ps.setInt(2, userId);
            ps.setString(3, nickname);
            ps.setString(4, content);

            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/board/detail.jsp?post_id=" + postId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("댓글 등록 중 오류 발생");
        }
    }
}
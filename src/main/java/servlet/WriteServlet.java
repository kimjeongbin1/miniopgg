package servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import util.DBUtil;

@WebServlet("/write")
@MultipartConfig
public class WriteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        Integer userId = (Integer) session.getAttribute("user_id");
        String nickname = (String) session.getAttribute("nickname");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        Integer isBlocked = (Integer) session.getAttribute("is_blocked");

        if (isBlocked != null && isBlocked == 1) {
            response.getWriter().println("<script>");
            response.getWriter().println("alert('차단된 사용자는 글을 작성할 수 없습니다.');");
            response.getWriter().println("history.back();");
            response.getWriter().println("</script>");
            return;
        }

        String category = request.getParameter("category");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        String imagePath = null;

        Part imagePart = request.getPart("image");

        if (imagePart != null && imagePart.getSize() > 0) {
            String originalFileName = imagePart.getSubmittedFileName();

            String fileName = System.currentTimeMillis() + "_" + originalFileName;

            String uploadPath = getServletContext().getRealPath("/uploads");

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            imagePart.write(uploadPath + File.separator + fileName);

            imagePath = "uploads/" + fileName;
        }

        String sql = "INSERT INTO board(title, content, user_id, writer, category, image_path) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setInt(3, userId);
            ps.setString(4, nickname);
            ps.setString(5, category);
            ps.setString(6, imagePath);

            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/board/board.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            response.getWriter().println("<script>");
            response.getWriter().println("alert('글 등록 실패');");
            response.getWriter().println("history.back();");
            response.getWriter().println("</script>");
        }
    }
}
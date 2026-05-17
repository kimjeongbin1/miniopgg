package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import util.DBUtil;

@WebServlet("/like")
public class LikeServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer userId =
                (Integer)session.getAttribute("user_id");

        if(userId==null){

            response.sendRedirect(
            request.getContextPath()
            +"/user/login.jsp");

            return;
        }

        int postId=
        Integer.parseInt(
        request.getParameter("post_id"));

        try(
            Connection conn=
            DBUtil.getConnection();
        ){

            String checkSql=
            "SELECT * FROM likes " +
            "WHERE post_id=? AND user_id=?";

            PreparedStatement checkPs=
            conn.prepareStatement(checkSql);

            checkPs.setInt(1,postId);
            checkPs.setInt(2,userId);

            ResultSet rs=
            checkPs.executeQuery();

            if(rs.next()){

                String deleteSql=
                "DELETE FROM likes " +
                "WHERE post_id=? AND user_id=?";

                PreparedStatement deletePs=
                conn.prepareStatement(deleteSql);

                deletePs.setInt(1,postId);
                deletePs.setInt(2,userId);

                deletePs.executeUpdate();

            }else{

                String insertSql=
                "INSERT INTO likes(post_id,user_id)" +
                "VALUES(?,?)";

                PreparedStatement insertPs=
                conn.prepareStatement(insertSql);

                insertPs.setInt(1,postId);
                insertPs.setInt(2,userId);

                insertPs.executeUpdate();
            }

            response.sendRedirect(
            request.getContextPath()
            +"/board/detail.jsp?post_id="
            +postId);

        }catch(Exception e){

            e.printStackTrace();
        }

    }

}
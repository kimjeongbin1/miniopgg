package servlet;

import java.io.IOException;
import java.util.List;

import dto.MatchDTO;
import dto.ChampionStatsDTO;
import dto.ChampionMasteryDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import service.RiotApiService;

@WebServlet("/record")
public class RecordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RiotApiService riotApiService = new RiotApiService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String riotId = request.getParameter("riotId");

        if (riotId == null || riotId.trim().equals("")) {
            request.setAttribute("error", "Riot ID를 입력해주세요.");
            request.getRequestDispatcher("/record/recordResult.jsp").forward(request, response);
            return;
        }

        if (!riotId.contains("#")) {
            request.setAttribute("error", "Riot ID는 닉네임#태그 형식으로 입력해주세요. 예: Hide on bush#KR1");
            request.getRequestDispatcher("/record/recordResult.jsp").forward(request, response);
            return;
        }

        try {
            String[] parts = riotId.split("#", 2);

            String gameName = parts[0].trim();
            String tagLine = parts[1].trim();

            if (gameName.equals("") || tagLine.equals("")) {
                request.setAttribute("error", "닉네임과 태그를 모두 입력해주세요. 예: Hide on bush#KR1");
                request.getRequestDispatcher("/record/recordResult.jsp").forward(request, response);
                return;
            }

            String[] summonerInfo = riotApiService.getSummonerInfo(gameName, tagLine);

            String puuid = summonerInfo[2];

            List<MatchDTO> matchList =
                    riotApiService.getRecentMatches(puuid, 3);

            List<ChampionStatsDTO> championStatsList =
                    riotApiService.getChampionStats(puuid);

            List<ChampionMasteryDTO> championMasteryList =
                    riotApiService.getChampionMasteries(puuid);

            request.setAttribute("gameName", summonerInfo[0]);
            request.setAttribute("tagLine", summonerInfo[1]);
            request.setAttribute("puuid", summonerInfo[2]);
            request.setAttribute("profileIconId", summonerInfo[3]);
            request.setAttribute("summonerLevel", summonerInfo[4]);
            request.setAttribute("soloRank", summonerInfo[5]);
            request.setAttribute("flexRank", summonerInfo[6]);

            request.setAttribute("matchList", matchList);
            request.setAttribute("championStatsList", championStatsList);
            request.setAttribute("championMasteryList", championMasteryList);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "오류 내용: " + e.getMessage());
        }

        request.getRequestDispatcher("/record/recordResult.jsp").forward(request, response);
    }
}
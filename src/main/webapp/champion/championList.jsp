<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>챔피언 목록</title>
<style>
#championList {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
    justify-content: center;
}

.champion-card {
    width: 120px;
    text-align: center;
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 10px;
    cursor: pointer;
}

.champion-card img {
    width: 80px;
    height: 80px;
}

.champion-name {
    margin-top: 8px;
    font-weight: bold;
}
</style>
</head>
<body>

<jsp:include page="/common/header.jsp" />

<h2 style="text-align:center;">챔피언 목록</h2>

<div id="championList"></div>

<script>
var version = "16.11.1";
var url = "https://ddragon.leagueoflegends.com/cdn/" + version + "/data/ko_KR/champion.json";

fetch(url)
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        var championList = document.getElementById("championList");
        var champions = data.data;

        for (var key in champions) {
            var champion = champions[key];

            championList.innerHTML +=
                '<div class="champion-card" onclick="moveDetail(\'' + champion.id + '\')">' +
                    '<img src="https://ddragon.leagueoflegends.com/cdn/' + version + '/img/champion/' + champion.id + '.png">' +
                    '<div class="champion-name">' + champion.name + '</div>' +
                '</div>';
        }
    })
    .catch(function(error) {
        console.log("챔피언 정보 불러오기 실패:", error);
        document.getElementById("championList").innerHTML =
            "<p style='color:red;'>챔피언 정보를 불러오지 못했습니다.</p>";
    });

function moveDetail(championId) {
    location.href = "championDetail.jsp?champion=" + championId;
}
</script>

</body>
</html>
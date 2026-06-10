<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>챔피언 목록</title>

<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: var(--bg);
    color: var(--text);
}

.page-container {
    width: 1300px;
    margin: 40px auto;
}

.page-title {
    text-align: center;
    color: var(--accent);
    font-size: 42px;
    margin-bottom: 35px;
}

.search-box {
    text-align: center;
    margin-bottom: 35px;
}

.search-box input {
    width: 400px;
    height: 50px;
    border: 1px solid var(--line);
    border-radius: 10px;
    background: var(--input);
    color: var(--text);
    padding: 0 15px;
    font-size: 16px;
    outline: none;
}

.search-box input:focus {
    border: 2px solid var(--accent);
}

.search-box input::placeholder {
    color: var(--subtext);
}

#championList {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
    gap: 20px;
}

.champion-card {
    background-color: var(--card);
    border: 1px solid var(--line);
    border-radius: 14px;
    padding: 15px;
    text-align: center;
    cursor: pointer;
    transition: all 0.2s;
    box-shadow: 0 4px 12px rgba(0,0,0,0.06);
}

.champion-card:hover {
    transform: translateY(-5px);
    background-color: var(--hover);
    border-color: var(--accent);
}

.champion-card img {
    width: 90px;
    height: 90px;
    border-radius: 12px;
}

.champion-name {
    margin-top: 12px;
    font-size: 15px;
    font-weight: bold;
    color: var(--text);
}
</style>
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="page-container">

    <h1 class="page-title">챔피언 목록</h1>

    <div class="search-box">
        <input
            type="text"
            id="championSearch"
            placeholder="챔피언 검색..."
            onkeyup="searchChampion()">
    </div>

    <div id="championList"></div>

</div>

<script>
var version = "16.11.1";
var url = "https://ddragon.leagueoflegends.com/cdn/" + version + "/data/ko_KR/champion.json";

fetch(url)
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        var championList = document.getElementById("championList");
        var champions = Object.values(data.data);

     // 챔피언 이름 기준 가나다순 정렬
     champions.sort(function(a, b) {
         return a.name.localeCompare(b.name, "ko");
     });

     for (var i = 0; i < champions.length; i++) {
         var champion = champions[i];

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
function searchChampion() {

    var keyword =
        document.getElementById("championSearch")
        .value
        .toLowerCase();

    var cards =
        document.getElementsByClassName("champion-card");

    for (var i = 0; i < cards.length; i++) {

        var name =
            cards[i]
            .querySelector(".champion-name")
            .innerText
            .toLowerCase();

        if (name.includes(keyword)) {
            cards[i].style.display = "";
        } else {
            cards[i].style.display = "none";
        }
    }
}
</script>

</body>
</html>
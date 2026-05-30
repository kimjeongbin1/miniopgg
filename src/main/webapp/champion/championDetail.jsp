<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>챔피언 상세</title>

<style>
body {
    font-family: Arial, sans-serif;
    margin: 30px;
}

.champion-box {
    text-align: center;
}

.skill-box {
    margin-top: 30px;
}

.skill {
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 15px;
    margin-bottom: 15px;
    display: flex;
    gap: 15px;
    align-items: flex-start;
}

.skill img {
    width: 60px;
    height: 60px;
}

.skill-name {
    font-weight: bold;
    font-size: 18px;
}

.skill-desc {
    margin-top: 8px;
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp" />

<div class="champion-box">
    <h2 id="championName"></h2>
    <img id="championImage" width="120">
    <h3 id="championTitle"></h3>
    <p id="championLore"></p>
</div>

<h2>스킬 정보</h2>

<div id="skillList" class="skill-box"></div>

<script>
var version = "16.11.1";

var params = new URLSearchParams(location.search);
var championId = params.get("champion");

var url = "https://ddragon.leagueoflegends.com/cdn/"
        + version + "/data/ko_KR/champion/"
        + championId + ".json";

fetch(url)
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        var champion = data.data[championId];

        document.getElementById("championName").innerText = champion.name;
        document.getElementById("championTitle").innerText = champion.title;
        document.getElementById("championLore").innerText = champion.lore;

        document.getElementById("championImage").src =
            "https://ddragon.leagueoflegends.com/cdn/"
            + version + "/img/champion/"
            + champion.id + ".png";

        var skillList = document.getElementById("skillList");

        skillList.innerHTML +=
            '<div class="skill">' +
                '<img src="https://ddragon.leagueoflegends.com/cdn/' + version + '/img/passive/' + champion.passive.image.full + '">' +
                '<div>' +
                    '<div class="skill-name">패시브 - ' + champion.passive.name + '</div>' +
                    '<div class="skill-desc">' + champion.passive.description + '</div>' +
                '</div>' +
            '</div>';

        var keys = ["Q", "W", "E", "R"];

        for (var i = 0; i < champion.spells.length; i++) {
            var spell = champion.spells[i];

            skillList.innerHTML +=
                '<div class="skill">' +
                    '<img src="https://ddragon.leagueoflegends.com/cdn/' + version + '/img/spell/' + spell.image.full + '">' +
                    '<div>' +
                        '<div class="skill-name">' + keys[i] + ' - ' + spell.name + '</div>' +
                        '<div class="skill-desc">' + spell.description + '</div>' +
                    '</div>' +
                '</div>';
        }
    });
</script>

</body>
</html>
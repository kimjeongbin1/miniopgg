<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>챔피언 상세</title>


<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: var(--bg);
    color: var(--text);
}

.page-container {
    width: 1100px;
    margin: 45px auto;
}

.champion-hero {
    background-color: var(--card);
    border: 1px solid var(--line);
    border-radius: 18px;
    padding: 36px;
    display: flex;
    gap: 28px;
    align-items: center;
    margin-bottom: 30px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.champion-image-box img {
    width: 130px;
    height: 130px;
    border-radius: 20px;
}

.champion-info {
    flex: 1;
}

.champion-name {
    color: var(--accent);
    font-size: 42px;
    font-weight: bold;
    margin-bottom: 8px;
}

.champion-title {
    color: var(--subtext);
    font-size: 22px;
    margin-bottom: 18px;
}

.champion-lore {
    color: var(--text);
    line-height: 1.7;
    font-size: 15px;
}

.section-card {
    background-color: var(--card);
    border: 1px solid var(--line);
    border-radius: 18px;
    padding: 32px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

.section-title {
    color: var(--accent);
    font-size: 30px;
    margin: 0 0 24px 0;
}

.skill-box {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.skill {
    background-color: var(--input);
    border: 1px solid var(--line);
    border-radius: 14px;
    padding: 18px;
    display: flex;
    gap: 18px;
    align-items: flex-start;
}

.skill img {
    width: 64px;
    height: 64px;
    border-radius: 12px;
    background-color: var(--menu);
    flex-shrink: 0;
}

.skill-name {
    color: var(--text);
    font-weight: bold;
    font-size: 18px;
    margin-bottom: 8px;
}

.skill-key {
    color: var(--accent);
}

.skill-desc {
    color: var(--subtext);
    line-height: 1.6;
    font-size: 14px;
}

.back-menu {
    margin-top: 24px;
}

.back-btn {
    display: inline-block;
    padding: 12px 18px;
    border-radius: 10px;
    background-color: var(--accent);
    color: white;
    text-decoration: none;
    font-weight: bold;
}

.back-btn:hover {
    opacity: 0.9;
}
</style>
</head>

<body>

<jsp:include page="/common/header.jsp" />

<div class="page-container">

    <div class="champion-hero">
        <div class="champion-image-box">
            <img id="championImage">
        </div>

        <div class="champion-info">
            <div id="championName" class="champion-name"></div>
            <div id="championTitle" class="champion-title"></div>
            <div id="championLore" class="champion-lore"></div>
        </div>
    </div>

    <div class="section-card">
        <h2 class="section-title">스킬 정보</h2>
        <div id="skillList" class="skill-box"></div>
    </div>

    <div class="back-menu">
        <a class="back-btn" href="championList.jsp">챔피언 목록으로</a>
    </div>

</div>

<script>
var version = "16.11.1";

var params = new URLSearchParams(location.search);
var championId = params.get("champion");

var url = "https://ddragon.leagueoflegends.com/cdn/"
        + version + "/data/ko_KR/champion/"
        + championId + ".json";

function cleanDescription(text) {
    return text.replace(/<[^>]*>/g, "");
}

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
                    '<div class="skill-name"><span class="skill-key">패시브</span> - ' + champion.passive.name + '</div>' +
                    '<div class="skill-desc">' + cleanDescription(champion.passive.description) + '</div>' +
                '</div>' +
            '</div>';

        var keys = ["Q", "W", "E", "R"];

        for (var i = 0; i < champion.spells.length; i++) {
            var spell = champion.spells[i];

            skillList.innerHTML +=
                '<div class="skill">' +
                    '<img src="https://ddragon.leagueoflegends.com/cdn/' + version + '/img/spell/' + spell.image.full + '">' +
                    '<div>' +
                        '<div class="skill-name"><span class="skill-key">' + keys[i] + '</span> - ' + spell.name + '</div>' +
                        '<div class="skill-desc">' + cleanDescription(spell.description) + '</div>' +
                    '</div>' +
                '</div>';
        }
    });
</script>

</body>
</html>
const FACTIONS = [
  "Drakes",
  "Knalgan Alliance",
  "Loyalists",
  "Northerners",
  "Rebels",
  "Undead"
];
const main = document.getElementById("container");

function roundToPrecision(x, precision) {
  var y = +x + (precision === undefined ? 0.5 : precision / 2);
  return y - (y % (precision === undefined ? 1 : +precision));
}

function makeFactionElement(faction, data) {
  const container = document.createElement("div");
  const heading = document.createElement("h3");
  const element = document.createElement("canvas");
  heading.innerHTML = faction;
  container.appendChild(heading);
  container.appendChild(element);
  main.appendChild(container);
  element.id = faction;
  const ctx = element.getContext("2d");
  new Chart(ctx, {
    scales: {
      xAxes: [
        {
          display: true,
          ticks: {
            max: 1,
            beginAtZero: true
          }
        }
      ]
    },
    maintainAspectRatio: false,
    responsive: true,
    type: "radar",
    data: data
  });
  console.log(data);
}

function transformData(csv) {
  FACTIONS.forEach(faction => {
    const winData = csv.data.filter(item => item.winner_faction === faction);
    const lossData = csv.data.filter(item => item.loser_faction === faction);
    const totalWins = winData.length;
    const totalLosses = lossData.length;
   const otherFactions = FACTIONS.filter(other => other !== faction);
console.log(otherFactions)
    const wins = [];
    const losses = [];

    const labels = otherFactions.map(other => {
      const numWins = winData.filter(item => item.loser_faction === other)
        .length;
      const numLosses = lossData.filter(item => item.winner_faction === other)
        .length;
	console.log(other + " " + numWins + " " + numLosses);
      const total = numWins + numLosses;
      wins.push(roundToPrecision(numWins / total, 0.001));
      losses.push(roundToPrecision(numLosses / total, 0.001));
      return other + ` (${numWins} Wins / ${numLosses} Losses)`;
    });
    const data = {
      labels: labels
    };

    data.datasets = [
      {
        label: "Win Probability",
        backgroundColor: "rgba(132, 99, 255, 0.3)",
        borderColor: "rgb(132, 99, 255)",
        data: wins
      },
      {
        label: "Loss Probability",
        backgroundColor: "rgba(255, 99, 132, 0.3)",
        borderColor: "rgb(255, 99, 132)",
        data: losses
      }
    ];

    makeFactionElement(
      faction +
        `<br> ${roundToPrecision(
          totalWins / (totalWins + totalLosses),
          0.001
        )}`,
      data
    );
  });
}

const csv = Papa.parse("/data/games.csv", {
  download: true,
  header: true,
  complete(results) {
    transformData(results);
  }
});

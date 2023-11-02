document.getElementById("fetchData").addEventListener("click", renderChart);

function fetchData() {
    // Replace this URL with the actual API endpoint that returns your data
    fetch("https://your-api-endpoint.com/data")
        .then((response) => response.json())
        .then((data) => {
            renderChart(data);
        })
        .catch((error) => console.error("Error fetching data: ", error));
}

function renderChart() {
    data = [{
        "label": "Category 1",
        "value": 10
      },
      {
        "label": "Category 2",
        "value": 20
      },
      {
        "label": "Category 3",
        "value": 15
      },
      {
        "label": "Category 4",
        "value": 30
      }];
    const labels = data.map((item) => item.label);
    const values = data.map((item) => item.value);

    const ctx = document.getElementById("myChart").getContext("2d");
    new Chart(ctx, {
        type: "bar",
        data: {
            labels: labels,
            datasets: [
                {
                    label: "Bar Chart",
                    data: values,
                    backgroundColor: "rgba(75, 192, 192, 0.2)",
                    borderColor: "rgba(75, 192, 192, 1)",
                    borderWidth: 1,
                },
            ],
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                },
            },
        },
    });
}
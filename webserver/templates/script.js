document.getElementById("fetchData").addEventListener("click", fetchData); 

function fetchData() {
    fetch("/chart")
        .then((response) => response.json())
        .then((data) => {
            renderChart(data.chart_data);
        })
        .catch((error) => console.error("Error fetching data: ", error));
}

function renderChart(data) { // Add the 'data' parameter
    const fraudData = data.fraud_percentage;
    const successData = data.success_percentage;
    const avgTransactionsData = data.average_transactions;
    const merchantNames = fraudData.map((item) => item[0]);

    const ctx = document.getElementById('myChart').getContext('2d');

    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: merchantNames,
            datasets: [
                {
                    label: 'Fraud Percentage',
                    data: fraudData.map((item) => item[1]),
                    backgroundColor: 'rgba(255, 99, 132, 0.5)',
                },
                {
                    label: 'Success Percentage',
                    data: successData.map((item) => item[1]),
                    backgroundColor: 'rgba(75, 192, 192, 0.5)',
                },
                {
                    label: 'Average Transactions',
                    data: avgTransactionsData.map((item) => item[1]),
                    backgroundColor: 'rgba(255, 206, 86, 0.5)',
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

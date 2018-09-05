const express = require('express');
const bodyParser = require('body-parser');
const pgp = require('pg-promise')();
const db = pgp('postgres://root:route@localhost:5432/local_ber')
const app = express();
const port = 8080;
const DATA_LENGTH = 10;
const chartTypes = ['bar', 'line', 'pie'];

const randomColor = (opacity) => {
    return `rgba(${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, ${opacity || Math.random()})`;
};
const generateExampleChart = (chartType) => {
    switch (chartType) {
        case 'bar':
            return {
                type: 'bar',
                data: {
                    labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
                    datasets: [{
                        label: '# of Votes',
                        data: [
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1)
                        ],
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.5)',
                            'rgba(54, 162, 235, 0.5)',
                            'rgba(255, 206, 86, 0.5)',
                            'rgba(75, 192, 192, 0.5)',
                            'rgba(153, 102, 255, 0.5)',
                            'rgba(255, 159, 64, 0.5)'
                        ],
                        borderColor: [
                            'rgba(255,99,132,1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 159, 64, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true,
                                suggestedMax: 30
                            }
                        }]
                    }
                }
            };
        case 'line':
            return {
                type: 'line',
                data: {
                    xAxisID: 'Absisses',
                    yAxisID: 'Ordonnees',
                    fill: true,
                    labels: ["Blue", "Red"],
                    datasets: [{
                        label: '# of Votes',
                        data: [
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1)
                        ],
                        borderColor: [
                            randomColor(1),
                            randomColor(1)
                        ],
                        backgroundColor: [
                            randomColor(0.5),
                            randomColor(0.5)
                        ],
                        borderWidth: 1
                    },{
                        label: '# of people alive',
                        data: [
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1)
                        ],
                        borderColor: [
                            randomColor(1),
                            randomColor(1)
                        ],
                        backgroundColor: [
                            randomColor(0.5),
                            randomColor(0.5)
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true,
                                suggestedMax: 30
                            }
                        }]
                    }
                }
            };
        case 'pie':
            return {
                type: 'pie',
                data: {
                    datasets: [{
                        data: [
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1),
                            Math.floor(Math.random() * 30 + 1)
                        ],
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.3)',
                            'rgba(54, 162, 235, 0.3)',
                            'rgba(255, 206, 86, 0.3)'
                        ],
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.85)',
                            'rgba(54, 162, 235, 0.85)',
                            'rgba(255, 206, 86, 0.85)'
                        ],
                        borderColor: [
                            'rgba(255,99,132,1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)'
                        ],
                        borderWidth: 1
                    }],

                    // These labels appear in the legend and in the tooltips when hovering different arcs
                    labels: [
                        'Red',
                        'Yellow',
                        'Blue',
                    ]
                },
                options: {
                    cutoutPercentage: 0,
                    circumference: 2 * Math.PI,
                    rotation: - 0.5 * Math.PI
                }
            };
        default:
            return generateExampleChart('bar');
    }
};

const getCharts = () => {
    const charts = [];
    for (let index = 0; index < 9; index++) {
        charts.push(generateExampleChart(chartTypes[index % chartTypes.length]));
    }
    return charts;
};

const executePGFunction = (functionName) => {
    return new Promise((resolve, reject) => {
        db.func(functionName)
        .then((data) => {
            pgp.end();
            resolve(data[0][functionName]);
        })
        .catch((error) => {
            console.log(functionName);
            console.log(error);
            reject(error);
            pgp.end();
        });
    })
}

app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});
app.use(bodyParser.urlencoded({ extended: true, limit: '50mb' }));
app.use(bodyParser.json({ limit: '50mb' }));       // to support JSON-encoded bodies
app.get('/', (req, res) => {
    executePGFunction('chr_get_charts').then((data) => {
        res.json(data);
    }).catch(console.log)
});
app.listen(port, () => console.log(`App listening on port ${port}!`));
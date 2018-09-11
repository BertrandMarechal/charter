import ReactDOM from 'react-dom';
import React, { Component } from 'react';
import './App.css';
import axios from 'axios';
import * as Chart from 'chart.js';


class App extends Component {
  localCharts;
  render() {
  
    axios.get('http://localhost:8080/')
    .then((response) => {
      console.log(response);
      
      // handle success
      const elements = response.data.map((x, i) => 'canvas' + i).map((x, index) => (<canvas id={x} key={x} style={{'maxWidth': '400px', heigh: '400px'}}></canvas>))
      ReactDOM.render(elements, document.getElementById('chart-displayer'));
      setTimeout(() => {
        this.localCharts = response.data.map((x, index) => new Chart(`canvas${index}`, response.data[index]));
      }, 10);
    })
    .catch(function (error) {
      // handle error
      console.log(error);
    })
    .then(function () {
      // always executed
    });

    return (
      <div id="chart-displayer">
      </div>
    );
  }

  updateData() {
    setTimeout(() => {
      axios.get('http://localhost:8080/')
      .then((response) => {
        this.localCharts.forEach((chart, index) => {
          chart.data.datasets[0].data = response.data[index].data.datasets[0].data;
          chart.update();
        })
      })
      .catch(function (error) {
        // handle error
        console.log(error);
      })
      .then(function () {
        // always executed
      });
    }, 1000);
  }
}

export default App;

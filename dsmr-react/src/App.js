import React, { Component } from "react";
import _ from "underscore";
import Moment from "moment";
import { TimeSeries, Index } from "pondjs";
import {
  Charts,
  ChartContainer,
  ChartRow,
  YAxis,
  LineChart,
  BarChart,
  styler,
  Resizable,
  Legend
} from "react-timeseries-charts";
import { format } from "d3-format";

import "./App.css";

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      points1: null,
      points2: null,
      points3: null,
      loading: true
    };
  }

  componentDidMount() {
    this.getReadings();
  }

  getReadings() {
    fetch("/api/v1/readings/last/")
      .then(response => response.json())
      .then(readingsjson => {
        const e1Points = [];
        const e2Points = [];
        const e3Points = [];
        let l1 = 0;
        let l2 = 0;
        let f1 = 0;
        _.each(readingsjson.data, readings => {
          const d = new Moment(readings.timestamp).toDate();
          const time = d.getTime();
          const e1 =
            readings.electricity_delivered_1 + readings.electricity_delivered_2;
          const e2 =
            readings.electricity_returned_1 + readings.electricity_returned_2;
          const index = Index.getIndexString("4h", d);
          if (e1Points.length) {
            const d1 = e1 - l1;
            const d2 = e2 - l2;
            e3Points.push([index, d1, d2]);
          } else {
            f1 = e1;
          }
          l1 = e1;
          l2 = e2;
          e1Points.push([time, e1]);
          e2Points.push([time, e2]);
        });
        //e1Points.sort(function(a,b) {return a[0]-b[0];});
        this.setState({
          points1: e1Points,
          points2: e2Points,
          points3: e3Points,
          loading: false
        });
      });
  }

  handleTrackerChanged = tracker => {
    if (!tracker) {
      this.setState({ tracker, x: null, y: null });
    } else {
      this.setState({ tracker });
    }
  };
  render() {
    const { loading, points1, points2, points3 } = this.state;
    if (loading) return <div>Loading</div>;
    if (points1.length === 0) return <div>Invalid data</div>;
    const series1 = new TimeSeries({
      name: "Electricity",
      columns: ["time", "in"],
      points: points1
    });
    const series2 = new TimeSeries({
      name: "Electricity",
      columns: ["time", "out"],
      points: points2
    });

    const series3 = new TimeSeries({
      name: "Electricity",
      columns: ["index", "in", "out"],
      points: points3
    });
    const trafficStyle = styler([
      { key: "in", color: "blue" },
      { key: "out", color: "orange" }
    ]);
    const f = format(",.2f");

    let inValue = "-",
      outValue = "-";
    if (this.state.tracker) {
      const index1 = series1.bisect(this.state.tracker);
      const trackerEvent1 = series1.at(index1);
      const index2 = series2.bisect(this.state.tracker);
      const trackerEvent2 = series2.at(index2);
      inValue = `${f(trackerEvent1.get("in"))}`;
      outValue = `${f(trackerEvent2.get("out"))}`;
    }
    const legendCategories = [
      { key: "in", label: "incoming", value: inValue },
      { key: "out", label: "outgoing", value: outValue }
    ];

    return (
      <div className="App">
        <Legend
          categories={legendCategories}
          align="left"
          style={trafficStyle}
          type="swatch"
        />
        <Resizable>
          <ChartContainer
            timeRange={series1.timerange()}
            format="day"
            onTrackerChanged={this.handleTrackerChanged}
          >
            <ChartRow height="150">
              <YAxis
                id="axis1"
                label="Electricity kWh"
                width="60"
                format=".2f"
                min={series1.min("in")}
                max={series1.max("in")}
              />
              <Charts>
                <LineChart
                  axis="axis1"
                  style={trafficStyle}
                  series={series1}
                  columns={["in"]}
                  highlight={this.state.highlight}
                  onHighlightChange={highlight => this.setState({ highlight })}
                />
                <LineChart
                  axis="axis2"
                  style={trafficStyle}
                  series={series2}
                  columns={["out"]}
                />
              </Charts>
              <YAxis
                id="axis2"
                label="Electricity kWh"
                width="60"
                format=".2f"
                min={series2.min("out")}
                max={series2.max("out")}
              />
            </ChartRow>
          </ChartContainer>
        </Resizable>
        <br />
        <Resizable>
          <ChartContainer timeRange={series3.timerange()} format="day">
            <ChartRow height="150">
              <YAxis
                id="axis3"
                label="Electricity kWh"
                width="60"
                format=".2f"
                min={0}
                max={series3.max("out")}
                type="linear"
              />
              <Charts>
                <BarChart
                  axis="axis3"
                  size={10}
                  offset={5.5}
                  columns={["in"]}
                  series={series3}
                  style={trafficStyle}
                />
                <BarChart
                  axis="axis3"
                  size={10}
                  offset={-5.5}
                  columns={["out"]}
                  series={series3}
                  style={trafficStyle}
                />
              </Charts>
              <YAxis
                id="axis3"
                label="Electricity kWh"
                width="60"
                format=".2f"
                min={0}
                max={series3.max("out")}
                type="linear"
              />
            </ChartRow>
          </ChartContainer>
        </Resizable>
      </div>
    );
  }
}

export default App;

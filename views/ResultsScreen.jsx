import React, { Component } from 'react';

export default class ResultsScreen extends Component {
  constructor(props) {
    super(props);
    this.handleNewSearch = this.handleNewSearch.bind(this);
  }

  handleNewSearch(e) {
    e.preventDefault();
    window.__runDuiCallback(JSON.stringify({
      tag: "MakeNewSearch",
      contents: undefined
    }));
  }

  render() {
    let { podcasts } = this.props;
    return (
      <div>
        <button onClick={this.handleNewSearch}> Back </button>
      </div>
    );
  }
}

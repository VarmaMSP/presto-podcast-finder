import React, { Component } from 'react';

export default class SearchScreen extends Component {
  constructor(props) {
    super(props);
    this.state = {searchTerm : ''}
    this.handleSearchTermChange = this.handleSearchTermChange.bind(this);
    this.handleSearchTermSubmit = this.handleSearchTermSubmit.bind(this);
  }

  handleSearchTermChange(e) {
    this.setState({
      searchTerm: e.target.value
    });
  }

  handleSearchTermSubmit(e) {
    e.preventDefault();

    let { searchTerm } = this.state;
    if (searchTerm.length > 0) {
      window.__runDuiCallback(JSON.stringify({
        tag: "SearchTermEntered",
        contents: this.state.searchTerm
      }));
    }
  }

  render() {
    let { searchTerm } = this.state;

    return (
      <div>
        <input type="text"
          onChange={this.handleSearchTermChange}
        />
        <br/>
        <button onClick={this.handleSearchTermSubmit}>SUBMIT</button>
      </div>
    );
  }
}

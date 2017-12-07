import React, { Component } from 'react';

import { Input, Button, Header } from 'semantic-ui-react'

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
      <div style={containerStyle}>
        <div style={titleStyle}>
          <Header size="huge">Podcast Finder</Header>
        </div>
        <div style={inputStyle}>
          <Input type='text' size='big' fluid
            placeholder='Search for podcasts ... '
            onChange={this.handleSearchTermChange}
          />
        </div>
        <br/>
        <div style={buttonStyle}>
          <Button fluid onClick={this.handleSearchTermSubmit}>SEARCH</Button>
        </div>
      </div>
    );
  }
}

const containerStyle = { marginTop: "10rem"};
const titleStyle     = { textAlign: "center"
                       , fontSize: "2.5rem"
                       , marginBottom: "0.5rem"
                       }
const inputStyle     = { width: "50%"
                       , marginLeft: "auto"
                       , marginRight: "auto"
                       , textAlign: "center"
                       };
const buttonStyle    = { width: "40%"
                       , marginLeft: "auto"
                       , marginRight: "auto"
                       };

import React, { Component } from 'react';

import { Card, Image, Icon, Header, Divider } from 'semantic-ui-react';

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

  componentDidMount() {
    window.__runDuiCallback(JSON.stringify({
      tag: "ResultsDisplayed",
      contents: undefined
    }));
  }

  render() {
    let { podcasts } = this.props;
    let renderedPodcasts = podcasts.map((podcast, i) => (
      <Card key={i} href={podcast.link}>
        <Image size='large' src={podcast.imageSrc}/>
        <Card.Content>{podcast.title}</Card.Content>
      </Card>
    ))

    return (
      <div style={containerStyle}>
        <div style={headerStyle}>
          <div style={iconStyle}>
            <Icon name="arrow left" size="large"
              onClick={this.handleNewSearch}
            />
          </div>
          <Header as='h3'>  Search Results</Header>
        </div>
        <Divider/>
        <Card.Group itemsPerRow={7}>
          {renderedPodcasts}
        </Card.Group>
      </div>
    );
  }
}

const containerStyle = {padding: "0.4rem"};
const headerStyle = { marginBottom: "1rem"
                    , marginTop: "0.5rem"
                    };
const iconStyle = { float: "left"
                  , marginRight: "0.4rem"
                  }

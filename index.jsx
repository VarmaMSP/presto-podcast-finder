const purescriptObj = require('./output/Main/index.js');

import React from 'react'
import ReactDOM from 'react-dom';

import SearchScreen from './views/SearchScreen';
import ResultsScreen from './views/ResultsScreen';

//component rendering flow
//   1) Presto calls window.__duiShowScreen with a callback and {screen : screen_name, contents: data}
//   2) callback is assigned to window.__duiCb, this allows rendered screen to send back data (JSON) to presto
//   3) finally screen_name is used to render appropriate screen from set of screens
window.__duiShowScreen = (callback, { screen, contents }) => {
	let screens =
      { "SearchScreen": <SearchScreen/>
      , "ResultsScreen": <ResultsScreen podcasts={contents}/>
      }
	window.__setCallback(callback)

	window.history.pushState({x : '2'}, 'results');
	try {
		ReactDOM.render(
      screens[screen],
      document.getElementById('app')
    );
	} catch(e) {
		console.log(e)
	}

}

// A utitlity function to allow a component to call the window.__duiCb
// this function should receive JSON encoded data of form
//      { tag      :: string representing a Action
//      , contents :: data
//      }
// corresponding to a data constructor of the ScreenAction
const runDuiCallback = state => {
  let callback = window.__duiCb;

  if (typeof callback == "function")
    callback(state)();
};

//utility functions
const setCallback = callback => {
  window.__duiCb = callback;
};

const purescriptInit = purescriptObj_ => {
  window.__duiCb          = null;
  window.__runDuiCallback = runDuiCallback;
  window.__setCallback    = setCallback
  window.__changePureScriptFlow = purescriptObj_.launchApp;
  (purescriptObj_.launchApp)();
};

purescriptInit(purescriptObj);

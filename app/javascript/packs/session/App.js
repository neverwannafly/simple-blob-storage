import React from 'react';
import { Provider } from 'react-redux';
import { TerminalContextProvider } from "react-terminal";

import store from './store/index';
import Session from './Session';

function App() {
  return (
    <Provider store={store}>
      <TerminalContextProvider>
        <Session />
      </TerminalContextProvider>
    </Provider>
  )
}

export default App;

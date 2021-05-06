import { applyMiddleware, combineReducers, createStore } from 'redux';
import thunk from 'redux-thunk';
import { composeWithDevTools } from 'redux-devtools-extension';

import session from './session';

const reducers = combineReducers({
  session,
});

const middlewares = composeWithDevTools(applyMiddleware(thunk));
const store = createStore(reducers, middlewares);

export default store;

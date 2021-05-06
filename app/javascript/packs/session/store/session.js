import { apiRequest } from '../../utils';

const initialState = {
  data: {},
  isLoading: false,
  error: null,
};

const SESSION_INIT = 'SESSION_INIT';
const SESSION_LOADED = 'SESSION_LOADED';
const SESSION_ERROR = 'SESSION_ERROR';

export function loadSession(forceServer = false) {
  return async (dispatch, getState) => {
    const { data } = getState().session;
    console.log(data);
    if (!Object.keys(data).length || forceServer) {
      dispatch({ type: SESSION_INIT });
      await new Promise((resolve) => setTimeout(() => resolve(), 2000));
      try {
        const response = await apiRequest('GET', '/session-data');
        dispatch({ type: SESSION_LOADED, payload: response });
      } catch (error) {
        dispatch({ type: SESSION_ERROR, payload: error });
      }
    }
  };
}

export default function reducer(state = initialState, action) {
  switch (action.type) {
    case SESSION_INIT: return {
      ...state,
      isLoading: true,
      error: null,
    };
    case SESSION_LOADED: return {
      ...state,
      data: action.payload,
      isLoading: false,
    };
    case SESSION_ERROR: return {
      ...state,
      isLoading: false,
      error: action.payload,
    };
    default:
      return state;
  }
}

import { AccountInfo, AuthenticationResult, AuthError } from '@azure/msal-browser';

export const UPDATE_ACCOUNT = 'UPDATE_ACCOUNT';
export const UPDATE_ERROR = 'UPDATE_ERROR';
export const UPDATE_TOKEN = 'UPDATE_TOKEN';

export interface UpdateAccountAction {
  type: typeof UPDATE_ACCOUNT;
  payload: AccountInfo | null;
}

export interface UpdateErrorAction {
  type: typeof UPDATE_ERROR;
  payload: AuthError;
}

export interface UpdateToken {
  type: typeof UPDATE_TOKEN;
  payload: AuthenticationResult;
}

export interface AuthState {
  account: AccountInfo | null;
  error: AuthError | null;
  idToken: Record<string, never> | null;
  accessToken: string | null;
  isAuthenticated: boolean;
}

export type AuthActionTypes = UpdateAccountAction | UpdateErrorAction | UpdateToken;

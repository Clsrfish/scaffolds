import React from 'react';
import styles from './index.less';

// eslint-disable-next-line react/prefer-stateless-function
export default class LoadingView extends React.Component {
  render() {
    return (<div className={styles['loading-container']}>Loading...</div>);
  }
}
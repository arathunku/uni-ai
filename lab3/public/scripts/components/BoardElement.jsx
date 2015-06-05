import React from 'react';


export default
class BoardElement extends React.Component {

  onClickHandler() {
    // Do nothing if it had been already pressed
    if(this.props.element.value == 2 || this.props.element.value == 2) {
      return;
    }

    this.props.onClick(this.props.element);
  }

  getClassUsability() {
    if(!this.props.element.value) {
      return 'selectable';
    } else if( this.props.element.value === 1) {
      return 'user';
    } else if(this.props.element.value === 2) {
      return 'computer';
    }
  }

  logValue() {
    if (this.props.logs) {
      return this.props.element.row + '-' + this.props.element.column + ' - ' + this.props.element.index
    }
  }

  render() {
    return <div className={'board-element ' + this.getClassUsability() } onClick={this.onClickHandler.bind(this)}>
    { this.logValue() }
    </div>;
  }
}

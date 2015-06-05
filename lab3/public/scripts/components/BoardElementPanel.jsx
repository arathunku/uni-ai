import React from 'react';

export default
class BoardElementPanel extends React.Component {
  constructor(props) {
    super(props);
    this.state = { alphaBeta: false, logs: window.LOGS }
  }

  onCheckboxAlphaBeta() {
    this.setState({
      alphaBeta: !this.state.alphaBeta
    })
  }

  onCheckboxLogs() {
    window.LOGS = !window.LOGS;
    this.setState({logs: window.LOGS})
  }

  render() {
    return <div className='board-element-panel'>
      <fieldset>
        <label for='alphabeta'>Alpha Beta</label>
        <input
          type='checkbox'
          onClick={ this.onCheckboxAlphaBeta.bind(this) }
          checked={this.state.alphaBeta}
          name='alphaBeta'/>
      </fieldset>
      <fieldset>
        <label for='logs'>Logs</label>
        <input
          type='checkbox'
          name='logs'
          onClick={ this.onCheckboxLogs.bind(this) }
          checked={ this.state.logs }
        />
      </fieldset>
      <input type='button' value='Restart' onClick={this.props.onRestart}/>
      <input type='button' value='Move Computer' onClick={this.props.onMoveComputer}/>
      <span>Current move: { this.props.currentMove === 1 ? 'Human': 'Computer'}</span>
    </div>
  }
}

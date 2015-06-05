import React from 'react';
import BoardElement from './BoardElement'
import BoardElementPanel from './BoardElementPanel'
import { lodash } from 'lodash'
import { getLastAvailableInColumn, clickElement, checkWin } from '../services/ConnectFourHelpers'
import { getComputerMove } from '../services/ConnectFourComputer'
const SIZE_X = 7;
const SIZE_Y = 6;

const defaultBoard = {
  elements: [],
  sizeX: SIZE_X,
  sizeY: SIZE_Y
};

export default class Board extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      board: _.cloneDeep(defaultBoard),
      currentMove: 1 //human
    };
  }

  componentDidMount() {
    this.initializeElements()
  }

  initializeElements() {
    let board = _.cloneDeep(defaultBoard);

    let index = 0;
    for(let i = 0; i < SIZE_Y; i += 1)
      for(let j = 0; j < SIZE_X; j += 1, index += 1)
        board.elements.push({
          value: 0,
          index: index,
          row: i,
          column: j
        })

    this.setState({
      board: board
    })
  }

  moveComputer() {
    this.onElementClickHandler(
      getComputerMove(this.state.board.elements, this.refs.panel.state.alphaBeta), 2
    );
  }

  onElementClickHandler(element, value) {
    let board = this.state.board;
    if(!value) {
      value = 1;
    }

    let result = clickElement(board.elements, element.column, value);
    board.elements = result.elements;

    this.setState({
      board: board,
      currentMove: value === 1 ? 2 : 1
    });

    setTimeout(() => {
      if(result.addedElement && checkWin(board.elements, result.addedElement.row, result.addedElement.column, value)) {
        alert('And the winner is...: ' + (value === 2 ? 'Computer' : 'Human'));
      } else if(result.addedElement && value == 1) { // Player moved
        this.onElementClickHandler(
          getComputerMove(this.state.board.elements, this.refs.panel.state.alphaBeta), 2
        );
      }
    })
  }

  renderBoardElements() {
    var rows = [];
    var currentRow = [];
    this.state.board.elements.forEach((element) => {
      currentRow.push(
        <BoardElement
          logs={LOGS}
          element={element}
          key={element.index}
          onClick={this.onElementClickHandler.bind(this)}/>
      );

      if(currentRow.length == SIZE_X) {
        rows.push(<div className='board-elements-row'>{currentRow}</div>);
        currentRow = [];
      }
    });

    return rows;
  }

  render() {
    return (<div className='board'>
      <BoardElementPanel
        ref='panel'
        onRestart={this.initializeElements.bind(this)}
        onMoveComputer={this.moveComputer.bind(this)}
        currentMove={this.state.currentMove}/>

      <div className='board-elements'>
        { this.renderBoardElements() }
      </div>
    </div>);
  }
}

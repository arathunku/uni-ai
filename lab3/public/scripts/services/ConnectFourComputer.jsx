import { getLastAvailableInColumn, clickElement, checkWin, availableMoves, score, printElements } from '../services/ConnectFourHelpers'
import { lodash } from 'lodash'
import { log } from './Log'
import MinMaxAlphaBeta from './MinMaxAlphaBeta'
import MinMax from './MinMax'

export function getComputerMove(elements, alphaBeta, depth) {
  let startTime = window.performance.now();
  let stats = {
    minimaxCount: 0,
    executionTime: -1
  };

  let element = null;

  if (alphaBeta) {
    element = MinMaxAlphaBeta(elements, null, 0, 1, 0, -Infinity, Infinity, false, stats).element
  } else {
    element = minimax(elements, stats)
  }

  stats.executionTime = window.performance.now() - startTime;
  log(stats);
  return element;
}

function minimax(elements, stats) {
  const moves = availableMoves(elements).map(function (e) {
    const result = clickElement(elements, e.column, 2);
    const elementScore = MinMax(result.elements, 0, 1, score(result.elements, result.addedElement, 2, 0).score, false, stats);

    return {
      element: e,
      score: elementScore
    }
  });

  const max = _.max(moves, 'score');

  log(moves.map((e) => {
    return e.score
  }));
  if (max !== Infinity){
    return max.element;
  } else {
    return moves[0].element;
  }
}



import { clickElement, availableMoves, score, printElements } from '../services/ConnectFourHelpers'
import { lodash } from 'lodash'
import { log } from './Log'

export default function MinMaxAlphaBeta(elements, nextMove, depth, turn, boardScore, alpha, beta, win, stats) {
  const moves = availableMoves(elements);
  stats.minimaxCount += 1;
  if (moves.length === 0 || win || depth >= 4) {
    if(depth >= 4) {
      //printElements(elements);
      log('' +
      ' depth: ' + depth +
      ' turn: ' + turn +
      ' boardScore: ' + boardScore +
      ' alpha: ' + alpha +
      ' beta: ' + beta);
    }
    return {score: boardScore, element: nextMove};
  }

  if (turn === 1) { //minimizing player
    let v = Infinity;
    for (let i = 0; i < moves.length; i += 1) {
      let e = moves[i];
      const result = clickElement(elements, e.column, turn);
      const winnerScore = score(result.elements, result.addedElement, turn, depth);

      const m = MinMaxAlphaBeta(
        result.elements,
        e,
        depth + 1,
        turn === 2 ? 1 : 2,
        boardScore + winnerScore.score,
        alpha,
        beta,
        winnerScore.win,
        stats).score;

      if (m < v) {
        v = m;
        nextMove = e;
      }
      if (v < beta) {
        beta = v;
      }
    }
    return {score: v, element: nextMove};
  } else { // maximizing computer
    let v = -Infinity;
    for (let i = 0; i < moves.length; i += 1) {
      let e = moves[i];
      const result = clickElement(elements, e.column, turn);
      const winnerScore = score(result.elements, result.addedElement, turn, depth);

      const m = MinMaxAlphaBeta(
        result.elements,
        e,
        depth + 1,
        turn === 2 ? 1 : 2,
        boardScore + winnerScore.score,
        alpha,
        beta,
        winnerScore.win,
        stats).score;

      if (m > v) {
        v = m;
        nextMove = e;
      }
      if (v > alpha) {
        alpha = v;
      }
    }
    return {score: v, element: nextMove};
  }
}

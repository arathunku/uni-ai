import { clickElement, availableMoves, score, printElements } from '../services/ConnectFourHelpers'
import { lodash } from 'lodash'
import { log } from './Log'

export default function MinMax(elements, depth, turn, boardScore, finish, stats) {
  const moves = availableMoves(elements);
  //printElements(elements);
  stats.minimaxCount += 1;

  if (moves.length === 0 || finish || depth >= 3) {
    return boardScore;
  }
  const scores = moves.map(function (e) {
    const result =  clickElement(elements, e.column, turn);
    const winnerScore = score(result.elements, result.addedElement, turn, depth);

    return MinMax(result.elements, depth + 1, turn === 2 ? 1 : 2, boardScore + winnerScore.score, winnerScore.win, stats)
  });

  //log(scores);
  if (turn === 2) {
    return _.max(scores); // Select max for computer
  } else {
    return _.min(scores); // select minimum for the player
  }
}

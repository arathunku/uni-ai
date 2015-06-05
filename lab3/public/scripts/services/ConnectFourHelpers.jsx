import { lodash } from 'lodash'
import { log } from './Log'

export function getLastAvailableInColumn(elements, column) {
  return _.last(elements.filter(function(e) {
    return e.column == column && e.value == 0
  }));
}

export function clickElement(elements, column, value) {
  let copiedElements = _.cloneDeep(elements);

  const lastInColumn = getLastAvailableInColumn(copiedElements, column);
  if(lastInColumn) {
    copiedElements[lastInColumn.index].value = value
  }

  return {
    elements: copiedElements,
    addedElement: lastInColumn
  }
}

function getRow(elements, row) {
  return elements.filter(function(e) {
    return e.row === row;
  });
}

function getColumn(elements, column) {
  return elements.filter(function(e) {
    return e.column === column;
  });
}

function handleFriends(elements, value) {
  return _.reduce(elements, function(friends, element) {
    if(friends.length === 4) {
      return friends;
    }
    else if(element.value === value) {
      return friends.concat([element]);
    }
    else {
      return [];
    }
  }, []);
}

function getLeftDiagonal(elements, row, column) {
  let elementDiagonal = [];
  let i = row;
  let j = column;
  while( i <= 5 && j <= 6 ) {
    elementDiagonal.push(elements[i * 7 + j]);
    i += 1;
    j += 1;
  }
  i = row - 1;
  j = column - 1;
  while( i >= 0 && j >= 0 ) {
    elementDiagonal.push(elements[i * 7 + j]);
    i -= 1;
    j -= 1;
  }

  return elementDiagonal.sort(function(a, b) {
    return a.index < b.index
  });
}

function getRightDiagonal(elements, row, column) {
  let elementDiagonal = [];
  let i = row;
  let j = column;
  while( i >= 0 && j <= 6 ) {
    elementDiagonal.push(elements[i * 7 + j]);
    i -= 1;
    j += 1;
  }
  i = row + 1;
  j = column - 1;

  while( i <= 5 && j >= 0 ) {
    elementDiagonal.push(elements[i * 7 + j]);
    i += 1;
    j -= 1;
  }
  return elementDiagonal.sort(function(a, b) {
    return a.index < b.index
  });
}

function getRowFriends(elements, row, value) {
  return handleFriends(getRow(elements, row), value);
}

function getColumnFriends(elements, column, value) {
  return handleFriends(getColumn(elements, column), value);
}

function getRightDiagonalFriends(elements, row, column, value) {
  return handleFriends(getRightDiagonal(elements, row, column), value);
}

function getLeftDiagonalFriends(elements, row, column, value) {
  return handleFriends(getLeftDiagonal(elements, row, column), value);
}

export function checkWin(elements, row, column, value) {
  return getRightDiagonalFriends(elements, row, column, value).length === 4 ||
    getLeftDiagonalFriends(elements, row, column, value).length === 4 ||
    getRowFriends(elements, row, value).length === 4 ||
    getColumnFriends(elements, column, value).length === 4

}

export function availableMoves(elements) {
  return _.shuffle(_.filter(elements, function(e) {
    return !e.value && e.row === 0;
  }));
}

export function score(elements, element, turn, depth) {
  let columnScore = [1,2,3,5,3,2,1];
  let rowScore = [1,1,5,8,10,10];
  let friendsMultiplier = [5, 10, 25, 100];

  let friendsCount = friendsMultiplier[getRowFriends(elements, element.row, turn).length] +
    friendsMultiplier[getColumnFriends(elements, element.column, turn).length] +
    friendsMultiplier[getLeftDiagonalFriends(elements, element.row, element.column, turn).length] +
    friendsMultiplier[getRightDiagonalFriends(elements, element.row, element.column, turn).length];

  let winner = { score: 0, win: false };

  if(checkWin(elements, element.row, element.column, turn)) {
    winner.win = true;
  } else {
    winner.score = friendsCount +
      rowScore[element.row] * 5 +
      columnScore[element.column] * 3 +
      depth * 5;
  }


  if(turn == 2) {
    winner.score = winner.win ? 1000 - (depth * 100) : 1000 - winner.score;
  } else {
    winner.score = winner.win ? (depth * 100) - 1000 : winner.score - 1000;
  }

  return winner;
}

export function printElements(elements) {
  let i = 0;
  let j = 0;
  log('Board:');
  for(i = 0; i <= 5; i += 1) {
    var str = "";

    for(j = 0; j <= 6; j += 1) {
      str += elements[i * 7 + j].value + ', '
    }

    log(str);
  }
}

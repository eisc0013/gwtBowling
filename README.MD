gwtBowling

Delphi 10.3.2

MIT License, Copyright 2019 by Anthony Eischens

This is my first instance of a code Kata, the bowling game.

There is a deviation from standard bowling scoring.  The logic returns a -1
 for the score if additional rolls are needed to determine the score.

Potential Improvements:
1. Use a class helper to format the indeterminate/integer score.
2. Implement a more efficient scoring algorithm.  The reverse scoring was
    an enjoyable exercise.
3. Improve ScoreByFrame, some of the record elements should probably
    be hidden.
4. Utilize more interfaces, perhaps separating out regular frame
    scoring from 10th frame scoring.
5. Store less, compute more given the light processing requirements of
    bowling.
6. Implement a more realistic random roll, perhaps with a few different skill
    levels.


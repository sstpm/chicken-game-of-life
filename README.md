##Conway's Game of Life
Conway's Game of Life implemented in Chicken Scheme. Based on [Robert Heaton's Advanced Beginner's Programming Project #2](https://robertheaton.com/2018/07/20/project-2-game-of-life/) . 

### Building the Game
The following eggs are needed to compile the program:
- srfi-1
- srfi-42

SRFI-1 supplies better list operations, including the `iota` function, which is needed for ranges.
SRFI-42 gives access to generators such as `list-ec`, which allows for quick generation of nested lists and easy operations on them.
Eggs can be installed with `chicken-install -S <egg>`
After installing the requisite eggs, compile the program with `csc life.scm`
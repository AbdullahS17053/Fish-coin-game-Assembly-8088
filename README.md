# Fish-coin-game-Assembly-8088
Coin game made using assembly 8088 architecture during my third semester in university

Game starts off in graphics mode with various ships being drawn pixel  by pixel.
User is stuck in infinite loop until 'S' key is pressed, coins blink from green to red if any other key is pressed.

If 'S' is pressed, ships are deleted and loading bar is drawn (again pixel by pixel). Hint is also displayed for user to emulate environment of an actual game.

After loading, game switches from graphics to text mode and intro screen in displayed. Name is asked.

Upon entering a name, screen transitions to home screen. Controls are displayed alongside game mechanics.

If enter is pressed, screen transitions to game screen.
User controls a fish with arrow keys to eat coins (red 50 points and green 10 points).
Border checks are also in play. There is set time for coins using timer interrupt and randomised posiitons of coins each time.
Mountains and boats are also dsiplayed which keep moving continously(execpt for when escape is pressed).
Sound is also implemented using multi-tasking and custom made sound file (Drake - Passionfruit made by hand using assembly keynote values and speaker interrurpt).

If escape is pressed, yes(Y)/No(N) options are available on escape screen.

If game is quit, screen transitions to end screen. Thank you message is displayed with users name,

Upon any key press on end screen, programs exits.



Interesting functionalities:

'Wiping' of pixels whilst in graphics mode before transitioning to another screen.
Music stops when escape is pressed and continues from same note if No(N) is selected.
Scrolling of ships and boats stops when escape is pressed and continues from same position if No(N) is selected.
Score is displayed at top right corner.
Screen transitions are implemented whilst in text mode. No abrupt jumping from one screen to another, smooth tranition is in play by the use of various screen buffer to give a 'scrolling' effect.
If arrows is pressed continously, fish moves at an increased and smooth speed.
Of the three pixels used to represent the fish, coins can be collected with each.

One of the most interesting projects i've made till date. (6/12/2022) (Uploaded a month later)

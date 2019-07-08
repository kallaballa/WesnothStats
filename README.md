This project depends on https://github.com/kallaballa/WML2XML to convert WML files to XML and XmlStarlet to query the xml documents.

### Decide the winner of a game by looking for a surrendering side
    
    ./decide.sh game.xml

Example Output (WinningFaction;LosingFaction;WinningPlayer;LosingPlayer;Title;File):

    Drakes;Undead;Player1:Player2;Ladder Game;./game.xml
    
For a game to be decidable the title of the replay has to contain the word "ladder" and must be ended by a surrender.


This project depends on https://github.com/kallaballa/WML2XML to convert WML files to XML and XmlStarlet to query the xml documents. The data/ladder.csv file has been generate from a DB dump of https://wesnoth.gamingladder.info/ with following query:

    SELECT * FROM webl_games INTO OUTFILE '/var/lib/mysql-files/ladder.csv' FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n'

### Usage

#### Analysis

Analysis is done in three steps.

1. Preparing data (and optionally filtering by year)
2. Downloading replays
3. Deciding 

The 3 steps are performed by 3 separate scripts (WARNING: you have to be in the base directory of the repo):

    ./1_prepareLimitedByElo.sh <optional elo limit> # generates "prepared.csv"
    ./2_downloadReplays.sh # downloads the replays files
    ./3_decide.sh # decide games and generate the final data # generates "errors.txt" and "result.csv"

The final data is stored in "result.csv"

#### Visualization

Copy "result.csv" to "./wesnothviz/data/games.csv"

    cp result.csv ./wesnothviz/data/games.csv

Start a webserver in the wesnothviz directory

    cd wesnothviz/
    python -m SimpleHTTPServer

View the data in the browser:

    xdg-open http://localhost:8000

#### Example Visualization

![Example Visualization](/example/viz.png?raw=true)


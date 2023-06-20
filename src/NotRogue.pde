import java.util.Iterator;
import java.util.Arrays;


float MAX_AREA_WIDTH, MAX_AREA_HEIGHT;
float MAX_CORRIDOR_WIDTH = 50;
final int MAX_HEALTH = 100;

// log
String fightLog;

// images
PImage spritesheet;
int tileWidth = 16;
int tileHeight = 16;
int numCols, numRows;
PImage[][] tiles;

// gamestate
enum State {
    MENU,
        DUNGEON,
        FIGHT,
        GAMEOVER,
        INCREASE_LEVEL,
        WIN
}
State gameState;
Dungeon dungeon;
Monster currentMonster;
int level;

void setup() {
    fullScreen();
    background(0);

    loadSpritesheet();

    MAX_AREA_WIDTH = width * 0.25;
    MAX_AREA_HEIGHT = height * 0.25;

    level = 0;
    gameState = State.MENU;
    //initialize();
}


void initialize() {

    gameState = State.DUNGEON;
    dungeon = new Dungeon(width, height, level);

    fightLog = "";
}


void draw() {
    switch(gameState) {
    case MENU:
        displayMenu();
        break;
    case DUNGEON:
        displayDungeonBackground();
        dungeon.display();
        displayPlayerDetails();
        break;
    case FIGHT:
        displayFightScreen();
        if (currentMonster.isDead()) {
            gameState = State.DUNGEON;
            dungeon.monsters.remove(currentMonster);
            currentMonster = null;
            fightLog = "";
        }
        if (dungeon.player.isDead()) {
            gameState = State.GAMEOVER;
        }
        displayPlayerDetails();
        break;
    case GAMEOVER:
        displayGameOver();
        break;
    case WIN:
        displayWin();
        break;
    case INCREASE_LEVEL:
        if (level >= 2) gameState = State.WIN;
        else {
            level++;
            initialize();
        }
    default:
    }
}

void keyPressed() {
    switch(gameState) {
    case MENU:
        if (key == ' ') {
            gameState = State.DUNGEON;
            initialize();
        }
        break;
    case DUNGEON:
        if (keyCode == LEFT || key == 'a') {
            dungeon.movePlayer(-5, 0);
        } else if (keyCode == RIGHT || key == 'd') {
            dungeon.movePlayer(5, 0);
        } else if (keyCode == UP || key == 'w') {
            dungeon.movePlayer(0, -5);
        } else if (keyCode == DOWN || key == 's') {
            dungeon.movePlayer(0, 5);
        }
        break;
    case FIGHT:
        int value = (int) key - 48;
        if (value > 0 && value < dungeon.player.skills.size() + 1) {
            print(key);
            fightLog = "";
            // player turn
            fightLog += "Player used skill: " + dungeon.player.skills.get(value - 1) + "\n";
            float damage = dungeon.player.useSkill(value);
            float hpReduced = currentMonster.receiveDamage(damage);
            fightLog += "Monster hp reduced by " + hpReduced + "\n";

            // monster turn
            int skillUsedIndex = int(random(currentMonster.skills.size()));
            fightLog += "Monster used skill: " + currentMonster.skills.get(skillUsedIndex) + "\n";
            damage = currentMonster.useSkill(skillUsedIndex);
            hpReduced = dungeon.player.receiveDamage(damage);
            fightLog += "Player hp reduced by " + hpReduced + "\n";
            print(fightLog);
        }
        break;
    default:
    }
}


void loadSpritesheet() {
    spritesheet = loadImage("sprites/tilemap_packed.png");

    // Calculate number of rows and columns in spritesheet
    numCols = spritesheet.width / tileWidth;
    numRows = spritesheet.height / tileHeight;

    // Initialize tiles array
    tiles = new PImage[numCols][numRows];

    // Extract tiles from spritesheet and store them in tiles array
    for (int col = 0; col < numCols; col++) {
        for (int row = 0; row < numRows; row++) {
            int x = col * tileWidth;
            int y = row * tileHeight;
            tiles[col][row] = spritesheet.get(x, y, tileWidth, tileHeight);
        }
    }
}

void displayPlayerDetails() {
    // draw HP bar
    fill(255);
    textSize(16);
    textAlign(LEFT);
    text("Player hp:", 20, 60);
    fill(255, 0, 0); // set fill color to red
    rect(120, 50, dungeon.player.hp, 10); // draw a rectangle representing the HP
}

void displayFightScreen() {
    background(51);
    fill(255);
    textSize(16);
    textAlign(LEFT);
    text("Monster hp:", 20, 90);
    fill(255, 0, 0); // set fill color to red
    rect(120, 80, currentMonster.hp, 10); // draw a rectangle representing the HP
    textSize(64);
    textAlign(CENTER);
    text("Fight!", width/2, height/2 -100);
    fill(255);
    textSize(32);
    text("Choose an action:\n" + dungeon.player.showAvailableSkills() + "\n" + fightLog, width/2, height/2 - 40);
}

void displayGameOver() {
    background(255);
    fill(255, 0, 0);
    textSize(64);
    textAlign(CENTER);
    text("Game Over!", width/2, height/2 -100);
}

void displayMenu() {
    background(255);
    fill(81, 184, 232);
    textSize(128);
    textAlign(CENTER);
    text("NotRogue", width/2, height/2 -100);
    fill(107, 131, 143);
    textSize(32);
    text("Move using 'wasd'\nPress space to start", width/2, height/2);
}

void displayWin() {
    background(255);
    fill(81, 184, 232);
    textSize(64);
    textAlign(CENTER);
    text("You win!", width/2, height/2 -100);
}

void displayDungeonBackground() {
    // Draw dungeon background using tiles array
    for (int x = 0; x < width; x += tileWidth*2) {
        for (int y = 0; y < height; y += tileHeight*2) {
            image(tiles[0][1], x, y, tileWidth * 2, tileHeight * 2);
        }
    }
}

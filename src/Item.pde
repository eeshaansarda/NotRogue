enum Pickable {
    POTION(8, 9), SWORD(8, 8), SHIELD(6, 8), POISON(7, 9), GATE(9, 1);

    int col, row;
    Pickable(int col, int row) {
        this.col = col;
        this.row = row;
    }
}

class Item {
    Pickable pickable;
    PVector pos;
    float w, h;

    Item(float x, float y, Pickable pickable) {
        this.pickable = pickable;
        pos = new PVector(x, y);
        w = tileWidth * 2;
        h = tileHeight * 2;
    }

    void display() {
        image(tiles[pickable.col][pickable.row], pos.x, pos.y, w, h);
    }
}

class Area {

    float w, h;
    PVector coordinate;

    public Area (float x, float y, float w, float h) {
        this.w = w;
        this.h = h;

        coordinate = new PVector(x, y);
    }

    void display() {
        // Draw dungeon background using tiles array
        for (float x = 0; x < w; x += tileWidth*2) {
            for (float y = 0; y < h; y += tileHeight*2) {
                image(tiles[0][4], x + coordinate.x, y + coordinate.y, tileWidth * 2, tileHeight * 2);
            }
        }
    }


    PVector center() {
        return new PVector(coordinate.x + w / 2, coordinate.y + h / 2);
    }

    boolean collides(float x, float y, float w, float h) {
        float left = x;
        float right = x + w;
        float top = y;
        float bottom = y + h;

        return (left < coordinate.x || right > coordinate.x + this.w || top < coordinate.y || bottom > coordinate.y + this.h);
        //return (left >= coordinate.x && right <= coordinate.x + this.w && top >= coordinate.y && bottom <= coordinate.y + this.h);
    }

    boolean contains(float x, float y) {
        return (x >= coordinate.x && x <= coordinate.x + w && y >= coordinate.y && y <= coordinate.y + h);
    }
}
